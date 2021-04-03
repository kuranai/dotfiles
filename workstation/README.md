# Workstation build

This terraform setup creates a workstation on DigitalOcean with my personal
setup and ready to use mosh setup.

## Install

1. Create workstation server

```
$ export SCW_ACCESS_KEY="my-access-key"
$ export SCW_SECRET_KEY="my-secret-key"
$ export SCW_DEFAULT_PROJECT_ID="Project-id" #can be found here: https://console.scaleway.com/project/settings
$ terraform plan
$ terraform apply -auto-approve
```
2. SSH via mosh:

```
$ mosh --no-init --ssh="ssh -o StrictHostKeyChecking=no -i ~/.ssh/id_rsa -p 22" root@<SERVER_IP> -- tmux new-session -ADs main
$ ./secrets/pull-secrets.sh
```
3. do some more setup
```
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/github_rsa
```

