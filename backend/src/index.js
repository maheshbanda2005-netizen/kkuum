import { S3Client, PutObjectCommand, GetObjectCommand } from '@aws-sdk/client-s3';
import { getSignedUrl } from '@aws-sdk/s3-request-presigner';

export default {
  async fetch(request, env) {
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
    const { filename, contentType, size, expiresIn = 86400, maxDownloads = 5 } = await request.json();

    // Validate inputs
    if (!filename || !contentType) {
      return new Response(JSON.stringify({ error: 'Missing required fields' }), {
        status: 400,
        headers: { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' }
      });
    }

    // Generate unique file ID
    const fileId = crypto.randomUUID();
    const key = `uploads/${fileId}/${filename}`;

    // Configure R2 client
    const R2 = new S3Client({
      region: 'auto',
      endpoint: `https://${env.CLOUDFLARE_ACCOUNT_ID}.r2.cloudflarestorage.com`,
      credentials: {
        accessKeyId: env.R2_ACCESS_KEY_ID,
        secretAccessKey: env.R2_SECRET_ACCESS_KEY,
      },
    });

    // Create presigned URL for PUT (valid for 1 hour)
    const command = new PutObjectCommand({
      Bucket: env.R2_BUCKET_NAME,
      Key: key,
      ContentType: contentType,
    });

    const uploadUrl = await getSignedUrl(R2, command, { expiresIn: 3600 });

    // Store metadata in KV
    await env.FILE_METADATA.put(fileId, JSON.stringify({
      filename,
      contentType,
      size,
      key,
      createdAt: Date.now(),
      expiresAt: Date.now() + (expiresIn * 1000),
      maxDownloads,
      downloadCount: 0,
      status: 'pending' // pending, uploaded, expired
    }), {
      expirationTtl: Math.max(60, expiresIn) // KV expirationTtl must be at least 60 seconds
    });

    return new Response(JSON.stringify({
      uploadUrl,
      fileId,
      key
    }), {
      headers: {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*'
      }
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

  const metadata = JSON.parse(metadataStr);

  // Don't return sensitive info like the S3 key if not needed, but here it's fine for the info endpoint
  return new Response(JSON.stringify(metadata), {
    headers: { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' }
  });
}

async function handleFileDownload(request, env) {
  const url = new URL(request.url);
  const fileId = url.pathname.split('/')[3];

  // Get metadata
  const metadataStr = await env.FILE_METADATA.get(fileId);
  if (!metadataStr) {
    return new Response('File not found', { status: 404, headers: { 'Access-Control-Allow-Origin': '*' } });
  }

  const metadata = JSON.parse(metadataStr);

  // Check expiry
  if (metadata.expiresAt < Date.now()) {
    return new Response('File expired', { status: 410, headers: { 'Access-Control-Allow-Origin': '*' } });
  }

  // Check download limit
  if (metadata.downloadCount >= metadata.maxDownloads) {
    return new Response('Download limit exceeded', { status: 403, headers: { 'Access-Control-Allow-Origin': '*' } });
  }

  // Generate temporary download URL (valid for 5 minutes)
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

  // Increment download count
  metadata.downloadCount++;
  await env.FILE_METADATA.put(fileId, JSON.stringify(metadata));

  // We can either redirect or return the URL. The guide says redirect.
  return Response.redirect(downloadUrl, 302);
}
