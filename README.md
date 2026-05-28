# GS1 Resolver

A serverless GS1 Digital Link resolver built with AWS CDK, React, and TypeScript. Resolves GS1 identifiers (GTIN + Batch) to product information or marketing URLs.

## 🏗️ Architecture

### AWS Services
- **DynamoDB**: Product data storage with PK/SK pattern
- **Lambda**: Serverless compute for API endpoints
- **API Gateway**: REST API with public and authenticated routes
- **Cognito**: User authentication for admin panel
- **CloudFront**: CDN for global distribution
- **S3**: Static website hosting for React SPA
- **Route53**: DNS management
- **ACM**: SSL/TLS certificates

### URL Pattern
```
https://gs1-resolver.engstrom.cloud/01/{gtin}/10/{batch}?17={bestBeforeDate}
```

### DynamoDB Schema
```
PK: GTIN#<gtin>
SK: BATCH#<batch>
GSI1PK: PRODUCT
GSI1SK: GTIN#<gtin>#BATCH#<batch>

Attributes:
- gtin: string
- batch: string
- linkType: "productInfo" | "marketing"
- targetUrl?: string (for marketing redirects)
- productData?: { name, description, manufacturer, bestBeforeDate }
- updatedAt: ISO timestamp
```

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
│   │   └── admin/               # Admin CRUD Lambda
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
│   │   └── types/
│   └── package.json
└── README.md
```

## 🚀 Deployment

### Prerequisites
- AWS CLI configured with credentials
- Node.js 18+ and npm
- AWS CDK CLI: `npm install -g aws-cdk`
- Domain `engstrom.cloud` hosted in Route53

### Step 1: Install Dependencies

```bash
# CDK dependencies
cd cdk
npm install

# Frontend dependencies
cd ../frontend
npm install
```

### Step 2: Build Frontend

```bash
cd frontend
npm run build
```

### Step 3: Deploy Infrastructure

```bash
cd cdk
npm run build

# Bootstrap CDK (first time only)
cdk bootstrap

# Deploy all stacks
cdk deploy --all
```

**Note**: The DomainStack will create an ACM certificate that requires DNS validation. This may take 5-10 minutes.

The deployment script will prompt you to seed sample products after deployment completes.

### Step 4: Create Admin User

After deployment, create an admin user in Cognito:

```bash
aws cognito-idp admin-create-user \
  --user-pool-id <USER_POOL_ID> \
  --username admin \
  --user-attributes Name=email,Value=admin@example.com \
  --temporary-password TempPass123! \
  --message-action SUPPRESS
```

Get the User Pool ID from CDK outputs or AWS Console.

### Step 5: Seed Sample Data (Optional)

Add sample Swedish grocery products to test the resolver:

```bash
./seed-products.sh
```

This adds 5 products:
- Garant Pannkakor (7340083450419)
- Garant Krossade Tomater (7340083438158)
- Eldorado Vispgrädde 36% (7340083407338)
- Garant Svensk Lantmjölk 1,5% (7340083482397)
- Eldorado Havregryn (7340083422010)

## 🧪 Testing

### Test Resolver Endpoint

```bash
# Add a test product via admin API (requires auth token)
curl -X POST https://gs1-resolver.engstrom.cloud/admin/products \
  -H "Authorization: Bearer <TOKEN>" \
  -H "Content-Type: application/json" \
  -d '{
    "gtin": "12345678901234",
    "batch": "LOT001",
    "linkType": "productInfo",
    "productData": {
      "name": "Test Product",
      "description": "A test product",
      "manufacturer": "ACME Corp"
    }
  }'

# Resolve the product
curl https://gs1-resolver.engstrom.cloud/01/12345678901234/10/LOT001
```

### Test Admin Panel

1. Navigate to `https://gs1-resolver.engstrom.cloud/admin`
2. Sign in with Cognito credentials
3. Add/edit/delete products

## 📝 Usage

### Product Information Display
When `linkType = "productInfo"`, the resolver displays product details on the page.

### Marketing Redirect
When `linkType = "marketing"` and `targetUrl` is set, the resolver automatically redirects to the marketing URL.

### 404 Handling
If a GTIN/Batch combination is not found, a styled "Product Not Found" page is displayed.

## 🔐 Security

- Admin API protected by Cognito authentication
- CloudFront enforces HTTPS
- S3 bucket not publicly accessible (OAI used)
- DynamoDB table has point-in-time recovery enabled
- Cognito enforces strong password policy

## 🛠️ Development

### Local Frontend Development

```bash
cd frontend
npm run dev
```

The app will run on `http://localhost:3000`. You'll need to update `config.json` to point to your deployed API.

### Update Lambda Functions

After modifying Lambda code:

```bash
cd cdk
npm run build
cdk deploy GS1ResolverApi
```

## 📊 Monitoring

- **CloudWatch Logs**: Lambda execution logs
- **CloudWatch Metrics**: API Gateway and Lambda metrics
- **X-Ray**: Distributed tracing (if enabled)

## 🧹 Cleanup

To remove all resources:

```bash
cd cdk
cdk destroy --all
```

**Warning**: This will delete the DynamoDB table and all data (unless retention policy is changed).

## 📄 License

MIT

## 👤 Author

Fredrik Engström (@engstromfredrik)
