# Reachy 2 Simulation Launcher

One-click deployment of [Pollen Robotics' Reachy 2](https://www.pollen-robotics.com/reachy/) humanoid robot simulation on GPU-enabled Linux hosts (Brev, cloud VMs, or local workstations).

---

## Purpose

Automates the complete setup and launch of a containerized Reachy 2 simulation environment, including:
- Docker engine installation
- NVIDIA GPU passthrough configuration
- Web-accessible 3D simulator (VNC)
- Jupyter Lab for Python development
- gRPC SDK server for programmatic robot control

---

## Prerequisites

| Requirement | Details |
|-------------|---------|
| **OS** | Ubuntu 22.04+ / Debian-based Linux |
| **GPU** | NVIDIA GPU with drivers installed (`nvidia-smi` should work) |
| **Network** | Internet access to pull Docker images (~5-10GB) |
| **Privileges** | `sudo` access for Docker/toolkit installation |

> **Note:** The scripts assume NVIDIA drivers are already installed on the host. If `nvidia-smi` fails, install drivers first.

---

## Quick Start

```bash
# Clone this repo
git clone https://github.com/liveaverage/launch-reachy2sim.git
cd launch-reachy2sim

# Run the installer (handles everything)
./install.sh
```

That's it. After a few minutes, access the simulation:

| Service | URL | Description |
|---------|-----|-------------|
| **3D Simulator** | http://localhost:6080/vnc.html | noVNC web interface to RViz/Gazebo |
| **Jupyter Lab** | http://localhost:8888 | Python notebooks for SDK development |
| **SDK (gRPC)** | `localhost:50051` | Programmatic control via Reachy SDK |

---

## Architecture

```
install.sh                    # Entry point - orchestrates setup
├── Clones/pulls automation repo
├── scripts/setup_env.sh      # Host environment setup
│   ├── Installs Docker (get.docker.com)
│   ├── Installs NVIDIA Container Toolkit
│   ├── Configures Docker → NVIDIA runtime
│   └── Adds user to 'docker' group
└── scripts/start_reachy.sh   # Launches simulation container
    ├── Pulls pollenrobotics/reachy2:latest
    ├── Runs with GPU passthrough
    └── Exposes ports 6080, 8888, 50051
```

### Docker Container Details

| Setting | Value | Purpose |
|---------|-------|---------|
| Image | `pollenrobotics/reachy2:latest` | Official Pollen Robotics image |
| Container Name | `reachy2_sim` | For easy management |
| Restart Policy | `unless-stopped` | Auto-recovery on failure |
| Shared Memory | `2GB` | Required for physics simulation |
| GPU Access | `--gpus all` | Full GPU passthrough |

---

## Configuration

### Simulation Mode

Edit `scripts/start_reachy.sh` to switch physics engines:

```bash
# Default: Gazebo simulation
SIM_MODE="gazebo"

# Alternative: MuJoCo physics (faster, different trade-offs)
SIM_MODE="mujoco"
```

**Mode comparison:**

| Mode | Physics Engine | Use Case |
|------|---------------|----------|
| `gazebo` | Gazebo Classic | Full ROS 2 integration, sensor simulation |
| `mujoco` | MuJoCo | Faster physics, contact-rich manipulation |

### Port Mappings

Default ports can be changed in `scripts/start_reachy.sh`:

```bash
docker run -d \
    -p 6080:6080 \   # VNC web interface
    -p 8888:8888 \   # Jupyter Lab
    -p 50051:50051 \ # SDK gRPC server
    ...
```

### Launch Flags

The simulation is started with these ROS 2 launch arguments:

| Flag | Default | Description |
|------|---------|-------------|
| `start_rviz` | `true` | Launch RViz visualization |
| `start_sdk_server` | `true` | Enable gRPC SDK server |
| `fake` | `true` | Use simulated hardware |
| `gazebo` | `true/false` | Enable Gazebo simulation |
| `mujoco` | `false/true` | Enable MuJoCo simulation |

---

## Usage

### Managing the Container

```bash
# Check status
docker ps -a | grep reachy2_sim

# View logs
docker logs -f reachy2_sim

# Stop simulation
docker stop reachy2_sim

# Restart simulation
docker start reachy2_sim

# Remove and relaunch
docker rm -f reachy2_sim
./scripts/start_reachy.sh
```

### Accessing the Simulation

**Web VNC (http://localhost:6080/vnc.html):**
- No password by default
- Shows RViz with Reachy 2 robot model
- Gazebo/MuJoCo physics visualization

**Jupyter Lab (http://localhost:8888):**
- Pre-configured with Reachy SDK
- Example notebooks may be available in `/notebooks`

**SDK Connection (Python):**

```python
from reachy_sdk import ReachySDK

# Connect to the simulated robot
reachy = ReachySDK(host="localhost", port=50051)

# Move the right arm
reachy.r_arm.r_shoulder_pitch.goal_position = -30
```

---

## Troubleshooting

### Docker permission denied

```bash
# If you see "permission denied" errors after install:
# Option 1: Log out and back in (recommended)
logout

# Option 2: Force group reload (install.sh does this automatically)
sg docker -c "./scripts/start_reachy.sh"
```

### GPU not detected

```bash
# Verify NVIDIA driver is working on host
nvidia-smi

# Verify NVIDIA Container Toolkit
docker run --rm --gpus all nvidia/cuda:12.0-base nvidia-smi

# If toolkit issues, reinstall:
sudo nvidia-ctk runtime configure --runtime=docker
sudo systemctl restart docker
```

### Container exits immediately

```bash
# Check container logs for errors
docker logs reachy2_sim

# Common issues:
# - Insufficient shared memory: increase --shm-size
# - GPU memory exhausted: close other GPU applications
# - Port already in use: change port mappings
```

### VNC page loads but shows nothing

```bash
# Wait 30-60 seconds for RViz/Gazebo to initialize
# Check if container is still running:
docker ps | grep reachy2_sim

# If container exited, check logs and restart
docker logs reachy2_sim
./scripts/start_reachy.sh
```

### Remote access (non-localhost)

```bash
# Get host IP
hostname -I | awk '{print $1}'

# Access from remote machine:
# http://<HOST_IP>:6080/vnc.html
# http://<HOST_IP>:8888

# Ensure firewall allows ports 6080, 8888, 50051
sudo ufw allow 6080/tcp
sudo ufw allow 8888/tcp
sudo ufw allow 50051/tcp
```

---

## File Reference

| File | Purpose |
|------|---------|
| `install.sh` | Main entry point; clones repo, runs setup, launches sim |
| `scripts/setup_env.sh` | Installs Docker + NVIDIA Container Toolkit |
| `scripts/start_reachy.sh` | Launches Reachy 2 Docker container |

---

## Dependencies

**Installed by scripts:**
- Docker Engine (via [get.docker.com](https://get.docker.com))
- NVIDIA Container Toolkit

**Required on host (pre-existing):**
- NVIDIA GPU drivers
- `curl`, `sudo`, `git`

**Docker image pulled:**
- `pollenrobotics/reachy2:latest` (~5-10GB)

---

## References

- [Pollen Robotics - Reachy 2](https://www.pollen-robotics.com/reachy/)
- [Reachy SDK Documentation](https://docs.pollen-robotics.com/)
- [NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/)
- [Source Repository](https://github.com/liveaverage/launch-reachy2sim)

---

## License

See upstream [Pollen Robotics licensing](https://github.com/pollen-robotics) for Reachy 2 software components.
