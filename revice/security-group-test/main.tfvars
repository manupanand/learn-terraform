cp_ingress={
 
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
cp_egress={  # remove outbound rule make it  0.0.0.0/0
    kubelet_api         =  {
                            port="10250"
                            #cidr of kube
                            }
    node_port           =  {
                            port="30000-32767"
                            #cidr of kube
                            }
}
worker_ingress={
    kubelet_api={
        port="10250"
    }
    kube_proxy={
        port="10256"
    }
    node_port={
        port="30000-32767"
    }
    internal={
        port="65535"
    }


}
worker_egress={ # make it all onternt 0.0.0.0/0
    kube_api_server={
        port = "6433"
    }
}


