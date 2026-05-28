import { useLocation } from 'react-router-dom';

export const NotFound = () => {
  const location = useLocation();
  const state = location.state as { gtin?: string; batch?: string } | null;

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

        <p style={styles.help}>
          Please check the code and try again, or contact support if you believe this is an error.
        </p>
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
    color: '#333',
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
    borderRadius: '4px',
    marginBottom: '20px',
    textAlign: 'left',
  },
  help: {
    fontSize: '14px',
    color: '#999',
  },
};
