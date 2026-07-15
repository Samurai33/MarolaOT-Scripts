# Quests e acessos

Esta área documenta e automatiza, quando seguro, quests e acessos do MarolaOT.

## Organização

```text
quests/<categoria>/<quest>/
```

Categorias iniciais:

- `access`: acessos e liberações permanentes;
- `bosses`: preparação e sequência de bosses;
- `tasks`: missões repetíveis ou por etapas;
- `outfits`: outfits, addons e recompensas relacionadas.

## Conteúdo esperado

- `README.md`: requisitos e visão geral;
- `checklist.md`: etapas marcáveis e estados esperados;
- `route/`: waypoints e segmentos seguros;
- `validation/`: verificações de storage, itens e acesso;
- `rollback/`: como interromper ou restaurar uma automação local.

## Checkpoints manuais obrigatórios

A automação deve parar antes de:

- entregar ou consumir itens raros;
- escolher recompensas;
- entrar em boss ou arena;
- iniciar etapas com tempo limitado;
- usar teleportes sem retorno simples;
- alterar storage ou estado administrativo diretamente no banco.

## Validação no servidor

Antes de publicar um pacote, confirmar:

1. nomes exatos dos NPCs;
2. diálogos e palavras-chave;
3. coordenadas e pisos;
4. itens e IDs usados;
5. storages ou condições de progresso;
6. comportamento específico do MarolaOT em relação ao Canary upstream.

Consulte o [catálogo geral](../docs/CATALOG.md) para ver a ordem de desenvolvimento.
