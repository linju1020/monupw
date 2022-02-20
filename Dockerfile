FROM azraelrabbit/monupw

RUN sudo sed -i 's/# export MONO_IOMAP="all"/export MONO_IOMAP="all"/' /usr/jexus/jws

RUN sudo apt-get install -y --force-yes apt-transport-https
#Install mono
RUN sudo apt-get update && \
        sudo apt-get install -y --force-yes mono-devel mono-complete referenceassemblies-pcl openssh-server curl
