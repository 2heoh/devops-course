USER = "$(shell id -u):$(shell id -g)"

app:
	docker-compose up

app-build:
	docker-compose build

app-bash:
	docker-compose run -p 3000:8080 --user=$(USER) app bash

development-setup-env:
	ansible-playbook ansible/development.yml -i ansible/development -vv
			