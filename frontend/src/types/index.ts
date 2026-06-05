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
  gtin: string;
  batch: string;
  linkType: string;
  targetUrl?: string;
  productData?: ProductData;
  expiryDate?: string;
  updatedAt: string;
}
