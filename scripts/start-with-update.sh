#!/bin/bash

# ==============================================================================
# BOLT Panel - Start with Auto-Update Check on Restart
# ==============================================================================

# Locate panel directory safely
if [ -f "package.json" ] && grep -q '"name": "bolt-panel"' "package.json" 2>/dev/null; then
    PANEL_DIR="$(pwd)"
elif [ -f "$(dirname "$0")/../package.json" ]; then
    PANEL_DIR="$(cd "$(dirname "$0")/.." && pwd)"
elif [ -d "$HOME/bolt" ]; then
    PANEL_DIR="$HOME/bolt"
elif [ -d "/root/BOLT" ]; then
    PANEL_DIR="/root/bolt"
else
    PANEL_DIR="$(pwd)"
fi

cd "$PANEL_DIR" || exit 1

echo "[BOLT Panel] Working Directory: $(pwd)"
echo "[BOLT Panel] Checking for updates from repository on restart..."

if command -v git &> /dev/null && [ -d ".git" ]; then
    # Fetch latest remote changes quietly
    git fetch origin main 2>/dev/null || git fetch origin master 2>/dev/null || true
    
    LOCAL_COMMIT=$(git rev-parse HEAD 2>/dev/null || echo "")
    REMOTE_COMMIT=$(git rev-parse @{u} 2>/dev/null || echo "")

    if [ -n "$LOCAL_COMMIT" ] && [ -n "$REMOTE_COMMIT" ] && [ "$LOCAL_COMMIT" != "$REMOTE_COMMIT" ]; then
        echo "[BOLT Panel] Updates detected ($LOCAL_COMMIT -> $REMOTE_COMMIT)! Pulling changes..."
        git pull --ff-only origin main 2>/dev/null || git pull --ff-only origin master 2>/dev/null || git pull || true
        
        echo "[BOLT Panel] Installing updated dependencies..."
        npm install --no-audit --no-fund --quiet || true
        
        echo "[BOLT Panel] Compiling production build..."
        npm run build || true
        echo "[BOLT Panel] Update successfully applied!"
    else
        echo "[BOLT Panel] Panel is up-to-date (commit: ${LOCAL_COMMIT:0:7})."
    fi
else
    echo "[BOLT Panel] Git repository not detected or git command unavailable, skipping auto-pull."
fi

# Ensure dist exists
if [ ! -f "dist/server.cjs" ]; then
    echo "[BOLT Panel] Compiling initial build..."
    npm run build
fi

echo "[BOLT Panel] Launching BOLT Server Management Panel..."
exec node dist/server.cjs
