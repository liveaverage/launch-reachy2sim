#!/bin/bash
set -e

# --- Configuration ---
# REPLACE THIS with your actual username and repo name
REPO_URL="https://github.com/liveaverage/launch-reachy2sim.git"
CLONE_DIR="reachy_automation"

echo ">>> 📦 Cloning Reachy 2 Automation Repo..."

# 1. Clone or Pull
if [ -d "$CLONE_DIR" ]; then
    echo ">>> Directory exists. Pulling latest changes..."
    cd "$CLONE_DIR"
    git pull
else
    git clone "$REPO_URL" "$CLONE_DIR"
    cd "$CLONE_DIR"
fi

# 2. Enter the 'scripts' subdirectory
if [ -d "scripts" ]; then
    cd scripts
else
    echo "❌ Error: 'scripts' directory not found in repository."
    exit 1
fi

# 3. Make scripts executable
chmod +x setup_env.sh start_reachy.sh

# 4. Run Host Setup (Installs Docker/NVIDIA Drivers)
echo ">>> 🛠️  Running Host Setup..."
# We use 'sudo' inside the script, so this runs as current user but prompts if needed
./setup_env.sh

# 5. Run Simulation with "Hot" Group Loading
echo ">>> 🚀 Launching Simulation..."

# Check if user is already effectively in the docker group
if groups $USER | grep &>/dev/null "\bdocker\b"; then
    ./start_reachy.sh
else
    # Force execution with 'docker' group permissions immediately
    # This avoids the need to log out and log back in
    echo ">>> 🔄 Applying docker permissions..."
    sg docker -c "./start_reachy.sh"
fi