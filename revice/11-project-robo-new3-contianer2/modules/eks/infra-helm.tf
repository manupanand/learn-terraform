# get kube config
resource "null_resource" "kube-config" {
  depends_on =[aws_eks_node_group.main]

  provisioner "local-exec" {
    command = <<EOF
    aws eks update-kubeconfig --name ${var.env}-eks
    kubectl create secret generic vault-token --from-literal=token=#vaulttokenprovide here -n kube-system

    EOF
  }
}
# create above commad yaml file  /opt and run from therr in github runner

# external secrets
resource "helm_release" "external-secrets" {
    depends_on = [ null_resource.kube-config]
    name        = "external-secrets"
    repository  = "https://charts.external-secrets.io"
    chart       ="external-secrets"
    namespace   = "kube-system"
    wait        = true
}

# create kubesecrets using kubecli
resource "null_resource" "external-secrets-store" {
  depends_on = [ helm_release.external-secrets ,null_resource.kube-config]
    provisioner "local-exec" {
      command = <<EOF
        kubectl apply -f - <<EOK
        apiVersion: external-secrets.io/v1beta1
        kind: ClusterSecretStore
        metadata:
            name: vault-backend
        spec:
            provider:
                vault:
                    server: "http://vault.manupanand.online:8200"
                    path: "roboshop-${var.env}"
                    version: "v2"
                    auth: 
                        tokenSecretRef: 
                            name: "vault-token"
                            key: "token"
                            namespace: kube-system
    EOK

    EOF
    }
}

# metric server for HPA

resource "null_resource" "metric-server-hpa" {
  depends_on = [ null_resource.kube-config ]

  provisioner "local-exec" {
    command =<<EOF
        kubectl apply -f https://github.com/kubenetes-sigs/releases/latest/download/component.yaml
    EOF
  }
}

# prometheus stack
#helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
resource "helm_release" "prometheus-stack" {
  depends_on =   [ null_resource.kube-config, helm_release.nginx-ingress ]
  name       =   "prometheus"
  repository =   "https://prometheus-community.github.io/helm-charts"
  chart      =   "kube-prometheus-stack"
  namespace  =   "kube-system"
  wait       =   true
  values = [
    file("${path.module}/helm-config/prometheus-stack.yaml")
  ]
  set_list {
    name="grafana.ingress.hosts"
    value = ["grafana-${var.env}.manupanand.online"]
  }
  set_list {
    name="prometheus.ingress.hosts"
    value = ["prometheus-${var.env}.manupanand.online"]
  }
}

# ingress - nginx-ingress |load balancer
#helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
# resource "helm_release" "nginx-ingress" {
#   depends_on = [null_resource.kube-config  ]
#   name       = "ingress-nginx"
#   repository = "https://kubernetes.github.io/ingress-nginx"
#   chart      = "ingress-nginx"
#   namespace  = "kube-system"
#   wait       =  true  

#    values = [
#     file("${path.module}/helm-config/nginx-ingress.yaml")
#   ]
# }# classic load balancer
# if want to change add annotation to changeload balancer type

#external-dns to sync with awsroute53 and ingress
resource "helm_release" "external-dns" {
  depends_on = [null_resource.kube-config  ]
  name       = "route53-dns"
  repository = "https://kubernetes-sigs.github.io/external-dns"
  chart      = "external-dns"
  namespace  = "kube-system"
  wait       =  true  
}# automatically sync but have to give permission throug IAM role
# pod idenetity agent add ons and pod iedneity configuration


# aws Load balancer controller ingress
resource "helm_release" "aws-controller-ingress" {
  depends_on = [null_resource.kube-config  ]
  name       = "aws-ingress"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"
  wait       =  true  

  #  values = [
  #   file("${path.module}/helm-config/nginx-ingress.yaml")
  # ]
  set {
    name = "clusterName"
    value = aws_eks_cluster.main.name
  }
  set {
    name="vpcId"
    value = var.vpc_id
  }
}