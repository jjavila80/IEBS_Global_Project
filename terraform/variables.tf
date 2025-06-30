variable "instance_type" {
  description = "Tipo de instancia EC2"
  type        = string
  default     = "t3.micro"
}

variable "ubuntu_version" {
  description = "Versión de Ubuntu Server (ej: 20.04)"
  type        = string
  default     = "20.04"
}

variable "key_pair_name" {
  description = "Nombre del par de claves"
  type        = string
  default     = "ec2_key_pair"
}

