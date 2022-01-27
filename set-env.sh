# Either your ACCESS_KEY and SECRET_KEY or from a serviceaccount
export OS_ACCESS_KEY="REPLACE_ME"
export OS_SECRET_KEY="REPLACE_ME"
export AWS_ACCESS_KEY_ID=$OS_ACCESS_KEY
export AWS_SECRET_ACCESS_KEY=$OS_SECRET_KEY

export OS_DOMAIN_NAME="OTC-EU-DE-REPLACE_ME"
export OS_PROJECT_NAME="eu-de"
export TF_VAR_project_name=${OS_PROJECT_NAME}

export TF_VAR_region="eu-de"

# Current Stage you are working on for example dev,qa, prod etc.
export TF_VAR_stage_name="dev"
#Current Context you are working on can be customer name or cloud name etc.
export TF_VAR_context_name="showcase"

# Pull Secrets for Git and Dockerhub
export TF_VAR_argocd_github_access_token="REPLACE_ME"
export TF_VAR_argocd_gitlab_access_token="REPLACE_ME"
export TF_VAR_dockerconfig_json_base64_encoded="REPLACE_ME"