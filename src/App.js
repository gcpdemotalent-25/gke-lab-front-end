import React, { useState, useEffect } from 'react';
import logo from './logo.svg';
import './App.css';

function App() {
  const [message, setMessage] = useState('Chargement du message depuis le backend...');

  useEffect(() => {
    // En prod, l'URL est relative. Le proxy Nginx redirigera vers le service backend.
    // Pour le dev local, on peut utiliser un proxy dans package.json
    fetch('/api/hello') 
      .then(response => response.json())
      .then(data => setMessage(data.message))
      .catch(error => {
        console.error("Erreur lors de la récupération des données:", error);
        setMessage("Impossible de joindre le backend. Tourne-t-il sur le port 8080?");
      });
  }, []);

  return (
    <div className="App">
      <header className="App-header">
        <img src={logo} className="App-logo" alt="logo" />
        <h1>Bienvenue sur notre Lab GKE</h1>
        <p style={{
          marginTop: '40px',
          padding: '20px',
          border: '2px dashed #61dafb',
          borderRadius: '10px'
        }}>
          {message}
        </p>
      </header>
    </div>
  );
}

export default App;