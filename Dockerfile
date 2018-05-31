FROM ubuntu:16.04

# Prepare directories
RUN mkdir /config

# Install dependencies
RUN apt-get update && apt-get -y install libmicrohttpd-dev libssl-dev cmake build-essential libhwloc-dev nano

# Clean
RUN rm -rf /var/lib/apt/lists/*

# Get Code
ADD https://github.com/IndeedMiners/xmr-aeon-stak/archive/2.4.7.tar.gz /opt/xmr-stak-cpu.tar.gz
RUN mkdir /opt/xmr-stak-cpu
RUN tar xfv /opt/xmr-stak-cpu.tar.gz --strip 1 -C /opt/xmr-stak-cpu
RUN sed -i 's/fDevDonationLevel = 1.0/fDevDonationLevel = 0.0/' /opt/xmr-stak-cpu/xmrstak/donate-level.hpp
WORKDIR /opt/xmr-stak-cpu/
RUN cmake -DCUDA_ENABLE=OFF -DOpenCL_ENABLE=OFF .
RUN make

# Volume
ADD https://raw.githubusercontent.com/hkese/newxmrstakcpu/master/config.txt /opt/xmr-stak-cpu/config.txt
ADD https://raw.githubusercontent.com/hkese/newxmrstakcpu/master/cpu.txt /opt/xmr-stak-cpu/cpu.txt
ADD https://raw.githubusercontent.com/hkese/newxmrstakcpu/master/pools.txt /opt/xmr-stak-cpu/pools.txt

# Ports
EXPOSE 8888

# Command
CMD ["/opt/xmr-stak-cpu/bin/xmr-stak"]
