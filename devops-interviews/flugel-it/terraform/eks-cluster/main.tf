# EKS Cluster
resource "aws_security_group" "eks-cluster" {
  name        = "${var.cluster-name}-sg"
  description = "Internet communication within EKS cluster"
  vpc_id      = aws_vpc.eks-cluster.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.workstation-ip]
    description = "Mgmt station access to cluster API server"
  }
}

resource "aws_eks_cluster" "eks-cluster" {
  name     = "${var.cluster-name}"
  role_arn = aws_iam_role.eks-cluster.arn

  vpc_config {
    security_group_ids = ["${aws_security_group.eks-cluster.id}"]
    subnet_ids         = aws_subnet.eks-cluster[*].id
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks-cluster-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.eks-cluster-AmazonEKSServicePolicy,
  ]
}

# EKS Worker Nodes
resource "aws_eks_node_group" "eks-workers" {
  cluster_name    = aws_eks_cluster.eks-cluster.name
  node_group_name = "eks-workers"
  node_role_arn   = aws_iam_role.eks-workers.arn
  subnet_ids      = aws_subnet.eks-cluster[*].id

  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks-workers-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.eks-workers-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.eks-workers-AmazonEC2ContainerRegistryReadOnly,
  ]
}
