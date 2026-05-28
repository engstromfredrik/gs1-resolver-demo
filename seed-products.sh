#!/bin/bash
set -e

TABLE_NAME="gs1-resolver-products"
REGION="${AWS_REGION:-eu-north-1}"

echo "🌱 Seeding sample products to DynamoDB..."
echo "Table: $TABLE_NAME"
echo "Region: $REGION"
echo ""

# Product 1: Garant Pannkakor
aws dynamodb put-item \
  --table-name "$TABLE_NAME" \
  --region "$REGION" \
  --item '{
    "PK": {"S": "GTIN#7340083450419"},
    "SK": {"S": "BATCH#BATCH001"},
    "GSI1PK": {"S": "PRODUCT"},
    "GSI1SK": {"S": "GTIN#7340083450419#BATCH#BATCH001"},
    "gtin": {"S": "7340083450419"},
    "batch": {"S": "BATCH001"},
    "linkType": {"S": "productInfo"},
    "productData": {"M": {
      "name": {"S": "Garant Pannkakor"},
      "description": {"S": "Swedish pancakes"},
      "weight": {"S": "400 g"},
      "manufacturer": {"S": "Garant"}
    }},
    "updatedAt": {"S": "'$(date -u +%Y-%m-%dT%H:%M:%SZ)'"}
  }'
echo "✅ Added: Garant Pannkakor (7340083450419)"

# Product 2: Garant Krossade Tomater
aws dynamodb put-item \
  --table-name "$TABLE_NAME" \
  --region "$REGION" \
  --item '{
    "PK": {"S": "GTIN#7340083438158"},
    "SK": {"S": "BATCH#BATCH001"},
    "GSI1PK": {"S": "PRODUCT"},
    "GSI1SK": {"S": "GTIN#7340083438158#BATCH#BATCH001"},
    "gtin": {"S": "7340083438158"},
    "batch": {"S": "BATCH001"},
    "linkType": {"S": "productInfo"},
    "productData": {"M": {
      "name": {"S": "Garant Krossade Tomater"},
      "description": {"S": "Crushed tomatoes"},
      "weight": {"S": "400 g"},
      "manufacturer": {"S": "Garant"}
    }},
    "updatedAt": {"S": "'$(date -u +%Y-%m-%dT%H:%M:%SZ)'"}
  }'
echo "✅ Added: Garant Krossade Tomater (7340083438158)"

# Product 3: Eldorado Vispgrädde
aws dynamodb put-item \
  --table-name "$TABLE_NAME" \
  --region "$REGION" \
  --item '{
    "PK": {"S": "GTIN#7340083407338"},
    "SK": {"S": "BATCH#BATCH001"},
    "GSI1PK": {"S": "PRODUCT"},
    "GSI1SK": {"S": "GTIN#7340083407338#BATCH#BATCH001"},
    "gtin": {"S": "7340083407338"},
    "batch": {"S": "BATCH001"},
    "linkType": {"S": "productInfo"},
    "productData": {"M": {
      "name": {"S": "Eldorado Vispgrädde 36%"},
      "description": {"S": "Whipping cream 36%"},
      "volume": {"S": "5 dl"},
      "manufacturer": {"S": "Eldorado"}
    }},
    "updatedAt": {"S": "'$(date -u +%Y-%m-%dT%H:%M:%SZ)'"}
  }'
echo "✅ Added: Eldorado Vispgrädde 36% (7340083407338)"

# Product 4: Garant Svensk Lantmjölk
aws dynamodb put-item \
  --table-name "$TABLE_NAME" \
  --region "$REGION" \
  --item '{
    "PK": {"S": "GTIN#7340083482397"},
    "SK": {"S": "BATCH#BATCH001"},
    "GSI1PK": {"S": "PRODUCT"},
    "GSI1SK": {"S": "GTIN#7340083482397#BATCH#BATCH001"},
    "gtin": {"S": "7340083482397"},
    "batch": {"S": "BATCH001"},
    "linkType": {"S": "productInfo"},
    "productData": {"M": {
      "name": {"S": "Garant Svensk Lantmjölk 1,5%"},
      "description": {"S": "Swedish farm milk 1.5%"},
      "volume": {"S": "1 liter"},
      "manufacturer": {"S": "Garant"}
    }},
    "updatedAt": {"S": "'$(date -u +%Y-%m-%dT%H:%M:%SZ)'"}
  }'
echo "✅ Added: Garant Svensk Lantmjölk 1,5% (7340083482397)"

# Product 5: Eldorado Havregryn
aws dynamodb put-item \
  --table-name "$TABLE_NAME" \
  --region "$REGION" \
  --item '{
    "PK": {"S": "GTIN#7340083422010"},
    "SK": {"S": "BATCH#BATCH001"},
    "GSI1PK": {"S": "PRODUCT"},
    "GSI1SK": {"S": "GTIN#7340083422010#BATCH#BATCH001"},
    "gtin": {"S": "7340083422010"},
    "batch": {"S": "BATCH001"},
    "linkType": {"S": "productInfo"},
    "productData": {"M": {
      "name": {"S": "Eldorado Havregryn"},
      "description": {"S": "Oat flakes"},
      "weight": {"S": "1,5 kg"},
      "manufacturer": {"S": "Eldorado"}
    }},
    "updatedAt": {"S": "'$(date -u +%Y-%m-%dT%H:%M:%SZ)'"}
  }'
echo "✅ Added: Eldorado Havregryn (7340083422010)"

echo ""
echo "✨ Seeding complete!"
echo ""
echo "Test URLs:"
echo "https://gs1-resolver.engstrom.cloud/01/7340083450419/10/BATCH001"
echo "https://gs1-resolver.engstrom.cloud/01/7340083438158/10/BATCH001"
echo "https://gs1-resolver.engstrom.cloud/01/7340083407338/10/BATCH001"
echo "https://gs1-resolver.engstrom.cloud/01/7340083482397/10/BATCH001"
echo "https://gs1-resolver.engstrom.cloud/01/7340083422010/10/BATCH001"
