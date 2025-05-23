import { useEffect, useState } from "react";
import { Button, CardBody, ListGroup } from "react-bootstrap";

const Personagens = () => {
    const [personagens, setPersonagens] = useState<any[]>([]);
    const [loading, setLoading] = useState(true);
    const [selectedId, setSelectedId] = useState<number | null>(() => {
        const savedId = localStorage.getItem('selectedCharacterId');
        return savedId ? Number(savedId) : null;
    });

    useEffect(() => {
        const userId = localStorage.getItem('userId');

        if (userId) {
            fetch(`http://localhost:3000/personagens/${userId}`)
                .then(response => response.json())
                .then(data => {
                    setPersonagens(data);
                    setLoading(false);
                })
                .catch(err => {
                    console.error('Erro ao buscar personagens:', err);
                    setLoading(false);
                });
        }
    }, []);

    const handleSelect = (id: number) => {
        setSelectedId(id);
        localStorage.setItem('selectedCharacterId', id.toString());
    };

    if (loading) {
        return <CardBody>Carregando...</CardBody>;
    }

    return (
        <CardBody>
            <h3 className="text-center mb-3">Seus Personagens</h3>
            <h5 className="text-center mb-3">Escolha seu Personagem</h5>
            {personagens.length === 0 ? (
                <p className="text-center">Nenhum personagem encontrado.</p>
            ) : (

                <ListGroup>
                    {personagens.map((personagem: any) => (
                        <ListGroup.Item
                            key={personagem.idpersonagem}
                            action
                            active={selectedId === personagem.idpersonagem}
                            onClick={() => handleSelect(personagem.idpersonagem)}
                            style={{ cursor: 'pointer' }}

                        >
                            <strong>{personagem.nome}</strong> - {personagem.classe} (Nível {personagem.nivel})
                        </ListGroup.Item>
                    ))}
                </ListGroup>
            )}
            <div style={{ marginTop: '20px', display: 'flex', gap: '10px', justifyContent: 'center' }}>
                <Button variant="primary" onClick={() => alert('Criar novo personagem')}>
                    Criar+
                </Button>

                <Button variant="success" onClick={() => alert('Iniciar jogo')}>
                    Jogar
                </Button>

            </div>

        </CardBody>
    );
}

export default Personagens;
