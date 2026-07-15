# Rota — ainda não capturada

Este diretório não contém CaveBot executável em M2.

A pesquisa pública não encontrou um pacote completo, reproduzível e licenciável para **The Order of the Falcon**. A futura rota será uma captura original no MarolaOT, sem converter coordenadas editoriais ou imagens em waypoints por suposição.

## Estratégia de captura

Cada arquivo deverá representar um segmento reversível:

```text
01-edron-to-old-outpost.cfg
02-old-outpost-to-ritual-checkpoint.cfg
03-bastion-entry-to-soeren.cfg
04-soeren-to-lazare.cfg
05-lazare-to-gaunder.cfg
06-gaunder-to-dominus.cfg
07-dominus-to-leaf-golem.cfg
08-leaf-golem-to-oberon-checkpoint.cfg
09-safe-return.cfg
```

Os nomes são planejamento; os arquivos não devem ser criados até a captura real.

## Labels obrigatórias futuras

```text
START_SAFE
CHECK_REQUIREMENTS
MANUAL_RITUAL
CONFIRM_BASTION_ENTRY
MANUAL_SOEREN
MANUAL_LAZARE
MANUAL_GAUNDER
MANUAL_DOMINUS
MANUAL_LEAF_GOLEM
MANUAL_OBERON_PORTAL
STOP_BEFORE_OBERON
SAFE_RETURN
```

## Regras

- começar e terminar cada segmento em posição verificável;
- nunca atravessar automaticamente um checkpoint manual;
- não usar `gotolabel` para contornar porta, barco ou storage;
- não automatizar uso de item do ritual;
- não automatizar lever/portal do Oberon;
- não incluir frases do debate;
- salvar evidências da primeira passagem controlada;
- registrar divergências de coordenadas no relatório da revisão do servidor.

## Gate para adicionar `.cfg`

Um arquivo CaveBot só poderá entrar neste diretório quando possuir:

- origem `original-capture` no manifesto;
- data, personagem de teste anonimizado e revisão do cliente/servidor;
- ponto inicial e final confirmados;
- inventário de actions utilizadas;
- validação estática de labels;
- checkpoint manual antes de qualquer item, boss, barco ou decisão;
- procedimento de retorno;
- teste controlado sem ativação automática de combate.
