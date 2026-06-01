import { DynamoDBClient } from '@aws-sdk/client-dynamodb';
import { DynamoDBDocumentClient, GetCommand, QueryCommand } from '@aws-sdk/lib-dynamodb';

const client = new DynamoDBClient({});
const ddb = DynamoDBDocumentClient.from(client);
const TABLE_NAME = process.env.TABLE_NAME!;
const ALLOWED_ORIGIN = 'https://gs1-resolver.engstrom.cloud';

const isValidGtin = (gtin: string): boolean => {
  return /^\d{8,14}$/.test(gtin);
};

const isValidBatch = (batch: string): boolean => {
  return /^[a-zA-Z0-9]{1,50}$/.test(batch);
};

const corsHeaders = {
  'Content-Type': 'application/json',
  'Access-Control-Allow-Origin': ALLOWED_ORIGIN,
  'Access-Control-Allow-Headers': 'Content-Type',
  'Access-Control-Allow-Methods': 'GET, OPTIONS',
};

const sanitizeItem = (item: any) => ({
  gtin: item.gtin,
  batch: item.batch,
  linkType: item.linkType,
  targetUrl: item.targetUrl,
  productData: item.productData,
  updatedAt: item.updatedAt,
});

export const handler = async (event: any) => {
  const { gtin, batch } = event.pathParameters || {};

  if (!gtin) {
    return {
      statusCode: 400,
      headers: corsHeaders,
      body: JSON.stringify({ error: 'Missing GTIN parameter' }),
    };
  }

  if (!isValidGtin(gtin)) {
    return {
      statusCode: 400,
      headers: corsHeaders,
      body: JSON.stringify({ error: 'Invalid GTIN format. Must be 8-14 digits.' }),
    };
  }

  if (batch && !isValidBatch(batch)) {
    return {
      statusCode: 400,
      headers: corsHeaders,
      body: JSON.stringify({ error: 'Invalid batch format. Must be alphanumeric, max 50 characters.' }),
    };
  }

  try {
    // If batch is provided, do a direct GetItem
    if (batch) {
      const result = await ddb.send(
        new GetCommand({
          TableName: TABLE_NAME,
          Key: {
            PK: `GTIN#${gtin}`,
            SK: `BATCH#${batch}`,
          },
        })
      );

      if (!result.Item) {
        return {
          statusCode: 404,
          headers: corsHeaders,
          body: JSON.stringify({
            error: 'Product not found',
            gtin,
            batch,
          }),
        };
      }

      return {
        statusCode: 200,
        headers: corsHeaders,
        body: JSON.stringify(sanitizeItem(result.Item)),
      };
    }

    // If no batch, query for all batches of this GTIN and return the first one
    const result = await ddb.send(
      new QueryCommand({
        TableName: TABLE_NAME,
        KeyConditionExpression: 'PK = :pk',
        ExpressionAttributeValues: {
          ':pk': `GTIN#${gtin}`,
        },
        Limit: 1,
      })
    );

    if (!result.Items || result.Items.length === 0) {
      return {
        statusCode: 404,
        headers: corsHeaders,
        body: JSON.stringify({
          error: 'Product not found',
          gtin,
        }),
      };
    }

    return {
      statusCode: 200,
      headers: corsHeaders,
      body: JSON.stringify(sanitizeItem(result.Items[0])),
    };
  } catch (error) {
    console.error('Error querying DynamoDB:', error);
    return {
      statusCode: 500,
      headers: corsHeaders,
      body: JSON.stringify({ error: 'Internal server error' }),
    };
  }
};
