#/bin/dash

COMMAND=$(printf '        - %s\\n' "$@")'#'

NAME=laravel-job-$(date +%s)
CRONJOB="$(kubectl get cronjob -o=custom-columns='name:.metadata.name' --no-headers | grep laravel-phpfpm)"

echo "
apiVersion: batch/v1
kind: Job
metadata:
  name: ${NAME}
spec:
  template:
$( \
  kubectl get cronjob ${CRONJOB} -o yaml | \
  grep '^        ' | \
  sed \
    -e 's/^    //' \
    -e "s/creationTimestamp: null/name: ${NAME}/" \
    -e "s/laravel-phpfpm-scheduler/${NAME}/g" \
    -e "s/\s*- schedule:run/$COMMAND/" \
)" | kubectl create -f -

POD="$(kubectl get pods -a | grep ${NAME} | awk '{printf $1}')"
echo "Found pod: ${POD}"

until kubectl logs -f "${POD}"
do
  sleep 1
done
