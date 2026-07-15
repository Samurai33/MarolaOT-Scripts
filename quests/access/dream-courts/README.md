# Dream Courts Access

> Status: 🛠️ Em desenvolvimento

Pacote de documentação e automação assistida para liberar os acessos relacionados à Dream Courts Quest no MarolaOT.

## Objetivos

- separar a quest em etapas pequenas e auditáveis;
- registrar requisitos, itens, NPCs e storages esperados;
- criar waypoints apenas para deslocamentos seguros;
- interromper automaticamente antes de escolhas, entregas ou áreas de risco;
- validar o acesso necessário para Summer Court e Winter Court;
- oferecer checklist de progresso e recuperação.

## Estrutura prevista

```text
dream-courts/
├── README.md
├── checklist.md
├── route/
│   ├── stage-01.cfg
│   ├── stage-02.cfg
│   └── stage-03.cfg
├── validation/
│   ├── Test-DreamCourtsAccess.ps1
│   └── storage-reference.md
└── rollback/
    └── README.md
```

## Checkpoints manuais

A automação deve parar antes de:

- entregar itens de missão;
- escolher recompensa ou facção;
- entrar em boss ou arena;
- usar teleportes de retorno difícil;
- iniciar etapas que possam consumir recursos;
- avançar quando o estado da quest não puder ser confirmado.

## Dados a validar no MarolaOT

- [ ] sequência real das missões habilitadas;
- [ ] nomes exatos dos NPCs;
- [ ] palavras-chave dos diálogos;
- [ ] itens e IDs necessários;
- [ ] coordenadas e pisos;
- [ ] storages usados pelo servidor;
- [ ] diferenças em relação ao Canary upstream;
- [ ] condição exata de acesso a Summer Court;
- [ ] condição exata de acesso a Winter Court.

## Critérios de aceite

- [ ] checklist reproduzível em personagem sem acesso;
- [ ] validação identifica corretamente etapa atual;
- [ ] rota nunca pula uma condição obrigatória;
- [ ] checkpoints manuais aparecem de forma clara;
- [ ] nenhuma alteração direta no banco é necessária;
- [ ] acesso final confirmado dentro do cliente;
- [ ] documentação de recuperação revisada.
