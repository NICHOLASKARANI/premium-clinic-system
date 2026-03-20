export default function Home() {
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
          <li style={{ margin: '10px 0' }}>⏳ Backend: Pending deployment</li>
          <li style={{ margin: '10px 0' }}>⏳ Database: Pending setup</li>
        </ul>
      </div>
      
      <p style={{ marginTop: '30px', color: '#6b7280' }}>
        Backend URL will be added once deployed.
      </p>
    </div>
  );
}
