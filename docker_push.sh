#!/bin/bash

#echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
#docker push USER/REPO

docker ps
docker container ls
sudo docker login --username $HEROKU_DOCKER_USERNAME --password $HEROKU_AUTH_TOKEN registry.heroku.com
sudo docker tag gmapsapp_backend:latest registry.heroku.com/gmapsapp/backend
sudo docker inspect --format='{{.Id}}' registry.heroku.com/gmapsapp/backend
if [ $TRAVIS_BRANCH == "master" ] && [ $TRAVIS_PULL_REQUEST == "false" ]; then sudo docker push registry.heroku.com/gmapsapp/web; fi
sudo docker tag gmapsapp_nginx:latest registry.heroku.com/gmapsapp/nginx
sudo docker inspect --format='{{.Id}}' registry.heroku.com/gmapsapp/nginx
if [ $TRAVIS_BRANCH == "master" ] && [ $TRAVIS_PULL_REQUEST == "false" ]; then sudo docker push registry.heroku.com/gmapsapp/nginx; fi

chmod +x heroku-container-release.sh

sudo chown $USER:docker ~/.docker
sudo chown $USER:docker ~/.docker/config.json
sudo chmod g+rw ~/.docker/config.json

./heroku-container-release.sh
