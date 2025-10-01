# Scripts Directory

This directory contains utility scripts for the FFL Playoffs application.

## Available Scripts

### bootstrap-pat.sh

Creates the initial bootstrap Personal Access Token for system setup.

**Purpose**: Solves the "chicken-and-egg" problem of creating the first super admin account when no super admins exist yet.

**Usage**:

```bash
./scripts/bootstrap-pat.sh
```

**Environment Variables**:

- `MONGODB_URI` - MongoDB connection string (default: `mongodb://localhost:27017/ffl_playoffs`)
- `MONGODB_DATABASE` - Database name (default: `ffl_playoffs`)

**Prerequisites**:

- MongoDB Shell (`mongosh`) installed
- Python 3 with `bcrypt` library installed:
  ```bash
  pip3 install bcrypt
  ```
- MongoDB running and accessible
- `personal_access_tokens` collection exists in database

**Output**:

The script will display the bootstrap PAT token **ONE TIME ONLY**. Save it immediately:

```
========================================
⚠️  BOOTSTRAP PAT - SAVE THIS NOW!
========================================

Token: pat_a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6_ABCDefgh123...

⚠️  THIS TOKEN WILL NEVER BE SHOWN AGAIN!
```

**Next Steps**:

1. Save the displayed token securely
2. Use it to create your first super admin:
   ```bash
   curl -X POST https://<your-api-url>/api/v1/superadmin/bootstrap \
     -H "Authorization: Bearer <bootstrap-pat-token>" \
     -H "Content-Type: application/json" \
     -d '{
       "email": "admin@example.com",
       "googleId": "google-oauth2|123456789",
       "name": "System Administrator"
     }'
   ```
3. Login with Google OAuth as the new super admin
4. **Immediately rotate or revoke the bootstrap PAT**

**Security Notes**:

- The plaintext token is NEVER logged to files
- Only the bcrypt hash is stored in the database
- The token has ADMIN scope (full access)
- Token expires in 1 year
- Rotate immediately after use

**Troubleshooting**:

If the script fails:

1. **"mongosh is not installed"**:
   - Install MongoDB Shell: https://www.mongodb.com/docs/mongodb-shell/install/

2. **"Cannot connect to MongoDB"**:
   - Check MongoDB is running: `systemctl status mongod` or `docker ps | grep mongo`
   - Verify MONGODB_URI: `echo $MONGODB_URI`
   - Test connection: `mongosh "$MONGODB_URI"`

3. **"Bootstrap PAT already exists"**:
   - A bootstrap PAT was previously created
   - To create a new one, delete the existing PAT:
     ```bash
     mongosh "$MONGODB_URI" --eval "db.personal_access_tokens.deleteOne({ name: 'bootstrap' })"
     ```

4. **"bcrypt module not found"** (Python error):
   - Install bcrypt: `pip3 install bcrypt`

**Related Documentation**:

- [PAT Management](../docs/PAT_MANAGEMENT.md) - Full PAT lifecycle documentation
- [API Documentation](../docs/API.md) - API authentication
- [Deployment Guide](../docs/DEPLOYMENT.md) - Kubernetes deployment

---

## Adding New Scripts

When adding new scripts to this directory:

1. Make scripts executable: `chmod +x scripts/your-script.sh`
2. Add shebang line: `#!/usr/bin/env bash`
3. Set strict mode: `set -e`
4. Document in this README
5. Add error handling and colored output
6. Test with environment variables
