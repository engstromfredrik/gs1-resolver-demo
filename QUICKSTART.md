# Quick Start Guide

## What Was Built

A complete serverless GS1 Digital Link resolver with:

✅ **Infrastructure (AWS CDK)**
- DynamoDB table for product data
- Lambda functions (resolver + admin)
- API Gateway with public and authenticated routes
- Cognito User Pool for admin authentication
- CloudFront + S3 for React SPA hosting
- ACM certificate + Route53 for custom domain

✅ **Frontend (React + TypeScript)**
- Product resolver page (displays info or redirects)
- Styled 404 "Product Not Found" page
- Admin panel with authentication
- CRUD operations for products

✅ **Features**
- Public resolver: `GET /01/{gtin}/10/{batch}`
- Admin API with Cognito auth
- Two link types: `productInfo` (display) and `marketing` (redirect)
- Custom domain: `gs1-resolver.engstrom.cloud`

## Deployment Steps

### 1. Install Dependencies & Deploy

```bash
./deploy.sh
```

This script will:
- Install all dependencies (CDK, Lambda, Frontend)
- Build TypeScript code
- Build React app
- Deploy all AWS stacks

**Note**: First deployment takes ~15-20 minutes due to CloudFront distribution and ACM certificate validation.

### 2. Create Admin User

After deployment, get the User Pool ID from CDK outputs:

```bash
cd cdk
cdk deploy GS1ResolverAuth --outputs-file outputs.json
cat outputs.json | grep UserPoolId
```

Then create an admin user:

```bash
aws cognito-idp admin-create-user \
  --user-pool-id <YOUR_USER_POOL_ID> \
  --username admin \
  --user-attributes Name=email,Value=your-email@example.com \
  --temporary-password TempPassword123! \
  --message-action SUPPRESS
```

### 3. Test the Application

**Admin Panel:**
1. Visit `https://gs1-resolver.engstrom.cloud/admin`
2. Sign in with username `admin` and temporary password
3. You'll be prompted to set a new password
4. Add a test product

**Resolver:**
Visit `https://gs1-resolver.engstrom.cloud/01/{gtin}/10/{batch}`

Example:
```
https://gs1-resolver.engstrom.cloud/01/12345678901234/10/LOT001
```

## Architecture Diagram

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

## Project Structure

```
gs1-resolver-demo/
├── cdk/                    # Infrastructure as Code
│   ├── bin/app.ts         # CDK entry point
│   ├── lib/               # Stack definitions
│   └── lambda/            # Lambda functions
├── frontend/              # React SPA
│   └── src/
│       ├── pages/         # React pages
│       ├── api/           # API clients
│       └── types/         # TypeScript types
├── deploy.sh              # Deployment script
└── README.md              # Full documentation
```

## Next Steps

1. **Customize the UI**: Edit React components in `frontend/src/pages/`
2. **Add more link types**: Extend the `linkType` enum
3. **Add more product fields**: Update DynamoDB schema and forms
4. **Set up monitoring**: Enable CloudWatch alarms
5. **Add CI/CD**: GitHub Actions for automated deployments

## Troubleshooting

**Certificate validation stuck?**
- Check Route53 for CNAME records created by ACM
- Wait 5-10 minutes for DNS propagation

**Lambda errors?**
- Check CloudWatch Logs: `/aws/lambda/GS1ResolverApi-*`

**Frontend not loading?**
- Check CloudFront distribution status (must be "Deployed")
- Verify S3 bucket has files
- Check browser console for errors

**Admin login fails?**
- Verify Cognito user exists
- Check user status (should be CONFIRMED)
- Try password reset

## Cost Estimate

With minimal usage:
- DynamoDB: ~$1-2/month (on-demand)
- Lambda: Free tier covers most usage
- API Gateway: ~$3.50 per million requests
- CloudFront: ~$0.085 per GB + requests
- S3: Negligible
- Cognito: Free for <50,000 MAU

**Estimated monthly cost: $5-15** for low traffic

## Support

For issues or questions:
- Check the main README.md
- Review AWS CloudWatch logs
- Open an issue on GitHub

---

Built with ❤️ by Fredrik Engström
