production-setup:
	ansible-playbook ansible/setup-docker.yml -i ansible/production -vv --vault-password-file ../../vault.txt

production-deploy:
	ansible-playbook ansible/deploy.yml -i ansible/production -vv --vault-password-file ../../vault.txt

production-deploy-app:
	ansible-playbook ansible/deploy.yml -i ansible/production -t app -vv --vault-password-file ../../vault.txt	