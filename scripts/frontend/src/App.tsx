import { Card } from 'react-bootstrap';
import './App.css';
import 'bootstrap/dist/css/bootstrap.min.css';

import Login from './pages/login';
import Personagem from './pages/perso';
import { useState, useEffect } from 'react';
import { motion, AnimatePresence } from 'framer-motion';

function App() {
  const [logado, setLogado] = useState(false);

  useEffect(() => {
    const userId = localStorage.getItem('userId');
    if (userId) {
      setLogado(true);
    }
  }, []);

  return (
    <div className="d-flex justify-content-center align-items-center w-100 h-100">
      <AnimatePresence mode="wait">
        <motion.div
          key={logado ? 'personagem' : 'login'}
          initial={{ opacity: 0, scale: 0.9 }}
          animate={{ opacity: 1, scale: 1 }}
          exit={{ opacity: 0, scale: 0.9 }}
          transition={{ duration: 0.5 }}
        >
          <Card style={{ borderRadius: '25px' }}>
            {logado ? (
              <Personagem />
            ) : (
              <Login onLogin={() => setLogado(true)} />
            )}
          </Card>
        </motion.div>
      </AnimatePresence>
    </div>
  );
}

export default App;
