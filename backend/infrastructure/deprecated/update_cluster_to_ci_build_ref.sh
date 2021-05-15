#!/bin/bash

# This is a placeholder script until RBAC with CI is finalized, at which time it
# will be removed.

if [[ $# -ne 2 && $# -ne 3 ]]
then
    echo "Usage: ./update_cluster_to_ci_build_ref.sh KUBECTL_FROM_CONTEXT KUBECTL_TO_CONTEXT"
    echo "or ./update_cluster_to_ci_build_ref.sh KUBECTL_TO_CONTEXT KUBECTL_TO_CONTEXT KUBE_TO_REVISION"
    echo "NOTE: this script is a stand-in for RBAC-based functionality and should be used with care"
    exit
fi

FROM_CONTEXT="$1"
TO_CONTEXT="$2"

if [ "x$HELM" == "x" ]
then
    HELM=helm
fi

FROM_NAMESPACE=$(kubectl config view -o jsonpath="{.contexts[?(@.name == \"${FROM_CONTEXT}\")].context.namespace}")
if [ "x$FROM_NAMESPACE" == "x" ]
then
    FROM_NAMESPACE="default"
fi
FROM_NAME=$($HELM --namespace=${FROM_NAMESPACE} --kube-context=${FROM_CONTEXT} list | grep buckram | awk '{print $1}')

if [[ "$FROM_CONTEXT" == "$TO_CONTEXT" && "x$3" != "" ]]
then
    FROM_REVISION="$3"
    TO_NAME="${FROM_NAME}"
else
    FROM_PHPFPM_CONTAINER=$(kubectl get deployment $FROM_NAME-laravel-phpfpm --context=${FROM_CONTEXT} -o=custom-columns='NAME:.spec.template.spec.containers[0].image' --no-headers)
    FROM_REVISION=$(echo $FROM_PHPFPM_CONTAINER | sed 's/.*:.*-//g')
    TO_NAMESPACE=$(kubectl config view -o jsonpath="{.contexts[?(@.name == \"${TO_CONTEXT}\")].context.namespace}")
    if [ "x$TO_NAMESPACE" == "x" ]
    then
	TO_NAMESPACE="default"
    fi
    TO_NAME=$($HELM --namespace=${TO_NAMESPACE} --kube-context=${TO_CONTEXT} list | grep buckram | awk '{print $1}')
fi
TO_PHPFPM_CONTAINER=$(kubectl get deployment $TO_NAME-laravel-phpfpm --context=${TO_CONTEXT} -o=custom-columns='NAME:.spec.template.spec.containers[0].image' --no-headers)
TO_REPO=$(echo $TO_PHPFPM_CONTAINER | sed 's/:.*//g')

echo "Updating release ${TO_NAME} from ${FROM_NAME}"

echo "Basing ${TO_NAME} update off the PHP-FPM deployment, with repo ${TO_REPO} and revision ${FROM_REVISION}"

select answer in "Proceed" "Cancel"; do
    case $answer in
	Proceed )
	    echo "Yes"

	    kubectl --context=${TO_CONTEXT} set image deployment/$TO_NAME-laravel-nginx nginx="$TO_REPO:nginx-${FROM_REVISION}"
	    kubectl --context=${TO_CONTEXT} patch cronjob.v1beta1.batch $TO_NAME-laravel-phpfpm -p "{\"spec\": {\"jobTemplate\": {\"spec\": {\"template\": {\"spec\": {\"containers\": [{\"name\": \"laravel-phpfpm-scheduler\",\"image\": \"$TO_REPO:phpfpm-${FROM_REVISION}\"}]}}}}}}"
	    kubectl --context=${TO_CONTEXT} set image deployment/$TO_NAME-laravel-phpfpm-worker laravel-phpfpm-artisan-worker="$TO_REPO:phpfpm-${FROM_REVISION}"
	    kubectl --context=${TO_CONTEXT} set image deployment/$TO_NAME-laravel-phpfpm laravel-phpfpm="$TO_REPO:phpfpm-${FROM_REVISION}"

	    break
	    ;;
	Cancel )
	    echo "No"
	    exit
	    ;;
    esac
done
