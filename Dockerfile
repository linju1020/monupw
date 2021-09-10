FROM azraelrabbit/monupw

RUN sudo sed -i 's/# export MONO_IOMAP="all"/export MONO_IOMAP="all"/' /usr/jexus/jws