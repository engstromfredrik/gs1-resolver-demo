#!/usr/bin/env node
import * as cdk from 'aws-cdk-lib';
import { DatabaseStack } from '../lib/database-stack';
import { AuthStack } from '../lib/auth-stack';
import { ApiStack } from '../lib/api-stack';
import { DomainStack } from '../lib/domain-stack';
import { FrontendStack } from '../lib/frontend-stack';

const app = new cdk.App();

const env = {
  account: process.env.CDK_DEFAULT_ACCOUNT,
  region: process.env.CDK_DEFAULT_REGION || 'eu-north-1',
};

const domainName = 'gs1-resolver.engstrom.cloud';
const hostedZoneName = 'engstrom.cloud';

// Database
const databaseStack = new DatabaseStack(app, 'GS1ResolverDatabase', { env });

// Auth
const authStack = new AuthStack(app, 'GS1ResolverAuth', { env });

// API
const apiStack = new ApiStack(app, 'GS1ResolverApi', {
  env,
  table: databaseStack.table,
  userPool: authStack.userPool,
});

// Domain (must be in us-east-1 for CloudFront certificate)
const domainStack = new DomainStack(app, 'GS1ResolverDomain', {
  env: { ...env, region: 'us-east-1' },
  domainName,
  hostedZoneName,
});

// Frontend
const frontendStack = new FrontendStack(app, 'GS1ResolverFrontend', {
  env,
  domainName,
  hostedZoneName,
  certificate: domainStack.certificate,
  apiUrl: apiStack.apiUrl,
  userPoolId: authStack.userPool.userPoolId,
  userPoolClientId: authStack.userPoolClient.userPoolClientId,
});

frontendStack.addDependency(domainStack);
