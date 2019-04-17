#!/bin/bash

export BUCKET_NAME=<replace_with_your_bucket_name>
export UPLOAD_IAM_ROLE_ARN=<replace_with_the_full_arn_to_your_user>
export PROFILE_NAME=<replace_with_your_aws_profile>
pip install awscli
aws s3api create-bucket \
    --bucket ${BUCKET_NAME} \
    --acl public-read \
    --region us-west-2 \
    --create-bucket-configuration LocationConstraint=us-west-2 \
    --profile ${PROFILE_NAME}

cat > policy_bucket_s3.json <<EOF
{
    "Version": "2008-10-17",
    "Statement": [
        {
            "Sid": "PublicReadForGetBucketObjects",
            "Effect": "Allow",
            "Principal": {
                "AWS": "*"
            },
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::${BUCKET_NAME}/*"
        },
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": "${UPLOAD_IAM_ROLE_ARN}"
            },
            "Action": "s3:*",
            "Resource": [
                "arn:aws:s3:::${BUCKET_NAME}",
                "arn:aws:s3:::${BUCKET_NAME}/*"
            ]
        }
    ]
}
EOF
aws s3api put-bucket-policy \
    --bucket ${BUCKET_NAME} \
    --policy file://${PWD}/policy_bucket_s3.json \
    --profile ${PROFILE_NAME}
