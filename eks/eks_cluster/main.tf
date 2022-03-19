resource "aws_iam_role" "eks_cluster" {
  name = "eks-cluster"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.eks_cluster.name
}

resource "aws_eks_cluster" "eks_cluster" {
  name     = "${var.cluster_name}-${terraform.workspace}"
  enabled_cluster_log_types = ["api", "audit", "authenticator","controllerManager","scheduler"]
  role_arn = aws_iam_role.eks_cluster.arn

  vpc_config {
    subnet_ids = concat(var.public_subnets, var.private_subnets)
  }

  tags = {
    Name = "eks_cluster_${terraform.workspace}"
  }
  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.AmazonEKSServicePolicy
  ]
}

resource "aws_eks_node_group" "node" {
  cluster_name    = var.eks_cluster_name
  node_group_name = "${var.node_group_name}-${terraform.workspace}"
  node_role_arn   = aws_iam_role.eks_nodes.arn
  subnet_ids      = var.subnet_ids
  instance_types  = var.instance_types
  disk_size       = var.disk_size

  scaling_config {
    desired_size = var.desired_nodes
    max_size     = var.max_nodes
    min_size     = var.min_nodes
  }
  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
  ]
}

