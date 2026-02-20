import secrets from 'secrets.js';

export class DistributedKeyManager {
  constructor() {
    this.TOTAL_SHARES = 5;
    this.THRESHOLD = 3; // Need 3/5 shares to reconstruct
  }

  splitEncryptionKey(keyHex) {
    const shares = secrets.share(
      keyHex,
      this.TOTAL_SHARES,
      this.THRESHOLD
    );

    return shares;
  }

  reconstructKey(shares) {
    if (shares.length < this.THRESHOLD) {
      throw new Error('Insufficient shares to reconstruct key');
    }

    const hexKey = secrets.combine(shares);
    return hexKey;
  }
}
