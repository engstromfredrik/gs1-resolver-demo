# All Products (15 total)

## Marketing Redirect

| GTIN | Product | Call |
|------|---------|------|
| 07311043015702 | FIXA BATTERIER 8st LR03 | Redirects to axfood.se |

```
https://gs1-resolver.engstrom.cloud/01/07311043015702?linkType=marketing
```

---

## Fun Products (gs1:productInfo)

| # | GTIN | Batch | Product |
|---|------|-------|---------|
| 1 | 1234567890001 | MARIA2024 | Marias Magiska Muffins |
| 2 | 1234567890002 | FRED2024 | Fredriks Fantastiska Fiskpinnar |
| 3 | 1234567890003 | MART2024 | Martins Magnifika Marmelad |
| 4 | 1234567890004 | KARO2024 | Karolinas Krispiga Kakor |
| 5 | 1234567890005 | MIKE2024 | Mikaels Maktiga Kottbullar |
| 6 | 1234567890006 | STRAND2024 | Strands Strandnara Lax |
| 7 | 1234567890007 | HOJD2024 | Hojds Hogt Hyllad Honung |
| 8 | 1234567890008 | ENG2024 | Engstroms Energigivande Dryck |
| 9 | 1234567890009 | EDQ2024 | Edqvists Exklusiva Espresso |

## Original Grocery Products (productInfo)

| # | GTIN | Batch | Product |
|---|------|-------|---------|
| 10 | 7340083407338 | BATCH001 | Eldorado Vispgrädde 36% |
| 11 | 7340083422010 | BATCH001 | Eldorado Havregryn |
| 12 | 7340083438158 | BATCH001 | Garant Krossade Tomater |
| 13 | 7340083450419 | BATCH001 | Garant Pannkakor |
| 14 | 7340083482397 | BATCH001 | Garant Svensk Lantmjölk 1,5% |

---

## URL Call Variants

**Basic (GTIN only, defaults to gs1:productInfo):**

```
https://gs1-resolver.engstrom.cloud/01/1234567890001
```

**With batch:**

```
https://gs1-resolver.engstrom.cloud/01/1234567890001/10/MARIA2024
```

**With expiry date (15=YYMMDD):**

```
https://gs1-resolver.engstrom.cloud/01/1234567890001/10/MARIA2024?15=260930
```

**With explicit linkType:**

```
https://gs1-resolver.engstrom.cloud/01/1234567890001/10/MARIA2024?linkType=gs1:productInfo
```

**Full GS1 Digital Link (all params):**

```
https://gs1-resolver.engstrom.cloud/01/1234567890001/10/MARIA2024?15=260930&linkType=gs1:productInfo
```

**Marketing redirect:**

```
https://gs1-resolver.engstrom.cloud/01/07311043015702?linkType=marketing
```

> **Note:** The 5 original grocery products use `linkType: "productInfo"` (without `gs1:` prefix) from the migration. They'll need the linkType query param `?linkType=productInfo` or a data update to add the `gs1:` prefix.
