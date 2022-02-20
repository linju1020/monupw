FROM azraelrabbit/monupw

RUN sudo sed -i 's/# export MONO_IOMAP="all"/export MONO_IOMAP="all"/' /usr/jexus/jws

#Install mono
RUN sudo apt-get install -y --force-yes mono-devel mono-complete referenceassemblies-pcl openssh-server curl
