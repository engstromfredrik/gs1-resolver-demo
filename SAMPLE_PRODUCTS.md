# Sample Products

## Swedish Grocery Products

These sample GTINs have been added to the seed script:

| GTIN | Product Name | Description | Size |
|------|--------------|-------------|------|
| 7340083450419 | Garant Pannkakor | Swedish pancakes | 400 g |
| 7340083438158 | Garant Krossade Tomater | Crushed tomatoes | 400 g |
| 7340083407338 | Eldorado Vispgrädde 36% | Whipping cream 36% | 5 dl |
| 7340083482397 | Garant Svensk Lantmjölk 1,5% | Swedish farm milk 1.5% | 1 liter |
| 7340083422010 | Eldorado Havregryn | Oat flakes | 1,5 kg |

## Test URLs

After seeding, test these URLs:

```
https://gs1-resolver.engstrom.cloud/01/7340083450419/10/BATCH001
https://gs1-resolver.engstrom.cloud/01/7340083438158/10/BATCH001
https://gs1-resolver.engstrom.cloud/01/7340083407338/10/BATCH001
https://gs1-resolver.engstrom.cloud/01/7340083482397/10/BATCH001
https://gs1-resolver.engstrom.cloud/01/7340083422010/10/BATCH001
```

## How to Seed

After deploying the infrastructure:

```bash
./seed-products.sh
```

Or manually via the admin panel at:
```
https://gs1-resolver.engstrom.cloud/admin
```

## Adding More Products

### Via Admin Panel
1. Login to `/admin`
2. Click "Add Product"
3. Enter GTIN, Batch, and details
4. Choose link type (productInfo or marketing)

### Via AWS CLI
```bash
aws dynamodb put-item \
  --table-name gs1-resolver-products \
  --region eu-north-1 \
  --item '{
    "PK": {"S": "GTIN#<your-gtin>"},
    "SK": {"S": "BATCH#<your-batch>"},
    "GSI1PK": {"S": "PRODUCT"},
    "GSI1SK": {"S": "GTIN#<your-gtin>#BATCH#<your-batch>"},
    "gtin": {"S": "<your-gtin>"},
    "batch": {"S": "<your-batch>"},
    "linkType": {"S": "productInfo"},
    "productData": {"M": {
      "name": {"S": "Product Name"},
      "description": {"S": "Description"}
    }},
    "updatedAt": {"S": "'$(date -u +%Y-%m-%dT%H:%M:%SZ)'"}
  }'
```

## Marketing Redirect Example

To create a product that redirects to a marketing page:

```json
{
  "gtin": "7340083450419",
  "batch": "PROMO2024",
  "linkType": "marketing",
  "targetUrl": "https://www.garant.se/produkter/pannkakor"
}
```

When users visit `/01/7340083450419/10/PROMO2024`, they'll be automatically redirected to the marketing URL.
