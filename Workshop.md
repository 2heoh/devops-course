## Перед воркшопом прочитать/посмотреть

* Раздел "Сети" любой книги по операционкам
* https://ru.atlassian.com/devops
* https://12factor.net/ru
* https://www.youtube.com/watch?v=m_5sos7i1Qk
* https://habr.com/ru/post/305400/
* https://guides.hexlet.io/docker/
* https://habr.com/ru/company/piter/blog/351878/
* https://habr.com/ru/post/267797/
* https://ru.hexlet.io/courses/cli-basics
* https://www.youtube.com/watch?v=pK9mF5aK05Q
* https://www.pagerduty.com/resources/learn/post-mortem-incident-report/
* https://bronevichok.ru/blog/2015/04/26/engineering-at-booking.com.html
* https://www.youtube.com/watch?v=WPCz_U7D8PI

## Пререквизиты

* Зарегистрированный DO аккаунт (партнерский линк с бонусом https://m.do.co/c/143ed180769e). Будьте готовы, что мы потратим в районе 10$ в результате наших экспериментов (скорее всего сильно меньше)
* Установленный и работающий docker
* Установленный и работающий ansible
* Установленный и работающий terraform (подключите его к DO)
* linux/mac

## Задание 

## Build From Scratch

Всегда сверяйтесь с https://github.com/hexlet-basics/hexlet_basics в котором реализована часть описанных вещей

1. File Structure

    ```
    project_name/
      ansible/
      services/
      terraform/
      .gitignore
    ```

1. Create project (web project using your stack)

    ```
    services/app
    ```

1. Commit project to your repository

1. Setup docker compose (https://docs.docker.com/compose/gettingstarted/)

    * Add `./services/app/Dockerfile.development`

        ```
        FROM <your lang>
        ENV PROJECT_ROOT /usr/src/app
        WORKDIR $PROJECT_ROOT
        ```

    * Create `project_name/docker-compose.yml` with _app_ services

        ```
        version: '3.3'

        services:
          app:
            build:
              context: services/app
              dockerfile: Dockerfile.development
            command: # https://docs.docker.com/compose/compose-file/#command
            ports:
              # https://docs.docker.com/compose/compose-file/#ports
            volumes:
	      # https://docs.docker.com/compose/compose-file/#volumes
              - "~/.bash_history:/.bash_history"
              - "./services/app:/usr/src/app:cached"
              - "/tmp:/tmp:delegated"
        ```

    * Add `./services/app/.dockerignore`

      ```
      tmp
      log
      ```

1. Add `project_name/make-app.mk` and include it to `Makefile`.

    ```make
    USER = "$(shell id -u):$(shell id -g)"

    app:
    	docker-compose up

    app-build:
    	docker-compose build

    app-bash:
    	docker-compose run --user=$(USER) app bash
    ```

1. Install deps

    ```
    $ make app-bash # goes to the app container
    <run command to install deps>
    ```

1. Run `make app` and check that site is working.


1. Add `make setup`

    ```make
    app-setup: app-build
    	docker-compose run --user=$(USER) app <install deps>

    app-build:
    	docker-compose build
    ```

1. Add nginx to services

    * Create `services/nginx/<you_domain_name>.conf`

        ```
        upstream application_server {
          server YOU_APP_CONTAINER_NAME:YOUR_PORT_NUMBER;
        }

        server {
          listen 80;
          server_name YOUR_SERVER_NAME;

          # root /root/path/to/your_app/public;

          try_files $uri/index.html $uri.html @app;

          location @app {
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header Host $http_host;
            proxy_redirect off;
            proxy_pass http://application_server;
          }
        }
        ```
    * Create `services/nginx/Dockerfile` and copy config to `/etc/nginx/conf.d/default.conf`
    * Add _nginx_ service to `project_name/docker-compose.yml`

1. Run app `make app` and open page `/`

1. Checkpoint

    * Commit everything
    * Remove project
    * Clone project
    * Run `make app-setup app`
    * Open site and check it on page `/`
    
1. Clone and setup hexlet-basics. Open browser and check it.

1. Create Ansible project structure

    * http://docs.ansible.com/ansible/latest/playbooks_best_practices.html
    * http://docs.ansible.com/ansible/latest/intro_inventory.html#group-variables

    * Add `ansible/group_vars/all/vars.yml`
    * Add `ansible/group_vars/all/vault.yml`

    * Add `ansible/development/group_vars/all/vars.yml`
    * Add `ansible/development/group_vars/all/vault.yml`

1. Add `ansible/development/inventory`

    ```ini
    localhost ansible_connection=local
    ```

1. Create playbook `ansible/development.yml` which generate `project_name/.env` from template `ansible/templates/environment.j2`

    https://docs.ansible.com/ansible/latest/modules/template_module.html

1. Add `.env` to `.gitignore`.

1. Create `development-setup-env` and run it (for check)

    ```make
    development-setup-env:
    	ansible-playbook ansible/development.yml -i ansible/development -vv
    ```

1. Add `development-setup-env` as deps for `app-setup`

    ```make
    app-setup: development-setup-env app-build
    	docker-compose run app <install deps>
    ```

1. Add `project_name/.env` to `docker-compose.yml`

    ```yaml
    app:
      env_file: ".env"
    ```

1. Setup port number by env for `docker-compose.yml` and `application`

    * Create apropriate variables in `ansible/group_vars/all/vars.yml`
    * set env _PORT_ in `ansible/templates/environment.j2`
    * https://docs.docker.com/compose/environment-variables/#the-env-file

1.  Send Application logs to STDOUT

1. Setup Application Env For Production

    * create application var (RAILS_ENV, NODE_ENV, MIX_ENV etc) `ansible/production/group_vars/all/vars.yml` with value for production
    * create application var `ansible/development/group_vars/all/vars.yml` with value for development
    * set env for application variable in `ansible/templates/environment.j2`

1. Add tasks for encrypt and decrypt ansible vaults to `make-ansible.mk`

    https://docs.ansible.com/ansible/2.4/vault.html

    ```make
    ansible-vaults-encrypt:
    	ansible-vault encrypt ansible/production/group_vars/all/vault.yml

    ansible-vaults-decrypt:
    	ansible-vault decrypt ansible/production/group_vars/all/vault.yml
	
    ansible-vaults-edit:
        ansible-vault edit ansible/production/group_vars/all/vault.yml
    ```

    Always encrypt before commit!

1. Create `services/app/Dockerfile.production`

    * Install deps
    * Copy project to image

1. Check locally that production image can be built successfully

    ```sh
    docker build -f services/app/Dockerfile.production -t <имя образа> services/app
    ```

1. Create repository `workshop-devops-app` on Docker Cloud

    * Join with github/bitbucket
    * Configure autobuild for master branch (docker tag: latest)
    * Make commit for triggering building

1. Create `services/app/docker-compose.test.yml`

    https://docs.docker.com/docker-cloud/builds/automated-testing/

    ```
    version: '2'
      services:
        db: # if need
          image: postgres
          environment:
            POSTGRES_USER: web
        sut:
          build:
            context: .
            dockerfile: Dockerfile.production
          command: make test
          depends_on:
            - db
    ```
    
1. Run tests throught docker-compose

    ```sh
    docker-compose -f services/app/docker-compose.test.yml run sut
    ```

1. Checkpoint

    * Build new image version and ensure that tests was passed on the Docker Cloud

1. Add nginx to the docker cloud

    * Create `workshop-devops-nginx` repository on docker cloud
    * Connect with bitbucket
    * Autbuild latest on commit

1. Add remote servers to `ansible/production/inventory`

1. Setup DO by hands

1. Install https://github.com/digitalocean/doctl

    ```
    doctl compute image list --public | grep docker
    ```
    
1. Setup python3

    https://docs.ansible.com/ansible/latest/reference_appendices/python_3_support.html

1. Write `ansible/deploy.yml` playbook

    * download images
    * run migrations
    * start new application version
    * write `make production-deploy`
    
    https://github.com/hexlet-basics/hexlet_basics/blob/3ab6005b48ac81fa81585ac4080d7844d1a4b48c/ansible/deploy.yml

1. Deploy application + nginx

    * Check your domain

1. Create task `make production-deploy-app` which deploy only application

    * use the same playbook with tag `app`

### Terraform

1. Setup Droplet
1. Setup balancer