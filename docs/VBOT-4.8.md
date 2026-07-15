# vBot 4.8 no MarolaOT

## Arquivos principais

```text
vBot_4.8/
├── cavebot_configs/
├── targetbot_configs/
├── storage/profile_1.json
└── vBot_configs/profile_1/
    ├── AttackBot.json
    ├── HealBot.json
    └── Supplies.json
```

## Regras de alteração

1. Fechar completamente o cliente.
2. Criar backup dos arquivos afetados.
3. Validar JSON antes da gravação.
4. Alterar somente as chaves necessárias.
5. Manter os módulos desligados.
6. Reabrir o cliente e testar localmente.

## Lootbag

Quando o servidor utiliza lootbag/autoloot, o looting interno do TargetBot deve permanecer vazio e `dontLoot` deve ser verdadeiro nas entradas de targeting.

## Cooldowns

O campo `cooldown` do AttackBot funciona como trava local do vBot. Ele deve refletir o cooldown real da magia com pequena margem adicional para evitar tentativas antecipadas.
