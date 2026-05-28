import { useEffect, useState } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import { resolveProduct } from '../api/resolver';
import { Product } from '../types';

export const ProductResolver = () => {
  const { gtin, batch } = useParams<{ gtin: string; batch: string }>();
  const navigate = useNavigate();
  const [product, setProduct] = useState<Product | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    if (!gtin || !batch) {
      setError('Invalid URL');
      setLoading(false);
      return;
    }

    resolveProduct(gtin, batch)
      .then((data) => {
        setProduct(data);
        
        // If linkType is marketing and targetUrl exists, redirect
        if (data.linkType === 'marketing' && data.targetUrl) {
          window.location.href = data.targetUrl;
        }
      })
      .catch(() => {
        navigate('/not-found', { state: { gtin, batch } });
      })
      .finally(() => setLoading(false));
  }, [gtin, batch, navigate]);

  if (loading) {
    return (
      <div style={styles.container}>
        <div style={styles.spinner}>Loading...</div>
      </div>
    );
  }

  if (error || !product) {
    return null;
  }

  return (
    <div style={styles.container}>
      <div style={styles.card}>
        <h1 style={styles.title}>Product Information</h1>
        
        <div style={styles.section}>
          <h2 style={styles.subtitle}>Identifiers</h2>
          <p><strong>GTIN:</strong> {product.gtin}</p>
          <p><strong>Batch:</strong> {product.batch}</p>
          <p><strong>Link Type:</strong> {product.linkType}</p>
        </div>

        {product.productData && (
          <div style={styles.section}>
            <h2 style={styles.subtitle}>Product Details</h2>
            {product.productData.name && <p><strong>Name:</strong> {product.productData.name}</p>}
            {product.productData.description && <p><strong>Description:</strong> {product.productData.description}</p>}
            {product.productData.manufacturer && <p><strong>Manufacturer:</strong> {product.productData.manufacturer}</p>}
            {product.productData.bestBeforeDate && <p><strong>Best Before:</strong> {product.productData.bestBeforeDate}</p>}
          </div>
        )}

        {product.targetUrl && (
          <div style={styles.section}>
            <a href={product.targetUrl} style={styles.link} target="_blank" rel="noopener noreferrer">
              Visit Product Page →
            </a>
          </div>
        )}
      </div>
    </div>
  );
};

const styles: Record<string, React.CSSProperties> = {
  container: {
    minHeight: '100vh',
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'center',
    backgroundColor: '#f5f5f5',
    padding: '20px',
  },
  card: {
    backgroundColor: 'white',
    borderRadius: '8px',
    boxShadow: '0 2px 8px rgba(0,0,0,0.1)',
    padding: '40px',
    maxWidth: '600px',
    width: '100%',
  },
  title: {
    fontSize: '28px',
    marginBottom: '30px',
    color: '#333',
  },
  subtitle: {
    fontSize: '20px',
    marginBottom: '15px',
    color: '#555',
  },
  section: {
    marginBottom: '30px',
  },
  spinner: {
    fontSize: '20px',
    color: '#666',
  },
  link: {
    display: 'inline-block',
    padding: '12px 24px',
    backgroundColor: '#007bff',
    color: 'white',
    textDecoration: 'none',
    borderRadius: '4px',
    fontSize: '16px',
  },
};
