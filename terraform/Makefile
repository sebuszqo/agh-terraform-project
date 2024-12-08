TF=terraform
TF_FLAGS=-lock=false

TF_STATE_FILE=terraform.tfstate

.PHONY: init plan apply destroy validate fmt

init:
	@echo "Initializing Terraform..."
	$(TF) init

plan:
	@echo "Generating Terraform plan..."
	$(TF) plan $(TF_FLAGS)

apply:
	@echo "Applying Terraform configuration..."
	$(TF) apply -auto-approve

destroy:
	@echo "Destroying Terraform-managed infrastructure..."
	$(TF) destroy -auto-approve $(TF_FLAGS)

validate:
	@echo "Validating Terraform configuration..."
	$(TF) validate

fmt:
	@echo "Formatting Terraform files..."
	$(TF) fmt -recursive
