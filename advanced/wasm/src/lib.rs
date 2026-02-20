use wasm_bindgen::prelude::*;
use aes_gcm::{
    aead::{Aead, KeyInit},
    Aes256Gcm, Nonce
};

#[wasm_bindgen]
pub struct StreamingEncryptor {
    cipher: Aes256Gcm,
    chunk_size: usize,
}

#[wasm_bindgen]
impl StreamingEncryptor {
    #[wasm_bindgen(constructor)]
    pub fn new(key: &[u8]) -> Self {
        let cipher = Aes256Gcm::new_from_slice(key).expect("Invalid key length");
        StreamingEncryptor {
            cipher,
            chunk_size: 64 * 1024, // 64KB chunks
        }
    }

    pub fn encrypt_chunk(&self, chunk: &[u8], index: u32) -> Vec<u8> {
        let mut nonce_bytes = [0u8; 12];
        let index_bytes = index.to_le_bytes();
        nonce_bytes[..4].copy_from_slice(&index_bytes);
        let nonce = Nonce::from_slice(&nonce_bytes);

        self.cipher.encrypt(nonce, chunk).expect("Encryption failed")
    }

    pub fn decrypt_chunk(&self, encrypted_chunk: &[u8], index: u32) -> Vec<u8> {
        let mut nonce_bytes = [0u8; 12];
        let index_bytes = index.to_le_bytes();
        nonce_bytes[..4].copy_from_slice(&index_bytes);
        let nonce = Nonce::from_slice(&nonce_bytes);

        self.cipher.decrypt(nonce, encrypted_chunk).expect("Decryption failed")
    }
}
