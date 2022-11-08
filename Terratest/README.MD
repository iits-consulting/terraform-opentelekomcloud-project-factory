# How to test it locally

You need the following environment variables

```shell
export OS_DOMAIN_NAME=""
export OS_ACCESS_KEY=""
export OS_SECRET_KEY=""
export TF_VAR_region="eu-nl" #or eu-de
export TF_VAR_context="terratest"
```

Then you can execute the tests like this

```shell
cd Terratest
go test -timeout 90m
```

or you can go into the folder and apply it manually

```shell
cd Terratest/network
terraform init
terraform apply
```

**Please destroy the resources after you are done**