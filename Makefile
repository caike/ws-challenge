.PHONY : build clean stop up

all : build up

build :
	docker-compose build

clean :
	docker-compose down --remove-orphans
	docker-compose rm
	docker image prune
	docker volume prune

stop :
	docker-compose stop

up :
	docker-compose up

