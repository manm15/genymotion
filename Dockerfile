# Use the official Ubuntu image as the base image
FROM ubuntu:20.04

# Install required dependencies
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y wget unzip openjdk-11-jdk xvfb x11vnc fluxbox python3 python3-pip supervisor

# Download and install the Genymotion emulator
RUN wget https://dl.genymotion.com/releases/genymotion-3.2.0/genymotion-3.2.0-linux_x64.bin -O genymotion.bin && \
    chmod +x genymotion.bin && \
    echo 'y' | ./genymotion.bin -d /opt/genymotion && \
    rm genymotion.bin

# Set up the VNC server
RUN mkdir ~/.vnc && \
    x11vnc -storepasswd 1234 ~/.vnc/passwd

# Install Python dependencies
COPY requirements.txt /app/requirements.txt
RUN pip3 install -r /app/requirements.txt

# Install NoVNC2
RUN wget https://github.com/novnc/noVNC/archive/v1.2.0.zip && \
    unzip v1.2.0.zip && \
    mv noVNC-1.2.0 /opt/noVNC && \
    rm v1.2.0.zip

# Configure supervisord
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Start the Genymotion emulator and NoVNC2 using supervisord
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
