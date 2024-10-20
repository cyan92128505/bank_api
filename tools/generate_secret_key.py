import secrets
import os

def generate_secret_key():
    return secrets.token_urlsafe(32)

def update_env_file(secret_key):
    env_path = '.env'
    
    if os.path.exists(env_path):
        with open(env_path, 'r') as file:
            lines = file.readlines()
    else:
        lines = []

    secret_key_line = f"SECRET_KEY={secret_key}\n"
    secret_key_found = False

    for i, line in enumerate(lines):
        if line.startswith("SECRET_KEY="):
            lines[i] = secret_key_line
            secret_key_found = True
            break

    if not secret_key_found:
        lines.append(secret_key_line)

    with open(env_path, 'w') as file:
        file.writelines(lines)

if __name__ == "__main__":
    new_secret_key = generate_secret_key()
    update_env_file(new_secret_key)
    print(f"Generate SECRET_KEY into .env: {new_secret_key}")