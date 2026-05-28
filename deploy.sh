#!/bin/bash
set -e

echo "🚀 GS1 Resolver Deployment Script"
echo "=================================="

# Install CDK dependencies
echo ""
echo "📦 Installing CDK dependencies..."
cd cdk
npm install

# Install Lambda dependencies
echo ""
echo "📦 Installing Lambda dependencies..."
cd lambda/resolver
npm install
cd ../admin
npm install
cd ../..

# Build CDK
echo ""
echo "🔨 Building CDK..."
npm run build

# Install Frontend dependencies
echo ""
echo "📦 Installing Frontend dependencies..."
cd ../frontend
npm install

# Build Frontend
echo ""
echo "🔨 Building Frontend..."
npm run build

# Deploy CDK
echo ""
echo "☁️  Deploying to AWS..."
cd ../cdk
cdk deploy --all --require-approval never

echo ""
echo "✅ Deployment complete!"
echo ""
echo "Next steps:"
echo "1. Create an admin user in Cognito"
echo "2. Visit https://gs1-resolver.engstrom.cloud/admin to manage products"
echo "3. Test resolver at https://gs1-resolver.engstrom.cloud/01/{gtin}/10/{batch}"
