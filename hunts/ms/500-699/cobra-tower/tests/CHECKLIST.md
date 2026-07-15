# Checklist de validação — Cobra Tower

## 1. Pacote

- [ ] Executar `Test-CobraTowerPackage.ps1`.
- [ ] Confirmar todos os checksums.
- [ ] Confirmar que o source lock aponta para o commit fixado.
- [ ] Confirmar que o cliente está fechado.

## 2. Instalação

- [ ] Executar o instalador sem erros.
- [ ] Confirmar criação de `backup-manifest.json`.
- [ ] Confirmar criação de `install-report.json`.
- [ ] Confirmar que AttackBot está OFF.
- [ ] Confirmar que HealBot está OFF.
- [ ] Confirmar que CaveBot está OFF.
- [ ] Confirmar que TargetBot está OFF.

## 3. Perfis

- [ ] Perfil AttackBot selecionado: `Cobra Tower MAX DPS v2`.
- [ ] Perfil HealBot selecionado: `Cobra Tower MAX DPS v2`.
- [ ] Perfil Supplies selecionado: `Cobra Tower MAX DPS v2`.
- [ ] TargetBot selecionado: `cobra`.
- [ ] CaveBot selecionado: `[550+] Cobra Tower`.

## 4. Dry-run

- [ ] Selecionar `[550+] Cobra Tower DRY RUN`.
- [ ] Manter AttackBot, HealBot e TargetBot desligados.
- [ ] Confirmar caminho de depot, banco e supplies.
- [ ] Confirmar Mehkesh.
- [ ] Confirmar Fenech.
- [ ] Confirmar que a rota para antes do início automático da hunt.
- [ ] Confirmar ausência de loop ou waypoint impossível.

## 5. Combate local

- [ ] CaveBot OFF.
- [ ] TargetBot e AttackBot ativados manualmente.
- [ ] Uma Cobra: SD/strike.
- [ ] Duas Cobras: GFB.
- [ ] Três Cobras alinhadas: waves.
- [ ] Seis Cobras: UE apenas uma vez por janela de cooldown.
- [ ] Confirmar que o looting interno do TargetBot está desligado.

## 6. Rota controlada

- [ ] Ativar TargetBot.
- [ ] Ativar HealBot.
- [ ] Ativar AttackBot.
- [ ] Ativar CaveBot por último.
- [ ] Acompanhar entrada, loop, supplycheck e retorno.
- [ ] Confirmar refill e venda.
- [ ] Confirmar lootbag.
- [ ] Confirmar retorno por supplies/capacidade.

## 7. Rollback

- [ ] Fechar o cliente.
- [ ] Executar `Restore-CobraTower.ps1`.
- [ ] Confirmar arquivos anteriores restaurados.
- [ ] Confirmar arquivos novos removidos quando aplicável.
- [ ] Confirmar `restore-report.json`.
- [ ] Confirmar todos os módulos OFF.
- [ ] Abrir o cliente e confirmar carregamento normal.

## 8. Gate M7

- [ ] CI do pull request verde.
- [ ] Instalação a partir de clone limpo.
- [ ] Dry-run aprovado.
- [ ] Volta completa aprovada.
- [ ] Rollback aprovado.
- [ ] Notas de release preparadas.
- [ ] Tag `cobra-tower-v1.0.0`.
