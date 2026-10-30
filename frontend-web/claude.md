# CLAUDE.md — Frente Frontend Web

> Leia também o `CLAUDE.md` raiz do projeto para contexto geral.

---

## Responsabilidade desta frente

Dashboard web para operadores de provedores de internet.  
Inicia na **Semana 5** — depende do backend estar funcional.  
Branch: `feature/front`

---

## Stack

- **HTML + CSS + JavaScript** (vanilla)
- **Bootstrap** — layout e componentes responsivos
- **fetch** ou **axios** — consumo da API REST
- **Socket.io client** — atualização em tempo real

---

## Estrutura de Pastas

```
frontend/
├── index.html           ← login do operador
├── dashboard.html       ← gráficos e indicadores
├── grid.html            ← tabela de todos os testes
├── css/
│   └── style.css
├── js/
│   ├── auth.js          ← login JWT
│   ├── grid.js          ← tabela + filtros + socket
│   ├── dashboard.js     ← gráficos e métricas
│   └── relatorio.js     ← exportar PDF
└── assets/
```

---

## Telas

### Grid
- Tabela com todos os testes: cliente, dispositivo, data/hora, SSID, dBm, GHz, ping, jitter, status
- Filtros: por cliente, data, tipo de teste, status
- Ordenação por coluna
- **Somente leitura** — sem botões de editar ou excluir
- Atualização automática via Socket.io quando novo teste chega

### Dashboard
- Indicadores de saúde da rede (médias de ping, jitter, sinal)
- Visualização de testes em execução em tempo real
- Histórico por cliente (selecionável)
- Alertas de incidente regional (múltiplos clientes com falha simultânea)
- Botão de **disparo remoto** de teste (com confirmação antes de enviar)
- Botão de **exportar relatório PDF** com filtros aplicados

---

## Autenticação

- Operador loga com usuário/senha
- API retorna token JWT
- Armazenar no `localStorage`
- Toda requisição envia `Authorization: Bearer <token>` no header

---

## Socket.io

```javascript
const socket = io('http://localhost:3000');

socket.on('novo_teste', (dados) => {
  // adicionar linha na grid em tempo real
});
```

---

## Regras Importantes

- Dados são **somente leitura** — nenhuma ação de edição ou exclusão
- Disparo remoto exige confirmação do operador antes de enviar
- Exibir alertas quando múltiplos clientes do mesmo provedor falharem simultaneamente
- Multi-tenant: operador vê apenas dados do seu provedor