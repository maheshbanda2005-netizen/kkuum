import { S3Client, PutObjectCommand, GetObjectCommand } from '@aws-sdk/client-s3';
import { getSignedUrl } from '@aws-sdk/s3-request-presigner';
import { ThreatDetectionSystem } from './advanced/auth/threatDetector.js';
import { ImmutableAuditLog } from './advanced/auth/blockchainLogger.js';

const threatDetector = new ThreatDetectionSystem();
const auditLog = new ImmutableAuditLog();

export default {
  async fetch(request, env) {
    // 1. Threat Detection
    const threatReport = await threatDetector.analyzeRequest(request);
    if (threatReport.action === 'BLOCK') {
      return new Response('Access Denied: Threat Detected', { status: 403 });
    }

    const url = new URL(request.url);

    // Handle CORS preflight
    if (request.method === 'OPTIONS') {
      return new Response(null, {
        headers: {
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Methods': 'POST, GET, OPTIONS',
          'Access-Control-Allow-Headers': 'Content-Type',
        },
      });
    }

    // Generate upload URL endpoint
    if (url.pathname === '/api/upload-url' && request.method === 'POST') {
      return handleUploadUrl(request, env);
    }

    // Get file info endpoint
    if (url.pathname.startsWith('/api/files/') && url.pathname.endsWith('/info')) {
      return handleFileInfo(request, env);
    }

    // Download/file access endpoint
    if (url.pathname.startsWith('/api/files/') && url.pathname.endsWith('/download')) {
      return handleFileDownload(request, env);
    }

    return new Response('Not found', { status: 404 });
  }
};

async function handleUploadUrl(request, env) {
  try {
    const { filename, contentType, size, expiresIn = 86400, maxDownloads = 5, shares = [] } = await request.json();

    // Validate inputs
    if (!filename || !contentType) {
      return new Response(JSON.stringify({ error: 'Missing required fields' }), {
        status: 400,
        headers: { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' }
      });
    }

    const fileId = crypto.randomUUID();
    const key = `uploads/${fileId}/${filename}`;

    const R2 = new S3Client({
      region: 'auto',
      endpoint: `https://${env.CLOUDFLARE_ACCOUNT_ID}.r2.cloudflarestorage.com`,
      credentials: {
        accessKeyId: env.R2_ACCESS_KEY_ID,
        secretAccessKey: env.R2_SECRET_ACCESS_KEY,
      },
    });

    const command = new PutObjectCommand({
      Bucket: env.R2_BUCKET_NAME,
      Key: key,
      ContentType: contentType,
    });

    const uploadUrl = await getSignedUrl(R2, command, { expiresIn: 3600 });

    await env.FILE_METADATA.put(fileId, JSON.stringify({
      filename,
      contentType,
      size,
      key,
      createdAt: Date.now(),
      expiresAt: Date.now() + (expiresIn * 1000),
      maxDownloads,
      downloadCount: 0,
      status: 'pending',
      shares
    }), {
      expirationTtl: Math.max(60, expiresIn)
    });

    // Audit Log
    await auditLog.logFileAccess(fileId, 'anonymous', 'UPLOAD_INITIATED');

    return new Response(JSON.stringify({ uploadUrl, fileId, key }), {
      headers: { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' }
    });

  } catch (error) {
    return new Response(JSON.stringify({ error: error.message }), {
      status: 500,
      headers: { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' }
    });
  }
}

async function handleFileInfo(request, env) {
  const url = new URL(request.url);
  const fileId = url.pathname.split('/')[3];

  const metadataStr = await env.FILE_METADATA.get(fileId);
  if (!metadataStr) {
    return new Response(JSON.stringify({ error: 'File not found' }), {
      status: 404,
      headers: { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' }
    });
  }

  await auditLog.logFileAccess(fileId, 'anonymous', 'INFO_REQUESTED');

  return new Response(metadataStr, {
    headers: { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' }
  });
}

async function handleFileDownload(request, env) {
  const url = new URL(request.url);
  const fileId = url.pathname.split('/')[3];

  const metadataStr = await env.FILE_METADATA.get(fileId);
  if (!metadataStr) {
    return new Response('File not found', { status: 404, headers: { 'Access-Control-Allow-Origin': '*' } });
  }

  const metadata = JSON.parse(metadataStr);

  if (metadata.expiresAt < Date.now()) {
    return new Response('File expired', { status: 410, headers: { 'Access-Control-Allow-Origin': '*' } });
  }

  if (metadata.downloadCount >= metadata.maxDownloads) {
    return new Response('Download limit exceeded', { status: 403, headers: { 'Access-Control-Allow-Origin': '*' } });
  }

  const R2 = new S3Client({
    region: 'auto',
    endpoint: `https://${env.CLOUDFLARE_ACCOUNT_ID}.r2.cloudflarestorage.com`,
    credentials: {
      accessKeyId: env.R2_ACCESS_KEY_ID,
      secretAccessKey: env.R2_SECRET_ACCESS_KEY,
    },
  });

  const command = new GetObjectCommand({
    Bucket: env.R2_BUCKET_NAME,
    Key: metadata.key,
    ResponseContentDisposition: `attachment; filename="${metadata.filename}"`
  });

  const downloadUrl = await getSignedUrl(R2, command, { expiresIn: 300 });

  metadata.downloadCount++;
  await env.FILE_METADATA.put(fileId, JSON.stringify(metadata));

  await auditLog.logFileAccess(fileId, 'anonymous', 'DOWNLOAD_REDIRECT');

  return Response.redirect(downloadUrl, 302);
}
