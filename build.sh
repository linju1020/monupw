set -e

docker stop abc || true
docker rm abc || true

docker image rm linju1020/monupw:2 || true
docker build --no-cache -t linju1020/monupw:2 .

docker run -d --name abc -v /etc/localtime:/etc/localtime linju1020/monupw:2

docker exec -it abc /bin/bash