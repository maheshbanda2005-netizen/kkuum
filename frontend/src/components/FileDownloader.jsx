import React, { useState, useEffect } from 'react';
import { useParams } from 'react-router-dom';
import { PostQuantumHybridEncryptor } from '../advanced/crypto/hybridEncryptor.js';
import { DistributedKeyManager } from '../advanced/crypto/secretSharing.js';
import init, { StreamingEncryptor } from '../advanced/wasm-pkg/wasm.js';

function FileDownloader() {
  const { fileId } = useParams();
  const [fileInfo, setFileInfo] = useState(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');
  const [urlShare, setUrlShare] = useState('');
  const [wasmReady, setWasmReady] = useState(false);

  const encryptor = new PostQuantumHybridEncryptor();
  const keyManager = new DistributedKeyManager();

  useEffect(() => {
    init().then(() => setWasmReady(true));

    const hash = window.location.hash;
    const shareMatch = hash.match(/share=([^&]*)/);
    const share = shareMatch ? decodeURIComponent(shareMatch[1]) : '';

    if (!share) {
      setError('No key share found in URL');
    } else {
      setUrlShare(share);
    }

    fetchFileInfo(fileId);
  }, [fileId]);

  const fetchFileInfo = async (id) => {
    try {
      const apiUrl = import.meta.env.VITE_API_URL || 'http://localhost:8787';
      const response = await fetch(`${apiUrl}/api/files/${id}/info`);
      if (!response.ok) throw new Error('Failed to load file info');
      const data = await response.json();
      setFileInfo(data);
    } catch (err) {
      setError('Failed to load file info: ' + err.message);
    }
  };

  const handleDownload = async () => {
    if (!wasmReady) return;
    setLoading(true);
    try {
      const apiUrl = import.meta.env.VITE_API_URL || 'http://localhost:8787';
      const response = await fetch(`${apiUrl}/api/files/${fileId}/download`);
      if (!response.ok) throw new Error('Download failed');
      const encryptedData = new Uint8Array(await response.arrayBuffer());

      const iv = encryptedData.slice(0, 12);
      const encapsulatedKeySize = 1568;
      const encapsulatedKey = encryptedData.slice(12, 12 + encapsulatedKeySize);
      const ciphertext = encryptedData.slice(12 + encapsulatedKeySize);

      const shares = [urlShare, ...fileInfo.shares];
      const skHex = keyManager.reconstructKey(shares);
      const quantumSecretKey = new Uint8Array(skHex.match(/.{1,2}/g).map(byte => parseInt(byte, 16)));

      const sharedSecret = await encryptor.getSharedSecret(encapsulatedKey, quantumSecretKey);

      const wasmEncryptor = new StreamingEncryptor(sharedSecret.slice(0, 32));
      const decryptedBuffer = wasmEncryptor.decrypt_chunk(ciphertext, 0);

      const blob = new Blob([decryptedBuffer], { type: fileInfo.contentType || 'application/octet-stream' });
      const url = window.URL.createObjectURL(blob);
      const a = document.createElement('a');
      a.href = url;
      a.download = fileInfo.filename;
      a.click();
      window.URL.revokeObjectURL(url);
      setLoading(false);

    } catch (err) {
      console.error(err);
      setError('Decryption failed: ' + err.message);
      setLoading(false);
    }
  };

  if (error && !fileInfo) return <div className="error" style={{ color: 'red' }}>{error}</div>;
  if (!fileInfo) return <div>Loading file info...</div>;

  return (
    <div className="downloader">
      <h2>Advanced Download</h2>
      {!wasmReady && <p style={{ color: 'orange' }}>Initializing Wasm...</p>}
      {error && <div className="error" style={{ color: 'red' }}>{error}</div>}
      <div className="file-info" style={{ border: '1px solid #ccc', padding: '15px', borderRadius: '8px', marginBottom: '15px' }}>
        <p><strong>File:</strong> {fileInfo.filename}</p>
        <p><strong>Security:</strong> Post-Quantum Hybrid (Kyber-1024) + Wasm</p>
        <p><strong>Shares:</strong> 1 in URL, {fileInfo.shares.length} from server</p>
      </div>
      <button onClick={handleDownload} disabled={loading || !urlShare || !wasmReady}>
        {loading ? 'Decrypting...' : 'Download & Decrypt'}
      </button>
    </div>
  );
}

export default FileDownloader;
