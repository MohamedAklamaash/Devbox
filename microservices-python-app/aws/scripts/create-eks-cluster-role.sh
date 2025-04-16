#!/bin/bash

ROLE_NAME="Amazon_EKS_ClusterPolicy"
TRUST_POLICY_FILE="eks-trust-policy.json"

cat > $TRUST_POLICY_FILE <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": [
        "sts:AssumeRole",
        "sts:TagSession"
      ]
    }
  ]
}
EOF

echo "🔍 Checking if IAM role '$ROLE_NAME' exists..."
aws iam get-role --role-name $ROLE_NAME >/dev/null 2>&1

if [ $? -eq 0 ]; then
  echo "Role '$ROLE_NAME' already exists. Updating trust policy..."
  aws iam update-assume-role-policy \
    --role-name $ROLE_NAME \
    --policy-document file://$TRUST_POLICY_FILE
else
  echo "🛠️ Role '$ROLE_NAME' does not exist. Creating it..."
  aws iam create-role \
    --role-name $ROLE_NAME \
    --assume-role-policy-document file://$TRUST_POLICY_FILE
fi

echo "🔗 Attaching required managed policies to '$ROLE_NAME'..."
POLICIES=(
  "AmazonEKSBlockStoragePolicy"
  "AmazonEKSComputePolicy"
  "AmazonEKSLoadBalancingPolicy"
  "AmazonEKSNetworkingPolicy"
)

for policy in "${POLICIES[@]}"; do
  echo "   ➤ Attaching $policy"
  aws iam attach-role-policy \
    --role-name $ROLE_NAME \
    --policy-arn arn:aws:iam::aws:policy/$policy
done

rm -f $TRUST_POLICY_FILE

echo "Done! '$ROLE_NAME' is fully configured for EKS Auto Mode."
