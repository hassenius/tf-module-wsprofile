variable "profile_create_opts" {
  description = "Configuration items for ICP installation."
  type        = "map"
  default     = {}
}

variable "user_home" {
  description = "Home directory of the user where WebSphere is installed"
  default     = ""
}

variable "wsadmin_user" {
  description = "Username for profile admin user. Default: wsadmin"
  default     = "wsadmin"
}

variable "admin_password" {
  description = "Password for profile admin user. Default 'Generate' to generate a new random password"
  default     = "Generate"
}

variable "server" {
  description = "Server to deploy software to"
}

variable "ssh_user" {
  description = "Username for Terraform to SSH to the VM. This is typically the default user with for the relevant cloud vendor. Default: ubuntu"
  default     = "ubuntu"
}

variable "ssh_key" {
  description = "Optional: Private key corresponding to the public key that the cloud servers are provisioned with."
  default     = ""
}

variable "ssh_key_content" {
  description = "Optional: Base64 encoded content of the private key corresponding to the public key that the cloud servers are provisioned with."
  default     = "None"
}

variable "ssh_password" {
  description = "Optional: Password to connect to newly created cloud server."
  default     = ""
}
