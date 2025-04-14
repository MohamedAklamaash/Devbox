# To create a role

```bash
aws iam create-role --role-name EKSNodeRole \
  --assume-role-policy-document file://<(cat <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
)
```
# And attach these policies

```bash
aws iam attach-role-policy --role-name EKSNodeRole --policy-arn arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy
aws iam attach-role-policy --role-name EKSNodeRole --policy-arn arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly
aws iam attach-role-policy --role-name EKSNodeRole --policy-arn arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy
```

---

# Attaching Subnets to EKS

```bash
aws ec2 create-tags --resources subnet-0219cb3de64d3fe86 \
  --tags Key=kubernetes.io/cluster/microservices,Value=owned

aws ec2 create-tags --resources subnet-028e14b3d4ca899a0 \
  --tags Key=kubernetes.io/cluster/microservices,Value=owned

aws ec2 create-tags --resources subnet-01d8fd3dee1b3b460 \
  --tags Key=kubernetes.io/cluster/microservices,Value=owned

aws ec2 create-tags --resources subnet-01fba226b0e006c59 \
  --tags Key=kubernetes.io/cluster/microservices,Value=owned

aws ec2 create-tags --resources subnet-08561eab5cd3653f4 \
  --tags Key=kubernetes.io/cluster/microservices,Value=owned

aws ec2 create-tags --resources subnet-07389a037cab38a09 \
  --tags Key=kubernetes.io/cluster/microservices,Value=owned
```

---

# To create a node group

```bash
aws eks create-nodegroup \
  --cluster-name microservices \
  --nodegroup-name microservices-nodegroup \
  --scaling-config minSize=1,maxSize=3,desiredSize=2 \
  --disk-size 20 \
  --subnets subnet-0219cb3de64d3fe86 subnet-028e14b3d4ca899a0 \
  --instance-types t3.medium \
  --ami-type AL2_x86_64 \
  --node-role arn:aws:iam::<your-account-id>:role/EKSNodeRole \
  --region us-east-1
```

# To describe the created node group

```bash
aws eks describe-nodegroup --cluster-name <cluster-name> --nodegroup-name <nodegrp-name> --region us-east-1
```