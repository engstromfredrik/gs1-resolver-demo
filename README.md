# GS1 Resolver

A modern product information system that connects physical products to digital content through scannable codes (QR codes, barcodes). Scan a product code to instantly view detailed information or get redirected to marketing pages—no app required.

Built with cloud technology for reliability, speed, and global reach.

---

## What Does This Do?

This system helps businesses share product information through scannable codes. When someone scans a product code, they can instantly see:

- **Product Details**: Name, description, ingredients, nutritional facts, allergen information
- **Marketing Pages**: Redirect to promotional websites or campaigns  
- **Batch Information**: Track specific production batches for recalls or quality control
- **Expiration Dates**: See when products expire

**Real-World Example:**
A customer scans a QR code on a package of batteries in a store. Instead of searching online, they're instantly taken to the manufacturer's product page with specifications, usage instructions, and warranty information.

---

## Who Can Use This?

- **Retailers**: Connect product codes to detailed information for customers
- **Manufacturers**: Provide rich product data through existing barcodes
- **Brand Managers**: Create marketing campaigns linked to product packaging
- **Supply Chain Teams**: Track batches and manage product recalls

---

## Examples

### Example 1: Product Information Display
**Scenario:** Customer scans a QR code on a grocery product

**What They See:**
- Product name: "Marias Magiska Muffins"
- Batch number: MARIA2024
- Ingredients list
- Allergen warnings
- Nutritional facts per 100g
- Expiration date

**Try it:** https://gs1-resolver.engstrom.cloud/01/1234567890001/10/MARIA2024

### Example 2: Marketing Redirect
**Scenario:** Customer scans a QR code on a battery pack

**What Happens:**
- Instantly redirected to manufacturer's marketing page
- No loading or intermediate screens
- Direct access to promotions, specifications, or warranty info

**Try it:** https://gs1-resolver.engstrom.cloud/01/07311043015702

---

## Key Features

✅ **Instant Product Information** - No app download required, works in any web browser  
✅ **Flexible Content** - Show product details OR redirect to external websites  
✅ **Batch Tracking** - Different information for different production batches  
✅ **Secure Admin Panel** - Control who can add/edit product information  
✅ **Fast & Global** - Uses cloud infrastructure for worldwide access  
✅ **Mobile-Friendly** - Works on smartphones, tablets, and computers

---

## How It Works (Simple Version)

1. **Store Product Information** → Add products through the admin panel (web interface)
2. **Create a Link** → System generates a URL like `gs1-resolver.engstrom.cloud/01/12345...`
3. **Print QR Code** → Generate QR code from the link and add to packaging
4. **Customer Scans** → Customer sees product info or gets redirected to marketing page

---

## Frequently Asked Questions

**Do users need to install an app?**  
No, it works in any web browser by scanning a QR code or clicking a link.

**Can I track who scans the codes?**  
This basic version doesn't include analytics, but it can be added.

**What information can I display?**  
Product names, descriptions, ingredients, nutrition facts, allergens, batch numbers, expiration dates, and links to external pages.

**Can I update product information after printing QR codes?**  
Yes! The QR code stays the same, but you can update the information shown at any time through the admin panel.

**How much does it cost to run?**  
For low traffic: approximately $5-15/month on AWS. Costs scale with usage.

**What is a GTIN?**  
GTIN (Global Trade Item Number) is the barcode number on products. Common formats include EAN-13 (13 digits) and UPC (12 digits).

---

## How It Works (Technical Version)

### Architecture

#### AWS Services
- **DynamoDB**: Product data storage with PK/SK pattern
- **Lambda**: Serverless compute for API endpoints
- **API Gateway**: REST API with public and authenticated routes
- **Cognito**: User authentication for admin panel
- **CloudFront**: CDN for global distribution
- **S3**: Static website hosting for React SPA
- **Route53**: DNS management
- **ACM**: SSL/TLS certificates

#### URL Pattern
```
https://gs1-resolver.engstrom.cloud/01/{gtin}/10/{batch}?15={expiryDate}&linkType={type}
```

**GS1 Digital Link Format:**
- `01` = Application Identifier for GTIN
- `10` = Application Identifier for Batch/Lot
- `15` = Application Identifier for Best Before Date (YYMMDD)
- `linkType` = Query parameter for content type (`gs1:productInfo` or `marketing`)

#### DynamoDB Schema
```
PK: GTIN#<gtin>
SK: BATCH#<batch>#LINKTYPE#<linkType>
GSI1PK: PRODUCT
GSI1SK: GTIN#<gtin>#BATCH#<batch>#LINKTYPE#<linkType>

Attributes:
- gtin: string
- batch: string
- linkType: "gs1:productInfo" | "marketing"
- targetUrl?: string (for marketing redirects)
- productData?: {
    name: string
    description: string
    manufacturer?: string
    ingredients?: string
    allergens?: string
    nutritionPer100g?: object
    weight?: string
    volume?: string
    brand?: string
    origin?: string
    packaging?: string
    storage?: string
    nutriScore?: string
    categories?: string
  }
- updatedAt: ISO timestamp
```

### Architecture Diagram

```
┌─────────────┐
│   Route53   │
│ engstrom.   │
│   cloud     │
└──────┬──────┘
       │
       ▼
┌─────────────────────────────────────────┐
│           CloudFront CDN                │
│  ┌─────────────┐    ┌───────────────┐  │
│  │  S3 Origin  │    │  API Gateway  │  │
│  │ (React SPA) │    │    Origin     │  │
│  └─────────────┘    └───────────────┘  │
└─────────────────────────────────────────┘
                │              │
                │              ▼
                │     ┌──────────────────┐
                │     │  API Gateway     │
                │     │  ┌────────────┐  │
                │     │  │ /01/{gtin} │  │ (public)
                │     │  │ /10/{batch}│  │
                │     │  └────────────┘  │
                │     │  ┌────────────┐  │
                │     │  │  /admin/*  │  │ (auth)
                │     │  └────────────┘  │
                │     └──────────────────┘
                │              │
                │              ▼
                │     ┌──────────────────┐
                │     │  Lambda          │
                │     │  ┌────────────┐  │
                │     │  │ Resolver   │  │
                │     │  │ Admin      │  │
                │     │  └────────────┘  │
                │     └──────────────────┘
                │              │
                │              ▼
                │     ┌──────────────────┐
                │     │   DynamoDB       │
                │     │   gs1-resolver-  │
                │     │   products       │
                │     └──────────────────┘
                │
                ▼
       ┌──────────────────┐
       │  Cognito User    │
       │      Pool        │
       └──────────────────┘
```

---

## 📁 Project Structure

```
gs1-resolver-demo/
├── cdk/                          # AWS CDK Infrastructure
│   ├── bin/
│   │   └── app.ts               # CDK app entry point
│   ├── lib/
│   │   ├── database-stack.ts    # DynamoDB table
│   │   ├── auth-stack.ts        # Cognito User Pool
│   │   ├── api-stack.ts         # API Gateway + Lambda
│   │   ├── domain-stack.ts      # ACM + Route53
│   │   └── frontend-stack.ts    # S3 + CloudFront
│   ├── lambda/
│   │   ├── resolver/            # Public resolver Lambda
│   │   │   └── index.ts
│   │   └── admin/               # Admin CRUD Lambda
│   │       └── index.ts
│   └── package.json
├── frontend/                     # React SPA
│   ├── src/
│   │   ├── pages/
│   │   │   ├── ProductResolver.tsx
│   │   │   ├── NotFound.tsx
│   │   │   └── Admin.tsx
│   │   ├── api/
│   │   │   ├── resolver.ts
│   │   │   └── auth.ts
│   │   ├── types/
│   │   │   └── index.ts
│   │   └── App.tsx
│   └── package.json
├── deploy.sh                     # Automated deployment script
├── seed-products.sh             # Sample data seeding
├── README.md                    # This file
├── QUICKSTART.md               # Quick deployment guide
└── PRODUCTS.md                 # Product examples and URLs
```

---

## 🚀 Deployment

### Prerequisites
- AWS CLI configured with credentials
- Node.js 18+ and npm
- AWS CDK CLI: `npm install -g aws-cdk`
- Domain hosted in Route53 (update `domain-stack.ts` with your domain)

### Quick Start

The easiest way to deploy is using the automated script:

```bash
./deploy.sh
```

This script will:
1. Install all dependencies (CDK, Lambda, Frontend)
2. Build TypeScript code
3. Build React app
4. Deploy all AWS stacks
5. Prompt to seed sample products (optional)

**Note**: First deployment takes ~15-20 minutes due to CloudFront distribution and ACM certificate validation.

### Manual Deployment Steps

If you prefer manual deployment:

#### Step 1: Install Dependencies

```bash
# CDK dependencies
cd cdk
npm install

# Lambda dependencies
cd lambda/resolver
npm install
cd ../admin
npm install
cd ../..

# Frontend dependencies
cd ../frontend
npm install
```

#### Step 2: Build Frontend

```bash
cd frontend
npm run build
```

#### Step 3: Deploy Infrastructure

```bash
cd cdk
npm run build

# Bootstrap CDK (first time only)
cdk bootstrap

# Deploy all stacks
cdk deploy --all --require-approval never
```

**Certificate Validation**: The DomainStack creates an ACM certificate that requires DNS validation. This may take 5-10 minutes. Check Route53 for CNAME records created by ACM.

#### Step 4: Create Admin User

After deployment, create an admin user in Cognito:

```bash
# Get User Pool ID from CDK outputs
aws cognito-idp admin-create-user \
  --user-pool-id <USER_POOL_ID> \
  --username admin \
  --user-attributes Name=email,Value=admin@example.com \
  --temporary-password TempPass123! \
  --message-action SUPPRESS
```

Get the User Pool ID from:
- CDK outputs: `cd cdk && cdk deploy GS1ResolverAuth --outputs-file outputs.json`
- AWS Console: Cognito → User Pools

#### Step 5: Seed Sample Data (Optional)

Add sample products to test the resolver:

```bash
./seed-products.sh
```

This adds 10 sample products including Swedish grocery items and a marketing redirect example.

---

## 🧪 Testing

### Test via Browser

**Product Information:**
https://gs1-resolver.engstrom.cloud/01/1234567890001/10/MARIA2024

**Marketing Redirect:**
https://gs1-resolver.engstrom.cloud/01/07311043015702

### Test via API

```bash
# Get product information
curl https://gvgj1vds22.execute-api.eu-north-1.amazonaws.com/prod/01/1234567890001/10/MARIA2024

# Response:
{
  "gtin": "1234567890001",
  "batch": "MARIA2024",
  "linkType": "gs1:productInfo",
  "productData": {
    "name": "Marias Magiska Muffins",
    "description": "Ljuvligt luftiga muffins...",
    ...
  },
  "updatedAt": "2026-06-08T07:13:39Z"
}
```

### Test Admin Panel

1. Navigate to `https://gs1-resolver.engstrom.cloud/admin`
2. Sign in with Cognito credentials (username: `admin`)
3. You'll be prompted to change the temporary password
4. Add/edit/delete products through the interface

### Add Product via Admin API

```bash
# Get auth token from Cognito (or use admin panel login)
curl -X POST https://gvgj1vds22.execute-api.eu-north-1.amazonaws.com/prod/admin/products \
  -H "Authorization: Bearer <TOKEN>" \
  -H "Content-Type: application/json" \
  -d '{
    "gtin": "12345678901234",
    "batch": "LOT001",
    "linkType": "gs1:productInfo",
    "productData": {
      "name": "Test Product",
      "description": "A test product",
      "manufacturer": "ACME Corp"
    }
  }'
```

---

## 📝 Usage Examples

### Product Information Display
When `linkType = "gs1:productInfo"`, the resolver displays product details on a styled page:

- Product name and description
- GTIN and batch number
- Manufacturer information
- Ingredients list
- Allergen warnings
- Nutritional facts table
- Additional details (weight, origin, storage, etc.)

### Marketing Redirect
When `linkType = "marketing"` and `targetUrl` is set, the resolver automatically redirects users to the marketing URL. This is useful for:

- Product campaigns
- Promotional landing pages
- Warranty registration
- Product manuals
- Social media pages

**Security**: Only whitelisted domains are allowed for redirects (configured in `ProductResolver.tsx`).

### URL Variants

**Basic (GTIN only):**
```
https://gs1-resolver.engstrom.cloud/01/1234567890001
```

**With batch:**
```
https://gs1-resolver.engstrom.cloud/01/1234567890001/10/MARIA2024
```

**With expiry date:**
```
https://gs1-resolver.engstrom.cloud/01/1234567890001/10/MARIA2024?15=260930
```

**With explicit linkType:**
```
https://gs1-resolver.engstrom.cloud/01/1234567890001/10/MARIA2024?linkType=gs1:productInfo
```

**Marketing redirect:**
```
https://gs1-resolver.engstrom.cloud/01/07311043015702?linkType=marketing
```

### 404 Handling
If a GTIN/Batch combination is not found, a styled "Product Not Found" page is displayed with:
- Error message
- GTIN that was searched
- Suggested next steps

---

## 🔐 Security

- **Admin API**: Protected by Cognito authentication with JWT tokens
- **HTTPS Only**: CloudFront enforces HTTPS, HTTP redirects to HTTPS
- **S3 Security**: Bucket not publicly accessible, CloudFront uses Origin Access Identity (OAI)
- **DynamoDB**: Point-in-time recovery enabled, encryption at rest
- **Cognito**: Strong password policy, MFA support (optional)
- **CORS**: Restricted to specific origins in Lambda functions
- **Input Validation**: GTINs and batch numbers validated with regex patterns
- **Redirect Whitelist**: Marketing redirects only allowed to whitelisted domains

---

## 🛠️ Development

### Local Frontend Development

```bash
cd frontend
npm run dev
```

The app runs on `http://localhost:5173`. Update API URLs in the code to point to your deployed API or use a local mock.

### Update Lambda Functions

After modifying Lambda code in `cdk/lambda/`:

```bash
cd cdk/lambda/resolver
npm run build  # Compile TypeScript

cd ../..
npm run build  # Build CDK

# Deploy just the API stack
cdk deploy GS1ResolverApi
```

### Update Frontend

After modifying React code:

```bash
cd frontend
npm run build

cd ../cdk
cdk deploy GS1ResolverFrontend
```

CloudFront cache invalidation is handled automatically by CDK.

### Run Tests

```bash
# Frontend tests
cd frontend
npm test

# Lambda tests (if added)
cd cdk/lambda/resolver
npm test
```

---

## 📊 Monitoring

### CloudWatch Logs

**Lambda Logs:**
- Resolver: `/aws/lambda/GS1ResolverApi-ResolverFunction-*`
- Admin: `/aws/lambda/GS1ResolverApi-AdminFunction-*`

**API Gateway Logs:**
- Execution logs available in API Gateway console

### CloudWatch Metrics

Key metrics to monitor:
- API Gateway: Request count, latency, 4xx/5xx errors
- Lambda: Invocations, duration, errors, throttles
- DynamoDB: Read/write capacity, throttled requests
- CloudFront: Requests, bytes downloaded, error rate

### Alarms (Recommended)

Set up CloudWatch alarms for:
- Lambda error rate > 5%
- API Gateway 5xx errors > 10 per minute
- DynamoDB throttling events
- Lambda concurrent executions near limit

---

## 💰 Cost Estimate

With minimal usage (< 10,000 requests/month):

| Service | Estimated Cost |
|---------|---------------|
| DynamoDB | $1-2/month (on-demand pricing) |
| Lambda | Free tier covers most usage |
| API Gateway | $3.50 per million requests |
| CloudFront | $0.085 per GB + $0.01 per 10,000 requests |
| S3 | < $1/month |
| Cognito | Free for < 50,000 MAU |
| Route53 | $0.50/hosted zone |
| ACM | Free |

**Total: $5-15/month for low traffic**

Costs scale with usage. For high traffic (> 1M requests/month), consider:
- DynamoDB provisioned capacity
- CloudFront reserved capacity
- API Gateway caching

---

## 🧹 Cleanup

To remove all resources and stop incurring costs:

```bash
cd cdk
cdk destroy --all
```

**Warning**: This will delete:
- DynamoDB table and all data
- S3 bucket and frontend files
- CloudFront distribution
- Lambda functions
- API Gateway
- Cognito User Pool and users

The Route53 hosted zone and ACM certificate may need manual deletion.

---

## 🐛 Troubleshooting

### Certificate Validation Stuck

**Problem**: CDK deployment waiting on certificate validation

**Solution**:
1. Check Route53 for CNAME records created by ACM
2. Wait 5-10 minutes for DNS propagation
3. If stuck > 30 minutes, check ACM console for validation status

### Lambda Errors

**Problem**: API returns 500 errors

**Solution**:
1. Check CloudWatch Logs: `/aws/lambda/GS1ResolverApi-ResolverFunction-*`
2. Verify environment variables (TABLE_NAME)
3. Check IAM role permissions for DynamoDB access

### Frontend Not Loading

**Problem**: Blank page or 404 errors

**Solution**:
1. Check CloudFront distribution status (must be "Deployed")
2. Verify S3 bucket has files: `aws s3 ls s3://<bucket-name>`
3. Check browser console for errors
4. Wait 10-15 minutes for CloudFront cache invalidation

### Admin Login Fails

**Problem**: Cannot log in to admin panel

**Solution**:
1. Verify Cognito user exists: `aws cognito-idp list-users --user-pool-id <pool-id>`
2. Check user status (should be CONFIRMED)
3. Try password reset in Cognito console
4. Check browser console for CORS errors

### Product Not Found

**Problem**: Scanned code shows "Product Not Found"

**Solution**:
1. Verify product exists in DynamoDB
2. Check GTIN and batch match exactly (case-sensitive)
3. Verify linkType matches (default is `gs1:productInfo`)
4. Check CloudWatch logs for resolver Lambda

### CORS Errors

**Problem**: Admin panel shows CORS errors

**Solution**:
1. Verify `ALLOWED_ORIGIN` in Lambda functions matches your domain
2. Check API Gateway CORS configuration
3. Clear browser cache and try again

---

## 📚 Additional Resources

- **GS1 Digital Link Standard**: https://www.gs1.org/standards/gs1-digital-link
- **AWS CDK Documentation**: https://docs.aws.amazon.com/cdk/
- **React Documentation**: https://react.dev/
- **DynamoDB Best Practices**: https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/best-practices.html

---

## 🗺️ Roadmap

See [TODO.md](TODO.md) for planned improvements:

- [ ] Search functionality
- [ ] Multi-language support (Swedish/English)
- [ ] Product image display
- [ ] QR code generator in admin panel
- [ ] Analytics dashboard
- [ ] Bulk import from CSV
- [ ] Product comparison feature
- [ ] CI/CD pipeline

---

## 📄 License

MIT

---

## 👤 Author

Fredrik Engström ([@engstromfredrik](https://github.com/engstromfredrik))

---

## 🤝 Contributing

Contributions welcome! Please:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

For major changes, please open an issue first to discuss what you'd like to change.

---

**Built with ❤️ using AWS CDK, React, and TypeScript**
