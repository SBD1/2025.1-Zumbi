import React, { useState } from 'react';
import { Card, FormGroup, Form, Button, Alert } from 'react-bootstrap';

const Login = ({ onLogin }: { onLogin: () => void }) => {
    const [email, setEmail] = useState('');
    const [senha, setSenha] = useState('');
    const [errorMessage, setErrorMessage] = useState('');

    const handleSubmit = async (e: React.FormEvent) => {
        e.preventDefault();

        try {
            const response = await fetch('http://localhost:3000/login', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({ email, senha })
            });

            const data = await response.json();

            if (response.ok) {
                localStorage.setItem('userId', data.conta.idconta);
                setErrorMessage('');
                onLogin();
            } else {
                setErrorMessage(data.error || 'Erro ao fazer login.');
            }
        } catch (error) {
            console.error('Erro:', error);
            setErrorMessage('Erro de conexão com o servidor.');
        }
    };

    return (
        <Card.Body>
            <Card.Title className="text-center">LOGIN</Card.Title>
            <Form className='m-auto p-5' onSubmit={handleSubmit}>
                <FormGroup className="mb-3">
                    <Form.Label>Email</Form.Label>
                    <Form.Control
                        type="email"
                        placeholder="Digite seu email"
                        value={email}
                        onChange={(e) => setEmail(e.target.value)}
                        required
                    />
                </FormGroup>

                <FormGroup className="mb-3">
                    <Form.Label>Senha</Form.Label>
                    <Form.Control
                        type="password"
                        placeholder="Digite sua senha"
                        value={senha}
                        onChange={(e) => setSenha(e.target.value)}
                        required
                    />
                </FormGroup>

                <Button variant="primary" type="submit" className="w-100">
                    Entrar
                </Button>

                {errorMessage && (
                    <Alert variant="danger" className="mt-3">
                        {errorMessage}
                    </Alert>
                )}
            </Form>
        </Card.Body>
    );
};

export default Login;
