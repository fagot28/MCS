
#!/usr/bin/env bash

export OS_AUTH_URL="https://infra.mail.ru:id/v3/"

export OS_PROJECT_ID="123"
unset OS_PROJECT_NAME
unset OS_PROJECT_DOMAIN_ID

# unset v2.0 items in case set
unset OS_TENANT_ID
unset OS_TENANT_NAME

if [[ -z $OS_USERNAME ]] || [[ -z $OS_PASSWORD ]] || [[ "$OS_USERNAME" != "user@mail.ru" ]]; then

export OS_USERNAME="user@mail.ru"
export OS_USER_DOMAIN_NAME="users"
export OS_PASSWORD="password"

fi

export OS_INTERFACE=public
export OS_IDENTITY_API_VERSION=3

# Terraform variables ----------------------------------------------------------
export TF_VAR_username=$OS_USERNAME
export TF_VAR_password=$OS_PASSWORD
export TF_VAR_tenant_id=$OS_PROJECT_ID
export TF_VAR_auth_url=$OS_AUTH_URL
export TF_VAR_user_domain_id=$OS_USER_DOMAIN_NAME
