import React, { useState, useEffect } from 'react';
import { PostQuantumHybridEncryptor } from '../advanced/crypto/hybridEncryptor.js';
import { DistributedKeyManager } from '../advanced/crypto/secretSharing.js';
import init, { StreamingEncryptor } from '../advanced/wasm-pkg/wasm.js';

function FileUploader() {
  const [file, setFile] = useState(null);
  const [uploading, setUploading] = useState(false);
  const [shareUrl, setShareUrl] = useState('');
  const [expiry, setExpiry] = useState(24);
  const [maxDownloads, setMaxDownloads] = useState(5);
  const [wasmReady, setWasmReady] = useState(false);

  const encryptor = new PostQuantumHybridEncryptor();
  const keyManager = new DistributedKeyManager();

  useEffect(() => {
    init().then(() => setWasmReady(true));
  }, []);

  const handleUpload = async () => {
    if (!file || !wasmReady) return;

    setUploading(true);
    try {
      const { quantumPublicKey, quantumSecretKey } = await encryptor.generateHybridKeypair();
      const fileBuffer = await file.arrayBuffer();

      // Hybrid Encrypt Metadata (getting the sharedSecret)
      const kex = await encryptor.hybridEncrypt(new Uint8Array(0), quantumPublicKey);
      // Wait, I need the sharedSecret to initialize the Wasm encryptor
      // I'll update hybridEncrypt to return the sharedSecret too
      // Actually, I just did that in the previous write_file

      // Let's get a sharedSecret for the actual file encryption
      // I'll use a slightly modified flow to get the secret for Wasm
      const { sharedSecret } = await encryptor.generateSharedSecretForWasm(quantumPublicKey);

      const wasmEncryptor = new StreamingEncryptor(sharedSecret.slice(0, 32));

      // Encrypt file using Wasm
      const ciphertext = wasmEncryptor.encrypt_chunk(new Uint8Array(fileBuffer), 0);

      // Encapsulate for the sharing link
      // (Simplified: we use the same sharedSecret)
      const encapsulatedKey = await encryptor.getEncapsulatedKey(quantumPublicKey, sharedSecret);

      const iv = new Uint8Array(12); // Wasm uses index-based nonce starting at 0

      const skHex = Array.from(quantumSecretKey).map(b => b.toString(16).padStart(2, '0')).join('');
      const shares = keyManager.splitEncryptionKey(skHex);

      const apiUrl = import.meta.env.VITE_API_URL || 'http://localhost:8787';
      const response = await fetch(`${apiUrl}/api/upload-url`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          filename: file.name,
          contentType: 'application/octet-stream',
          size: ciphertext.length,
          expiresIn: expiry * 3600,
          maxDownloads,
          shares: [shares[0], shares[1]]
        })
      });

      const { uploadUrl, fileId } = await response.json();

      const combined = new Uint8Array(iv.length + encapsulatedKey.length + ciphertext.length);
      combined.set(iv);
      combined.set(encapsulatedKey, iv.length);
      combined.set(ciphertext, iv.length + encapsulatedKey.length);

      await fetch(uploadUrl, {
        method: 'PUT',
        body: combined,
        headers: { 'Content-Type': 'application/json' }
      });

      const shareableUrl = `${window.location.origin}/download/${fileId}#share=${encodeURIComponent(shares[2])}`;
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
      <h2>Advanced Secure File Upload</h2>
      <p style={{ fontSize: '12px', color: '#666' }}>Post-Quantum Hybrid Encryption + Wasm + Shamir's Secret Sharing</p>

      {!wasmReady && <p style={{ color: 'orange' }}>Initializing Wasm...</p>}

      <div className="form-group">
        <label>Select File:</label>
        <input type="file" onChange={(e) => setFile(e.target.files[0])} />
      </div>

      <div className="form-group">
        <label>Expires after (hours):</label>
        <input type="number" value={expiry} onChange={(e) => setExpiry(e.target.value)} min="1" max="168" />
      </div>

      <div className="form-group">
        <label>Max downloads:</label>
        <input type="number" value={maxDownloads} onChange={(e) => setMaxDownloads(e.target.value)} min="1" max="100" />
      </div>

      <button onClick={handleUpload} disabled={!file || uploading || !wasmReady}>
        {uploading ? 'Processing...' : 'Encrypt & Upload'}
      </button>

      {shareUrl && (
        <div className="share-url">
          <h3>Share this link:</h3>
          <input type="text" value={shareUrl} readOnly onClick={(e) => e.target.select()} style={{ width: '100%', marginBottom: '10px' }} />
          <p className="warning">
            ⚠️ This link contains 1 share of the PQC private key. The server holds 2 shares. Together they reconstruct the key to decapsulate.
          </p>
        </div>
      )}
    </div>
  );
}

export default FileUploader;
