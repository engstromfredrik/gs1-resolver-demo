#!/bin/bash
set -e

TABLE_NAME="gs1-resolver-products"
REGION="${AWS_REGION:-eu-north-1}"

echo "🔄 Migrating DynamoDB items to new SK pattern..."
echo "   Old: BATCH#<batch>"
echo "   New: BATCH#<batch>#LINKTYPE#<linkType>"
echo ""

# Get all items
ITEMS=$(aws dynamodb scan \
  --table-name "$TABLE_NAME" \
  --region "$REGION" \
  --output json)

echo "$ITEMS" | python3 -c "
import json, sys, subprocess

data = json.load(sys.stdin)
items = data.get('Items', [])

for item in items:
    sk = item['SK']['S']
    # Skip already migrated items
    if '#LINKTYPE#' in sk:
        print(f'⏭️  Skipping (already migrated): {sk}')
        continue

    pk = item['PK']['S']
    link_type = item.get('linkType', {}).get('S', 'gs1:productInfo')
    new_sk = f'{sk}#LINKTYPE#{link_type}'

    print(f'📝 {pk} | {sk} → {new_sk}')

    # Update item with new SK
    item['SK'] = {'S': new_sk}
    # Update GSI1SK too
    gtin = item.get('gtin', {}).get('S', '')
    batch = item.get('batch', {}).get('S', '')
    item['GSI1SK'] = {'S': f'GTIN#{gtin}#BATCH#{batch}#LINKTYPE#{link_type}'}

    print(json.dumps({'pk': pk, 'old_sk': sk, 'new_sk': new_sk, 'item': item}))
" > /tmp/migration_plan.jsonl

echo ""
echo "Executing migration..."

# Process each item: delete old, write new
echo "$ITEMS" | python3 -c "
import json, sys, os

data = json.load(sys.stdin)
items = data.get('Items', [])
table = '$TABLE_NAME'
region = '$REGION'

for item in items:
    sk = item['SK']['S']
    if '#LINKTYPE#' in sk:
        continue

    pk = item['PK']['S']
    link_type = item.get('linkType', {}).get('S', 'gs1:productInfo')
    new_sk = f'{sk}#LINKTYPE#{link_type}'
    gtin = item.get('gtin', {}).get('S', '')
    batch = item.get('batch', {}).get('S', '')

    # Update SK and GSI1SK
    item['SK'] = {'S': new_sk}
    item['GSI1SK'] = {'S': f'GTIN#{gtin}#BATCH#{batch}#LINKTYPE#{link_type}'}

    # Write new item
    item_json = json.dumps(item)
    put_cmd = f\"\"\"aws dynamodb put-item --table-name {table} --region {region} --item '{item_json}'\"\"\"
    os.system(put_cmd)

    # Delete old item
    old_key = json.dumps({'PK': {'S': pk}, 'SK': {'S': sk}})
    del_cmd = f\"\"\"aws dynamodb delete-item --table-name {table} --region {region} --key '{old_key}'\"\"\"
    os.system(del_cmd)

    print(f'✅ Migrated: {pk} | {sk} → {new_sk}')

print()
print('✨ Migration complete!')
"
