FROM ubuntu:16.04

# Prepare directories
RUN mkdir /config

# Install dependencies
RUN apt-get update && apt-get -y install libmicrohttpd-dev libssl-dev cmake build-essential libhwloc-dev nano

# Clean
RUN rm -rf /var/lib/apt/lists/*

# Get Code
ADD https://github.com/fireice-uk/xmr-stak-cpu/archive/v1.3.0-1.5.0.tar.gz /opt/
RUN mkdir /opt/xmr-stak-cpu
RUN tar xfv *.tar.gz --strip 1 -C /opt/xmr-stak-cpu
RUN cd /opt/xmr-stak-cpu
RUN cmake .
RUN make

# Volume
VOLUME /config
ADD https://raw.githubusercontent.com/kenayagi/docker-xmrstakcpu/master/xmr-stak-cpu.conf /config/xmr-stak-cpu.conf

# Ports
EXPOSE 8080

# Command
CMD ["/opt/xmr-stak-cpu/bin/xmr-stak-cpu", "/config/xmr-stak-cpu.conf"]
