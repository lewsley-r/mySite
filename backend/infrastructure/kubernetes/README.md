This directory contains a Helm chart for launching a Kubernetes cluster based on this app.

See the readme.md in the root directory for more information.

To add a Kubernetes integration for Gitlab:

# Turn on Gitlab repo's Settings->Integrations->Kubernetes
# `kubectl create -f gitlab-ci-user.yml`
# `kubectl get secrets` - find the gitlab-ci token
# `kubectl get secret gitlab-ci-token-XYZAB -o yaml`
# Take the ca.crt output from the above and run through `echo -n "CHARS" | base64 -d`. Paste this into the Gitlab Kubernetes CA Certificate box
# Take the token output from the above and run through `echo -n "CHARS" | base64 -d`. Paste this into the Gitlab Kubernetes Token box
# Add the API URL (https://api.[cluster.url])

To add an AWS ECR integration for Gitlab:

# Create an IAM user with ECR permissions and programmatic access
# Create a single ECR image repository
# Add AWS_DEFAULT_REGION, AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, AWS_ECR_URI as CI variables
