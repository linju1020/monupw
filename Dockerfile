FROM mono:5.0

RUN  uname -a

COPY sources.list /etc/apt/sources.list
RUN apt-get update
RUN apt-get install curl
#RUN apt-get install sudo
 
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
RUN  sed -i "s/root=\/ \/var\/www\/default/root=\/ \/data/g" /usr/jexus/siteconf/default

# by LJG
RUN  sed -i 's/# export MONO_IOMAP="all"/export MONO_IOMAP="all"/' /usr/jexus/jws

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



