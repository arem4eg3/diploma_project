resource "yandex_iam_service_account" "sa" {
  name      = var.service_account
  folder_id = var.folder_id
}


resource "yandex_resourcemanager_folder_iam_member" "sa-role" {
  for_each  = var.sa-role
  role      = each.value
  member    = "serviceAccount:${yandex_iam_service_account.sa.id}"
  folder_id = var.folder_id
}

resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
  service_account_id = yandex_iam_service_account.sa.id
  description        = "static access key for object storage"
}
