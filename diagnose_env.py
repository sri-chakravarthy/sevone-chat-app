#!/usr/bin/env python3
"""Diagnostic script to check environment configuration"""
import os
from pathlib import Path

print("=" * 60)
print("Environment Diagnostics")
print("=" * 60)

# Check .env file
env_file = Path('.env')
print(f"\n1. Checking .env file at: {env_file.absolute()}")
if env_file.exists():
    print("   ✓ .env file exists")
    print(f"   Size: {env_file.stat().st_size} bytes")
    
    # Read and display (masking password)
    print("\n   Contents:")
    with open(env_file) as f:
        for line in f:
            line = line.strip()
            if line and not line.startswith('#'):
                if 'PASSWORD' in line:
                    key, value = line.split('=', 1)
                    masked = '*' * len(value) if value else '(empty)'
                    print(f"   {key}={masked}")
                else:
                    print(f"   {line}")
else:
    print("   ✗ .env file NOT FOUND")
    print("   Please create .env file from .env.example")

# Check environment variables
print("\n2. Checking environment variables:")
env_vars = [
    'MYSQL_HOST',
    'MYSQL_PORT', 
    'MYSQL_DATABASE',
    'MYSQL_USER',
    'MYSQL_PASSWORD'
]

for var in env_vars:
    value = os.getenv(var)
    if value:
        if 'PASSWORD' in var:
            masked = '*' * len(value)
            print(f"   ✓ {var}={masked}")
        else:
            print(f"   ✓ {var}={value}")
    else:
        print(f"   ✗ {var}=(not set)")

# Try loading with python-dotenv
print("\n3. Testing python-dotenv:")
try:
    from dotenv import load_dotenv
    print("   ✓ python-dotenv is installed")
    
    # Load .env
    load_dotenv('.env')
    print("   ✓ load_dotenv() executed")
    
    # Check if variables are now loaded
    password = os.getenv('MYSQL_PASSWORD')
    if password:
        print(f"   ✓ MYSQL_PASSWORD loaded: {'*' * len(password)}")
    else:
        print("   ✗ MYSQL_PASSWORD still empty after load_dotenv()")
        
except ImportError:
    print("   ✗ python-dotenv NOT installed")
    print("   Run: pip install python-dotenv")

# Test MySQL connection
print("\n4. Testing MySQL connection:")
try:
    import pymysql
    print("   ✓ pymysql is installed")
    
    # Get credentials
    from dotenv import load_dotenv
    load_dotenv('.env')
    
    host = os.getenv('MYSQL_HOST', 'localhost')
    port = int(os.getenv('MYSQL_PORT', '3306'))
    database = os.getenv('MYSQL_DATABASE', 'sevone_db')
    user = os.getenv('MYSQL_USER', 'root')
    password = os.getenv('MYSQL_PASSWORD', '')
    
    print(f"   Attempting connection to: {host}:{port}/{database}")
    print(f"   User: {user}")
    print(f"   Password: {'*' * len(password) if password else '(empty)'}")
    
    if not password:
        print("\n   ✗ PASSWORD IS EMPTY!")
        print("   This is the problem. Update your .env file with the actual password.")
    else:
        try:
            conn = pymysql.connect(
                host=host,
                port=port,
                user=user,
                password=password,
                database=database
            )
            print("   ✓ MySQL connection successful!")
            conn.close()
        except Exception as e:
            print(f"   ✗ MySQL connection failed: {e}")
            
except ImportError as e:
    print(f"   ✗ Required module not installed: {e}")
    print("   Run: pip install pymysql")

print("\n" + "=" * 60)
print("Diagnosis Complete")
print("=" * 60)

# Provide recommendations
print("\nRecommendations:")
if not env_file.exists():
    print("1. Create .env file: cp .env.example .env")
    print("2. Edit .env and set your MySQL password")
elif not os.getenv('MYSQL_PASSWORD'):
    print("1. Edit .env file and set MYSQL_PASSWORD to your actual password")
    print("2. Make sure there are no quotes around the password")
    print("3. Make sure there are no spaces around the = sign")
else:
    print("Environment looks good! If still having issues:")
    print("1. Verify MySQL is running: mysql -u root -p")
    print("2. Check if database exists: SHOW DATABASES;")
    print("3. Verify user permissions")

print("\n")

# Made with Bob
