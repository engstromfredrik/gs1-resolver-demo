import { Product } from '../types';

let config: any = null;

export const loadConfig = async () => {
  if (!config) {
    const response = await fetch('/config.json');
    config = await response.json();
  }
  return config;
};

export const resolveProduct = async (gtin: string, batch?: string): Promise<Product> => {
  const cfg = await loadConfig();
  const url = batch 
    ? `${cfg.apiUrl}01/${gtin}/10/${batch}`
    : `${cfg.apiUrl}01/${gtin}`;
  const response = await fetch(url);
  
  if (!response.ok) {
    throw new Error('Product not found');
  }
  
  return response.json();
};

export const listProducts = async (token: string): Promise<Product[]> => {
  const cfg = await loadConfig();
  const response = await fetch(`${cfg.apiUrl}admin/products`, {
    headers: {
      Authorization: `Bearer ${token}`,
    },
  });
  
  if (!response.ok) {
    throw new Error('Failed to fetch products');
  }
  
  const data = await response.json();
  return data.items;
};

export const createProduct = async (token: string, product: Partial<Product>): Promise<Product> => {
  const cfg = await loadConfig();
  const response = await fetch(`${cfg.apiUrl}admin/products`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      Authorization: `Bearer ${token}`,
    },
    body: JSON.stringify(product),
  });
  
  if (!response.ok) {
    throw new Error('Failed to create product');
  }
  
  return response.json();
};

export const deleteProduct = async (token: string, gtin: string, batch: string): Promise<void> => {
  const cfg = await loadConfig();
  const response = await fetch(`${cfg.apiUrl}admin/products/${gtin}/${batch}`, {
    method: 'DELETE',
    headers: {
      Authorization: `Bearer ${token}`,
    },
  });
  
  if (!response.ok) {
    throw new Error('Failed to delete product');
  }
};
