import { StrictMode } from 'react'
import { createRoot } from 'react-dom/client'
import './index.css'
import App from './App.jsx'

// Polyfill for secrets.js and other Node-dependent libraries
if (typeof window !== 'undefined' && !window.crypto.randomBytes) {
  window.crypto.randomBytes = (size) => {
    const arr = new Uint8Array(size);
    window.crypto.getRandomValues(arr);
    return arr;
  };
}

createRoot(document.getElementById('root')).render(
  <StrictMode>
    <App />
  </StrictMode>,
)
