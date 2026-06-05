#!/bin/bash
set -e

TABLE_NAME="gs1-resolver-products"
REGION="${AWS_REGION:-eu-north-1}"

echo "🌱 Seeding fun sample products to DynamoDB (new SK pattern)..."
echo "Table: $TABLE_NAME"
echo "Region: $REGION"
echo ""

# Product 1: Maria's Magical Muffins
aws dynamodb put-item \
  --table-name "$TABLE_NAME" \
  --region "$REGION" \
  --item '{
    "PK": {"S": "GTIN#1234567890001"},
    "SK": {"S": "BATCH#MARIA2024#LINKTYPE#gs1:productInfo"},
    "GSI1PK": {"S": "PRODUCT"},
    "GSI1SK": {"S": "GTIN#1234567890001#BATCH#MARIA2024#LINKTYPE#gs1:productInfo"},
    "gtin": {"S": "1234567890001"},
    "batch": {"S": "MARIA2024"},
    "linkType": {"S": "gs1:productInfo"},
    "productData": {"M": {
      "name": {"S": "Marias Magiska Muffins"},
      "description": {"S": "Himmelskt goda chokladmuffins bakade med karlek"},
      "weight": {"S": "400 g (6 st)"},
      "manufacturer": {"S": "Marias Bakery AB"},
      "brand": {"S": "Marias Magic"},
      "categories": {"S": "Bakverk, Muffins, Choklad, Fika"},
      "ingredients": {"S": "Vetemjol, socker, agg, smor, choklad (20%), kakao, bakpulver, vanilj, salt"},
      "allergens": {"S": "Vete, agg, mjolk. Kan innehalla spar av notter"},
      "origin": {"S": "Sverige"},
      "packaging": {"S": "Kartong"},
      "storage": {"S": "Forvaras svalt och torrt"},
      "nutritionPer100g": {"M": {
        "energy": {"S": "1850 kJ / 442 kcal"},
        "fat": {"S": "22 g"},
        "saturatedFat": {"S": "13 g"},
        "carbohydrates": {"S": "52 g"},
        "sugars": {"S": "28 g"},
        "fiber": {"S": "3.2 g"},
        "protein": {"S": "6.5 g"},
        "salt": {"S": "0.8 g"}
      }}
    }},
    "updatedAt": {"S": "'$(date -u +%Y-%m-%dT%H:%M:%SZ)'"}
  }'
echo "✅ Marias Magiska Muffins"

# Product 2: Fredrik's Fantastic Fish Fingers
aws dynamodb put-item \
  --table-name "$TABLE_NAME" \
  --region "$REGION" \
  --item '{
    "PK": {"S": "GTIN#1234567890002"},
    "SK": {"S": "BATCH#FRED2024#LINKTYPE#gs1:productInfo"},
    "GSI1PK": {"S": "PRODUCT"},
    "GSI1SK": {"S": "GTIN#1234567890002#BATCH#FRED2024#LINKTYPE#gs1:productInfo"},
    "gtin": {"S": "1234567890002"},
    "batch": {"S": "FRED2024"},
    "linkType": {"S": "gs1:productInfo"},
    "productData": {"M": {
      "name": {"S": "Fredriks Fantastiska Fiskpinnar"},
      "description": {"S": "Krispiga fiskpinnar - Fredriks favorit!"},
      "weight": {"S": "450 g (12 st)"},
      "manufacturer": {"S": "Fredriks Fisk AB"},
      "brand": {"S": "Fredriks Finest"},
      "categories": {"S": "Fryst, Fisk, Fiskpinnar, Middag"},
      "ingredients": {"S": "Torskfile (65%), panering (vetemjol, vatten, majsmjol, salt, jast), rapsolja"},
      "allergens": {"S": "Fisk, vete"},
      "origin": {"S": "Sverige"},
      "packaging": {"S": "Frysforpackning, kartong"},
      "storage": {"S": "Forvaras fryst vid -18C"},
      "certifications": {"S": "MSC-certifierad"},
      "nutritionPer100g": {"M": {
        "energy": {"S": "920 kJ / 220 kcal"},
        "fat": {"S": "11 g"},
        "saturatedFat": {"S": "1.2 g"},
        "carbohydrates": {"S": "18 g"},
        "sugars": {"S": "1.5 g"},
        "fiber": {"S": "1.8 g"},
        "protein": {"S": "12 g"},
        "salt": {"S": "1.1 g"}
      }}
    }},
    "updatedAt": {"S": "'$(date -u +%Y-%m-%dT%H:%M:%SZ)'"}
  }'
echo "✅ Fredriks Fantastiska Fiskpinnar"

# Product 3: Martin's Marvelous Marmalade
aws dynamodb put-item \
  --table-name "$TABLE_NAME" \
  --region "$REGION" \
  --item '{
    "PK": {"S": "GTIN#1234567890003"},
    "SK": {"S": "BATCH#MART2024#LINKTYPE#gs1:productInfo"},
    "GSI1PK": {"S": "PRODUCT"},
    "GSI1SK": {"S": "GTIN#1234567890003#BATCH#MART2024#LINKTYPE#gs1:productInfo"},
    "gtin": {"S": "1234567890003"},
    "batch": {"S": "MART2024"},
    "linkType": {"S": "gs1:productInfo"},
    "productData": {"M": {
      "name": {"S": "Martins Magnifika Marmelad"},
      "description": {"S": "Apelsinmarmelad med bitter touch - Martins morgonmust!"},
      "weight": {"S": "450 g"},
      "manufacturer": {"S": "Martins Marmelad AB"},
      "brand": {"S": "Martins Marvelous"},
      "categories": {"S": "Sylt och marmelad, Frukost"},
      "ingredients": {"S": "Apelsiner (55%), socker, vatten, citronsaft, pektin"},
      "allergens": {"S": "Inga kanda allergener"},
      "origin": {"S": "Spanien/Sverige"},
      "packaging": {"S": "Glasburk"},
      "storage": {"S": "Forvaras svalt"},
      "certifications": {"S": "Ekologisk"},
      "nutritionPer100g": {"M": {
        "energy": {"S": "1050 kJ / 250 kcal"},
        "fat": {"S": "0.2 g"},
        "saturatedFat": {"S": "0 g"},
        "carbohydrates": {"S": "60 g"},
        "sugars": {"S": "58 g"},
        "fiber": {"S": "1.5 g"},
        "protein": {"S": "0.5 g"},
        "salt": {"S": "0.01 g"}
      }}
    }},
    "updatedAt": {"S": "'$(date -u +%Y-%m-%dT%H:%M:%SZ)'"}
  }'
echo "✅ Martins Magnifika Marmelad"

# Product 4: Karolina's Crispy Cookies
aws dynamodb put-item \
  --table-name "$TABLE_NAME" \
  --region "$REGION" \
  --item '{
    "PK": {"S": "GTIN#1234567890004"},
    "SK": {"S": "BATCH#KARO2024#LINKTYPE#gs1:productInfo"},
    "GSI1PK": {"S": "PRODUCT"},
    "GSI1SK": {"S": "GTIN#1234567890004#BATCH#KARO2024#LINKTYPE#gs1:productInfo"},
    "gtin": {"S": "1234567890004"},
    "batch": {"S": "KARO2024"},
    "linkType": {"S": "gs1:productInfo"},
    "productData": {"M": {
      "name": {"S": "Karolinas Krispiga Kakor"},
      "description": {"S": "Havrekakor med chokladbitar - Karolinas klassiker!"},
      "weight": {"S": "300 g"},
      "manufacturer": {"S": "Karolinas Konfektyr AB"},
      "brand": {"S": "Karolinas Crispy"},
      "categories": {"S": "Kex och kakor, Fika, Choklad"},
      "ingredients": {"S": "Havregryn (35%), vetemjol, smor, socker, chokladbitar (15%), agg, honung, bakpulver, vanilj, salt"},
      "allergens": {"S": "Havre, vete, mjolk, agg"},
      "origin": {"S": "Sverige"},
      "packaging": {"S": "Pase"},
      "storage": {"S": "Forvaras torrt"},
      "certifications": {"S": "Fullkorn"},
      "nutritionPer100g": {"M": {
        "energy": {"S": "2100 kJ / 502 kcal"},
        "fat": {"S": "25 g"},
        "saturatedFat": {"S": "14 g"},
        "carbohydrates": {"S": "60 g"},
        "sugars": {"S": "22 g"},
        "fiber": {"S": "5.5 g"},
        "protein": {"S": "8 g"},
        "salt": {"S": "0.6 g"}
      }}
    }},
    "updatedAt": {"S": "'$(date -u +%Y-%m-%dT%H:%M:%SZ)'"}
  }'
echo "✅ Karolinas Krispiga Kakor"

# Product 5: Mikael's Mighty Meatballs
aws dynamodb put-item \
  --table-name "$TABLE_NAME" \
  --region "$REGION" \
  --item '{
    "PK": {"S": "GTIN#1234567890005"},
    "SK": {"S": "BATCH#MIKE2024#LINKTYPE#gs1:productInfo"},
    "GSI1PK": {"S": "PRODUCT"},
    "GSI1SK": {"S": "GTIN#1234567890005#BATCH#MIKE2024#LINKTYPE#gs1:productInfo"},
    "gtin": {"S": "1234567890005"},
    "batch": {"S": "MIKE2024"},
    "linkType": {"S": "gs1:productInfo"},
    "productData": {"M": {
      "name": {"S": "Mikaels Maktiga Kottbullar"},
      "description": {"S": "Saftiga kottbullar av svenskt kott - Mikaels masterverk!"},
      "weight": {"S": "500 g"},
      "manufacturer": {"S": "Mikaels Kott AB"},
      "brand": {"S": "Mikaels Mighty"},
      "categories": {"S": "Kott, Kottbullar, Fardigmat, Middag"},
      "ingredients": {"S": "Notkott (70%), griskott (15%), lok, strobrod (vete), mjolk, agg, salt, peppar"},
      "allergens": {"S": "Vete, mjolk, agg"},
      "origin": {"S": "Svenskt kott"},
      "packaging": {"S": "Vakuumforpackning"},
      "storage": {"S": "Forvaras kallt, max +4C"},
      "certifications": {"S": "Svenskt kott, Fran Sverige"},
      "nutritionPer100g": {"M": {
        "energy": {"S": "1150 kJ / 275 kcal"},
        "fat": {"S": "20 g"},
        "saturatedFat": {"S": "8.5 g"},
        "carbohydrates": {"S": "5 g"},
        "sugars": {"S": "1.2 g"},
        "fiber": {"S": "0.8 g"},
        "protein": {"S": "20 g"},
        "salt": {"S": "1.3 g"}
      }}
    }},
    "updatedAt": {"S": "'$(date -u +%Y-%m-%dT%H:%M:%SZ)'"}
  }'
echo "✅ Mikaels Maktiga Kottbullar"

# Product 6: Strand's Seaside Salmon
aws dynamodb put-item \
  --table-name "$TABLE_NAME" \
  --region "$REGION" \
  --item '{
    "PK": {"S": "GTIN#1234567890006"},
    "SK": {"S": "BATCH#STRAND2024#LINKTYPE#gs1:productInfo"},
    "GSI1PK": {"S": "PRODUCT"},
    "GSI1SK": {"S": "GTIN#1234567890006#BATCH#STRAND2024#LINKTYPE#gs1:productInfo"},
    "gtin": {"S": "1234567890006"},
    "batch": {"S": "STRAND2024"},
    "linkType": {"S": "gs1:productInfo"},
    "productData": {"M": {
      "name": {"S": "Strands Strandnara Lax"},
      "description": {"S": "Kallrokt lax fran svenska vastkusten - direkt fran stranden!"},
      "weight": {"S": "200 g"},
      "manufacturer": {"S": "Strands Seafood AB"},
      "brand": {"S": "Strands Seaside"},
      "categories": {"S": "Fisk, Rokt fisk, Lax, Delikatesser"},
      "ingredients": {"S": "Lax (97%), salt, roksmak"},
      "allergens": {"S": "Fisk"},
      "origin": {"S": "Svenska vastkusten"},
      "packaging": {"S": "Vakuumforpackning"},
      "storage": {"S": "Forvaras kallt, max +4C"},
      "certifications": {"S": "ASC-certifierad"},
      "nutritionPer100g": {"M": {
        "energy": {"S": "920 kJ / 220 kcal"},
        "fat": {"S": "14 g"},
        "saturatedFat": {"S": "3.2 g"},
        "carbohydrates": {"S": "0.5 g"},
        "sugars": {"S": "0.5 g"},
        "fiber": {"S": "0 g"},
        "protein": {"S": "24 g"},
        "salt": {"S": "3.5 g"}
      }}
    }},
    "updatedAt": {"S": "'$(date -u +%Y-%m-%dT%H:%M:%SZ)'"}
  }'
echo "✅ Strands Strandnara Lax"

# Product 7: Höjd's High-Quality Honey
aws dynamodb put-item \
  --table-name "$TABLE_NAME" \
  --region "$REGION" \
  --item '{
    "PK": {"S": "GTIN#1234567890007"},
    "SK": {"S": "BATCH#HOJD2024#LINKTYPE#gs1:productInfo"},
    "GSI1PK": {"S": "PRODUCT"},
    "GSI1SK": {"S": "GTIN#1234567890007#BATCH#HOJD2024#LINKTYPE#gs1:productInfo"},
    "gtin": {"S": "1234567890007"},
    "batch": {"S": "HOJD2024"},
    "linkType": {"S": "gs1:productInfo"},
    "productData": {"M": {
      "name": {"S": "Hojds Hogt Hyllad Honung"},
      "description": {"S": "Ekologisk honung fran svenska fjallangar - pa hog hojd!"},
      "weight": {"S": "350 g"},
      "manufacturer": {"S": "Hojds Biodling AB"},
      "brand": {"S": "Hojds High"},
      "categories": {"S": "Honung, Ekologiskt, Frukost"},
      "ingredients": {"S": "Honung (100%)"},
      "allergens": {"S": "Inga kanda allergener"},
      "origin": {"S": "Sverige, Jamtland"},
      "packaging": {"S": "Glasburk"},
      "storage": {"S": "Forvaras rumstempererat"},
      "certifications": {"S": "Ekologisk, KRAV"},
      "nutritionPer100g": {"M": {
        "energy": {"S": "1360 kJ / 325 kcal"},
        "fat": {"S": "0 g"},
        "saturatedFat": {"S": "0 g"},
        "carbohydrates": {"S": "81 g"},
        "sugars": {"S": "80 g"},
        "fiber": {"S": "0 g"},
        "protein": {"S": "0.4 g"},
        "salt": {"S": "0.01 g"}
      }}
    }},
    "updatedAt": {"S": "'$(date -u +%Y-%m-%dT%H:%M:%SZ)'"}
  }'
echo "✅ Hojds Hogt Hyllad Honung"

# Product 8: Engstrom's Energy Drink
aws dynamodb put-item \
  --table-name "$TABLE_NAME" \
  --region "$REGION" \
  --item '{
    "PK": {"S": "GTIN#1234567890008"},
    "SK": {"S": "BATCH#ENG2024#LINKTYPE#gs1:productInfo"},
    "GSI1PK": {"S": "PRODUCT"},
    "GSI1SK": {"S": "GTIN#1234567890008#BATCH#ENG2024#LINKTYPE#gs1:productInfo"},
    "gtin": {"S": "1234567890008"},
    "batch": {"S": "ENG2024"},
    "linkType": {"S": "gs1:productInfo"},
    "productData": {"M": {
      "name": {"S": "Engstroms Energigivande Dryck"},
      "description": {"S": "Naturlig energidryck med guarana - Engstroms elixir!"},
      "volume": {"S": "500 ml"},
      "manufacturer": {"S": "Engstroms Beverages AB"},
      "brand": {"S": "Engstroms Energy"},
      "categories": {"S": "Dryck, Energidryck"},
      "ingredients": {"S": "Vatten, socker, kolsyra, guaranaextrakt, koffein, vitaminer (B6, B12), citronsyra"},
      "allergens": {"S": "Inga kanda allergener"},
      "origin": {"S": "Sverige"},
      "packaging": {"S": "Aluminiumburk"},
      "storage": {"S": "Forvaras svalt"},
      "certifications": {"S": "Naturliga ingredienser"},
      "nutritionPer100g": {"M": {
        "energy": {"S": "180 kJ / 43 kcal"},
        "fat": {"S": "0 g"},
        "saturatedFat": {"S": "0 g"},
        "carbohydrates": {"S": "10.5 g"},
        "sugars": {"S": "10.5 g"},
        "fiber": {"S": "0 g"},
        "protein": {"S": "0 g"},
        "salt": {"S": "0.1 g"}
      }}
    }},
    "updatedAt": {"S": "'$(date -u +%Y-%m-%dT%H:%M:%SZ)'"}
  }'
echo "✅ Engstroms Energigivande Dryck"

# Product 9: Edqvist's Exquisite Espresso
aws dynamodb put-item \
  --table-name "$TABLE_NAME" \
  --region "$REGION" \
  --item '{
    "PK": {"S": "GTIN#1234567890009"},
    "SK": {"S": "BATCH#EDQ2024#LINKTYPE#gs1:productInfo"},
    "GSI1PK": {"S": "PRODUCT"},
    "GSI1SK": {"S": "GTIN#1234567890009#BATCH#EDQ2024#LINKTYPE#gs1:productInfo"},
    "gtin": {"S": "1234567890009"},
    "batch": {"S": "EDQ2024"},
    "linkType": {"S": "gs1:productInfo"},
    "productData": {"M": {
      "name": {"S": "Edqvists Exklusiva Espresso"},
      "description": {"S": "Morkrostade kaffebonor fran Etiopien - Edqvists elegans!"},
      "weight": {"S": "250 g"},
      "manufacturer": {"S": "Edqvists Coffee Roasters AB"},
      "brand": {"S": "Edqvists Exquisite"},
      "categories": {"S": "Kaffe, Espresso, Hela bonor"},
      "ingredients": {"S": "Kaffebonor (100%)"},
      "allergens": {"S": "Inga kanda allergener"},
      "origin": {"S": "Etiopien, rostat i Sverige"},
      "packaging": {"S": "Pase med ventil"},
      "storage": {"S": "Forvaras svalt och torrt"},
      "certifications": {"S": "Ekologisk, Fairtrade, Rainforest Alliance"},
      "nutritionPer100g": {"M": {
        "energy": {"S": "0 kJ / 0 kcal"},
        "fat": {"S": "0 g"},
        "saturatedFat": {"S": "0 g"},
        "carbohydrates": {"S": "0 g"},
        "sugars": {"S": "0 g"},
        "fiber": {"S": "0 g"},
        "protein": {"S": "0 g"},
        "salt": {"S": "0 g"}
      }}
    }},
    "updatedAt": {"S": "'$(date -u +%Y-%m-%dT%H:%M:%SZ)'"}
  }'
echo "✅ Edqvists Exklusiva Espresso"

echo ""
echo "✨ Seeding complete! 9 products added."
echo ""
echo "Test URLs:"
echo "https://gs1-resolver.engstrom.cloud/01/1234567890001/10/MARIA2024"
echo "https://gs1-resolver.engstrom.cloud/01/1234567890001/10/MARIA2024?15=260930"
echo "https://gs1-resolver.engstrom.cloud/01/1234567890001/10/MARIA2024?15=260930&linkType=gs1:productInfo"
