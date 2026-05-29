#!/bin/bash
set -e

TABLE_NAME="gs1-resolver-products"
REGION="${AWS_REGION:-eu-north-1}"

echo "🌱 Seeding fun sample products to DynamoDB..."
echo "Table: $TABLE_NAME"
echo "Region: $REGION"
echo ""

# Product 1: Maria's Magical Muffins
aws dynamodb put-item \
  --table-name "$TABLE_NAME" \
  --region "$REGION" \
  --item '{
    "PK": {"S": "GTIN#1234567890001"},
    "SK": {"S": "BATCH#MARIA2024"},
    "GSI1PK": {"S": "PRODUCT"},
    "GSI1SK": {"S": "GTIN#1234567890001#BATCH#MARIA2024"},
    "gtin": {"S": "1234567890001"},
    "batch": {"S": "MARIA2024"},
    "linkType": {"S": "productInfo"},
    "productData": {"M": {
      "name": {"S": "Marias Magiska Muffins"},
      "description": {"S": "Himmelskt goda chokladmuffins bakade med kärlek"},
      "weight": {"S": "400 g (6 st)"},
      "manufacturer": {"S": "Maria'\''s Bakery AB"},
      "brand": {"S": "Maria'\''s Magic"},
      "categories": {"S": "Bakverk, Muffins, Choklad, Fika"},
      "ingredients": {"S": "Vetemjöl, socker, ägg, smör, choklad (20%), kakao, bakpulver, vanilj, salt, kärlek"},
      "allergens": {"S": "Vete, ägg, mjölk. Kan innehålla spår av nötter"},
      "origin": {"S": "Sverige"},
      "packaging": {"S": "Kartong, återvinningsbar"},
      "storage": {"S": "Förvaras svalt och torrt"},
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
echo "✅ Added: Marias Magiska Muffins (1234567890001)"

# Product 2: Fredrik's Fantastic Fish Fingers
aws dynamodb put-item \
  --table-name "$TABLE_NAME" \
  --region "$REGION" \
  --item '{
    "PK": {"S": "GTIN#1234567890002"},
    "SK": {"S": "BATCH#FRED2024"},
    "GSI1PK": {"S": "PRODUCT"},
    "GSI1SK": {"S": "GTIN#1234567890002#BATCH#FRED2024"},
    "gtin": {"S": "1234567890002"},
    "batch": {"S": "FRED2024"},
    "linkType": {"S": "productInfo"},
    "productData": {"M": {
      "name": {"S": "Fredriks Fantastiska Fiskpinnar"},
      "description": {"S": "Krispiga fiskpinnar från Östersjön - Fredriks favorit!"},
      "weight": {"S": "450 g (12 st)"},
      "manufacturer": {"S": "Fredrik'\''s Fisk & Skaldjur AB"},
      "brand": {"S": "Fredrik'\''s Finest"},
      "categories": {"S": "Fryst, Fisk, Fiskpinnar, Middag"},
      "ingredients": {"S": "Torskfilé (65%), panering (vetemjöl, vatten, majsmjöl, salt, jäst), rapsolja"},
      "allergens": {"S": "Fisk, vete. Kan innehålla spår av ägg"},
      "origin": {"S": "Fisk från Östersjön, förädlad i Sverige"},
      "packaging": {"S": "Frysförpackning, kartong"},
      "storage": {"S": "Förvaras fryst vid -18°C"},
      "certifications": {"S": "MSC-certifierad, Svenskt fiske"},
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
echo "✅ Added: Fredriks Fantastiska Fiskpinnar (1234567890002)"

# Product 3: Martin's Marvelous Marmalade
aws dynamodb put-item \
  --table-name "$TABLE_NAME" \
  --region "$REGION" \
  --item '{
    "PK": {"S": "GTIN#1234567890003"},
    "SK": {"S": "BATCH#MART2024"},
    "GSI1PK": {"S": "PRODUCT"},
    "GSI1SK": {"S": "GTIN#1234567890003#BATCH#MART2024"},
    "gtin": {"S": "1234567890003"},
    "batch": {"S": "MART2024"},
    "linkType": {"S": "productInfo"},
    "productData": {"M": {
      "name": {"S": "Martins Magnifika Marmelad"},
      "description": {"S": "Apelsinmarmelad med bitter touch - Martins morgonmust!"},
      "weight": {"S": "450 g"},
      "manufacturer": {"S": "Martin'\''s Marmelad & Sylt AB"},
      "brand": {"S": "Martin'\''s Marvelous"},
      "categories": {"S": "Sylt och marmelad, Frukost, Pålägg"},
      "ingredients": {"S": "Apelsiner (55%), socker, vatten, citronsaft, pektin, apelsinolja"},
      "allergens": {"S": "Inga kända allergener"},
      "origin": {"S": "Apelsiner från Spanien, tillverkad i Sverige"},
      "packaging": {"S": "Glasburk, återvinningsbar"},
      "storage": {"S": "Förvaras svalt. Efter öppning i kylskåp"},
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
echo "✅ Added: Martins Magnifika Marmelad (1234567890003)"

# Product 4: Karolina's Crispy Cookies
aws dynamodb put-item \
  --table-name "$TABLE_NAME" \
  --region "$REGION" \
  --item '{
    "PK": {"S": "GTIN#1234567890004"},
    "SK": {"S": "BATCH#KARO2024"},
    "GSI1PK": {"S": "PRODUCT"},
    "GSI1SK": {"S": "GTIN#1234567890004#BATCH#KARO2024"},
    "gtin": {"S": "1234567890004"},
    "batch": {"S": "KARO2024"},
    "linkType": {"S": "productInfo"},
    "productData": {"M": {
      "name": {"S": "Karolinas Krispiga Kakor"},
      "description": {"S": "Havrekakor med chokladbitar - Karolinas klassiker!"},
      "weight": {"S": "300 g"},
      "manufacturer": {"S": "Karolina'\''s Kök & Konfektyr AB"},
      "brand": {"S": "Karolina'\''s Crispy"},
      "categories": {"S": "Kex och kakor, Fika, Choklad"},
      "ingredients": {"S": "Havregryn (35%), vetemjöl, smör, socker, chokladbitar (15%), ägg, honung, bakpulver, vanilj, salt"},
      "allergens": {"S": "Havre, vete, mjölk, ägg. Kan innehålla spår av nötter"},
      "origin": {"S": "Sverige"},
      "packaging": {"S": "Påse, återvinningsbar"},
      "storage": {"S": "Förvaras torrt"},
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
echo "✅ Added: Karolinas Krispiga Kakor (1234567890004)"

# Product 5: Mikael's Mighty Meatballs
aws dynamodb put-item \
  --table-name "$TABLE_NAME" \
  --region "$REGION" \
  --item '{
    "PK": {"S": "GTIN#1234567890005"},
    "SK": {"S": "BATCH#MIKE2024"},
    "GSI1PK": {"S": "PRODUCT"},
    "GSI1SK": {"S": "GTIN#1234567890005#BATCH#MIKE2024"},
    "gtin": {"S": "1234567890005"},
    "batch": {"S": "MIKE2024"},
    "linkType": {"S": "productInfo"},
    "productData": {"M": {
      "name": {"S": "Mikaels Mäktiga Köttbullar"},
      "description": {"S": "Saftiga köttbullar av svenskt kött - Mikaels mästerverk!"},
      "weight": {"S": "500 g"},
      "manufacturer": {"S": "Mikael'\''s Kött & Chark AB"},
      "brand": {"S": "Mikael'\''s Mighty"},
      "categories": {"S": "Kött, Köttbullar, Färdigmat, Middag"},
      "ingredients": {"S": "Nötkött (70%), griskött (15%), lök, ströbröd (vete), mjölk, ägg, salt, peppar, kryddor"},
      "allergens": {"S": "Vete, mjölk, ägg"},
      "origin": {"S": "Svenskt kött"},
      "packaging": {"S": "Vakuumförpackning"},
      "storage": {"S": "Förvaras kallt, max +4°C"},
      "certifications": {"S": "Svenskt kött, Från Sverige"},
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
echo "✅ Added: Mikaels Mäktiga Köttbullar (1234567890005)"

# Product 6: Strand's Seaside Salmon
aws dynamodb put-item \
  --table-name "$TABLE_NAME" \
  --region "$REGION" \
  --item '{
    "PK": {"S": "GTIN#1234567890006"},
    "SK": {"S": "BATCH#STRAND2024"},
    "GSI1PK": {"S": "PRODUCT"},
    "GSI1SK": {"S": "GTIN#1234567890006#BATCH#STRAND2024"},
    "gtin": {"S": "1234567890006"},
    "batch": {"S": "STRAND2024"},
    "linkType": {"S": "productInfo"},
    "productData": {"M": {
      "name": {"S": "Strands Strandnära Lax"},
      "description": {"S": "Kallrökt lax från svenska västkusten - direkt från stranden!"},
      "weight": {"S": "200 g"},
      "manufacturer": {"S": "Strand'\''s Seafood AB"},
      "brand": {"S": "Strand'\''s Seaside"},
      "categories": {"S": "Fisk, Rökt fisk, Lax, Delikatesser"},
      "ingredients": {"S": "Lax (97%), salt, röksmak"},
      "allergens": {"S": "Fisk"},
      "origin": {"S": "Lax från svenska västkusten"},
      "packaging": {"S": "Vakuumförpackning"},
      "storage": {"S": "Förvaras kallt, max +4°C"},
      "certifications": {"S": "ASC-certifierad, Svenskt fiske"},
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
echo "✅ Added: Strands Strandnära Lax (1234567890006)"

# Product 7: Höjd's High-Quality Honey
aws dynamodb put-item \
  --table-name "$TABLE_NAME" \
  --region "$REGION" \
  --item '{
    "PK": {"S": "GTIN#1234567890007"},
    "SK": {"S": "BATCH#HOJD2024"},
    "GSI1PK": {"S": "PRODUCT"},
    "GSI1SK": {"S": "GTIN#1234567890007#BATCH#HOJD2024"},
    "gtin": {"S": "1234567890007"},
    "batch": {"S": "HOJD2024"},
    "linkType": {"S": "productInfo"},
    "productData": {"M": {
      "name": {"S": "Höjds Högt Hyllad Honung"},
      "description": {"S": "Ekologisk honung från svenska fjällängar - på hög höjd!"},
      "weight": {"S": "350 g"},
      "manufacturer": {"S": "Höjd'\''s Biodling AB"},
      "brand": {"S": "Höjd'\''s High"},
      "categories": {"S": "Honung, Ekologiskt, Frukost, Pålägg"},
      "ingredients": {"S": "Honung (100%)"},
      "allergens": {"S": "Inga kända allergener"},
      "origin": {"S": "Sverige, Jämtland"},
      "packaging": {"S": "Glasburk, återvinningsbar"},
      "storage": {"S": "Förvaras rumstempererat"},
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
echo "✅ Added: Höjds Högt Hyllad Honung (1234567890007)"

# Product 8: Engström's Energy Drink
aws dynamodb put-item \
  --table-name "$TABLE_NAME" \
  --region "$REGION" \
  --item '{
    "PK": {"S": "GTIN#1234567890008"},
    "SK": {"S": "BATCH#ENG2024"},
    "GSI1PK": {"S": "PRODUCT"},
    "GSI1SK": {"S": "GTIN#1234567890008#BATCH#ENG2024"},
    "gtin": {"S": "1234567890008"},
    "batch": {"S": "ENG2024"},
    "linkType": {"S": "productInfo"},
    "productData": {"M": {
      "name": {"S": "Engströms Energigivande Dryck"},
      "description": {"S": "Naturlig energidryck med guarana - Engströms elixir!"},
      "volume": {"S": "500 ml"},
      "manufacturer": {"S": "Engström'\''s Beverages AB"},
      "brand": {"S": "Engström'\''s Energy"},
      "categories": {"S": "Dryck, Energidryck, Läsk"},
      "ingredients": {"S": "Vatten, socker, kolsyra, guaranaextrakt, koffein, vitaminer (B6, B12), citronsyra, naturlig arom"},
      "allergens": {"S": "Inga kända allergener"},
      "origin": {"S": "Sverige"},
      "packaging": {"S": "Aluminiumburk, återvinningsbar"},
      "storage": {"S": "Förvaras svalt"},
      "certifications": {"S": "Naturliga ingredienser"},
      "nutritionPer100ml": {"M": {
        "energy": {"S": "180 kJ / 43 kcal"},
        "fat": {"S": "0 g"},
        "saturatedFat": {"S": "0 g"},
        "carbohydrates": {"S": "10.5 g"},
        "sugars": {"S": "10.5 g"},
        "fiber": {"S": "0 g"},
        "protein": {"S": "0 g"},
        "salt": {"S": "0.1 g"},
        "caffeine": {"S": "32 mg"}
      }}
    }},
    "updatedAt": {"S": "'$(date -u +%Y-%m-%dT%H:%M:%SZ)'"}
  }'
echo "✅ Added: Engströms Energigivande Dryck (1234567890008)"

# Product 9: Edqvist's Exquisite Espresso
aws dynamodb put-item \
  --table-name "$TABLE_NAME" \
  --region "$REGION" \
  --item '{
    "PK": {"S": "GTIN#1234567890009"},
    "SK": {"S": "BATCH#EDQ2024"},
    "GSI1PK": {"S": "PRODUCT"},
    "GSI1SK": {"S": "GTIN#1234567890009#BATCH#EDQ2024"},
    "gtin": {"S": "1234567890009"},
    "batch": {"S": "EDQ2024"},
    "linkType": {"S": "productInfo"},
    "productData": {"M": {
      "name": {"S": "Edqvists Exklusiva Espresso"},
      "description": {"S": "Mörkrostade kaffebönor från Etiopien - Edqvists elegans!"},
      "weight": {"S": "250 g"},
      "manufacturer": {"S": "Edqvist'\''s Coffee Roasters AB"},
      "brand": {"S": "Edqvist'\''s Exquisite"},
      "categories": {"S": "Kaffe, Espresso, Hela bönor"},
      "ingredients": {"S": "Kaffebönor (100%)"},
      "allergens": {"S": "Inga kända allergener"},
      "origin": {"S": "Etiopien, rostat i Sverige"},
      "packaging": {"S": "Påse med ventil, återvinningsbar"},
      "storage": {"S": "Förvaras svalt och torrt, tätt försluten"},
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
echo "✅ Added: Edqvists Exklusiva Espresso (1234567890009)"

echo ""
echo "✨ Seeding complete! 9 fun products added."
echo ""
echo "Test URLs:"
echo "https://gs1-resolver.engstrom.cloud/01/1234567890001/10/MARIA2024"
echo "https://gs1-resolver.engstrom.cloud/01/1234567890002/10/FRED2024"
echo "https://gs1-resolver.engstrom.cloud/01/1234567890003/10/MART2024"
echo "https://gs1-resolver.engstrom.cloud/01/1234567890004/10/KARO2024"
echo "https://gs1-resolver.engstrom.cloud/01/1234567890005/10/MIKE2024"
echo "https://gs1-resolver.engstrom.cloud/01/1234567890006/10/STRAND2024"
echo "https://gs1-resolver.engstrom.cloud/01/1234567890007/10/HOJD2024"
echo "https://gs1-resolver.engstrom.cloud/01/1234567890008/10/ENG2024"
echo "https://gs1-resolver.engstrom.cloud/01/1234567890009/10/EDQ2024"
