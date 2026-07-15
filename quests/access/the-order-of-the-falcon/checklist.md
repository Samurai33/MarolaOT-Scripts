# Checklist assistido — The Order of the Falcon

> Este checklist é documental. Nenhuma etapa deve ser executada automaticamente antes de validação no MarolaOT.

## Estado de segurança

- [ ] Cliente e vBot na versão esperada.
- [ ] CaveBot, TargetBot, AttackBot e HealBot desligados.
- [ ] Local de retorno seguro definido.
- [ ] The New Frontier confirmada como concluída.
- [ ] Estado atual da missão conferido no Quest Log.
- [ ] Bucket, Chalk e supplies disponíveis.
- [ ] IDs dos itens conferidos no MarolaOT.
- [ ] Grupo e comunicação preparados para os bosses.

## Etapa A — Edron até o antigo posto

**Objetivo:** capturar a primeira rota reproduzível sem interagir com objetos de quest.

- [ ] Iniciar em ponto fixo de Edron.
- [ ] Registrar posição inicial e andar.
- [ ] Caminhar manualmente até a referência editorial próxima de `33210,31749,7`.
- [ ] Confirmar se o mapa do MarolaOT coincide com a referência.
- [ ] Capturar somente deslocamento, escadas e levitate.
- [ ] Encerrar o segmento antes de usar Chalk, Bucket ou símbolo.

**Parar imediatamente quando:**

- a posição não existir;
- houver mudança de mapa;
- o caminho exigir item/action não documentado;
- o personagem entrar em combate não planejado.

## Etapa B — Preparação e ritual

**Checkpoint manual obrigatório.**

- [ ] Confirmar que o período noturno do jogo está ativo.
- [ ] Confirmar que o Bucket e o Chalk corretos estão na backpack.
- [ ] Preparar o Bucket Filled with Chalk manualmente.
- [ ] Confirmar visualmente o item resultante.
- [ ] Usar o item no símbolo manualmente.
- [ ] Confirmar que o acesso foi liberado antes de prosseguir.
- [ ] Registrar mensagem, efeito e alteração observada.

O intervalo editorial publicado para o ritual corresponde aproximadamente à janela real `xx:45` até `xx:15`, mas o indicador visual do jogo prevalece.

**Proibido:** repetir automaticamente o uso do item quando não houver confirmação de sucesso.

## Etapa C — Entrada e reconhecimento do Falcon Bastion

- [ ] Entrar manualmente.
- [ ] Confirmar coordenadas, andar e ponto seguro de retorno.
- [ ] Registrar armadilhas, portas, barcos e teletransportes.
- [ ] Não inferir rota por minimapa incompleto.
- [ ] Criar segmentos independentes entre checkpoints.

### Segmentos planejados

1. entrada → Grand Commander Soeren;
2. Soeren → Preceptor Lazare;
3. Lazare → Grand Chaplain Gaunder;
4. Gaunder → Grand Canon Dominus;
5. Dominus → Dazed Leaf Golem;
6. Dazed Leaf Golem → checkpoint do Oberon.

## Etapa D — Bosses intermediários

Todos os encontros são manuais.

| Ordem | Boss | Storage esperado após vitória |
|---:|---|---:|
| 1 | Grand Commander Soeren | 1 |
| 2 | Preceptor Lazare | 2 |
| 3 | Grand Chaplain Gaunder | 3 |
| 4 | Grand Canon Dominus | 4 |
| 5 | Dazed Leaf Golem | 5 |

Para cada boss:

- [ ] parar CaveBot antes da área;
- [ ] confirmar grupo, supplies e saída;
- [ ] executar combate manualmente;
- [ ] confirmar avanço no Quest Log ou abertura do próximo gate;
- [ ] registrar divergências;
- [ ] só retomar navegação após confirmação.

**Não prosseguir** quando a porta ou o barco permanecer bloqueado.

## Etapa E — Portas e barcos

- [ ] Validar cada gate contra o progresso observado.
- [ ] Usar barcos manualmente na primeira passagem.
- [ ] Registrar origem, destino e mensagem.
- [ ] Confirmar rota de retorno antes de avançar.

O Canary indica gates progressivos nos valores 1, 2, 3 e 4 do storage `KillingBosses`. Esses valores precisam ser comparados com o comportamento do MarolaOT.

## Etapa F — Grand Master Oberon

**Automação proibida nesta versão.**

- [ ] Confirmar que os cinco bosses anteriores foram concluídos.
- [ ] Confirmar cooldown disponível.
- [ ] Reunir no máximo cinco jogadores.
- [ ] Entrar no portal manualmente.
- [ ] Acionar a alavanca manualmente.
- [ ] Executar debate e combate manualmente.
- [ ] Confirmar conclusão da missão no Quest Log.
- [ ] Registrar saída e retorno seguro.

O Canary aplica cooldown de 20 horas para nova tentativa.

## Recuperação

- Item consumido sem progresso: parar e registrar; não repetir.
- Storage/porta divergente: retornar ao último checkpoint seguro.
- Morte ou separação do grupo: abandonar a execução assistida.
- Cooldown ativo: encerrar a tentativa sem contornar a trava.
- Coordenada incompatível: marcar a rota como inválida para essa revisão.

## Critério para M3

- [ ] IDs de itens confirmados.
- [ ] rota Edron → ritual capturada.
- [ ] ritual validado manualmente.
- [ ] entrada e segmentos internos capturados.
- [ ] cada gate associado ao progresso real.
- [ ] rota de retorno conhecida.
- [ ] nenhuma lógica automática de boss ou debate.
- [ ] divergências entre TibiaWiki, Canary e MarolaOT documentadas.
