# terraform

```
export YC_TOKEN=$(yc iam create-token)
export YC_CLOUD_ID=$(yc config get cloud-id)
export YC_FOLDER_ID=$(yc config get folder-id)
export ACCESS_KEY="<идентификатор_ключа>"
export SECRET_KEY="<секретный_ключ>"

terraform init -backend-config="access_key=$ACCESS_KEY" -backend-config="secret_key=$SECRET_KEY"
terraform apply -var="folder_id=$YC_FOLDER_ID"
```