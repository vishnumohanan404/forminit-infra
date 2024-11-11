
resource "civo_network" "custom_network" {
  label = "custom-network"

}


# Define a firewall for the Kubernetes cluster
resource "civo_firewall" "my_firewall" {
  name                 = "my-firewall"
  create_default_rules = true
  network_id           = civo_network.custom_network.id
  depends_on           = [civo_network.custom_network]
}

# Define the Kubernetes cluster
resource "civo_kubernetes_cluster" "my_cluster" {
  name        = "my-cluster"
  firewall_id = civo_firewall.my_firewall.id # Reference the firewall ID here
  network_id  = civo_network.custom_network.id
  pools {
    node_count = 2
    size       = "g4s.kube.small"
  }

  depends_on = [civo_firewall.my_firewall] # Ensure the firewall is created first
}

# Output kubeconfig as a string
output "kubeconfig" {
  value     = civo_kubernetes_cluster.my_cluster.kubeconfig
  sensitive = true
}