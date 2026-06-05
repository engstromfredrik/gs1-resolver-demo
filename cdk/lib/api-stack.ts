import * as cdk from 'aws-cdk-lib';
import * as apigateway from 'aws-cdk-lib/aws-apigateway';
import * as lambda from 'aws-cdk-lib/aws-lambda';
import * as dynamodb from 'aws-cdk-lib/aws-dynamodb';
import * as cognito from 'aws-cdk-lib/aws-cognito';
import { Construct } from 'constructs';
import * as path from 'path';

interface ApiStackProps extends cdk.StackProps {
  table: dynamodb.Table;
  userPool: cognito.UserPool;
}

export class ApiStack extends cdk.Stack {
  public readonly apiUrl: string;

  constructor(scope: Construct, id: string, props: ApiStackProps) {
    super(scope, id, props);

    // Resolver Lambda (public)
    const resolverFn = new lambda.Function(this, 'ResolverFunction', {
      runtime: lambda.Runtime.NODEJS_20_X,
      handler: 'index.handler',
      code: lambda.Code.fromAsset(path.join(__dirname, '../lambda/resolver')),
      environment: {
        TABLE_NAME: props.table.tableName,
      },
      timeout: cdk.Duration.seconds(10),
    });

    props.table.grantReadData(resolverFn);

    // Admin Lambda (authenticated)
    const adminFn = new lambda.Function(this, 'AdminFunction', {
      runtime: lambda.Runtime.NODEJS_20_X,
      handler: 'index.handler',
      code: lambda.Code.fromAsset(path.join(__dirname, '../lambda/admin')),
      environment: {
        TABLE_NAME: props.table.tableName,
      },
      timeout: cdk.Duration.seconds(10),
    });

    props.table.grantReadWriteData(adminFn);

    // API Gateway
    const api = new apigateway.RestApi(this, 'GS1ResolverApi', {
      restApiName: 'gs1-resolver-api',
      description: 'GS1 Resolver API',
      deployOptions: {
        throttlingRateLimit: 5,
        throttlingBurstLimit: 10,
      },
      defaultCorsPreflightOptions: {
        allowOrigins: ['https://gs1-resolver.engstrom.cloud'],
        allowMethods: apigateway.Cors.ALL_METHODS,
        allowHeaders: ['Content-Type', 'Authorization'],
      },
    });

    // Cognito Authorizer
    const authorizer = new apigateway.CognitoUserPoolsAuthorizer(this, 'CognitoAuthorizer', {
      cognitoUserPools: [props.userPool],
    });

    // Public resolver route: GET /01/{gtin}/10/{batch}
    const resolverIntegration = new apigateway.LambdaIntegration(resolverFn);
    const ai01 = api.root.addResource('01');
    const gtinResource = ai01.addResource('{gtin}');
    
    // Route for GTIN only: GET /01/{gtin}
    gtinResource.addMethod('GET', resolverIntegration);
    
    // Route for GTIN + batch: GET /01/{gtin}/10/{batch}
    const ai10 = gtinResource.addResource('10');
    const batchResource = ai10.addResource('{batch}');
    batchResource.addMethod('GET', resolverIntegration);

    // Admin routes (authenticated)
    const adminIntegration = new apigateway.LambdaIntegration(adminFn);
    const admin = api.root.addResource('admin');
    const products = admin.addResource('products');

    products.addMethod('GET', adminIntegration, {
      authorizer,
      authorizationType: apigateway.AuthorizationType.COGNITO,
    });

    products.addMethod('POST', adminIntegration, {
      authorizer,
      authorizationType: apigateway.AuthorizationType.COGNITO,
    });

    const productDetail = products.addResource('{gtin}').addResource('{batch}');
    productDetail.addMethod('GET', adminIntegration, {
      authorizer,
      authorizationType: apigateway.AuthorizationType.COGNITO,
    });

    productDetail.addMethod('DELETE', adminIntegration, {
      authorizer,
      authorizationType: apigateway.AuthorizationType.COGNITO,
    });

    this.apiUrl = api.url;

    new cdk.CfnOutput(this, 'ApiUrl', {
      value: api.url,
      exportName: 'GS1ResolverApiUrl',
    });
  }
}
