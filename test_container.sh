docker run -dit --name ansible-test-debian -p 2222:22 -v /home/$(whoami)/developer/lnmp_laravel_setup:/etc/ansible debian:12
docker exec ansible-test-debian sh -c "apt update && apt install -y openssh-server sudo"
docker exec ansible-test-debian mkdir -p /root/.ssh
docker exec ansible-test-debian chmod 700 /root/.ssh
docker cp ~/.ssh/id_ed25519.pub ansible-test-debian:/root/.ssh/authorized_keys_temp
docker exec ansible-test-debian sh -c "cat /root/.ssh/authorized_keys_temp >> /root/.ssh/authorized_keys && chmod 600 /root/.ssh/authorized_keys && rm /root/.ssh/authorized_keys_temp"
docker exec ansible-test-debian service ssh start
docker exec ansible-test-debian sh -c "apt install -y python3"