variable "project_id" {
  description = "Your GCP project ID (find it in the GCP Console dashboard)"
  type        = string
}

variable "region" {
  description = "GCP region. Stick to us-central1, us-west1, or us-east1 to stay in the always-free tier."
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "GCP zone within the region."
  type        = string
  default     = "us-central1-a"
}

variable "machine_type" {
  description = "GCP machine type. e2-micro is always-free tier eligible. Upgrade to e2-small (~$13/mo) if Juice Shop feels sluggish."
  type        = string
  default     = "e2-micro"
}
