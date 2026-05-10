output "instance_ip" {
  description = "Public IP address of the Juice Shop instance"
  value       = google_compute_instance.juiceshop.network_interface[0].access_config[0].nat_ip
}

output "juiceshop_url" {
  description = "URL to access Juice Shop in a browser"
  value       = "http://${google_compute_instance.juiceshop.network_interface[0].access_config[0].nat_ip}:3000"
}
