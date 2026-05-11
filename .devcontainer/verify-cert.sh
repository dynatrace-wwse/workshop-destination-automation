#!/bin/bash
#
# Certificate trust verification script for devcontainer
#

echo "========================================="
echo " Certificate Trust Verification"
echo "========================================="
echo ""

# 1. Check if certificate file exists
echo "1. Checking certificate file..."
if [ -f "/usr/local/share/ca-certificates/aap-cert.crt" ]; then
    echo "   ✓ Certificate exists at /usr/local/share/ca-certificates/aap-cert.crt"
    openssl x509 -in /usr/local/share/ca-certificates/aap-cert.crt -noout -subject -issuer
else
    echo "   ✗ Certificate NOT found"
fi
echo ""

# 2. Check if certificate is in system trust store
echo "2. Checking system trust store..."
if [ -f "/etc/ssl/certs/aap-cert.pem" ]; then
    echo "   ✓ Certificate symlink exists at /etc/ssl/certs/aap-cert.pem"
    ls -la /etc/ssl/certs/aap-cert.pem
else
    echo "   ✗ Certificate symlink NOT found"
fi
echo ""

# 3. Check NODE_EXTRA_CA_CERTS environment variable
echo "3. Checking NODE_EXTRA_CA_CERTS..."
if [ -n "$NODE_EXTRA_CA_CERTS" ]; then
    echo "   ✓ NODE_EXTRA_CA_CERTS is set to: $NODE_EXTRA_CA_CERTS"
    if [ -f "$NODE_EXTRA_CA_CERTS" ]; then
        echo "   ✓ Certificate file exists at that path"
    else
        echo "   ✗ Certificate file NOT found at that path"
    fi
else
    echo "   ✗ NODE_EXTRA_CA_CERTS is NOT set"
fi
echo ""

# 4. Check if certificate is in the system CA bundle
echo "4. Checking if certificate is in system CA bundle..."
if grep -q "Ansible Automation Platform" /etc/ssl/certs/ca-certificates.crt 2>/dev/null; then
    echo "   ✓ AAP certificate found in system CA bundle"
else
    echo "   ⚠ AAP certificate NOT found in system CA bundle (this may be OK if using NODE_EXTRA_CA_CERTS)"
fi
echo ""

# 5. Test HTTPS connection to AAP server
echo "5. Testing HTTPS connection to AAP server..."
if [ -f ".vscode/mcp.json" ]; then
    AAP_URL=$(jq -r '.servers["aap-job-management"].url' .vscode/mcp.json 2>/dev/null)
    AAP_HOSTNAME=$(echo "$AAP_URL" | sed 's|https://||' | sed 's|/.*||')
    
    if [ -n "$AAP_HOSTNAME" ]; then
        echo "   Testing connection to: $AAP_HOSTNAME"
        echo ""
        
        # Test with curl using system certs
        echo "   a) Testing with system certificates:"
        if curl -sS --connect-timeout 5 "https://$AAP_HOSTNAME" -o /dev/null 2>&1; then
            echo "      ✓ Connection successful with system certificates"
        else
            echo "      ✗ Connection failed with system certificates"
            echo "      Error: $(curl -sS --connect-timeout 5 "https://$AAP_HOSTNAME" 2>&1 | head -1)"
        fi
        echo ""
        
        # Test certificate validation specifically
        echo "   b) Testing certificate validation:"
        if openssl s_client -connect "$AAP_HOSTNAME" -CAfile /etc/ssl/certs/ca-certificates.crt </dev/null 2>&1 | grep -q "Verify return code: 0"; then
            echo "      ✓ Certificate validates successfully"
        else
            echo "      ⚠ Certificate validation has issues"
            echo "      Detailed output:"
            openssl s_client -connect "$AAP_HOSTNAME" -CAfile /etc/ssl/certs/ca-certificates.crt </dev/null 2>&1 | grep "Verify return code"
        fi
        echo ""
        
        # Test with Node.js if available
        echo "   c) Testing with Node.js (as VS Code would):"
        if command -v node &> /dev/null; then
            node -e "
const https = require('https');
const url = 'https://$AAP_HOSTNAME';
https.get(url, (res) => {
    console.log('      ✓ Node.js connection successful');
    console.log('      Status code:', res.statusCode);
}).on('error', (err) => {
    console.log('      ✗ Node.js connection failed');
    console.log('      Error:', err.message);
});
" 2>&1 | sed 's/^/   /'
        else
            echo "      ⚠ Node.js not available for testing"
        fi
    else
        echo "   ⚠ Could not extract hostname from mcp.json"
    fi
else
    echo "   ⚠ .vscode/mcp.json not found - run setup.sh first"
fi
echo ""

echo "========================================="
echo " Verification Complete"
echo "========================================="
