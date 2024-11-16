#Network
resource "civo_network" "custom_network" {
  label = "custom-network"
}

# Firewall
resource "civo_firewall" "my_firewall" {
  name                 = "my-firewall"
  create_default_rules = false
  network_id           = civo_network.custom_network.id
  depends_on           = [civo_network.custom_network]
  ingress_rule {
    label      = "http"
    protocol   = "tcp"
    port_range = "80" # Added HTTP (port 80) rule
    cidr       = ["0.0.0.0/0"]
    action     = "allow"
  }
  ingress_rule {
    label      = "https"
    protocol   = "tcp"
    port_range = "443"
    cidr       = ["0.0.0.0/0"]
    action     = "allow"
  }
  ingress_rule {
    label      = "allow_k8s_api"
    protocol   = "tcp"
    port_range = "6443"
    cidr       = ["0.0.0.0/0"]
    action     = "allow"
  }
  egress_rule {
    label      = "all"
    protocol   = "tcp"
    port_range = "1-65535"
    cidr       = ["0.0.0.0/0"]
    action     = "allow"
  }
}

# Kubernetes cluster
resource "civo_kubernetes_cluster" "my_cluster" {
  name             = "my-cluster"
  firewall_id      = civo_firewall.my_firewall.id
  network_id       = civo_network.custom_network.id
  write_kubeconfig = true
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
