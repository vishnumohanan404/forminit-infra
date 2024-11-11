#Network
resource "civo_network" "custom_network" {
  label = "custom-network"
}


# Firewall
resource "civo_firewall" "my_firewall" {
  name                 = "my-firewall"
  create_default_rules = true
  network_id           = civo_network.custom_network.id
  depends_on           = [civo_network.custom_network]
}

# Kubernetes cluster
resource "civo_kubernetes_cluster" "my_cluster" {
  name        = "my-cluster"
  firewall_id = civo_firewall.my_firewall.id
  network_id  = civo_network.custom_network.id
  pools {
    node_count = 2
    size       = "g4s.kube.medium"
  }
  depends_on = [civo_firewall.my_firewall] # Ensure the firewall is created first
}

# Confirmation
output "kubeconfig" {
  value     = civo_kubernetes_cluster.my_cluster.kubeconfig
  sensitive = true
}
