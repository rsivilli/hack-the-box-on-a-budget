# Hack The Box on a Budget

A minimal Terraform setup to deploy [OWASP Juice Shop](https://owasp.org/www-project-juice-shop/) on GCP — a free (or near-free) intentionally vulnerable web app for learning web application security.

Juice Shop is a realistic fake e-commerce site with 100+ hidden security challenges covering SQL injection, XSS, broken authentication, and more. It has a built-in scoreboard and is widely used for CTF-style learning.

## Cost

This runs on a GCP `e2-micro` instance, which falls under GCP's [always-free tier](https://cloud.google.com/free/docs/free-cloud-features#compute) in `us-central1`, `us-west1`, and `us-east1`. **Cost: $0/month** under normal single-user usage.

If you need more performance, change `machine_type` to `e2-small` (~$13/month).

## Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/install) >= 1.0
- A GCP account with billing enabled
- [gcloud CLI](https://cloud.google.com/sdk/docs/install) authenticated (`gcloud auth application-default login`)

## Setup

**1. Create a dedicated GCP project** (recommended for clean billing isolation):

```bash
gcloud projects create hack-the-box-ctf --name="Hack The Box CTF"
gcloud billing projects link hack-the-box-ctf --billing-account=YOUR_BILLING_ACCOUNT_ID
```

**2. Configure your variables:**

```bash
cp terraform.tfvars.example terraform.tfvars
```

Edit `terraform.tfvars` and fill in your `project_id`. The defaults are fine for everything else.

**3. Deploy:**

```bash
terraform init
terraform apply
```

Type `yes` when prompted. Terraform will provision the instance and print the Juice Shop URL when done. Give it 2-3 minutes after `apply` completes for Docker to pull the image and start the app.

## Accessing Juice Shop

The `juiceshop_url` output gives you the URL to share with your player — it looks like:

```
http://<ip>:3000
```

To verify the app is running on the instance:

```bash
gcloud compute ssh juiceshop --project=hack-the-box-ctf --zone=us-central1-a
sudo docker ps
sudo docker logs juiceshop -f
```

Juice Shop is ready when the logs show `Server listening on port 3000`.

## Scoreboard (hosts only)

The scoreboard is intentionally hidden as the first challenge. As the host, you can access it directly at:

```
http://<ip>:3000/#/score-board
```

Don't share this URL with your player — finding it is part of the game.

## Teardown

```bash
terraform destroy
```

This removes all GCP resources. If you're fully done, you can also delete the project:

```bash
gcloud projects delete hack-the-box-ctf
```
