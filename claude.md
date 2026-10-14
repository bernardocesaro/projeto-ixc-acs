# CLAUDE.md — Projeto IXC ACS

Este arquivo contextualiza o Claude Code sobre o projeto, stack, regras de negócio e convenções adotadas pela equipe.

---

## Sobre o Projeto

**Nome interno:** Projeto IXC ACS  
**Cliente:** IXCSoft  
**Objetivo:** Aplicativo mobile (Android/iOS) + plataforma web para diagnóstico de rede em tempo real, integrado ao sistema IXC ACS via protocolo TR-069.

**Fluxo principal:**
1. Cliente loga no app mobile com usuário/senha do **roteador Wi-Fi** (não PPPoE)
2. MAC do dispositivo é capturado automaticamente (para identificar modelo, ex: "iPhone XR")
3. App executa bateria de testes de rede: SSID, dBm, GHz, ping, jitter, perda de pacotes
4. Resultados são enviados para a API → salvos no Supabase → exibidos no dashboard web em tempo real
5. Operador do provedor pode disparar teste remoto → cliente recebe notificação clara (linguagem não técnica) → autoriza → teste executa

---

## Stack Tecnológica

### Backend
- **Node.js** + **Express** — API REST
- **Prisma** — ORM (schema + migrations)
- **Supabase** — banco de dados PostgreSQL gerenciado
- **JWT** — autenticação
- **Socket.io** — sincronização em tempo real com o frontend web
- **PDFKit** — geração de relatórios PDF

### Frontend Web (Dashboard)
- **HTML + CSS + JavaScript**
- **Bootstrap** — layout responsivo
- Consome a API via **fetch/axios**
- Atualização em tempo real via **Socket.io**

### Mobile
- **Expo** + **React Native**
- Testado com **Expo Go** durante desenvolvimento

### Banco de Dados
- **Supabase** (PostgreSQL gerenciado na nuvem)
- Tabelas: `provedores`, `clientes`, `dispositivos`, `testes`

### Controle de Versão
- **Git** + **GitHub**

---

## Estrutura de Branches

```
main            → entrega final — apenas código aprovado e homologado
homolog         → ambiente de testes e validação antes da main
develop         → integração de todas as frentes (merge dos feature/*)
feature/backend → banco de dados (Supabase/Prisma) + API Node/Express
feature/front   → dashboard web (HTML/CSS/JS/Bootstrap)
feature/mobile  → aplicativo Expo/React Native
```

**Fluxo de trabalho:**
`feature/*` → `develop` → `homolog` (testes) → `main` (entrega)

**Regra:** nunca commitar direto na `main` ou `homolog`. Todo código novo vai para o `feature/*` correspondente.

---

## Divisão do Time (4 pessoas)

| Frente | Pessoas | Início |
|--------|---------|--------|
| Backend (Supabase + API) | 2 | Semana 1 |
| Mobile (Expo + React Native) | 1 | Semana 3 |
| Frontend Web (Dashboard) | 1 | Semana 5 |

---

## Regras de Negócio Importantes

### Mobile
- Login com usuário/senha do **Wi-Fi do roteador** (não login próprio no app)
- Testes só executam se conectado à rede do provedor
- Testes só executam com app em **primeiro plano**
- Usuário deve aceitar **termos de uso** antes de qualquer teste (LGPD)
- App deve solicitar permissões de rede e localização; sem elas, testes não executam
- Teste remoto requer **autorização explícita** do cliente — mensagem em linguagem simples e não técnica
- Dados coletados: SSID, dBm, GHz, latência (ping), jitter, perda de pacotes
- Após envio, dados são **imutáveis** — nenhuma edição ou exclusão manual
- Histórico de testes por dispositivo disponível no app

### Web / Dashboard
- Grid exibe todos os testes: cliente, dispositivo, data/hora, parâmetros, status
- Grid é **somente leitura** — sem edição ou exclusão
- Sincronização em tempo real via **Socket.io**
- Operador pode disparar teste remoto pelo dashboard
- Geração de relatório PDF com filtros aplicados
- Logs de todas as ações do operador registrados
- Multi-tenant: cada provedor vê apenas seus próprios dados

### Melhorias Futuras (fora do escopo atual)
- Testes automáticos por horário/reconexão (RN12/RN13 mobile)
- Bloqueio de teste se streaming ativo (RN15 mobile)
- IA para diagnóstico (RN22 web)

---

## Cronograma Resumido (8 Semanas)

| Semana | Foco |
|--------|------|
| 1 | Git, ambiente, modelagem Supabase |
| 2 | Backend base — Node.js, Express, rotas, JWT |
| 3 | Mobile — autenticação, coleta de dados |
| 4 | Integração mobile ↔ backend |
| 5 | Frontend web — Grid e Dashboard base |
| 6 | Funcionalidades avançadas (Socket.io, PDF, alertas) |
| 7 | Testes, correções, LGPD, multi-tenant |
| 8 | Entrega — revisão, deploy, apresentação |

**Entrega prevista:** primeira semana de dezembro de 2026.

---

## Convenções de Código

- Idioma do código: **inglês** (variáveis, funções, arquivos)
- Idioma dos comentários e mensagens ao usuário: **português**
- Sempre usar **async/await** (nunca callbacks aninhados)
- Variáveis de ambiente em `.env` — nunca hardcodar credenciais
- `.env` no `.gitignore` — versionar apenas `.env.example`
- Prisma schema em `prisma/schema.prisma`
- Rotas Express organizadas em `src/routes/`
- Controllers em `src/controllers/`
- Middlewares em `src/middlewares/`

---

## Estrutura de Pastas Sugerida (Backend)

```
projeto-ixc-acs/
├── prisma/
│   └── schema.prisma
├── src/
│   ├── controllers/
│   ├── middlewares/
│   ├── routes/
│   └── server.js
├── .env.example
├── .gitignore
└── package.json
```

---

## Repositório

- **Protótipo:** https://github.com/felipevailoes-ship-it/PrototipoIXCACS
- **Projeto principal:** https://github.com/bernardocesaro/projeto-ixc-acs

---

## Como usar este arquivo

Ao iniciar uma sessão no Claude Code, ele lê automaticamente o `CLAUDE.md` da raiz do projeto. Com isso, qualquer membro do time abre o VS Code e o Claude já entende o contexto completo sem precisar re-explicar tudo.