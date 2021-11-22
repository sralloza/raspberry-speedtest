#!/bin/bash

set -e

TIMES=$1
: ${BUCKET_NAME:?must set \$BUCKET_NAME}
: ${AWS_ACCESS_KEY_ID:?must set \$AWS_ACCESS_KEY_ID}
: ${AWS_SECRET_ACCESS_KEY:?must set \$AWS_SECRET_ACCESS_KEY}

: ${TIMES:=1}

id=$(date -u +"%FT%T.000Z")
echo "Testing connection with aws"
aws sts get-caller-identity > /dev/null

echo "running speedtest $TIMES times ($id)"

for (( i=0; i<$TIMES; i++ )); do
    /speedtest --json > "result-$i.json"
    aws s3 cp "result-$i.json" s3://$BUCKET_NAME/speedtest/$id/result-$i.json

    res=$(cat result-$i.json)
    echo "results #$i: $res"
done
