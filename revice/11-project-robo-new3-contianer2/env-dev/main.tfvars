env="dev"
bastion_nodes=["172.31.3.63/32"]
zone_id="Z02556032JV56RSCGA16T"
vpc={
    cidr="10.10.0.0/16"
    public_subnets=["10.10.0.0/24","10.10.1.0/24"] # 24 will bring 56 ips az1 ,az2
    web_subnets=["10.10.2.0/24","10.10.3.0/24"] # 24 will bring 56 ips
    app_subnets=["10.10.4.0/24","10.10.5.0/24"] # 24 will bring 56 ips
    db_subnets=["10.10.6.0/24","10.10.7.0/24"] # 24 will bring 56 ips
    availability_zones=["ap-south-2a","ap-south-2b"]
    default_vpc_id="vpc-0a814be354897a863"
    default_vpc_rt="rtb-0cf04062d48dae201"
    default_vpc_cidr="172.31.0.0/16"
}

# apps={
#     frontend={
#         subnet_ref= "web"
#         instance_type = "t3.small"
#         allow_port = 80
#         allow_sg_cidr = ["10.10.0.0/24","10.10.1.0/24"]# allow public subnet traffic only
#         # it can acces internet-hidden using nat gateway, but ir will allow only incoming traffic from public
#         allow_lb_sg_cidr=["0.0.0.0/0"]
#         capcity={
#             desired=1
#             max=1
#             min=1
#         }
#          # lb_internal=true
#         lb_ref="public"# frontend
#         # acm_https_arn= null
#         lb_rule_priority = 1
#     }
#     catalogue={
#         subnet_ref= "app"
#         instance_type = "t3.small"
#         allow_port = 8080
#         allow_sg_cidr = ["10.10.4.0/24","10.10.5.0/24"]# allow web subnet for app- traffic only
#         # it can acces internet-hidden using nat gateway, but ir will allow only incoming traffic from public
#         allow_lb_sg_cidr=["10.10.2.0/24","10.10.3.0/24","10.10.4.0/24","10.10.5.0/24"]# access same subnet also
#         capcity={
#             desired=1
#             max=1
#             min=1
#         }
#          # lb_internal=true
#         lb_ref="private"
#         # acm_https_arn= null
#          lb_rule_priority = 1
#     }
#     user={
#         subnet_ref= "app"
#         instance_type = "t3.small"
#         allow_port = 80
#         allow_sg_cidr = ["10.10.4.0/24","10.10.5.0/24"]# allow web subnet for app- traffic only
#         # it can acces internet-hidden using nat gateway, but ir will allow only incoming traffic from public
#         allow_lb_sg_cidr=["10.10.2.0/24","10.10.3.0/24","10.10.4.0/24","10.10.5.0/24"] # sometimes need internal connection itsel through load balancer
#         capcity={
#             desired=1
#             max=1
#             min=1
#         }
#         # lb_internal=true
#         lb_ref="private"
#         # acm_https_arn= null
#          lb_rule_priority = 2
#     }
#     cart={
#         subnet_ref= "app"
#         instance_type = "t3.small"
#         allow_port = 80
#         allow_sg_cidr = ["10.10.4.0/24","10.10.5.0/24"]# allow web subnet for app- traffic only
#         # it can acces internet-hidden using nat gateway, but ir will allow only incoming traffic from public
#         allow_lb_sg_cidr=["10.10.2.0/24","10.10.3.0/24","10.10.4.0/24","10.10.5.0/24"]
#         capcity={
#             desired=1
#             max=1
#             min=1
#         }
#        # lb_internal=true
#         lb_ref="private"
#         # acm_https_arn= null
#          lb_rule_priority = 3
#     }
#     shipping={
#         subnet_ref= "app"
#         instance_type = "t3.small"
#         allow_port = 80
#         allow_sg_cidr = ["10.10.4.0/24","10.10.5.0/24"]# allow web subnet for app- traffic only
#         # it can acces internet-hidden using nat gateway, but ir will allow only incoming traffic from public
#         allow_lb_sg_cidr=["10.10.2.0/24","10.10.3.0/24","10.10.4.0/24","10.10.5.0/24"]
#         capcity={
#             desired=1
#             max=1
#             min=1
#         }
#         # lb_internal=true
#         lb_ref="private"
#         # acm_https_arn= null
#          lb_rule_priority = 4
#     }
#     payment={
#         subnet_ref= "app"
#         instance_type = "t3.small"
#         allow_port = 80
#         allow_sg_cidr = ["10.10.4.0/24","10.10.5.0/24"]# allow web subnet for app- traffic only
#         # it can acces internet-hidden using nat gateway, but ir will allow only incoming traffic from public
#         allow_lb_sg_cidr=["10.10.2.0/24","10.10.3.0/24","10.10.4.0/24","10.10.5.0/24"]
#         capcity={
#             desired=1
#             max=1
#             min=1
#         }
#         # lb_internal=true
#         lb_ref="private"
#         # acm_https_arn= null
#          lb_rule_priority = 5
#     }
# }
db={
    # mongo={
    #     subnet_ref= "db"
    #     instance_type = "t3.small"
    #     allow_port = 27017
    #     allow_sg_cidr = ["10.10.4.0/24","10.10.5.0/24"]# allow only ap subnets to access security
    # }
    # mysql={
    #     subnet_ref= "db"
    #     instance_type = "t3.small"
    #     allow_port = 3306
    #     allow_sg_cidr = ["10.10.4.0/24","10.10.5.0/24"]# allow only ap subnets to access security
    # }
    # rabbitmq={
    #     subnet_ref= "db"
    #     instance_type = "t3.small"
    #     allow_port = 5672
    #     allow_sg_cidr = ["10.10.4.0/24","10.10.5.0/24"]# allow only ap subnets to access security
    # }
    # redis={
    #     subnet_ref= "db"
    #     instance_type = "t3.small"
    #     allow_port = 6379
    #     allow_sg_cidr = ["10.10.4.0/24","10.10.5.0/24"]# allow only ap subnets to access security
    # }
}
# load_balancers={#create seperate load balancer
#     private={
#         internal            =   true
#         load_balancer_type  =   "application"
#         allow_lb_sg_cidr    =   ["10.10.2.0/24","10.10.3.0/24","10.10.4.0/24","10.10.5.0/24"]
#         subnet_ref          =   "app"
#         acm_https_arn       =   null
#         listener_port       = "80"
#         listener_protocol   = "HTTP"
#         ssl_policy          =  null
#     }
#     public={
#         internal            =   false
#         load_balancer_type  =   "application"
#         allow_lb_sg_cidr    =   ["0.0.0.0/0"]
#         subnet_ref          =   "public"
#         acm_https_arn       =   "arn:aws:acm:ap-south-2:058264470882:certificate/4cd9df2c-4516-4d66-ad57-c84f1ba19b50"
#         listener_port       = "443"
#         listener_protocol   = "HTTPs"
#         ssl_policy          = "ELBSecurityPolicy-2016-08"
#     }

# }


# change in vault port 8080 -> 80
#secrets-cart, and shipping as 80,payment->80
#multiple node groups
eks={
    eks_version="1.30"
    node_groups={
        
        main-spot={
            
            min_size=1
            max_size=3
            instance_types=["t3.medium"]
            capacity_type="SPOT"
        }
    }
    add_ons={
        vpc-cni="v1.18.3-eksbuild.2"
        kube-proxy="v1.30.3-eksbuild.20"
        coredns="v1.11.1-eksbuild.11" 
        eks-pod-identity-agent = "v1.3.2-eksbuild.2"
        
    }
    eks-iam-access={
        workstation={
            principal_arn=  "arn:aws:iam::058264470882:role/workstation-devops"
            policy="arn:aws:iam::cluster-access-policy/AmazonEKSClusterAdminPolicy"
            kubernetes_groups = []
        }
        #add sso group policy 23-aug-37.57
    }
}