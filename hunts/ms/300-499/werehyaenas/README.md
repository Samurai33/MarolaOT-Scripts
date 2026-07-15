# Werehyaenas — Master Sorcerer 300+

> **Maturidade:** M1 — referência encontrada, pacote ainda não adaptável.

Este diretório inicia o bloco **P2** do MarolaOT-Scripts. Ele registra somente informações verificadas e não contém CaveBot executável, refill, AttackBot ou instalador.

## Evidência confirmada

Foi localizado um TargetBot comunitário em:

```text
Repositório: Kolczan/Tibia-Scripts
Commit: 52e6baaa1a32448abe88476fca53dcd466d7678e
Arquivo: otclientv8/bot/EK tsunami/targetbot_configs/Werehyaenas.json
```

A referência contempla:

- `Werehyaena`;
- `Werehyaena Shaman`;
- regex para os dois monstros;
- integração de lure com CaveBot;
- `lureCount` igual a 3;
- distância máxima igual a 10.

O código original não é copiado para este repositório enquanto sua licença não estiver confirmada.

## Componentes

| Componente | Estado | Observação |
|---|---|---|
| Source manifest | Criado | [`source-manifest.json`](source-manifest.json) |
| CaveBot | Ausente | Rota correspondente não localizada |
| TargetBot | Referenciado | Arquivo comunitário identificado |
| AttackBot | Ausente | Elementos e cooldowns ainda não auditados |
| HealBot | Ausente | Limiares ainda não definidos |
| Supplies | Ausente | NPCs e quantidades não auditados |
| Refill | Ausente | Cidade, banco, compras e retorno não confirmados |
| Rollback | Ausente | Será produzido junto ao instalador |

## Objetivo do P2

Promover o pacote de M1 para M3 somente por evidência verificável.

### Etapa 1 — Auditoria

- [ ] confirmar licença do repositório comunitário;
- [ ] fixar commit do upstream OTCv8 usado na adaptação;
- [ ] localizar CaveBot correspondente;
- [ ] localizar dependências e actions personalizadas;
- [ ] identificar cidade inicial, banco e NPCs de refill;
- [ ] conferir acesso e entrada sem alterar personagem;
- [ ] registrar criaturas, elementos, ataques e riscos.

### Etapa 2 — Adaptação

Somente após a auditoria:

- [ ] produzir TargetBot próprio no schema do MarolaOT;
- [ ] criar AttackBot para MS;
- [ ] criar HealBot e Supplies;
- [ ] converter ou capturar a rota CaveBot;
- [ ] desligar looting interno para uso do lootbag;
- [ ] criar instalador com backup e módulos desligados;
- [ ] criar rollback específico do pacote.

### Etapa 3 — Testes futuros

- [ ] validação estática de JSON;
- [ ] teste local de combate;
- [ ] dry-run de refill e entrada;
- [ ] rota controlada;
- [ ] uma volta completa;
- [ ] release versionada.

## Bloqueadores atuais

1. CaveBot completo não localizado.
2. Refill não localizado.
3. Licença da referência comunitária não confirmada.
4. Perfil encontrado foi criado para EK, não para MS.
5. Dados específicos do MarolaOT ainda não foram comparados.

Enquanto esses bloqueadores existirem, o pacote permanece **não instalável**.

## Segurança

- nenhum teste no personagem é necessário nesta fase;
- nenhuma configuração local será alterada;
- nenhuma rota será inferida por coordenadas aproximadas;
- nenhum código externo será republicado sem licença clara;
- qualquer futuro instalador deverá terminar com todos os bots desligados.
