ssh-private-key-path   = "/home/fga/.ssh/id_rsa_mcs"
ssh-public-key-path    = "/home/fga/.ssh/id_rsa_mcs.pub"


# K8s configuration  ----------------------------------------------------------
k8s-master_count         = "1"
k8s-instance-name        = "terracluster"
k8s-flavor-name          = "Standard-2-4-40"


k8s-node_count           = "2"
k8s-node-flavor-id       = "Standard-2-4-40"
k8s-node-disk-size       = "20"
k8s-node-disk-type       = "ssd"
# Basic-1-2-20
