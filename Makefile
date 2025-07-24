SHELL := /bin/bash # Use bash syntax

up:
	docker-compose up --remove-orphans

up_hide:
	docker-compose up -d --remove-orphans

up_build:
	docker-compose up --build --remove-orphans

down:
	docker-compose down

build:
	docker-compose build

open_container:
	docker exec -it laravel_project bash