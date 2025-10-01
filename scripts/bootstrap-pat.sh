#!/usr/bin/env bash

########################################
# Bootstrap PAT Setup Script
# Creates the initial bootstrap Personal Access Token
# for creating the first super admin account
########################################

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color
BOLD='\033[1m'

echo -e "${BOLD}========================================${NC}"
echo -e "${BOLD}Bootstrap PAT Setup Script${NC}"
echo -e "${BOLD}========================================${NC}"
echo ""

# Get MongoDB URI from environment or use default
MONGODB_URI="${MONGODB_URI:-mongodb://localhost:27017/ffl_playoffs}"
DATABASE_NAME="${MONGODB_DATABASE:-ffl_playoffs}"
COLLECTION_NAME="personal_access_tokens"

echo "Configuration:"
echo "  MongoDB URI: $MONGODB_URI"
echo "  Database: $DATABASE_NAME"
echo "  Collection: $COLLECTION_NAME"
echo ""

# Check if mongosh is available
if ! command -v mongosh &> /dev/null; then
    echo -e "${RED}ERROR: mongosh (MongoDB Shell) is not installed${NC}"
    echo "Please install MongoDB Shell: https://www.mongodb.com/docs/mongodb-shell/install/"
    exit 1
fi

# Test MongoDB connection
echo "Testing MongoDB connection..."
if ! mongosh "$MONGODB_URI" --quiet --eval "db.runCommand({ ping: 1 })" > /dev/null 2>&1; then
    echo -e "${RED}ERROR: Cannot connect to MongoDB${NC}"
    echo "Please check:"
    echo "  1. MongoDB is running"
    echo "  2. MONGODB_URI is correct: $MONGODB_URI"
    echo "  3. Network connectivity"
    exit 1
fi
echo -e "${GREEN}✓ MongoDB connection successful${NC}"
echo ""

# Check if bootstrap PAT already exists
echo "Checking for existing bootstrap PAT..."
EXISTING_PAT=$(mongosh "$MONGODB_URI" --quiet --eval "
    use $DATABASE_NAME;
    db.$COLLECTION_NAME.findOne({ name: 'bootstrap' });
" | tail -n +2)

if echo "$EXISTING_PAT" | grep -q "_id"; then
    echo -e "${YELLOW}⚠️  Bootstrap PAT already exists!${NC}"
    echo ""
    echo "A bootstrap PAT has already been created for this system."
    echo "If you lost the token, you can:"
    echo "  1. Use another super admin to create a new PAT"
    echo "  2. Delete the existing bootstrap PAT and run this script again:"
    echo ""
    echo "     mongosh \"$MONGODB_URI\" --eval \"db.$COLLECTION_NAME.deleteOne({ name: 'bootstrap' })\""
    echo ""
    exit 0
fi
echo -e "${GREEN}✓ No existing bootstrap PAT found${NC}"
echo ""

# Generate secure token
echo "Generating secure token..."

# Generate UUID for identifier (32 hex characters without hyphens)
TOKEN_ID=$(python3 -c "import uuid; print(uuid.uuid4().hex)")

# Generate 64 random characters for the token
TOKEN_RANDOM=$(python3 -c "import secrets, string; alphabet = string.ascii_letters + string.digits; print(''.join(secrets.choice(alphabet) for i in range(64)))")

# Construct full token
FULL_TOKEN="pat_${TOKEN_ID}_${TOKEN_RANDOM}"

echo -e "${GREEN}✓ Token generated${NC}"
echo ""

# Hash token with bcrypt
echo "Hashing token with bcrypt (this may take a few seconds)..."

# Use Python to generate bcrypt hash (cost factor 12)
TOKEN_HASH=$(python3 <<EOF
import bcrypt
token = "$FULL_TOKEN"
salt = bcrypt.gensalt(rounds=12)
hash = bcrypt.hashpw(token.encode('utf-8'), salt)
print(hash.decode('utf-8'))
EOF
)

echo -e "${GREEN}✓ Token hashed${NC}"
echo ""

# Calculate expiration date (1 year from now)
EXPIRES_AT=$(python3 -c "from datetime import datetime, timedelta; print((datetime.utcnow() + timedelta(days=365)).isoformat() + 'Z')")
CREATED_AT=$(python3 -c "from datetime import datetime; print(datetime.utcnow().isoformat() + 'Z')")

# Generate UUID for PAT record
PAT_UUID=$(python3 -c "import uuid; print(str(uuid.uuid4()))")

# Create database record
echo "Creating bootstrap PAT in database..."

mongosh "$MONGODB_URI" --quiet --eval "
use $DATABASE_NAME;

db.$COLLECTION_NAME.insertOne({
    _id: '$PAT_UUID',
    name: 'bootstrap',
    tokenIdentifier: '$TOKEN_ID',
    tokenHash: '$TOKEN_HASH',
    scope: 'ADMIN',
    expiresAt: ISODate('$EXPIRES_AT'),
    createdBy: 'SYSTEM',
    createdAt: ISODate('$CREATED_AT'),
    lastUsedAt: null,
    revoked: false,
    revokedAt: null
});

print('Bootstrap PAT created successfully');
" > /dev/null

echo -e "${GREEN}✓ Bootstrap PAT created in database${NC}"
echo ""

# Display the token (ONE TIME ONLY)
echo ""
echo -e "${BOLD}========================================${NC}"
echo -e "${BOLD}⚠️  BOOTSTRAP PAT - SAVE THIS NOW!${NC}"
echo -e "${BOLD}========================================${NC}"
echo ""
echo -e "${BOLD}Token:${NC} ${GREEN}$FULL_TOKEN${NC}"
echo ""
echo -e "${RED}${BOLD}⚠️  THIS TOKEN WILL NEVER BE SHOWN AGAIN!${NC}"
echo ""
echo "Use this token to create your first super admin account:"
echo ""
echo "  curl -X POST https://<your-api-url>/api/v1/superadmin/bootstrap \\"
echo "    -H \"Authorization: Bearer $FULL_TOKEN\" \\"
echo "    -H \"Content-Type: application/json\" \\"
echo "    -d '{"
echo "      \"email\": \"admin@example.com\","
echo "      \"googleId\": \"google-oauth2|123456789\","
echo "      \"name\": \"System Administrator\""
echo "    }'"
echo ""
echo -e "${YELLOW}After creating your super admin, rotate this token immediately!${NC}"
echo ""
echo "Token Details:"
echo "  ID: $PAT_UUID"
echo "  Name: bootstrap"
echo "  Scope: ADMIN"
echo "  Expires: $EXPIRES_AT"
echo ""
echo -e "${BOLD}========================================${NC}"
echo ""

# Save token to a secure file (optional, with warning)
read -p "Save token to a file? (NOT RECOMMENDED, only for testing) [y/N]: " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    TOKEN_FILE="bootstrap-pat-token.txt"
    echo "$FULL_TOKEN" > "$TOKEN_FILE"
    chmod 600 "$TOKEN_FILE"
    echo -e "${YELLOW}⚠️  Token saved to: $TOKEN_FILE${NC}"
    echo -e "${YELLOW}⚠️  Make sure to delete this file after use!${NC}"
    echo ""
fi

echo -e "${GREEN}${BOLD}✓ Bootstrap PAT setup complete!${NC}"
echo ""
