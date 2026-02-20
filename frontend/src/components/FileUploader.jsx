import React, { useState } from 'react';
import CryptoJS from 'crypto-js';

function FileUploader() {
  const [file, setFile] = useState(null);
  const [uploading, setUploading] = useState(false);
  const [shareUrl, setShareUrl] = useState('');
  const [expiry, setExpiry] = useState(24); // hours
  const [maxDownloads, setMaxDownloads] = useState(5);

  // Generate random encryption key
  const generateEncryptionKey = () => {
    return CryptoJS.lib.WordArray.random(32).toString(); // 256-bit key
  };

  // Encrypt file in browser
  const encryptFile = (file, key) => {
    return new Promise((resolve, reject) => {
      const reader = new FileReader();

      reader.onload = (event) => {
        try {
          const fileData = event.target.result;

          // Encrypt using AES
          // Using WordArray for better performance and correctness with binary data
          const wa = CryptoJS.enc.Latin1.parse(fileData);
          const encrypted = CryptoJS.AES.encrypt(wa, key).toString();

          // Convert encrypted string to Blob
          const encryptedBlob = new Blob(
            [encrypted],
            { type: 'application/octet-stream' }
          );

          resolve(encryptedBlob);
        } catch (error) {
          reject(error);
        }
      };

      reader.onerror = (error) => reject(error);
      reader.readAsBinaryString(file);
    });
  };

  const handleUpload = async () => {
    if (!file) return;

    setUploading(true);
    setShareUrl('');

    try {
      // Step 1: Generate encryption key
      const encryptionKey = generateEncryptionKey();

      // Step 2: Encrypt file
      const encryptedBlob = await encryptFile(file, encryptionKey);

      // Step 3: Get presigned URL from backend
      // In production, this would be the actual API URL
      const apiUrl = import.meta.env.VITE_API_URL || 'http://localhost:8787';
      const response = await fetch(`${apiUrl}/api/upload-url`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          filename: file.name,
          contentType: 'application/octet-stream',
          size: encryptedBlob.size,
          expiresIn: expiry * 3600,
          maxDownloads
        })
      });

      if (!response.ok) {
        throw new Error('Failed to get upload URL');
      }

      const { uploadUrl, fileId } = await response.json();

      // Step 4: Upload encrypted file directly to storage
      const uploadResponse = await fetch(uploadUrl, {
        method: 'PUT',
        body: encryptedBlob,
        headers: { 'Content-Type': 'application/octet-stream' }
      });

      if (!uploadResponse.ok) {
        throw new Error('Failed to upload file to storage');
      }

      // Step 5: Generate share URL with key in fragment
      const shareableUrl = `${window.location.origin}/download/${fileId}#key=${encodeURIComponent(encryptionKey)}`;
      setShareUrl(shareableUrl);

    } catch (error) {
      console.error('Upload failed:', error);
      alert('Upload failed: ' + error.message);
    } finally {
      setUploading(false);
    }
  };

  return (
    <div className="uploader">
      <h2>Secure File Upload</h2>

      <div className="form-group">
        <label>Select File:</label>
        <input
          type="file"
          onChange={(e) => setFile(e.target.files[0])}
        />
      </div>

      <div className="form-group">
        <label>Expires after (hours):</label>
        <input
          type="number"
          value={expiry}
          onChange={(e) => setExpiry(e.target.value)}
          min="1"
          max="168"
        />
      </div>

      <div className="form-group">
        <label>Max downloads:</label>
        <input
          type="number"
          value={maxDownloads}
          onChange={(e) => setMaxDownloads(e.target.value)}
          min="1"
          max="100"
        />
      </div>

      <button
        onClick={handleUpload}
        disabled={!file || uploading}
      >
        {uploading ? 'Uploading...' : 'Upload & Encrypt'}
      </button>

      {shareUrl && (
        <div className="share-url">
          <h3>Share this link:</h3>
          <input
            type="text"
            value={shareUrl}
            readOnly
            onClick={(e) => e.target.select()}
            style={{ width: '100%', marginBottom: '10px' }}
          />
          <button onClick={() => navigator.clipboard.writeText(shareUrl)}>
            Copy
          </button>
          <p className="warning">
            ⚠️ This link contains the encryption key. Anyone with this link can decrypt the file.
          </p>
        </div>
      )}
    </div>
  );
}

export default FileUploader;
