import { DynamoDBClient } from '@aws-sdk/client-dynamodb';
import { DynamoDBDocumentClient, PutCommand, GetCommand, DeleteCommand, QueryCommand } from '@aws-sdk/lib-dynamodb';

const client = new DynamoDBClient({});
const ddb = DynamoDBDocumentClient.from(client);
const TABLE_NAME = process.env.TABLE_NAME!;

export const handler = async (event: any) => {
  const method = event.httpMethod;
  const path = event.path;

  try {
    // List all products (GET /admin/products)
    if (method === 'GET' && path === '/admin/products') {
      const result = await ddb.send(
        new QueryCommand({
          TableName: TABLE_NAME,
          IndexName: 'GSI1',
          KeyConditionExpression: 'GSI1PK = :pk',
          ExpressionAttributeValues: { ':pk': 'PRODUCT' },
        })
      );
      return response(200, { items: result.Items || [] });
    }

    // Get single product (GET /admin/products/{gtin}/{batch})
    if (method === 'GET' && path.startsWith('/admin/products/')) {
      const parts = path.split('/').filter(Boolean);
      const gtin = parts[2];
      const batch = parts[3];

      const result = await ddb.send(
        new GetCommand({
          TableName: TABLE_NAME,
          Key: { PK: `GTIN#${gtin}`, SK: `BATCH#${batch}` },
        })
      );

      if (!result.Item) {
        return response(404, { error: 'Product not found' });
      }

      return response(200, result.Item);
    }

    // Create/Update product (POST /admin/products)
    if (method === 'POST' && path === '/admin/products') {
      const body = JSON.parse(event.body || '{}');
      const { gtin, batch, linkType, targetUrl, productData } = body;

      if (!gtin || !batch || !linkType) {
        return response(400, { error: 'Missing required fields: gtin, batch, linkType' });
      }

      const item = {
        PK: `GTIN#${gtin}`,
        SK: `BATCH#${batch}`,
        GSI1PK: 'PRODUCT',
        GSI1SK: `GTIN#${gtin}#BATCH#${batch}`,
        gtin,
        batch,
        linkType,
        targetUrl: targetUrl || null,
        productData: productData || null,
        updatedAt: new Date().toISOString(),
      };

      await ddb.send(new PutCommand({ TableName: TABLE_NAME, Item: item }));
      return response(200, item);
    }

    // Delete product (DELETE /admin/products/{gtin}/{batch})
    if (method === 'DELETE' && path.startsWith('/admin/products/')) {
      const parts = path.split('/').filter(Boolean);
      const gtin = parts[2];
      const batch = parts[3];

      await ddb.send(
        new DeleteCommand({
          TableName: TABLE_NAME,
          Key: { PK: `GTIN#${gtin}`, SK: `BATCH#${batch}` },
        })
      );

      return response(200, { message: 'Product deleted' });
    }

    return response(404, { error: 'Not found' });
  } catch (error) {
    console.error('Error:', error);
    return response(500, { error: 'Internal server error' });
  }
};

const response = (statusCode: number, body: any) => ({
  statusCode,
  headers: {
    'Content-Type': 'application/json',
    'Access-Control-Allow-Origin': '*',
  },
  body: JSON.stringify(body),
});
