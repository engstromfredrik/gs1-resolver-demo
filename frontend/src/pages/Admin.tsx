import { useEffect, useState } from 'react';
import { signIn, signOut, getCurrentSession } from '../api/auth';
import { listProducts, createProduct, deleteProduct } from '../api/resolver';
import { Product } from '../types';

export const Admin = () => {
  const [token, setToken] = useState<string | null>(null);
  const [username, setUsername] = useState('');
  const [password, setPassword] = useState('');
  const [products, setProducts] = useState<Product[]>([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [showForm, setShowForm] = useState(false);
  
  // Form state
  const [formData, setFormData] = useState({
    gtin: '',
    batch: '',
    linkType: 'productInfo',
    targetUrl: '',
    productName: '',
    productDescription: '',
  });

  useEffect(() => {
    getCurrentSession().then(setToken);
  }, []);

  useEffect(() => {
    if (token) {
      loadProducts();
    }
  }, [token]);

  const handleSignIn = async (e: React.FormEvent) => {
    e.preventDefault();
    setError(null);
    setLoading(true);
    
    try {
      const newToken = await signIn(username, password);
      setToken(newToken);
    } catch (err: any) {
      setError(err.message || 'Failed to sign in');
    } finally {
      setLoading(false);
    }
  };

  const handleSignOut = async () => {
    await signOut();
    setToken(null);
    setProducts([]);
  };

  const loadProducts = async () => {
    if (!token) return;
    
    setLoading(true);
    try {
      const data = await listProducts(token);
      setProducts(data);
    } catch (err: any) {
      setError(err.message);
    } finally {
      setLoading(false);
    }
  };

  const handleCreateProduct = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!token) return;
    
    setLoading(true);
    setError(null);
    
    try {
      await createProduct(token, {
        gtin: formData.gtin,
        batch: formData.batch,
        linkType: formData.linkType,
        targetUrl: formData.linkType === 'marketing' ? formData.targetUrl : undefined,
        productData: formData.linkType === 'productInfo' ? {
          name: formData.productName,
          description: formData.productDescription,
        } : undefined,
      });
      
      setShowForm(false);
      setFormData({
        gtin: '',
        batch: '',
        linkType: 'productInfo',
        targetUrl: '',
        productName: '',
        productDescription: '',
      });
      
      await loadProducts();
    } catch (err: any) {
      setError(err.message);
    } finally {
      setLoading(false);
    }
  };

  const handleDelete = async (gtin: string, batch: string) => {
    if (!token || !confirm('Are you sure you want to delete this product?')) return;
    
    setLoading(true);
    try {
      await deleteProduct(token, gtin, batch);
      await loadProducts();
    } catch (err: any) {
      setError(err.message);
    } finally {
      setLoading(false);
    }
  };

  if (!token) {
    return (
      <div style={styles.container}>
        <div style={styles.card}>
          <h1 style={styles.title}>Admin Login</h1>
          
          <form onSubmit={handleSignIn} style={styles.form}>
            <input
              type="text"
              placeholder="Username"
              value={username}
              onChange={(e) => setUsername(e.target.value)}
              style={styles.input}
              required
            />
            
            <input
              type="password"
              placeholder="Password"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              style={styles.input}
              required
            />
            
            {error && <p style={styles.error}>{error}</p>}
            
            <button type="submit" style={styles.button} disabled={loading}>
              {loading ? 'Signing in...' : 'Sign In'}
            </button>
          </form>
        </div>
      </div>
    );
  }

  return (
    <div style={styles.container}>
      <div style={styles.adminCard}>
        <div style={styles.header}>
          <h1 style={styles.title}>Product Administration</h1>
          <button onClick={handleSignOut} style={styles.signOutButton}>
            Sign Out
          </button>
        </div>

        {error && <p style={styles.error}>{error}</p>}

        <div style={styles.actions}>
          <button onClick={() => setShowForm(!showForm)} style={styles.button}>
            {showForm ? 'Cancel' : '+ Add Product'}
          </button>
        </div>

        {showForm && (
          <form onSubmit={handleCreateProduct} style={styles.form}>
            <input
              type="text"
              placeholder="GTIN"
              value={formData.gtin}
              onChange={(e) => setFormData({ ...formData, gtin: e.target.value })}
              style={styles.input}
              required
            />
            
            <input
              type="text"
              placeholder="Batch"
              value={formData.batch}
              onChange={(e) => setFormData({ ...formData, batch: e.target.value })}
              style={styles.input}
              required
            />
            
            <select
              value={formData.linkType}
              onChange={(e) => setFormData({ ...formData, linkType: e.target.value })}
              style={styles.input}
            >
              <option value="productInfo">Product Info</option>
              <option value="marketing">Marketing Link</option>
            </select>

            {formData.linkType === 'marketing' && (
              <input
                type="url"
                placeholder="Target URL"
                value={formData.targetUrl}
                onChange={(e) => setFormData({ ...formData, targetUrl: e.target.value })}
                style={styles.input}
                required
              />
            )}

            {formData.linkType === 'productInfo' && (
              <>
                <input
                  type="text"
                  placeholder="Product Name"
                  value={formData.productName}
                  onChange={(e) => setFormData({ ...formData, productName: e.target.value })}
                  style={styles.input}
                />
                
                <textarea
                  placeholder="Product Description"
                  value={formData.productDescription}
                  onChange={(e) => setFormData({ ...formData, productDescription: e.target.value })}
                  style={{ ...styles.input, minHeight: '80px' }}
                />
              </>
            )}
            
            <button type="submit" style={styles.button} disabled={loading}>
              {loading ? 'Creating...' : 'Create Product'}
            </button>
          </form>
        )}

        <div style={styles.productList}>
          <h2 style={styles.subtitle}>Products</h2>
          
          {loading && <p>Loading...</p>}
          
          {products.length === 0 && !loading && (
            <p style={styles.emptyState}>No products yet. Add your first product above.</p>
          )}
          
          {products.map((product) => (
            <div key={`${product.gtin}-${product.batch}`} style={styles.productItem}>
              <div>
                <p><strong>GTIN:</strong> {product.gtin}</p>
                <p><strong>Batch:</strong> {product.batch}</p>
                <p><strong>Type:</strong> {product.linkType}</p>
              </div>
              <button
                onClick={() => handleDelete(product.gtin, product.batch)}
                style={styles.deleteButton}
              >
                Delete
              </button>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
};

const styles: Record<string, React.CSSProperties> = {
  container: {
    minHeight: '100vh',
    backgroundColor: '#f5f5f5',
    padding: '20px',
  },
  card: {
    backgroundColor: 'white',
    borderRadius: '8px',
    boxShadow: '0 2px 8px rgba(0,0,0,0.1)',
    padding: '40px',
    maxWidth: '400px',
    margin: '100px auto',
  },
  adminCard: {
    backgroundColor: 'white',
    borderRadius: '8px',
    boxShadow: '0 2px 8px rgba(0,0,0,0.1)',
    padding: '40px',
    maxWidth: '800px',
    margin: '0 auto',
  },
  header: {
    display: 'flex',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: '30px',
  },
  title: {
    fontSize: '28px',
    color: '#333',
    margin: 0,
  },
  subtitle: {
    fontSize: '20px',
    color: '#555',
    marginBottom: '20px',
  },
  form: {
    display: 'flex',
    flexDirection: 'column',
    gap: '15px',
    marginBottom: '30px',
  },
  input: {
    padding: '12px',
    fontSize: '16px',
    border: '1px solid #ddd',
    borderRadius: '4px',
  },
  button: {
    padding: '12px 24px',
    fontSize: '16px',
    backgroundColor: '#007bff',
    color: 'white',
    border: 'none',
    borderRadius: '4px',
    cursor: 'pointer',
  },
  signOutButton: {
    padding: '8px 16px',
    fontSize: '14px',
    backgroundColor: '#6c757d',
    color: 'white',
    border: 'none',
    borderRadius: '4px',
    cursor: 'pointer',
  },
  deleteButton: {
    padding: '8px 16px',
    fontSize: '14px',
    backgroundColor: '#dc3545',
    color: 'white',
    border: 'none',
    borderRadius: '4px',
    cursor: 'pointer',
  },
  error: {
    color: '#dc3545',
    marginBottom: '15px',
  },
  actions: {
    marginBottom: '20px',
  },
  productList: {
    marginTop: '30px',
  },
  productItem: {
    display: 'flex',
    justifyContent: 'space-between',
    alignItems: 'center',
    padding: '15px',
    backgroundColor: '#f8f9fa',
    borderRadius: '4px',
    marginBottom: '10px',
  },
  emptyState: {
    color: '#999',
    textAlign: 'center',
    padding: '40px',
  },
};
