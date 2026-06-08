import { DynamoDBClient } from '@aws-sdk/client-dynamodb';
import { DynamoDBDocumentClient, GetCommand, QueryCommand } from '@aws-sdk/lib-dynamodb';

const client = new DynamoDBClient({});
const ddb = DynamoDBDocumentClient.from(client);
const TABLE_NAME = process.env.TABLE_NAME!;
const ALLOWED_ORIGIN = 'https://gs1-resolver.engstrom.cloud';

const isValidGtin = (gtin: string): boolean => /^\d{8,14}$/.test(gtin);
const isValidBatch = (batch: string): boolean => /^[a-zA-Z0-9]{1,50}$/.test(batch);

const corsHeaders = {
  'Content-Type': 'application/json',
  'Access-Control-Allow-Origin': ALLOWED_ORIGIN,
  'Access-Control-Allow-Headers': 'Content-Type',
  'Access-Control-Allow-Methods': 'GET, OPTIONS',
};

const sanitizeItem = (item: any, expiryDate?: string) => {
  const result: any = {
    gtin: item.gtin,
    batch: item.batch,
    linkType: item.linkType,
    targetUrl: item.targetUrl,
    productData: item.productData,
    updatedAt: item.updatedAt,
  };
  if (expiryDate) result.expiryDate = expiryDate;
  return result;
};

export const handler = async (event: any) => {
  const { gtin, batch } = event.pathParameters || {};
  const queryParams = event.queryStringParameters || {};
  const linkType = queryParams.linkType;
  const expiryDate = queryParams['15'];

  if (!gtin) {
    return { statusCode: 400, headers: corsHeaders, body: JSON.stringify({ error: 'Missing GTIN parameter' }) };
  }

  if (!isValidGtin(gtin)) {
    return { statusCode: 400, headers: corsHeaders, body: JSON.stringify({ error: 'Invalid GTIN format. Must be 8-14 digits.' }) };
  }

  if (batch && !isValidBatch(batch)) {
    return { statusCode: 400, headers: corsHeaders, body: JSON.stringify({ error: 'Invalid batch format. Must be alphanumeric, max 50 characters.' }) };
  }

  try {
    if (batch && linkType) {
      const sk = `BATCH#${batch}#LINKTYPE#${linkType}`;
      const result = await ddb.send(new GetCommand({
        TableName: TABLE_NAME,
        Key: { PK: `GTIN#${gtin}`, SK: sk },
      }));

      if (!result.Item) {
        return { statusCode: 404, headers: corsHeaders, body: JSON.stringify({ error: 'Product not found', gtin, batch, linkType }) };
      }

      return { statusCode: 200, headers: corsHeaders, body: JSON.stringify(sanitizeItem(result.Item, expiryDate)) };
    }

    const result = await ddb.send(new QueryCommand({
      TableName: TABLE_NAME,
      KeyConditionExpression: 'PK = :pk AND begins_with(SK, :skPrefix)',
      ExpressionAttributeValues: {
        ':pk': `GTIN#${gtin}`,
        ':skPrefix': batch ? `BATCH#${batch}#` : 'BATCH#',
      },
    }));

    if (!result.Items?.length) {
      return { statusCode: 404, headers: corsHeaders, body: JSON.stringify({ error: 'Product not found', gtin }) };
    }

    const item = linkType ? result.Items.find(i => i.linkType === linkType) : result.Items[0];
    if (!item) {
      return { statusCode: 404, headers: corsHeaders, body: JSON.stringify({ error: 'Product not found', gtin, linkType }) };
    }

    return { statusCode: 200, headers: corsHeaders, body: JSON.stringify(sanitizeItem(item, expiryDate)) };
  } catch (error) {
    console.error('Error querying DynamoDB:', error);
    return { statusCode: 500, headers: corsHeaders, body: JSON.stringify({ error: 'Internal server error' }) };
  }
};
