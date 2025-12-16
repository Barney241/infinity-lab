# Agenix Secrets Management

## Overview

Secrets are encrypted with `age` and can only be decrypted by:
- Your SSH key (for editing)
- Host SSH keys (for decryption at boot)

## Initial Setup (One-time)

### Step 1: Get host SSH public keys

Run on each host:
```bash
cat /etc/ssh/ssh_host_ed25519_key.pub
```

### Step 2: Add keys to secrets.nix

Edit `secrets.nix` and replace placeholder keys:
```nix
orion = "ssh-ed25519 AAAA...actual-key-from-orion...";
serveros = "ssh-ed25519 AAAA...actual-key-from-serveros...";
```

### Step 3: Create encrypted secrets

```bash
cd nixos/secrets

# User password (for login)
mkpasswd -m yescrypt
# Enter your password when prompted
# Output: $y$j9T$somesalt$longhashstring...

agenix -e barney-password.age
# This opens your editor (vim/nano)
# Paste ONLY the hash as the entire file content:
#   $y$j9T$somesalt$longhashstring...
# Save and exit (:wq in vim, Ctrl+X in nano)

# Jupyter password (if using jupyter)
python3 -c "from notebook.auth import passwd; print(passwd('yourpassword'))"
# Output: 'sha1:abc123:def456...'

agenix -e jupyter-password.age
# Paste the hash (including quotes) as entire file content:
#   'sha1:abc123:def456...'
# Save and exit
```

**Note:** The file content is JUST the hash/secret value, nothing else.
Agenix encrypts it when you save. The decrypted secret will be available
at `/run/agenix/<secret-name>` on the host.

### Step 4: Commit secrets

```bash
git add *.age
git commit -m "Add encrypted secrets"
```

## Adding New Secrets

1. Add entry to `secrets.nix`:
   ```nix
   "my-secret.age".publicKeys = allUsers ++ allHosts;
   ```

2. Create the secret:
   ```bash
   agenix -e my-secret.age
   ```

3. Reference in NixOS config:
   ```nix
   age.secrets.my-secret = {
     file = ../../secrets/my-secret.age;
   };
   # Use: config.age.secrets.my-secret.path
   ```

## Adding New Hosts

1. Get the new host's SSH public key:
   ```bash
   cat /etc/ssh/ssh_host_ed25519_key.pub
   ```

2. Add to `secrets.nix`:
   ```nix
   newhost = "ssh-ed25519 AAAA...";
   allHosts = [ orion serveros newhost ];
   ```

3. Re-encrypt all secrets:
   ```bash
   agenix -r
   ```

## Editing Secrets

```bash
agenix -e secret-name.age
```

## Troubleshooting

**"No secret key found"** - Host key not in secrets.nix or wrong key

**"Permission denied"** - Check file permissions on /run/agenix/

**View decrypted secret (on host):**
```bash
sudo cat /run/agenix/secret-name
```
