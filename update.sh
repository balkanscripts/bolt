#!/usr/bin/env bash

#================================================================================
#  ██████╗   ██████╗  ██╗     ████████╗   ███╗   ██╗███████╗████████╗██╗    ██╗ ██████╗   ██╗  ██╗
#  ██╔══██╗ ██╔═══██╗ ██║     ╚══██╔══╝   ████╗  ██║██╔════╝╚══██╔══╝██║    ██║ ██╔═══██╗ ██║ ██╔╝
#  ██████╔╝ ██║   ██║ ██║        ██║      ██╔██╗ ██║█████╗     ██║   ██║ █╗ ██║ ██║   ██║ █████╔╝ 
#  ██   ██╔══██╗ ██║  ██║ ██║    ██║      ██║╚██╗██║██╔══╝     ██║   ██║███╗██║ ██║   ██║ ██╔═██╗ 
# ╚█████╔╝  ╚██████╔╝ ███████╗   ██║      ██║ ╚████║███████╗   ██║   ╚███╔███╔╝ ██████╔╝  ██║  ██╗
#  ╚════╝    ╚═════╝  ╚══════╝   ╚═╝      ╚═╝  ╚═══╝╚══════╝   ╚═╝    ╚══╝╚══╝  ╚═════╝   ╚═╝  ╚═╝
#================================================================================
#
#  Product Name : 3.2.0v- BOLT PANEL (Update Suite)
#  Banner       : BOLT PANEL
#  Creator      : vuuletic
# ==============================================================================

set -e

# ANSI Color Palette
C_RESET='\033[0m'
C_BOLD='\033[1m'
C_VIBRANT_CYAN='\033[38;5;45m'
C_DEEP_BLUE='\033[38;5;33m'
C_EMERALD='\033[38;5;48m'
C_AMBER='\033[38;5;214m'
C_CRIMSON='\033[38;5;196m'
C_WHITE='\033[38;5;255m'
C_MUTED='\033[38;5;244m'

echo ""
echo -e "${C_VIBRANT_CYAN}${C_BOLD}  ╭──────────────────────────────────────────────────────────────────────────╮${C_RESET}"
echo -e "${C_VIBRANT_CYAN}${C_BOLD}  │                 BOLT - AUTOMATED UPDATE SUITE                            │${C_RESET}"
echo -e "${C_VIBRANT_CYAN}${C_BOLD}  │               Credit: vuuletic  |  3.2.0v - BOLT                           │${C_RESET}"
echo -e "${C_VIBRANT_CYAN}${C_BOLD}  ╰──────────────────────────────────────────────────────────────────────────╯${C_RESET}"
echo ""

<<<<<<< HEAD
# Workspace verification
if [ ! -f "package.json" ]; then
    if [ -d "BOLT" ]; then
        cd Jtg
    else
        echo -e " ${C_CRIMSON}[✗ ERROR]${C_RESET} package.json not found. Please run this script from inside the BOLT directory."
        exit 1
=======
# ==============================================================================
# SMART AUTO-DETECTION: Find and change to BOLT Panel directory
# ==============================================================================
is_bolt_directory() {
    local target_dir="$1"
    if [ -f "${target_dir}/package.json" ] && grep -q '"name": "bolt-panel"' "${target_dir}/package.json" 2>/dev/null; then
        return 0
>>>>>>> 8428d0bcbfa7cdae8634f37c8060ab09ca5fa4a0
    fi
    if [ -f "${target_dir}/package.json" ] && [ -f "${target_dir}/server.ts" ]; then
        return 0
    fi
    return 1
}

locate_bolt_directory() {
    # 1. Check if current directory is already BOLT Panel
    if is_bolt_directory "."; then
        return 0
    fi

    # 2. Check script directory's parent (if called via /path/to/update.sh)
    local script_dir
    script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" 2>/dev/null && pwd)"
    if [ -n "$script_dir" ] && is_bolt_directory "$script_dir"; then
        cd "$script_dir"
        return 0
    fi

    # 3. Check common relative subdirectories
    local candidate_paths=(
        "./bolt"
        "./bolt"
        "./bolt"
        "../bolt"
        "../bolt"
        "../../bolt"
        "$HOME/bolt"
        "$HOME/bolt"
        "/root/bolt"
        "/root/bolt"
        "/var/www/bolt"
        "/var/www/bolt"
        "/opt/bolt"
        "/opt/bolt"
    )

    for path in "${candidate_paths[@]}"; do
        if [ -d "$path" ] && is_bolt_directory "$path"; then
            cd "$path"
            echo -e " ${C_DEEP_BLUE}[INFO]${C_RESET} Automatically detected BOLT Panel directory: ${C_VIBRANT_CYAN}$(pwd)${C_RESET}"
            return 0
        fi
    done

    # 4. Search nearby system locations
    echo -e " ${C_MUTED}[...] Searching system for B0LT Panel directory...${C_RESET}"
    local search_result
    search_result=$(find /root /home /var/www /opt . -maxdepth 3 -type d \( -name "BOLT" -o -name "bolt" -o -name "BOLT" \) 2>/dev/null | head -n 1)

    if [ -n "$search_result" ] && is_bolt_directory "$search_result"; then
        cd "$search_result"
        echo -e " ${C_DEEP_BLUE}[INFO]${C_RESET} Located BOLT Panel directory at: ${C_VIBRANT_CYAN}$(pwd)${C_RESET}"
        return 0
    fi

    return 1
}

if ! locate_bolt_directory; then
    echo -e " ${C_CRIMSON}${C_BOLD}[✗ ERROR]${C_RESET} ${C_CRIMSON}BOLT Panel directory could not be found automatically.${C_RESET}"
    echo -e " ${C_MUTED}Please navigate to your BOLT Panel installation folder (e.g. 'cd bolt') and run: bash update.sh${C_RESET}"
    exit 1
fi

echo -e " ${C_EMERALD}[✓]${C_RESET} Active Workspace: ${C_WHITE}${C_BOLD}$(pwd)${C_RESET}"
echo ""

# ==============================================================================
# GIT REPOSITORY SYNC
# ==============================================================================
if [ -d ".git" ] && command -v git &> /dev/null; then
    echo -e " ${C_DEEP_BLUE}[INFO]${C_RESET} Fetching latest updates from GitHub repository..."
    git fetch origin main 2>/dev/null || git fetch origin master 2>/dev/null || true
    
    LOCAL_COMMIT=$(git rev-parse HEAD 2>/dev/null || echo "")
    REMOTE_COMMIT=$(git rev-parse @{u} 2>/dev/null || echo "")

    if [ -n "$LOCAL_COMMIT" ] && [ -n "$REMOTE_COMMIT" ] && [ "$LOCAL_COMMIT" != "$REMOTE_COMMIT" ]; then
        echo -e " ${C_EMERALD}[INFO]${C_RESET} New updates found ($LOCAL_COMMIT -> $REMOTE_COMMIT). Pulling changes..."
        git pull --ff-only origin main 2>/dev/null || git pull --ff-only origin master 2>/dev/null || git pull || true
    else
        echo -e " ${C_MUTED}[INFO] Already on latest commit or up-to-date.${C_RESET}"
    fi
else
    echo -e " ${C_MUTED}[INFO] Git repository not detected; proceeding with dependency & build refresh.${C_RESET}"
fi

# ==============================================================================
# REFRESH DEPENDENCIES & COMPILE PRODUCTION BUILD
# ==============================================================================
echo -e " ${C_DEEP_BLUE}[INFO]${C_RESET} Refreshing npm dependencies..."
npm install --no-audit --no-fund --quiet || true

echo -e " ${C_DEEP_BLUE}[INFO]${C_RESET} Compiling and building latest production release..."
npm run build || true

# ==============================================================================
# RESTART BACKGROUND DAEMON
# ==============================================================================
echo -e " ${C_DEEP_BLUE}[INFO]${C_RESET} Restarting background service..."
RESTARTED=0

if command -v pm2 &> /dev/null; then
    if pm2 list 2>/dev/null | grep -q "bolt-panel"; then
        pm2 restart bolt-panel 2>/dev/null || npx pm2 restart bolt-panel 2>/dev/null || true
        RESTARTED=1
    fi
elif command -v npx &> /dev/null; then
    if npx pm2 list 2>/dev/null | grep -q "bolt-panel"; then
        npx pm2 restart bolt-panel 2>/dev/null || true
        RESTARTED=1
    fi
fi

if [ "$RESTARTED" -eq 0 ] && command -v systemctl &> /dev/null; then
    if systemctl is-active --quiet bolt-panel 2>/dev/null; then
        sudo systemctl restart bolt-panel 2>/dev/null || true
        RESTARTED=1
    fi
fi

echo ""
echo -e " ${C_EMERALD}${C_BOLD}[✓ SUCCESS]${C_RESET} ${C_WHITE}BOLT Panel has been updated and refreshed successfully!${C_RESET}"
if [ "$RESTARTED" -eq 1 ]; then
    echo -e " ${C_EMERALD}[✓]${C_RESET} Background process restarted."
else
    echo -e " ${C_MUTED}Start or restart anytime using:${C_RESET} ${C_VIBRANT_CYAN}npx pm2 restart bolt-panel${C_RESET} or ${C_VIBRANT_CYAN}npm run dev${C_RESET}"
fi
echo ""
