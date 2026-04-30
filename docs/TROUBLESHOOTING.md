# Troubleshooting Guide

## Database Connection Issues

### Error: "Access denied for user (using password: NO)"

**Symptoms**:
```
(1045, "Access denied for user 'sevone_user'@'172.17.0.1' (using password: NO)")
```

**Cause**: The password is not being loaded from the `.env` file.

**Solutions**:

#### Solution 1: Update Your .env File

Your `.env` file currently has a placeholder password. Update it with your actual MySQL password:

```bash
# Edit .env file
nano .env

# Change this line:
MYSQL_PASSWORD=your_password_here

# To your actual password:
MYSQL_PASSWORD=your_actual_mysql_password
```

#### Solution 2: Verify MySQL Credentials

Test your MySQL credentials directly:

```bash
# Test connection with mysql client
mysql -h localhost -u root -p employee_management

# If successful, you'll see:
# mysql>
```

If this fails, you need to:
1. Check if MySQL is running
2. Verify the password
3. Check if the database exists

#### Solution 3: Create Database and User (If Needed)

If you don't have the database set up yet:

```sql
-- Connect to MySQL as root
mysql -u root -p

-- Create database
CREATE DATABASE employee_management CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Create user (if using a different user than root)
CREATE USER 'sevone_user'@'localhost' IDENTIFIED BY 'your_password';
GRANT SELECT, INSERT ON employee_management.* TO 'sevone_user'@'localhost';
FLUSH PRIVILEGES;

-- Exit
EXIT;
```

#### Solution 4: Use Root User (Temporary)

For testing, you can use the root user. Update your `.env`:

```bash
MYSQL_HOST=localhost
MYSQL_PORT=3306
MYSQL_DATABASE=employee_management
MYSQL_USER=root
MYSQL_PASSWORD=your_root_password
```

#### Solution 5: Check Docker MySQL Connection

If you're using MySQL in Docker (the error shows `172.17.0.1` which is a Docker network):

```bash
# Check if MySQL container is running
docker ps | grep mysql

# Get container name
docker ps

# Connect to MySQL container
docker exec -it <container_name> mysql -u root -p

# Inside MySQL, create user for Docker network
CREATE USER 'root'@'172.17.0.%' IDENTIFIED BY 'your_password';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'172.17.0.%';
FLUSH PRIVILEGES;
```

### Running the Test Script

After fixing the `.env` file:

```bash
# Make sure you're in the mcp-server directory
cd mcp-server

# Run the test
python3 test_db_conn_via_mcp.py
```

**Expected Output**:
```
Connecting to: localhost:3306/employee_management
User: root
Password: ********
Connection test: ✓ Success
```

### Quick Fix Script

Create a quick test to verify your credentials:

```bash
# Create test script
cat > test_mysql_direct.py << 'EOF'
import os
from dotenv import load_dotenv
import pymysql

# Load .env
load_dotenv('../.env')

# Get credentials
host = os.getenv('MYSQL_HOST', 'localhost')
port = int(os.getenv('MYSQL_PORT', '3306'))
database = os.getenv('MYSQL_DATABASE', 'employee_management')
user = os.getenv('MYSQL_USER', 'root')
password = os.getenv('MYSQL_PASSWORD', '')

print(f"Testing connection to: {host}:{port}/{database}")
print(f"User: {user}")
print(f"Password: {'*' * len(password) if password else '(empty)'}")

try:
    conn = pymysql.connect(
        host=host,
        port=port,
        user=user,
        password=password,
        database=database
    )
    print("✓ Connection successful!")
    conn.close()
except Exception as e:
    print(f"✗ Connection failed: {e}")
EOF

# Run it
python3 test_mysql_direct.py
```

## Common Issues and Solutions

### Issue 1: Module Not Found

**Error**: `ModuleNotFoundError: No module named 'dotenv'`

**Solution**:
```bash
pip install python-dotenv
# or
pip install -r requirements.txt
```

### Issue 2: Database Does Not Exist

**Error**: `(1049, "Unknown database 'employee_management'")`

**Solution**:
```bash
# Create the database
mysql -u root -p -e "CREATE DATABASE employee_management;"
```

### Issue 3: Can't Connect to MySQL Server

**Error**: `(2003, "Can't connect to MySQL server on 'localhost'")`

**Solutions**:

1. **Check if MySQL is running**:
```bash
# macOS
brew services list | grep mysql

# Linux
systemctl status mysql

# Start MySQL if not running
brew services start mysql  # macOS
sudo systemctl start mysql  # Linux
```

2. **Check MySQL port**:
```bash
# Check if MySQL is listening on port 3306
netstat -an | grep 3306
# or
lsof -i :3306
```

3. **Check MySQL socket** (if using localhost):
```bash
# Find MySQL socket
mysql_config --socket

# Update .env to use socket
MYSQL_HOST=/tmp/mysql.sock  # or wherever your socket is
```

### Issue 4: Permission Denied

**Error**: `Access denied for user 'sevone_user'@'localhost'`

**Solution**:
```sql
-- Connect as root
mysql -u root -p

-- Grant permissions
GRANT SELECT, INSERT ON employee_management.* TO 'sevone_user'@'localhost';
GRANT SELECT, INSERT ON employee_management.* TO 'sevone_user'@'%';
FLUSH PRIVILEGES;
```

### Issue 5: Docker MySQL Issues

If using Docker MySQL:

```bash
# Check container status
docker ps -a | grep mysql

# View container logs
docker logs <container_name>

# Restart container
docker restart <container_name>

# Connect to container
docker exec -it <container_name> bash

# Inside container, test MySQL
mysql -u root -p
```

## Verification Checklist

Before running the MCP server, verify:

- [ ] MySQL is running
- [ ] Database exists
- [ ] User has correct permissions
- [ ] `.env` file has correct credentials
- [ ] Password is not empty or placeholder
- [ ] Can connect with `mysql` command line
- [ ] Python dependencies are installed
- [ ] `python-dotenv` is installed

## Step-by-Step Verification

### Step 1: Verify MySQL is Running

```bash
# Check MySQL status
ps aux | grep mysql

# Or try to connect
mysql -u root -p
```

### Step 2: Verify Database Exists

```bash
mysql -u root -p -e "SHOW DATABASES;"
```

Should show `employee_management` in the list.

### Step 3: Verify User Permissions

```bash
mysql -u root -p -e "SHOW GRANTS FOR 'root'@'localhost';"
```

### Step 4: Test Connection with Python

```python
import pymysql

try:
    conn = pymysql.connect(
        host='localhost',
        user='root',
        password='your_password',
        database='employee_management'
    )
    print("✓ Connection successful!")
    conn.close()
except Exception as e:
    print(f"✗ Error: {e}")
```

### Step 5: Test with MCP Server

```bash
cd mcp-server
python3 test_db_conn_via_mcp.py
```

## Getting Help

If you're still having issues:

1. Check the error message carefully
2. Verify each step in the checklist
3. Check MySQL error logs:
   ```bash
   # macOS
   tail -f /usr/local/var/mysql/*.err
   
   # Linux
   tail -f /var/log/mysql/error.log
   ```
4. Review the setup guide: [`docs/SETUP.md`](SETUP.md)
5. Check the manual testing guide: [`docs/MANUAL_TESTING.md`](MANUAL_TESTING.md)

## Quick Reference

### Correct .env Format

```bash
MYSQL_HOST=localhost
MYSQL_PORT=3306
MYSQL_DATABASE=employee_management
MYSQL_USER=root
MYSQL_PASSWORD=your_actual_password_here  # NOT a placeholder!
MYSQL_POOL_SIZE=10
MYSQL_CONNECT_TIMEOUT=10
```

### Test Connection Command

```bash
mysql -h localhost -P 3306 -u root -p employee_management
```

### Create Database Command

```sql
CREATE DATABASE employee_management CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

### Grant Permissions Command

```sql
GRANT SELECT, INSERT ON employee_management.* TO 'root'@'localhost';
FLUSH PRIVILEGES;