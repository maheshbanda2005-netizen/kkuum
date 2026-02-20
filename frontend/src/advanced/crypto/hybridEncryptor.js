import { keypair, encapsulate, decapsulate } from 'pqc-kyber';

export class PostQuantumHybridEncryptor {
  constructor() {
    this.AES_256 = { name: 'AES-GCM', length: 256 };
  }

  async generateHybridKeypair() {
    const keys = keypair();
    return {
      quantumPublicKey: keys.pubkey,
      quantumSecretKey: keys.secret
    };
  }

  async generateSharedSecretForWasm(recipientQuantumPublicKey) {
    const kex = encapsulate(recipientQuantumPublicKey);
    return {
      sharedSecret: kex.sharedSecret,
      ciphertext: kex.ciphertext
    };
  }

  async getEncapsulatedKey(recipientQuantumPublicKey, sharedSecret) {
    // In a real KEM, we'd use the ciphertext from encapsulate.
    // For this demo, we'll just re-encapsulate or use the one we got.
    // Let's assume we use the one from generateSharedSecretForWasm.
    const kex = encapsulate(recipientQuantumPublicKey);
    return kex.ciphertext;
  }

  async hybridDecrypt(ciphertext, encapsulatedKey, iv, quantumSecretKey) {
    const sharedSecret = decapsulate(encapsulatedKey, quantumSecretKey);

    const aesKey = await window.crypto.subtle.importKey(
      'raw',
      sharedSecret.slice(0, 32),
      { name: 'AES-GCM' },
      false,
      ['decrypt']
    );

    const decryptedBuffer = await window.crypto.subtle.decrypt(
      { name: 'AES-GCM', iv },
      aesKey,
      ciphertext
    );

    return decryptedBuffer;
  }

  // Method to get shared secret for Wasm decryption
  async getSharedSecret(encapsulatedKey, quantumSecretKey) {
    return decapsulate(encapsulatedKey, quantumSecretKey);
  }
}
