export interface Config {
  apiUrl: string;
  userPoolId: string;
  userPoolClientId: string;
  region: string;
}

export interface ProductData {
  name?: string;
  description?: string;
  bestBeforeDate?: string;
  manufacturer?: string;
  [key: string]: any;
}

export interface Product {
  PK: string;
  SK: string;
  gtin: string;
  batch: string;
  linkType: string;
  targetUrl?: string;
  productData?: ProductData;
  updatedAt: string;
}
