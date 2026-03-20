import React from 'react';

export default function Home() {
  const [backendStatus, setBackendStatus] = React.useState('Checking...');
  const [backendData, setBackendData] = React.useState(null);

  React.useEffect(() => {
    fetch(process.env.NEXT_PUBLIC_API_URL + '/health')
      .then(res => res.json())
      .then(data => {
        setBackendStatus('Connected');
        setBackendData(data);
      })
      .catch(err => {
        setBackendStatus('Error connecting');
        console.error(err);
      });
  }, []);

  return (
    <div style={{
      padding: '40px',
      fontFamily: 'Arial, sans-serif',
      maxWidth: '800px',
      margin: '0 auto'
    }}>
      <h1 style={{ color: '#2563eb' }}>🏥 Premium Clinic Management System</h1>
      <p style={{ fontSize: '18px', marginBottom: '20px' }}>
        Welcome to your clinic management system. The frontend is successfully deployed!
      </p>

      <div style={{
        backgroundColor: '#f3f4f6',
        padding: '20px',
        borderRadius: '8px',
        marginTop: '20px'
      }}>
        <h2>System Status:</h2>
        <ul style={{ listStyle: 'none', padding: 0 }}>
          <li style={{ margin: '10px 0' }}>✅ Frontend: Running</li>
          <li style={{ margin: '10px 0' }}>🔄 Backend: {backendStatus}</li>
          <li style={{ margin: '10px 0' }}>⏳ Database: Pending setup</li>
        </ul>
        {backendData && (
          <div style={{ marginTop: '15px', padding: '10px', backgroundColor: '#e5e7eb', borderRadius: '4px' }}>
            <strong>Backend Response:</strong>
            <pre style={{ marginTop: '5px', overflow: 'auto' }}>
              {JSON.stringify(backendData, null, 2)}
            </pre>
          </div>
        )}
      </div>

      <p style={{ marginTop: '30px', color: '#6b7280' }}>
        Backend URL: {process.env.NEXT_PUBLIC_API_URL}
      </p>
    </div>
  );
}
