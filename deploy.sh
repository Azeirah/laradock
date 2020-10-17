# assumption 1) docker is running
# assumption 2) the workspace container is running

development=$1
if [[ -n $development ]]; then
    FILES="-f basis-docker-compose.yml -f development-docker-compose.override.yml"
    echo 'running for development';
else
    FILES="-f basis-docker-compose.yml -f production-docker-compose.override.yml"
fi

# build the dependency installation container
docker-compose $FILES build --no-cache code

# prepare for maintenance
docker-compose $FILES exec --user=laradock workspace php artisan down
docker-compose $FILES exec --user=laradock workspace php artisan optimize:clear

# install dependencies
docker-compose $FILES up code

# update the code
cd ..
git pull
cd laradock

# start server again
docker-compose $FILES exec --user=laradock workspace php artisan optimize
docker-compose $FILES exec --user=laradock workspace php artisan up
