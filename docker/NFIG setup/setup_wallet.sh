#!/bin/bash
# -------------------------------------------------------------------------
# Script: 01_setup_wallet.sh
# Purpose: Download AWS CA Certs and create an Oracle Wallet
# Run as: ROOT (inside container)
# -------------------------------------------------------------------------

# 1. Define Paths
WALLET_DIR="/opt/oracle/wallet"
AMAZON_CA_URL="https://www.amazontrust.com/repository/AmazonRootCA1.pem"
CERT_FILE="${WALLET_DIR}/AmazonRootCA1.pem"

echo "--- Starting Wallet Setup ---"

# 2. Create Wallet Directory
if [ ! -d "$WALLET_DIR" ]; then
    echo "Creating wallet directory: $WALLET_DIR"
    mkdir -p "$WALLET_DIR"
    chown oracle:oinstall "$WALLET_DIR"
    chmod 755 "$WALLET_DIR"
fi

# 3. Download Amazon Root CA 1
echo "Downloading Amazon Root CA..."
curl -s -o "$CERT_FILE" "$AMAZON_CA_URL"

if [ ! -f "$CERT_FILE" ]; then
    echo "Error: Failed to download certificate."
    exit 1
fi

# 4. Create Oracle Wallet using orapki
# Note: Source the oracle environment to find orapki
source /home/oracle/.bashrc

echo "Creating Oracle Wallet..."
# Create the wallet with auto_login enabled (cwallet.sso) so the DB can read it without a password
orapki wallet create -wallet "$WALLET_DIR" -pwd "WalletPass123!" -auto_login

# 5. Add the Certificate
echo "Importing Amazon Root CA into Wallet..."
orapki wallet add -wallet "$WALLET_DIR" -trusted_cert -cert "$CERT_FILE" -pwd "WalletPass123!"

# 6. Set Permissions
# Crucial: The Oracle Database user must be able to read these files
chown -R oracle:oinstall "$WALLET_DIR"
chmod 600 "$WALLET_DIR"/*

echo "--- Wallet Setup Complete ---"
echo "Wallet Location: $WALLET_DIR"
orapki wallet display -wallet "$WALLET_DIR" -pwd "WalletPass123!"