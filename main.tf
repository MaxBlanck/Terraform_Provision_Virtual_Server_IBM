# Configure the IBM Cloud Provider
provider "ibm" {
  bluemix_api_key    = "${var.ibm_bmx_api_key}"
  softlayer_username = "${var.ibm_sl_username}"
  softlayer_api_key  = "${var.ibm_sl_api_key}"
}

# Create an SSH key. You can find the SSH key surfaces in the SoftLayer console under Devices > Manage > SSH Keys
resource "ibm_compute_ssh_key" "ssh_key_1" {
  label      = "PoC_Daimler_Terraform" #creates a new entry in IBM Softlayer
  public_key = "${var.ssh_public_key}"
}

# Create a virtual server with the SSH key
resource "ibm_compute_vm_instance" "virtual-server-1" {
  hostname          = "poc-virtual-server-terraform-hourly-01"
  domain            = "Oliver-Seiffert-s-Account.cloud"
  ssh_key_ids       = ["${ibm_compute_ssh_key.ssh_key_1.id}"]
  os_reference_code = "REDHAT_7_64"
  datacenter        = "tor01"
  network_speed     = 10
  cores             = 1
  memory            = 1024

  #Copy file from from machine to ressource
  provisioner "file" {
    source      = "files/"
    destination = "/tmp/"

    connection {
      type        = "ssh"
      user        = "root"
      private_key = "${file("./.ssh/id_Terraform_Daimler_PoC")}." #https://www.terraform.io/docs/configuration/interpolation.html#file_path_
    }
  }

  # Execute commands on the host using the 'remote-exec' provisioner
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/install.sh",
      "sh /tmp/install.sh",
    ]
     connection {
      type        = "ssh"
      user        = "root"
      private_key = "${file("./.ssh/id_Terraform_Daimler_PoC")}." #https://www.terraform.io/docs/configuration/interpolation.html#file_path_
    }
  }
}
