postgres_service_external_name_deploy:
	kustomize edit set namespace kans-$(app)-$(env)
	kustomize build --enable-alpha-plugins --enable-exec . | kubectl apply --filename -
