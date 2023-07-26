variable "yandex_cloud_id" {
  default = "b1gk0tcpmdt9lhdnsjrl"
}

variable "yandex_folder_id" {
  default = "b1g1qalus625i26qmq56"
}

variable "instance-nat-ip" {
  default = "192.168.10.254"
}

variable "domain" {
  default = "netology.ycloud"
}

variable "user_name" {
  description = "VM User Name"
  default     = "ubuntu"
}

variable "user_ssh_key_path" {
  description = "User's SSH public key file"
  default     = "~/.ssh/id_rsa.pub"
}
