import React, { useState, useEffect } from 'react';
import { useParams } from 'react-router-dom';
import CryptoJS from 'crypto-js';

function FileDownloader() {
  const { fileId } = useParams();
  const [fileInfo, setFileInfo] = useState(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');
  const [decryptionKey, setDecryptionKey] = useState('');

  useEffect(() => {
    // Extract key from URL fragment
    const hash = window.location.hash;
    const keyMatch = hash.match(/key=([^&]*)/);
    const key = keyMatch ? decodeURIComponent(keyMatch[1]) : '';

    if (!key) {
      setError('No decryption key found in URL');
    } else {
      setDecryptionKey(key);
    }

    fetchFileInfo(fileId);
  }, [fileId]);

  const fetchFileInfo = async (id) => {
    try {
      const apiUrl = import.meta.env.VITE_API_URL || 'http://localhost:8787';
      const response = await fetch(`${apiUrl}/api/files/${id}/info`);
      if (!response.ok) {
        throw new Error('Failed to load file info');
      }
      const data = await response.json();
      setFileInfo(data);
    } catch (err) {
      setError('Failed to load file info: ' + err.message);
    }
  };

  const decryptFile = (encryptedData, key) => {
    // Decrypt using AES
    const decrypted = CryptoJS.AES.decrypt(encryptedData, key);
    return decrypted.toString(CryptoJS.enc.Latin1);
  };

  const handleDownload = async () => {
    setLoading(true);

    try {
      const apiUrl = import.meta.env.VITE_API_URL || 'http://localhost:8787';
      // Step 1: Fetch encrypted file
      const response = await fetch(`${apiUrl}/api/files/${fileId}/download`);
      if (!response.ok) {
        const errorText = await response.text();
        throw new Error(errorText || 'Download failed');
      }

      const encryptedBlob = await response.blob();

      // Step 2: Read encrypted data
      const reader = new FileReader();
      reader.onload = (e) => {
        try {
          // Step 3: Decrypt
          const decryptedData = decryptFile(e.target.result, decryptionKey);

          if (!decryptedData) {
            throw new Error('Decryption failed. Check your key.');
          }

          // Step 4: Create download link
          // Convert Latin1 string back to Uint8Array/Blob
          const n = decryptedData.length;
          const u8arr = new Uint8Array(n);
          for (let i = 0; i < n; i++) {
            u8arr[i] = decryptedData.charCodeAt(i);
          }

          const blob = new Blob([u8arr], { type: fileInfo.contentType || 'application/octet-stream' });
          const url = window.URL.createObjectURL(blob);
          const a = document.createElement('a');
          a.href = url;
          a.download = fileInfo.filename;
          document.body.appendChild(a);
          a.click();

          window.URL.revokeObjectURL(url);
          document.body.removeChild(a);
          setLoading(false);

          // Refresh file info to update download count
          fetchFileInfo(fileId);
        } catch (err) {
          setError('Decryption failed: ' + err.message);
          setLoading(false);
        }
      };

      reader.onerror = () => {
        setError('Failed to read encrypted file');
        setLoading(false);
      };

      reader.readAsText(encryptedBlob);

    } catch (err) {
      setError('Download failed: ' + err.message);
      setLoading(false);
    }
  };

  if (error && !fileInfo) return <div className="error" style={{ color: 'red' }}>{error}</div>;
  if (!fileInfo) return <div>Loading file info...</div>;

  return (
    <div className="downloader">
      <h2>Download File</h2>

      {error && <div className="error" style={{ color: 'red', marginBottom: '10px' }}>{error}</div>}

      <div className="file-info" style={{ border: '1px solid #ccc', padding: '15px', borderRadius: '8px', marginBottom: '15px' }}>
        <p><strong>File:</strong> {fileInfo.filename}</p>
        <p><strong>Size:</strong> {Math.round(fileInfo.size / 1024)} KB</p>
        <p><strong>Expires:</strong> {new Date(fileInfo.expiresAt).toLocaleString()}</p>
        <p><strong>Downloads:</strong> {fileInfo.downloadCount} / {fileInfo.maxDownloads}</p>
      </div>

      <button
        onClick={handleDownload}
        disabled={loading || fileInfo.downloadCount >= fileInfo.maxDownloads || !decryptionKey}
        style={{ padding: '10px 20px', fontSize: '16px', cursor: 'pointer' }}
      >
        {loading ? 'Decrypting...' : 'Download & Decrypt'}
      </button>

      {fileInfo.downloadCount >= fileInfo.maxDownloads && (
        <p style={{ color: 'orange', marginTop: '10px' }}>
          Maximum download limit reached.
        </p>
      )}
    </div>
  );
}

export default FileDownloader;
