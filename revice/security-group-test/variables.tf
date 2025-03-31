
 
   variable "vpc_name" {
     default = "dev-private-vpc"
   }
   variable "subnet_name" {
     default = "dev-kube-subnet"
   }
   variable "cp_ingress" {
     default = {
        kube_api_server          =   {
                            port="6443"
                            #cidr of kube
                            }
    etcd                =   {
                            port="2379-2380"
                            #cidr of kube
                            }
    kubelet_api_sche_con_manger         =  {
                            port="10248-10260"
                            #cidr of kube
                            }
    internal            ={
        port="65535"
    }
     }
   }
   variable "cp_egress" {
    default= { 
        kubelet_api     =  {
                            port="10250"
                            #cidr of kube
                            }
    node_port           =  {
                            port="30000-32767"
                            #cidr of kube
                            }}
   }