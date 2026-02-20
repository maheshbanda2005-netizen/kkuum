import React from 'react'
import { BrowserRouter as Router, Routes, Route, Link } from 'react-router-dom'
import FileUploader from './components/FileUploader'
import FileDownloader from './components/FileDownloader'
import './App.css'

function App() {
  return (
    <Router>
      <div className="App" style={{ maxWidth: '800px', margin: '0 auto', padding: '20px', fontFamily: 'sans-serif' }}>
        <header>
          <h1><Link to="/" style={{ textDecoration: 'none', color: 'inherit' }}>Secure Share</Link></h1>
          <p>Zero-knowledge, serverless file sharing</p>
        </header>

        <main style={{ marginTop: '40px' }}>
          <Routes>
            <Route path="/" element={<FileUploader />} />
            <Route path="/download/:fileId" element={<FileDownloader />} />
          </Routes>
        </main>

        <footer style={{ marginTop: '60px', borderTop: '1px solid #eee', paddingTop: '20px', fontSize: '14px', color: '#666' }}>
          <p>Files are encrypted in your browser before upload using Post-Quantum Hybrid Encryption. Keys are split via Shamir's Secret Sharing.</p>
        </footer>
      </div>
    </Router>
  )
}

export default App
