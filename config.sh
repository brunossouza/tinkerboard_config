sudo locale-gen pt_BR.UTF-8
update-locale LANG=pt_BR.UTF-8

sudo apt update -y 
sudo apt upgrade -y 

curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

sudo usermod -aG docker linaro

sudo echo "" > /etc/apt/sources.list
sudo cp ./source/sources.list.py6 /etc/apt/sources.list

sudo apt update
sudo apt install -y python3.6

sudo echo "" > /etc/apt/sources.list
sudo cp ./source/sources.list.orig /etc/apt/sources.list

sudo apt update

git clone https://github.com/docker/compose.git
cd compose
git checkout bump-1.24.1
sed -i -e 's:^VENV=/code/.tox/py36:VENV=/code/.venv; python3 -m venv $VENV:' script/build/linux-entrypoint
sed -i -e '/requirements-build.txt/ i $VENV/bin/pip install -q -r requirements.txt' script/build/linux-entrypoint
docker build -t docker-compose:armhf -f Dockerfile.armhf .
docker run --rm --entrypoint="script/build/linux-entrypoint" -v $(pwd)/dist:/code/dist -v $(pwd)/.git:/code/.git "docker-compose:armhf"
sudo cp dist/docker-compose-Linux-armv7l /usr/local/bin/docker-compose

sudo chown root:root /usr/local/bin/docker-compose
sudo chmod 0755 /usr/local/bin/docker-compose

docker-compose version

sudo reboot