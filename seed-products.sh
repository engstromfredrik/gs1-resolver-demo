#!/bin/bash
set -e

TABLE_NAME="gs1-resolver-products"
REGION="${AWS_REGION:-eu-north-1}"

echo "🌱 Seeding sample products to DynamoDB..."
echo "Table: $TABLE_NAME"
echo "Region: $REGION"
echo ""

# Product 1: Garant Pannkakor
aws dynamodb put-item \
  --table-name "$TABLE_NAME" \
  --region "$REGION" \
  --item '{
    "PK": {"S": "GTIN#7340083450419"},
    "SK": {"S": "BATCH#BATCH001"},
    "GSI1PK": {"S": "PRODUCT"},
    "GSI1SK": {"S": "GTIN#7340083450419#BATCH#BATCH001"},
    "gtin": {"S": "7340083450419"},
    "batch": {"S": "BATCH001"},
    "linkType": {"S": "productInfo"},
    "productData": {"M": {
      "name": {"S": "Garant Pannkakor"},
      "description": {"S": "Pannkakor - 8 x 50 g"},
      "weight": {"S": "400 g (8 x 50 g)"},
      "manufacturer": {"S": "Garant (Axfood)"},
      "brand": {"S": "Garant"},
      "categories": {"S": "Färdigmat, Crêpes and galettes, Microwave meals, Pancakes"},
      "ingredients": {"S": "Mjölk, vetemjöl, ägg, rapsolja, socker, salt, bakpulver (E500)"},
      "allergens": {"S": "Mjölk, vete, ägg"},
      "origin": {"S": "Belgien"},
      "nutriScore": {"S": "C"},
      "nutritionPer100g": {"M": {
        "energy": {"S": "950 kJ / 227 kcal"},
        "fat": {"S": "9.5 g"},
        "saturatedFat": {"S": "3.5 g"},
        "carbohydrates": {"S": "26 g"},
        "sugars": {"S": "2 g"},
        "fiber": {"S": "1.5 g"},
        "protein": {"S": "7.5 g"},
        "salt": {"S": "0.75 g"}
      }},
      "packaging": {"S": "Plast"},
      "productUrl": {"S": "https://www.garantskafferiet.se/vara-produkter/skafferi/pannkakor-8-pack/"}
    }},
    "updatedAt": {"S": "'$(date -u +%Y-%m-%dT%H:%M:%SZ)'"}
  }'
echo "✅ Added: Garant Pannkakor (7340083450419)"

# Product 2: Garant Krossade Tomater
aws dynamodb put-item \
  --table-name "$TABLE_NAME" \
  --region "$REGION" \
  --item '{
    "PK": {"S": "GTIN#7340083438158"},
    "SK": {"S": "BATCH#BATCH001"},
    "GSI1PK": {"S": "PRODUCT"},
    "GSI1SK": {"S": "GTIN#7340083438158#BATCH#BATCH001"},
    "gtin": {"S": "7340083438158"},
    "batch": {"S": "BATCH001"},
    "linkType": {"S": "productInfo"},
    "productData": {"M": {
      "name": {"S": "Garant Krossade Tomater"},
      "description": {"S": "Krossade tomater på burk"},
      "weight": {"S": "400 g"},
      "manufacturer": {"S": "Garant (Axfood)"},
      "brand": {"S": "Garant"},
      "categories": {"S": "Konserver, Grönsaker, Tomater, Krossade tomater"},
      "ingredients": {"S": "Tomater, tomatjuice, surhetsreglerande medel (citronsyra)"},
      "allergens": {"S": "Inga kända allergener"},
      "nutritionPer100g": {"M": {
        "energy": {"S": "100 kJ / 24 kcal"},
        "fat": {"S": "0.2 g"},
        "saturatedFat": {"S": "0 g"},
        "carbohydrates": {"S": "3.5 g"},
        "sugars": {"S": "3.5 g"},
        "fiber": {"S": "1.5 g"},
        "protein": {"S": "1.2 g"},
        "salt": {"S": "0.3 g"}
      }},
      "packaging": {"S": "Burk, metall"}
    }},
    "updatedAt": {"S": "'$(date -u +%Y-%m-%dT%H:%M:%SZ)'"}
  }'
echo "✅ Added: Garant Krossade Tomater (7340083438158)"

# Product 3: Eldorado Vispgrädde
aws dynamodb put-item \
  --table-name "$TABLE_NAME" \
  --region "$REGION" \
  --item '{
    "PK": {"S": "GTIN#7340083407338"},
    "SK": {"S": "BATCH#BATCH001"},
    "GSI1PK": {"S": "PRODUCT"},
    "GSI1SK": {"S": "GTIN#7340083407338#BATCH#BATCH001"},
    "gtin": {"S": "7340083407338"},
    "batch": {"S": "BATCH001"},
    "linkType": {"S": "productInfo"},
    "productData": {"M": {
      "name": {"S": "Eldorado Vispgrädde 36%"},
      "description": {"S": "Vispgrädde för matlagning och bakning"},
      "volume": {"S": "5 dl"},
      "manufacturer": {"S": "Eldorado (Axfood)"},
      "brand": {"S": "Eldorado"},
      "categories": {"S": "Mejeri, Grädde, Vispgrädde"},
      "ingredients": {"S": "Grädde (mjölk)"},
      "allergens": {"S": "Mjölk"},
      "fatContent": {"S": "36%"},
      "nutritionPer100ml": {"M": {
        "energy": {"S": "1420 kJ / 345 kcal"},
        "fat": {"S": "36 g"},
        "saturatedFat": {"S": "23 g"},
        "carbohydrates": {"S": "3.2 g"},
        "sugars": {"S": "3.2 g"},
        "protein": {"S": "2.2 g"},
        "salt": {"S": "0.08 g"}
      }},
      "packaging": {"S": "Kartong"},
      "storage": {"S": "Förvaras kallt, max +8°C"}
    }},
    "updatedAt": {"S": "'$(date -u +%Y-%m-%dT%H:%M:%SZ)'"}
  }'
echo "✅ Added: Eldorado Vispgrädde 36% (7340083407338)"

# Product 4: Garant Svensk Lantmjölk
aws dynamodb put-item \
  --table-name "$TABLE_NAME" \
  --region "$REGION" \
  --item '{
    "PK": {"S": "GTIN#7340083482397"},
    "SK": {"S": "BATCH#BATCH001"},
    "GSI1PK": {"S": "PRODUCT"},
    "GSI1SK": {"S": "GTIN#7340083482397#BATCH#BATCH001"},
    "gtin": {"S": "7340083482397"},
    "batch": {"S": "BATCH001"},
    "linkType": {"S": "productInfo"},
    "productData": {"M": {
      "name": {"S": "Garant Svensk Lantmjölk 1,5%"},
      "description": {"S": "Mellanmjölk från svenska gårdar"},
      "volume": {"S": "1 liter"},
      "manufacturer": {"S": "Garant (Axfood)"},
      "brand": {"S": "Garant"},
      "categories": {"S": "Mejeri, Mjölk, Mellanmjölk"},
      "ingredients": {"S": "Mjölk, vitamin D"},
      "allergens": {"S": "Mjölk"},
      "fatContent": {"S": "1,5%"},
      "origin": {"S": "Sverige"},
      "nutritionPer100ml": {"M": {
        "energy": {"S": "195 kJ / 46 kcal"},
        "fat": {"S": "1.5 g"},
        "saturatedFat": {"S": "1.0 g"},
        "carbohydrates": {"S": "4.7 g"},
        "sugars": {"S": "4.7 g"},
        "protein": {"S": "3.4 g"},
        "salt": {"S": "0.1 g"},
        "calcium": {"S": "120 mg"},
        "vitaminD": {"S": "1.0 µg"}
      }},
      "packaging": {"S": "Kartong"},
      "storage": {"S": "Förvaras kallt, max +8°C"},
      "certifications": {"S": "Svenskt ursprung"}
    }},
    "updatedAt": {"S": "'$(date -u +%Y-%m-%dT%H:%M:%SZ)'"}
  }'
echo "✅ Added: Garant Svensk Lantmjölk 1,5% (7340083482397)"

# Product 5: Eldorado Havregryn
aws dynamodb put-item \
  --table-name "$TABLE_NAME" \
  --region "$REGION" \
  --item '{
    "PK": {"S": "GTIN#7340083422010"},
    "SK": {"S": "BATCH#BATCH001"},
    "GSI1PK": {"S": "PRODUCT"},
    "GSI1SK": {"S": "GTIN#7340083422010#BATCH#BATCH001"},
    "gtin": {"S": "7340083422010"},
    "batch": {"S": "BATCH001"},
    "linkType": {"S": "productInfo"},
    "productData": {"M": {
      "name": {"S": "Eldorado Havregryn"},
      "description": {"S": "Fullkorn havregryn för gröt och bakning"},
      "weight": {"S": "1,5 kg"},
      "manufacturer": {"S": "Eldorado (Axfood)"},
      "brand": {"S": "Eldorado"},
      "categories": {"S": "Frukost, Flingor och müsli, Havregryn, Fullkorn"},
      "ingredients": {"S": "Havregryn (100%)"},
      "allergens": {"S": "Havre (gluten). Kan innehålla spår av vete, råg, korn"},
      "nutritionPer100g": {"M": {
        "energy": {"S": "1550 kJ / 368 kcal"},
        "fat": {"S": "7.0 g"},
        "saturatedFat": {"S": "1.3 g"},
        "carbohydrates": {"S": "58 g"},
        "sugars": {"S": "1.0 g"},
        "fiber": {"S": "10 g"},
        "protein": {"S": "13 g"},
        "salt": {"S": "0.01 g"}
      }},
      "packaging": {"S": "Påse, papper"},
      "storage": {"S": "Förvaras torrt och svalt"},
      "certifications": {"S": "Fullkorn"}
    }},
    "updatedAt": {"S": "'$(date -u +%Y-%m-%dT%H:%M:%SZ)'"}
  }'
echo "✅ Added: Eldorado Havregryn (7340083422010)"

echo ""
echo "✨ Seeding complete!"
echo ""
echo "Test URLs:"
echo "https://gs1-resolver.engstrom.cloud/01/7340083450419/10/BATCH001"
echo "https://gs1-resolver.engstrom.cloud/01/7340083438158/10/BATCH001"
echo "https://gs1-resolver.engstrom.cloud/01/7340083407338/10/BATCH001"
echo "https://gs1-resolver.engstrom.cloud/01/7340083482397/10/BATCH001"
echo "https://gs1-resolver.engstrom.cloud/01/7340083422010/10/BATCH001"
