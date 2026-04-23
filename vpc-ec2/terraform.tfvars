env                   = "dev"
aws-region            = "us-west-2"
vpc-cidr-block        = "10.16.0.0/16"
vpc-name              = "vpc"
igw-name              = "igw"
pub-subnet-count      = 3
pub-cidr-block        = ["10.16.0.0/20", "10.16.16.0/20", "10.16.32.0/20"]
pub-availability-zone = ["us-west-2a", "us-west-2b", "us-west-2c"]
pub-sub-name          = "subnet-public"
pri-subnet-count      = 3
pri-cidr-block        = ["10.16.128.0/20", "10.16.144.0/20", "10.16.160.0/20"]
pri-availability-zone = ["us-west-2a", "us-west-2b", "us-west-2c"]
pri-sub-name          = "subnet-private"
public-rt-name        = "public-route-table"
private-rt-name       = "private-route-table"
eip-name              = "elasticip-ngw"
ngw-name              = "ngw"
eks-sg                = "eks-sg"
ec2-sg                = "ec2-sg"

ec2-iam-role             = "ec2-ssm-role"
ec2-iam-role-policy      = "ec2-ssm-role-policy"
ec2-iam-instance-profile = "ec2-ssm-instance-profile"

cluster-name = "eks-cluster"
ec2-name     = "eks-deploy-server"
