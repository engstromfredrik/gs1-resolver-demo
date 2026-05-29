import { useEffect, useState } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import { resolveProduct } from '../api/resolver';
import { Product } from '../types';

export const ProductResolver = () => {
  const { gtin, batch } = useParams<{ gtin: string; batch: string }>();
  const navigate = useNavigate();
  const [product, setProduct] = useState<Product | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    if (!gtin) {
      navigate('/not-found');
      return;
    }

    resolveProduct(gtin, batch)
      .then((data) => {
        setProduct(data);
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
        <div style={styles.spinner}>
          <div style={styles.spinnerCircle}></div>
          <p style={styles.loadingText}>Loading product...</p>
        </div>
      </div>
    );
  }

  if (!product) return null;

  const pd = product.productData;

  return (
    <div style={styles.container}>
      <div style={styles.card}>
        <div style={styles.header}>
          <div style={styles.badge}>{product.linkType === 'productInfo' ? '📦 Product Info' : '🔗 Marketing'}</div>
          <h1 style={styles.productName}>{pd?.name || 'Product'}</h1>
          <p style={styles.description}>{pd?.description}</p>
        </div>

        <div style={styles.section}>
          <h2 style={styles.sectionTitle}>Identifiers</h2>
          <div style={styles.grid}>
            <div style={styles.infoBox}>
              <span style={styles.label}>GTIN</span>
              <span style={styles.value}>{product.gtin}</span>
            </div>
            <div style={styles.infoBox}>
              <span style={styles.label}>Batch</span>
              <span style={styles.value}>{product.batch}</span>
            </div>
          </div>
        </div>

        {pd?.manufacturer && (
          <div style={styles.section}>
            <h2 style={styles.sectionTitle}>Manufacturer</h2>
            <p style={styles.text}>{pd.manufacturer}</p>
          </div>
        )}

        {pd?.ingredients && (
          <div style={styles.section}>
            <h2 style={styles.sectionTitle}>Ingredients</h2>
            <p style={styles.text}>{pd.ingredients}</p>
          </div>
        )}

        {pd?.allergens && (
          <div style={styles.section}>
            <h2 style={styles.sectionTitle}>⚠️ Allergens</h2>
            <div style={styles.allergenBox}>
              <p style={styles.allergenText}>{pd.allergens}</p>
            </div>
          </div>
        )}

        {pd?.nutritionPer100g && (
          <div style={styles.section}>
            <h2 style={styles.sectionTitle}>Nutrition Facts (per 100g/100ml)</h2>
            <div style={styles.nutritionGrid}>
              {Object.entries(pd.nutritionPer100g).map(([key, value]) => (
                <div key={key} style={styles.nutritionItem}>
                  <span style={styles.nutritionLabel}>{key.replace(/([A-Z])/g, ' $1').trim()}</span>
                  <span style={styles.nutritionValue}>{String(value)}</span>
                </div>
              ))}
            </div>
          </div>
        )}

        <div style={styles.section}>
          <h2 style={styles.sectionTitle}>Product Details</h2>
          <div style={styles.detailsGrid}>
            {pd?.weight && <div style={styles.detail}><strong>Weight:</strong> {pd.weight}</div>}
            {pd?.volume && <div style={styles.detail}><strong>Volume:</strong> {pd.volume}</div>}
            {pd?.brand && <div style={styles.detail}><strong>Brand:</strong> {pd.brand}</div>}
            {pd?.origin && <div style={styles.detail}><strong>Origin:</strong> {pd.origin}</div>}
            {pd?.packaging && <div style={styles.detail}><strong>Packaging:</strong> {pd.packaging}</div>}
            {pd?.storage && <div style={styles.detail}><strong>Storage:</strong> {pd.storage}</div>}
            {pd?.nutriScore && <div style={styles.detail}><strong>Nutri-Score:</strong> <span style={styles.nutriScore}>{pd.nutriScore}</span></div>}
          </div>
        </div>

        {pd?.categories && (
          <div style={styles.section}>
            <h2 style={styles.sectionTitle}>Categories</h2>
            <div style={styles.tags}>
              {pd.categories.split(',').map((cat: string, i: number) => (
                <span key={i} style={styles.tag}>{cat.trim()}</span>
              ))}
            </div>
          </div>
        )}

        {product.targetUrl && (
          <div style={styles.section}>
            <a href={product.targetUrl} style={styles.button} target="_blank" rel="noopener noreferrer">
              Visit Product Page →
            </a>
          </div>
        )}

        <div style={styles.footer}>
          <p style={styles.footerText}>Last updated: {new Date(product.updatedAt).toLocaleDateString()}</p>
        </div>
      </div>
    </div>
  );
};

const styles: Record<string, React.CSSProperties> = {
  container: {
    minHeight: '100vh',
    background: '#0C1122',
    padding: '20px 10px',
    fontFamily: '-apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif',
  },
  card: {
    backgroundColor: '#FFFFFF',
    borderRadius: '8px',
    boxShadow: '0 2px 12px rgba(0,0,0,0.3)',
    padding: '0',
    maxWidth: '800px',
    margin: '0 auto',
    overflow: 'hidden',
  },
  header: {
    background: '#3B507D',
    color: '#FFFFFF',
    padding: '24px',
    textAlign: 'center',
  },
  badge: {
    display: 'inline-block',
    backgroundColor: 'rgba(255,255,255,0.2)',
    padding: '4px 12px',
    borderRadius: '12px',
    fontSize: '12px',
    marginBottom: '8px',
  },
  productName: {
    fontSize: '24px',
    fontWeight: 'bold',
    margin: '0 0 8px 0',
  },
  description: {
    fontSize: '14px',
    margin: '0',
    opacity: 0.9,
  },
  section: {
    padding: '20px 24px',
    borderBottom: '1px solid #f0f0f0',
  },
  sectionTitle: {
    fontSize: '16px',
    fontWeight: '600',
    color: '#3B507D',
    marginBottom: '12px',
    marginTop: '0',
  },
  grid: {
    display: 'grid',
    gridTemplateColumns: 'repeat(auto-fit, minmax(150px, 1fr))',
    gap: '12px',
  },
  infoBox: {
    backgroundColor: '#f8f9fa',
    padding: '12px',
    borderRadius: '4px',
    display: 'flex',
    flexDirection: 'column',
    gap: '4px',
  },
  label: {
    fontSize: '11px',
    color: '#666',
    textTransform: 'uppercase',
    fontWeight: '600',
    letterSpacing: '0.5px',
  },
  value: {
    fontSize: '16px',
    color: '#0C1122',
    fontWeight: '600',
    fontFamily: 'monospace',
  },
  text: {
    fontSize: '14px',
    color: '#555',
    lineHeight: '1.5',
    margin: '0',
  },
  allergenBox: {
    backgroundColor: '#fff3cd',
    border: '2px solid #ffc107',
    borderRadius: '4px',
    padding: '12px',
  },
  allergenText: {
    color: '#856404',
    margin: '0',
    fontWeight: '500',
    fontSize: '14px',
  },
  nutritionGrid: {
    display: 'grid',
    gridTemplateColumns: 'repeat(auto-fill, minmax(140px, 1fr))',
    gap: '8px',
  },
  nutritionItem: {
    display: 'flex',
    justifyContent: 'space-between',
    padding: '8px',
    backgroundColor: '#f8f9fa',
    borderRadius: '4px',
    fontSize: '13px',
  },
  nutritionLabel: {
    color: '#333',
    textTransform: 'capitalize',
    fontSize: '12px',
  },
  nutritionValue: {
    fontWeight: '600',
    color: '#3B507D',
    fontSize: '12px',
  },
  detailsGrid: {
    display: 'grid',
    gridTemplateColumns: 'repeat(auto-fit, minmax(200px, 1fr))',
    gap: '8px',
  },
  detail: {
    fontSize: '14px',
    color: '#555',
    padding: '4px 0',
  },
  nutriScore: {
    display: 'inline-block',
    backgroundColor: '#3B507D',
    color: '#FFFFFF',
    padding: '2px 8px',
    borderRadius: '4px',
    fontWeight: 'bold',
    fontSize: '12px',
  },
  tags: {
    display: 'flex',
    flexWrap: 'wrap',
    gap: '6px',
  },
  tag: {
    backgroundColor: '#f8f9fa',
    color: '#3B507D',
    padding: '4px 10px',
    borderRadius: '4px',
    fontSize: '12px',
    fontWeight: '500',
  },
  button: {
    display: 'inline-block',
    backgroundColor: '#3B507D',
    color: '#FFFFFF',
    padding: '12px 24px',
    borderRadius: '4px',
    textDecoration: 'none',
    fontSize: '14px',
    fontWeight: '600',
    transition: 'background-color 0.2s',
    border: 'none',
    cursor: 'pointer',
  },
  footer: {
    padding: '12px 24px',
    backgroundColor: '#f8f9fa',
    textAlign: 'center',
  },
  footerText: {
    fontSize: '12px',
    color: '#999',
    margin: '0',
  },
  spinner: {
    textAlign: 'center',
    padding: '40px 20px',
  },
  spinnerCircle: {
    width: '40px',
    height: '40px',
    border: '3px solid rgba(255,255,255,0.3)',
    borderTop: '3px solid white',
    borderRadius: '50%',
    margin: '0 auto 16px',
    animation: 'spin 1s linear infinite',
  },
  loadingText: {
    color: 'white',
    fontSize: '16px',
    margin: '0',
  },
};
