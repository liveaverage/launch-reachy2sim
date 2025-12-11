<h1 align="center">🤖 Reachy 2 Simulation Launcher</h1>

<p align="center">
  <strong>One-click deployment of Pollen Robotics' Reachy 2 humanoid robot simulation</strong>
</p>

<p align="center">
  <a href="https://www.pollen-robotics.com/reachy/"><img src="https://img.shields.io/badge/Robot-Reachy%202-00d4aa?style=for-the-badge&logo=probot&logoColor=white" alt="Reachy 2"/></a>
  <a href="https://docs.docker.com/"><img src="https://img.shields.io/badge/Docker-Required-2496ED?style=for-the-badge&logo=docker&logoColor=white" alt="Docker"/></a>
  <a href="https://developer.nvidia.com/cuda-toolkit"><img src="https://img.shields.io/badge/NVIDIA-GPU%20Required-76B900?style=for-the-badge&logo=nvidia&logoColor=white" alt="NVIDIA GPU"/></a>
  <a href="https://www.ros.org/"><img src="https://img.shields.io/badge/ROS%202-Humble-22314E?style=for-the-badge&logo=ros&logoColor=white" alt="ROS 2"/></a>
</p>

---

## 🚀 Deploy Instantly with Brev

<p align="center">
  <em>Skip the setup—launch a fully configured Reachy 2 simulation environment in seconds</em>
</p>

<table align="center">
<thead>
<tr>
<th align="center">GPU</th>
<th align="center">VRAM</th>
<th align="center">Best For</th>
<th align="center">Deploy</th>
</tr>
</thead>
<tbody>
<tr>
<td align="center"><strong>🔵 NVIDIA L40S</strong></td>
<td align="center">48 GB</td>
<td align="center">Heavy Simulation & Training</td>
<td align="center"><a href="https://brev.nvidia.com/launchable/deploy?launchableID=env-36ihk4SZip9LQocx5jR6c6srggd"><img src="https://brev-assets.s3.us-west-1.amazonaws.com/nv-lb-dark.svg" alt="Deploy on Brev" height="40"/></a></td>
</tr>
</tbody>
</table>

<p align="center">
  <sub>☝️ Click a deploy button above to launch on <a href="https://brev.nvidia.com">Brev</a> — GPU cloud for AI developers</sub>
</p>

---

<p align="center">
  <a href="#-quick-start">Quick Start</a> •
  <a href="#-features">Features</a> •
  <a href="#-architecture">Architecture</a> •
  <a href="#%EF%B8%8F-configuration">Configuration</a> •
  <a href="#-sdk-examples">SDK Examples</a> •
  <a href="#-troubleshooting">Troubleshooting</a>
</p>

---

## ✨ Features

<table>
<tr>
<td width="50%">

### 🖥️ Web-Based VNC
Access the full 3D simulation through your browser—no X11 forwarding or local GPU required on your client machine.

### 🐍 Jupyter Lab
Pre-configured Python environment with Reachy SDK for rapid prototyping and experimentation.

</td>
<td width="50%">

### ⚡ GPU Accelerated
Full NVIDIA GPU passthrough for real-time physics simulation with Gazebo or MuJoCo.

### 📡 gRPC SDK Server
Programmatic control of the robot via the official Pollen Robotics SDK.

</td>
</tr>
</table>

---

## 📋 Prerequisites

| Requirement | Details |
|:------------|:--------|
| **OS** | Ubuntu 22.04+ / Debian-based Linux |
| **GPU** | NVIDIA GPU with drivers installed |
| **Verification** | `nvidia-smi` should display GPU info |
| **Network** | Internet access for Docker image (~5-10GB) |
| **Privileges** | `sudo` access required |

> [!IMPORTANT]
> The scripts assume NVIDIA drivers are already installed. If `nvidia-smi` fails, [install NVIDIA drivers](https://docs.nvidia.com/cuda/cuda-installation-guide-linux/) first.

---

## 🚀 Quick Start

```bash
# Clone and run - that's it!
git clone https://github.com/liveaverage/launch-reachy2sim.git
cd launch-reachy2sim
./install.sh
```

After a few minutes, access your simulation:

<table>
<tr>
<th>🖥️ 3D Simulator</th>
<th>📓 Jupyter Lab</th>
<th>📡 SDK Server</th>
</tr>
<tr>
<td align="center">

**http://localhost:6080/vnc.html**

VNC web interface to<br/>RViz & Gazebo

</td>
<td align="center">

**http://localhost:8888**

Python notebooks for<br/>SDK development

</td>
<td align="center">

**localhost:50051**

gRPC endpoint for<br/>programmatic control

</td>
</tr>
</table>

---

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────────────────┐
│                         install.sh                                  │
│                    (Entry Point Script)                             │
└──────────────────────────┬──────────────────────────────────────────┘
                           │
           ┌───────────────┴───────────────┐
           ▼                               ▼
┌──────────────────────┐       ┌──────────────────────┐
│   setup_env.sh       │       │   start_reachy.sh    │
│  ─────────────────   │       │  ─────────────────   │
│  • Install Docker    │       │  • Pull Docker image │
│  • NVIDIA Toolkit    │       │  • Configure GPU     │
│  • User permissions  │       │  • Expose ports      │
└──────────────────────┘       └──────────┬───────────┘
                                          │
                                          ▼
                        ┌─────────────────────────────────┐
                        │  pollenrobotics/reachy2:latest  │
                        │  ─────────────────────────────  │
                        │                                 │
                        │   ┌─────────┐  ┌───────────┐   │
                        │   │  RViz   │  │  Gazebo/  │   │
                        │   │         │  │  MuJoCo   │   │
                        │   └─────────┘  └───────────┘   │
                        │                                 │
                        │   ┌─────────┐  ┌───────────┐   │
                        │   │ Jupyter │  │    SDK    │   │
                        │   │   Lab   │  │  Server   │   │
                        │   └─────────┘  └───────────┘   │
                        │                                 │
                        │    :6080       :8888    :50051  │
                        └─────────────────────────────────┘
```

### Docker Container Configuration

| Setting | Value | Purpose |
|:--------|:------|:--------|
| **Image** | `pollenrobotics/reachy2:latest` | Official Pollen Robotics image |
| **Container** | `reachy2_sim` | Easy identification |
| **Restart** | `unless-stopped` | Auto-recovery on failure |
| **Shared Memory** | `2GB` | Physics simulation buffer |
| **GPU** | `--gpus all` | Full GPU passthrough |

---

## ⚙️ Configuration

### Simulation Mode

Edit `scripts/start_reachy.sh` to switch physics engines:

```bash
# Default: Gazebo simulation
SIM_MODE="gazebo"

# Alternative: MuJoCo physics (faster, different dynamics)
SIM_MODE="mujoco"
```

<table>
<tr>
<th>Mode</th>
<th>Physics Engine</th>
<th>Best For</th>
</tr>
<tr>
<td><code>gazebo</code></td>
<td>Gazebo Classic</td>
<td>Full ROS 2 integration, sensor simulation, visualization</td>
</tr>
<tr>
<td><code>mujoco</code></td>
<td>MuJoCo</td>
<td>Faster physics, contact-rich manipulation, RL training</td>
</tr>
</table>

### Port Configuration

Default ports in `scripts/start_reachy.sh`:

```bash
-p 6080:6080 \   # 🖥️  VNC web interface
-p 8888:8888 \   # 📓 Jupyter Lab
-p 50051:50051   # 📡 SDK gRPC server
```

### Launch Arguments

| Flag | Default | Description |
|:-----|:--------|:------------|
| `start_rviz` | `true` | Launch RViz visualization |
| `start_sdk_server` | `true` | Enable gRPC SDK server |
| `fake` | `true` | Use simulated (not real) hardware |
| `gazebo` | `true`/`false` | Enable Gazebo simulation |
| `mujoco` | `false`/`true` | Enable MuJoCo simulation |

---

## 🐍 SDK Examples

### Connect to the Simulation

```python
from reachy_sdk import ReachySDK

# Connect to the simulated robot
reachy = ReachySDK(host="localhost", port=50051)
```

### Move the Robot Arm

```python
# Move right arm shoulder
reachy.r_arm.r_shoulder_pitch.goal_position = -30

# Coordinated arm movement
reachy.r_arm.goto(
    goal_positions=[0, -45, 0, -90, 0, 45, 0],
    duration=2.0,
    wait=True
)
```

### Access Camera Feeds

```python
from reachy_sdk.media import CameraView

# Get image from the left teleop camera
left_image, timestamp = reachy.cameras.teleop.get_frame(CameraView.LEFT)

# Display with OpenCV
import cv2
cv2.imshow('Reachy Vision', left_image)
cv2.waitKey(0)
```

> 📚 **Full SDK Documentation:** [docs.pollen-robotics.com](https://docs.pollen-robotics.com/developing-with-reachy-2/)

---

## 🔧 Container Management

```bash
# Check container status
docker ps -a | grep reachy2_sim

# View live logs
docker logs -f reachy2_sim

# Stop the simulation
docker stop reachy2_sim

# Restart the simulation
docker start reachy2_sim

# Full restart (remove and relaunch)
docker rm -f reachy2_sim
./scripts/start_reachy.sh
```

---

## 🔥 Troubleshooting

<details>
<summary><strong>❌ Docker permission denied</strong></summary>

```bash
# Option 1: Log out and back in (recommended after first install)
logout

# Option 2: Force group reload (install.sh does this automatically)
sg docker -c "./scripts/start_reachy.sh"
```

</details>

<details>
<summary><strong>❌ GPU not detected in container</strong></summary>

```bash
# Verify host GPU works
nvidia-smi

# Test NVIDIA Container Toolkit
docker run --rm --gpus all nvidia/cuda:12.0-base nvidia-smi

# Reconfigure if needed
sudo nvidia-ctk runtime configure --runtime=docker
sudo systemctl restart docker
```

</details>

<details>
<summary><strong>❌ Container exits immediately</strong></summary>

```bash
# Check logs for error details
docker logs reachy2_sim

# Common causes:
# • Insufficient shared memory → increase --shm-size
# • GPU memory exhausted → close other GPU applications
# • Port already in use → change port mappings
```

</details>

<details>
<summary><strong>❌ VNC page loads but shows nothing</strong></summary>

- Wait 30-60 seconds for RViz/Gazebo to initialize
- Verify container is running: `docker ps | grep reachy2_sim`
- Check logs: `docker logs reachy2_sim`

</details>

<details>
<summary><strong>🌐 Remote access setup</strong></summary>

```bash
# Get host IP
hostname -I | awk '{print $1}'

# Access remotely:
# http://<HOST_IP>:6080/vnc.html
# http://<HOST_IP>:8888

# Open firewall ports
sudo ufw allow 6080/tcp
sudo ufw allow 8888/tcp
sudo ufw allow 50051/tcp
```

</details>

---

## 📁 File Reference

| File | Purpose |
|:-----|:--------|
| `install.sh` | 🚀 Entry point—clones repo, runs setup, launches simulation |
| `scripts/setup_env.sh` | 🔧 Installs Docker + NVIDIA Container Toolkit |
| `scripts/start_reachy.sh` | 🤖 Launches Reachy 2 Docker container |

---

## 📦 Dependencies

**Installed automatically:**
- Docker Engine via [get.docker.com](https://get.docker.com)
- NVIDIA Container Toolkit

**Required on host:**
- NVIDIA GPU drivers
- `curl`, `sudo`, `git`

**Docker image:**
- `pollenrobotics/reachy2:latest` (~5-10GB)

---

## 🔗 References

<table>
<tr>
<td align="center">
<a href="https://www.pollen-robotics.com/reachy/">
<img src="https://img.shields.io/badge/Pollen%20Robotics-Reachy%202-00d4aa?style=flat-square" alt="Pollen Robotics"/>
</a>
<br/><sub>Official Website</sub>
</td>
<td align="center">
<a href="https://docs.pollen-robotics.com/">
<img src="https://img.shields.io/badge/Reachy%202-Documentation-blue?style=flat-square" alt="Documentation"/>
</a>
<br/><sub>SDK Docs</sub>
</td>
<td align="center">
<a href="https://github.com/pollen-robotics">
<img src="https://img.shields.io/badge/GitHub-pollen--robotics-181717?style=flat-square&logo=github" alt="GitHub"/>
</a>
<br/><sub>Source Code</sub>
</td>
<td align="center">
<a href="https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/">
<img src="https://img.shields.io/badge/NVIDIA-Container%20Toolkit-76B900?style=flat-square&logo=nvidia" alt="NVIDIA"/>
</a>
<br/><sub>GPU Runtime</sub>
</td>
</tr>
</table>

---

<p align="center">
  <sub>See upstream <a href="https://github.com/pollen-robotics">Pollen Robotics licensing</a> for Reachy 2 software components.</sub>
</p>
