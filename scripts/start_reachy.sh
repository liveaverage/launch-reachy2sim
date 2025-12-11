#!/bin/bash

# Configuration
IMAGE_NAME="pollenrobotics/reachy2:latest"
CONTAINER_NAME="reachy2_sim"

# Default Mode (Change to 'mujoco' if preferred)
SIM_MODE="gazebo" 
# SIM_MODE="mujoco"

echo ">>> 🚀 Launching Reachy 2 Simulation ($SIM_MODE)..."

# 1. Stop existing container if running
if [ "$(docker ps -aq -f name=$CONTAINER_NAME)" ]; then
    echo ">>> 🛑 Stopping old container..."
    docker rm -f $CONTAINER_NAME
fi

# 2. Set simulation flags based on mode
if [ "$SIM_MODE" == "mujoco" ]; then
    CMD_FLAGS="start_rviz:=true start_sdk_server:=true fake:=true gazebo:=false mujoco:=true"
    echo ">>> 🧪 Mode: MuJoCo Physics"
else
    CMD_FLAGS="start_rviz:=true start_sdk_server:=true fake:=true gazebo:=true mujoco:=false"
    echo ">>> 🏢 Mode: Gazebo Standard"
fi

# 3. Run the Container
# --gpus all: Passes the GPU
# --network host: Optional, but simplifies ROS 2 discovery. 
# We use port mapping (-p) here to keep it isolated and web-friendly.
docker run -d \
    --name $CONTAINER_NAME \
    --restart unless-stopped \
    --gpus all \
    --shm-size=2gb \
    -p 6080:6080 \
    -p 8888:8888 \
    -p 50051:50051 \
    -e NVIDIA_DRIVER_CAPABILITIES=all \
    $IMAGE_NAME

# 4. Success Message
HOST_IP=$(hostname -I | awk '{print $1}')
echo ""
echo "################################################################"
echo ">>> ✅ Reachy 2 is Running!"
echo ">>> 🖥️  3D Simulator: http://localhost:6080/vnc.html"
echo ">>> 🐍 Jupyter Lab:   http://localhost:8888"
echo ">>> 📡 SDK Port:      50051"
echo "################################################################"