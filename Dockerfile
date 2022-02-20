# This for mono-opt under ubuntu 16.04
FROM ubuntu:16.04

RUN apt update
RUN apt install sudo
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
RUN sudo apt install -y --force-yes apt-transport-https ca-certificates

#RUN sh -c "echo 'deb https://download.mono-project.com/repo/ubuntu stable-xenial main' | sudo tee /etc/apt/sources.list.d/mono-official-stable.list"
#RUN apt update && sudo apt install -y --force-yes mono-devel mono-complete referenceassemblies-pcl openssh-server curl
RUN /bin/sh -c echo "deb http://download.mono-project.com/repo/debian jessie/snapshots/5.0.1.1 main" > /etc/apt/sources.list.d/mono-official.list   && apt-get update   && apt-get install -y binutils mono-devel ca-certificates-mono fsharp mono-vbnc nuget referenceassemblies-pcl   && rm -rf /var/lib/apt/lists/* /tmp/*

RUN sudo sed -i 's/UsePAM yes/UsePAM no/g' /etc/ssh/sshd_config
RUN mkdir -p /var/run/sshd && \
      echo "root:monups" |chpasswd  && \
      useradd admin  &&  echo "admin:monupw" | chpasswd  &&  echo "admin   ALL=(ALL)       ALL" >> /etc/sudoers 

# Fix PAM login issue with sshd
RUN sed -i 's/session    required     pam_loginuid.so/#session    required     pam_loginuid.so/g' /etc/pam.d/sshd

#set the PATH for mono-opt
ENV PATH $PATH:/opt/mono/bin
ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:/opt/mono/lib
ENV PKG_CONFIG_PATH $PKG_CONFIG_PATH:/opt/mono/lib/pkgconfig

# install mono web server Jexus
RUN cd /tmp && curl https://jexus.org/release/x64/install.sh | sh

RUN mkdir /data
#&& touch /data/x && mkdir /data/jwslog && mkdir /data/siteconf && mkdir /data/wwwroot
#RUN cp /usr/jexus/siteconf/default /data/siteconf/
#RUN cp /usr/jexus/jws.conf /usr/jexus/jws.conf.backup
#RUN sed -i 's/SiteLogDir=log/SiteLogDir=/data/jwslog/g' /usr/jesus/jws.conf && sed -i 's/SiteConfigDir=siteconf/SiteConfigDir=/data/siteconf/g' /usr/jexus/jws.conf
RUN sudo sed -i "s/root=\/ \/var\/www\/default/root=\/ \/data/g" /usr/jexus/siteconf/default

# by LJG
RUN sudo sed -i 's/# export MONO_IOMAP="all"/export MONO_IOMAP="all"/' /usr/jexus/jws

VOLUME ["/data"]

# open port for ssh 
EXPOSE 22  8081  80

# open port for jexus web server
#EXPOSE 8081

# open port for default http 80
#EXPOSE 80


#&& /usr/jexus/jws start
#ENTRYPOINT /usr/sbin/sshd -D 
#CMD    ["/usr/sbin/sshd", "-D"]
CMD  /usr/jexus/jws start && /usr/sbin/sshd -D



