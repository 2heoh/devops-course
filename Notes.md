
### Первый созвон
* Что такое DevOps
* Когда закрыта задача?
* На хекслете 5 раз в день
* "Невозможно бить на мелкие задачи"
* ДевОпс - это не профессия 
* Микросервисы решают организационные проблемы
* https://github.com/mholt/caddy
* https://www.youtube.com/watch?v=l5ug_W9iFUs
* https://habr.com/ru/post/322474/
* https://www.youtube.com/watch?v=pK9mF5aK05Q
* Настройки приложения должны храниться вовне 

### Второй созвон
* learn once write anywhere
* https://docs.docker.com/develop/develop-images/dockerfile_best-practices/
* Слоёная структура Dockerfile - кешируется по строчкам-слоям 

### Третий созвон
* sudo lsof -i :portnumber 
* https://wiki.archlinux.org/index.php/Network_bridge
* Книжка Робачевский про операционки
* InterProcessCommunication (IPC)
* Ambasador Pattern
* https://www.youtube.com/watch?v=WPCz_U7D8PI&t=4873s
* Ansible - single source of truth (vault)
* Эволюционное проектирование баз данных 
* .env

### Четвертый созвон
* https://github.com/hexlet-basics/hexlet_basics/blob/3ab6005b48ac81fa81585ac4080d7844d1a4b48c/ansible/deploy.yml
* Terraform
    * Имеет state
    * Может импортить существующие дроплеты
    * https://www.terraform.io/docs/providers/do/index.html

### Пятый созвон 
* S3 половина интернета
* Менеджмент секретов
* systemd - основной супервизор в современном linux
* docker - это супервизор
* cgroups
* https://docs.docker.com/config/containers/resource_constraints/
* Datadog
* На хекслете постоянно кончаются иноды
* Задание на code dojo
    * Написать тестовый фреймворк
    * Web-сервер
    * Event loop

Как настроена супервизия:
```    
docker_container:
        recreate: true
        name: hexlet-basics-nginx
        image: "{{ hexlet_basics_nginx_image_name }}:{{ hexlet_basics_image_tag }}"
        state: started
        # log_driver: awslogs
        # log_options:
        #   awslogs-group: "{{ hexlet_basics_aws_logs_group }}"
        #   awslogs-stream: "{{ hexlet_basics_aws_logs_stream_web }}"
        #   awslogs-region: '{{ hexlet_basics_aws_region }}'
        restart_policy: always
        published_ports:
          - "80:8080"
        networks:
          - name: "{{ hexlet_basics_docker_network }}"
      tags: [webserver]
```