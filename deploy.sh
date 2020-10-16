# assumption 1) docker is running
# assumption 2) the workspace container is running

development=$1
if [[ -n $development ]]; then
    FILES="-f basis-docker-compose.yml -f development-docker-compose.override.yml"
    echo 'running for development';
else
    FILES="-f basis-docker-compose.yml -f production-docker-compose.override.yml"
fi
docker-compose $FILES build --no-cache code
docker-compose $FILES exec workspace php artisan down
docker-compose $FILES exec workspace php artisan cache:clear
docker-compose $FILES up code
docker-compose $FILES exec workspace php artisan optimize
if [[ -n $development ]]; then
    make development-up
else
    make up
fi
docker-compose $FILES exec workspace php artisan up
