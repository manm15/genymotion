# Use the official Ubuntu image as the base image
FROM ubuntu:20.04

# Install required dependencies
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y wget unzip openjdk-11-jdk xvfb x11vnc fluxbox novnc

# Download and install the Genymotion emulator
RUN wget https://dl.genymotion.com/releases/genymotion-3.2.0/genymotion-3.2.0-linux_x64.bin -O genymotion.bin && \
    chmod +x genymotion.bin && \
    echo 'y' | ./genymotion.bin -d /opt/genymotion && \
    rm genymotion.bin

# Set up the VNC server
RUN mkdir ~/.vnc && \
    x11vnc -storepasswd 1234 ~/.vnc/passwd

# Start the Genymotion emulator
CMD ["bash", "-c", "/opt/genymotion/player --vm-name 'test' & sleep 30 && novnc --listen 80 --vnc localhost:5900"]
