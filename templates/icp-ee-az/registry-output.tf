module "gather_output" {
	dependsOn					= "${module.icp_provision.install_complete}"
    source 						= "git::https://github.com/IBM-CAMHub-Open/template_icp_modules.git?ref=3.2.1//public_cloud_output"
	cluster_CA_domain 			= "${element(azurerm_public_ip.master_pip.*.fqdn, 0)}"
	icp_master 					= "${azurerm_network_interface.master_nic.*.private_ip_address}"
	ssh_user 					= "${var.admin_username}"
	ssh_key_base64 				= "${base64encode(tls_private_key.vmkey.private_key_pem)}"
	bastion_host 				= "${azurerm_public_ip.bootnode_pip.ip_address}"
	bastion_user    			= "${var.admin_username}"
    bastion_private_key_base64 	= "${base64encode(tls_private_key.vmkey.private_key_pem)}"
}

output "registry_ca_cert"{
  value = "${module.gather_output.registry_ca_cert}"
} 

output "icp_install_dir"{
  value = "${module.gather_output.icp_install_dir}"
} 

output "registry_config_do_name"{
	value = "${var.instance_name}${random_id.clusterid.hex}RegistryConfig"
}
