# ======================== #
# VMs configuration        #
# ======================== #

vm-master-count         = "3"
vm-worker-count         = "3"
vm-name-prefix          = "K8S-NODE"
vm-master-name          = "MASTER"
vm-worker-name          = "WORKER"
vm-master-template-name = "K8S-Master-CentOS-7-9-2009-template"
vm-template-name        = "K8S-CentOS-7-9-2009-template"
vm-cpu                  = 16
vm-ram                  = 32768
vm-hdd-master           = 25
vm-hdd                  = 100
vm-scsi                 = "lsilogic"
vm-guest-id             = "centos64Guest"

# ============================ #
# MCS configuration            #
# ============================ #

# MCS username used to deploy the infrastructure
mcs-username = "fadgerman@mail.ru"

# MCS password used to deploy the infrastructure
mcs-password = "GrendyA4tech"

# MSC project id
mcs-project-id = "f0f622ba7fc54ea69fd01edc7ef4eb53"

# MCS auth_url "https://infra.mail.ru/identity/v3/"
mcs-auth-url = "https://infra.mail.ru:35357/v3/"
