#!/bin/bash
LANG=en_us_88591

function getStageSecretsBucket(){
  if [[ -z "${OS_PROJECT_NAME}" ]]; then
    echo "Mandatory Env Variable \"OS_PROJECT_NAME\" not found. Please switch to a directory with a suitable \".envrc\" file and run \"direnv allow\" before executing again."
    return 1
  fi
  PROJECT=${OS_PROJECT_NAME/"_"/"-"}
  CONTEXT=${TF_VAR_context/"_"/"-"}
  BUCKET_NAME=$PROJECT-$CONTEXT-$TF_VAR_stage-stage-secrets
  secretspath="/terraform-secrets"
  current_date=$(date +'%a, %d %b %Y %H:%M:%S %z')
  request_string="GET\n\n\n${current_date}\n/${BUCKET_NAME}${secretspath}"
  signed_reqest=$(echo -en "${request_string}" | openssl sha1 -hmac "${AWS_SECRET_ACCESS_KEY}" -binary | base64)
  curl -s -H "Host: ${BUCKET_NAME}.obs.${TF_VAR_region}.otc.t-systems.com" \
       -H "Date: ${current_date}" \
       -H "Authorization: AWS ${AWS_ACCESS_KEY_ID}:${signed_reqest}" \
       "https://${BUCKET_NAME}.obs.${TF_VAR_region}.otc.t-systems.com${secretspath}"
}

function getKubectlConfig() {
    getStageSecretsBucket | jq -r ."kubectl_config" > ~/.kube/config || true
}

function getElbPublicIp(){
    elbPublicIp=$(getStageSecretsBucket | jq -r ."elb_public_ip")
    echo "ELB-PUBLIC-IP: $elbPublicIp"
}

function getElbId() {
    elbID=$(getStageSecretsBucket | jq -r ."elb_id")
    echo "ELB-ID: $elbID"
}

function argo(){
  local ARGOCD_PASSWORD=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)
  echo "Username=admin, password=$ARGOCD_PASSWORD"


  if [[ $(uname) == "Linux" ]]; then
    xdg-open http://localhost:8080/argocd && kubectl -n argocd port-forward svc/argocd-server 8080:80
  else
    open http://localhost:8080/argocd && kubectl -n argocd port-forward svc/argocd-server 8080:80
  fi
}

function traefik() {
  local localhost_port="9000"
  echo "Open \"http://localhost:${localhost_port}/dashboard/#/\" to see your treafik dashboard"
  kubectl -n routing port-forward $(kubectl get pod -n routing -o jsonpath="{.items[0].metadata.name}") ${localhost_port}:9000

}

alias kubens='kubectl config set-context --current --namespace '
alias deleteErrorPods="kubectl delete pods --field-selector status.phase=Failed --all-namespaces"
alias kubeEnv="kubectl config current-context"