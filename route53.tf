resource "aws_route53_record" "www" {
  zone_id = "${var.domain_zone_id}"
  name    = "${var.custom_url}-${var.environment}.${var.domain}"
  type    = "A"

  alias {
    name                   = "${aws_alb.main.dns_name}"
    zone_id                = "${aws_alb.main.zone_id}"
    evaluate_target_health = false
  }
}
