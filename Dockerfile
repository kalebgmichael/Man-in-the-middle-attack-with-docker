FROM ubuntu:20.04

# Set the timezone
ENV TZ=Europe/Rome
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Install required system dependencies
RUN apt-get update && apt-get install -y \
    iptables \
    tcpdump \
    dsniff \
    iproute2 \
    python3 \
    python3-pip \
    tmux \
    dnsutils

# Install specific versions of Werkzeug and mitmproxy
RUN pip3 install "werkzeug<2.1.0" "mitmproxy==7.0.4"

# Default command to keep the container running
CMD exec /bin/bash -c "trap : TERM INT; sleep infinity & wait"
