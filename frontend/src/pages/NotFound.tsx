import { useLocation, useNavigate } from 'react-router-dom';
import { useState } from 'react';

export const NotFound = () => {
  const location = useLocation();
  const navigate = useNavigate();
  const state = location.state as { gtin?: string; batch?: string } | null;
  
  const [gtin, setGtin] = useState('');
  const [batch, setBatch] = useState('');

  const handleSearch = (e: React.FormEvent) => {
    e.preventDefault();
    if (gtin.trim()) {
      if (batch.trim()) {
        navigate(`/01/${gtin.trim()}/10/${batch.trim()}`);
      } else {
        navigate(`/01/${gtin.trim()}`);
      }
    }
  };

  return (
    <div style={styles.container}>
      <div style={styles.card}>
        <div style={styles.iconContainer}>
          <span style={styles.icon}>📦</span>
        </div>
        
        <h1 style={styles.title}>Product Not Found</h1>
        
        <p style={styles.message}>
          We couldn't find the product you're looking for in our database.
        </p>

        {state?.gtin && state?.batch && (
          <div style={styles.details}>
            <p><strong>GTIN:</strong> {state.gtin}</p>
            <p><strong>Batch:</strong> {state.batch}</p>
          </div>
        )}

        <div style={styles.searchSection}>
          <h2 style={styles.searchTitle}>Try Another Product</h2>
          <form onSubmit={handleSearch} style={styles.form}>
            <div style={styles.inputGroup}>
              <label style={styles.label}>GTIN</label>
              <input
                type="text"
                value={gtin}
                onChange={(e) => setGtin(e.target.value)}
                placeholder="Enter GTIN (e.g., 1234567890001)"
                style={styles.input}
                required
              />
            </div>
            <div style={styles.inputGroup}>
              <label style={styles.label}>Batch (optional)</label>
              <input
                type="text"
                value={batch}
                onChange={(e) => setBatch(e.target.value)}
                placeholder="Leave empty for any batch"
                style={styles.input}
              />
            </div>
            <button type="submit" style={styles.button}>
              Search Product
            </button>
          </form>
        </div>
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
    backgroundColor: '#0C1122',
    padding: '20px',
  },
  card: {
    backgroundColor: 'white',
    borderRadius: '12px',
    boxShadow: '0 4px 12px rgba(0,0,0,0.3)',
    padding: '40px',
    maxWidth: '500px',
    width: '100%',
    textAlign: 'center',
  },
  iconContainer: {
    marginBottom: '20px',
  },
  icon: {
    fontSize: '64px',
  },
  title: {
    fontSize: '28px',
    marginBottom: '20px',
    color: '#0C1122',
  },
  message: {
    fontSize: '16px',
    color: '#666',
    marginBottom: '20px',
    lineHeight: '1.5',
  },
  details: {
    backgroundColor: '#f8f9fa',
    padding: '15px',
    borderRadius: '8px',
    marginBottom: '20px',
    textAlign: 'left',
  },
  searchSection: {
    marginTop: '30px',
    paddingTop: '30px',
    borderTop: '2px solid #e0e0e0',
  },
  searchTitle: {
    fontSize: '20px',
    color: '#3B507D',
    marginBottom: '20px',
  },
  form: {
    display: 'flex',
    flexDirection: 'column',
    gap: '15px',
  },
  inputGroup: {
    display: 'flex',
    flexDirection: 'column',
    alignItems: 'flex-start',
    textAlign: 'left',
  },
  label: {
    fontSize: '14px',
    fontWeight: '600',
    color: '#0C1122',
    marginBottom: '5px',
  },
  input: {
    width: '100%',
    padding: '12px',
    fontSize: '16px',
    border: '2px solid #e0e0e0',
    borderRadius: '8px',
    outline: 'none',
    transition: 'border-color 0.2s',
    boxSizing: 'border-box',
  },
  button: {
    backgroundColor: '#3B507D',
    color: 'white',
    padding: '14px 24px',
    fontSize: '16px',
    fontWeight: '600',
    border: 'none',
    borderRadius: '8px',
    cursor: 'pointer',
    transition: 'background-color 0.2s',
    marginTop: '10px',
  },
};
