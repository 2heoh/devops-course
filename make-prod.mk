production-ping:
	ansible-playbook ansible/deploy.yml -i ansible/production -t ping -vv --vault-password-file ../../vault.txt	

production-setup:
	ansible-playbook ansible/setup-docker.yml -i ansible/production --vault-password-file ../../vault.txt

production-deploy:
	ansible-playbook ansible/deploy.yml -i ansible/production --vault-password-file ../../vault.txt

production-deploy-app:
	ansible-playbook ansible/deploy.yml -i ansible/production -t app --vault-password-file ../../vault.txt	