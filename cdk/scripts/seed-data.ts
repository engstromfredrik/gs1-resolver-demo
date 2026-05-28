import { DynamoDBClient } from '@aws-sdk/client-dynamodb';
import { DynamoDBDocumentClient, PutCommand } from '@aws-sdk/lib-dynamodb';

const client = new DynamoDBClient({ region: process.env.AWS_REGION || 'eu-north-1' });
const ddb = DynamoDBDocumentClient.from(client);
const TABLE_NAME = process.env.TABLE_NAME || 'gs1-resolver-products';

const products = [
  {
    gtin: '7340083450419',
    batch: 'BATCH001',
    name: 'Garant Pannkakor',
    description: 'Swedish pancakes',
    weight: '400 g',
  },
  {
    gtin: '7340083438158',
    batch: 'BATCH001',
    name: 'Garant Krossade Tomater',
    description: 'Crushed tomatoes',
    weight: '400 g',
  },
  {
    gtin: '7340083407338',
    batch: 'BATCH001',
    name: 'Eldorado Vispgrädde 36%',
    description: 'Whipping cream 36%',
    volume: '5 dl',
  },
  {
    gtin: '7340083482397',
    batch: 'BATCH001',
    name: 'Garant Svensk Lantmjölk 1,5%',
    description: 'Swedish farm milk 1.5%',
    volume: '1 liter',
  },
  {
    gtin: '7340083422010',
    batch: 'BATCH001',
    name: 'Eldorado Havregryn',
    description: 'Oat flakes',
    weight: '1,5 kg',
  },
];

async function seedData() {
  console.log('🌱 Seeding sample products...\n');

  for (const product of products) {
    const item = {
      PK: `GTIN#${product.gtin}`,
      SK: `BATCH#${product.batch}`,
      GSI1PK: 'PRODUCT',
      GSI1SK: `GTIN#${product.gtin}#BATCH#${product.batch}`,
      gtin: product.gtin,
      batch: product.batch,
      linkType: 'productInfo',
      productData: {
        name: product.name,
        description: product.description,
        weight: product.weight,
        volume: product.volume,
        manufacturer: 'Garant/Eldorado',
      },
      updatedAt: new Date().toISOString(),
    };

    try {
      await ddb.send(new PutCommand({ TableName: TABLE_NAME, Item: item }));
      console.log(`✅ Added: ${product.name} (${product.gtin})`);
    } catch (error) {
      console.error(`❌ Failed to add ${product.name}:`, error);
    }
  }

  console.log('\n✨ Seeding complete!');
  console.log('\nTest URLs:');
  products.forEach((p) => {
    console.log(`https://gs1-resolver.engstrom.cloud/01/${p.gtin}/10/${p.batch}`);
  });
}

seedData();
