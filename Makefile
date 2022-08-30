CONTAINER_NAME=localstack
TFPATH="infrastructure/environments/local"
CODEPATH="source/"

clean:
	rm -rf infrastructure/environments/local/.terraform/* infrastructure/environments/local/terraform.tfstate*
pull:
	docker pull localstack/localstack
	docker pull localstack/localstack-full
start: #stop
	docker-compose up -d
stop:
	docker container stop ${CONTAINER_NAME}
	docker container rm ${CONTAINER_NAME}
status:
	localstack status services
logs:
	docker logs -f ${CONTAINER_NAME}
init:
	cd ${TFPATH} && tflocal init
apply: init compile-hello compile-goodbye
	cd ${TFPATH} && tflocal apply
destroy:
	cd ${TFPATH} && tflocal destroy
compile-hello:
	cd ${CODEPATH}/hello && go build
compile-goodbye:
	cd ${CODEPATH}/goodbye && go build