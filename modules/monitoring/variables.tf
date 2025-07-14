variable "alb_arn" {}

variable "instance_ids" {
  type    = list(string)
  default = []
}

