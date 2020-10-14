database=mariadb
server=nginx
services=redis \
	 laravel-horizon \
	 mail \
	 nginx-proxy \
	 nginx-proxy-letsencrypt
dev_services=redis \
	laravel-horizon \

development-up:
	docker-compose -f basis-docker-compose.yml -f development-docker-compose.override.yml up -d $(server) $(database) $(dev_services)

development-build:
	docker-compose -f basis-docker-compose.yml -f development-docker-compose.override.yml build -d $(server) $(database) $(dev_services)

up:
	docker-compose -f basis-docker-compose.yml -f production-docker-compose.override.yml up -d $(server) $(database) $(services)

restart:
	docker-compose -f basis-docker-compose.yml -f production-docker-compose.override.yml restart

down:
	docker-compose down

work:
	docker-compose exec --user laradock workspace bash

rebuild:
	docker-compose build --no-cache $(server) $(database) $(services)

nuke-db: confirm
	echo 'nuking db'
	docker-compose stop $(database)
	docker-compose rm $(database)
	rm -rf ~/.laradock/data/$(database)/
	docker-compose build --no-cache $(database)
	docker-compose up -d $(database)

confirm:
	@echo -n "Are you sure? [y/N] " && read ans && [ $${ans:-N} = y ]
