resource "yandex_dns_zone" "zone1" {
  name        = var.dns_zone.name
  description = "${var.dns_zone.name} zone"

  zone   = var.dns_zone.zone
  public = var.dns_zone.public
}