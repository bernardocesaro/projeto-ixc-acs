# CLAUDE.md — Frente Backend

> Leia também o `CLAUDE.md` raiz do projeto para contexto geral.

---

## Responsabilidade desta frente

Banco de dados (Supabase + Prisma) e API REST (Node.js + Express).  
Esta frente é a **base do projeto** — mobile e frontend dependem dela.  
Branch: `feature/backend`

---

## Stack

- **Node.js** + **Express**
- **Prisma** (ORM — schema, migrations, queries)
- **Supabase** (PostgreSQL gerenciado — painel em supabase.com)
- **JWT** (autenticação dos operadores e do app mobile)
- **Socket.io** (eventos em tempo real para o frontend web)
- **PDFKit** (geração de relatórios PDF)
- **dotenv** (variáveis de ambiente)

---

## Estrutura de Pastas

```
projeto-ixc-acs/
├── prisma/
│   └── schema.prisma        ← modelo do banco
├── src/
│   ├── controllers/         ← lógica de cada recurso
│   ├── middlewares/         ← auth JWT, validações
│   ├── routes/              ← definição das rotas Express
│   └── server.js            ← entry point
├── .env                     ← NÃO versionar
├── .env.example             ← versionar (sem valores reais)
├── .gitignore
└── package.json
```

---

## Tabelas do Banco (Supabase)

| Tabela | Descrição |
|--------|-----------|
| `provedores` | ISPs cadastrados (multi-tenant) |
| `clientes` | Clientes de cada provedor |
| `dispositivos` | Dispositivos identificados por MAC |
| `testes` | Resultados dos testes de rede |

**Relações:** `provedores` → `clientes` → `dispositivos` → `testes`

---

## Rotas da API

| Método | Rota | Descrição |
|--------|------|-----------|
| POST | `/auth` | Login via usuário/senha Wi-Fi do roteador |
| POST | `/testes` | Recebe resultado do teste vindo do mobile |
| GET | `/testes` | Lista testes (com filtros: cliente, data, status) |
| GET | `/testes/:clienteId` | Histórico de testes de um cliente |
| GET | `/relatorios` | Gera PDF com filtros aplicados |
| POST | `/testes/remoto` | Dispara teste remoto no dispositivo do cliente |

---

## Regras Importantes

- Dados de teste são **imutáveis** após inserção — sem UPDATE ou DELETE
- Validar rede do provedor antes de aceitar um teste (RN04 mobile)
- Teste remoto só executa com **autorização do cliente** (flag no payload)
- Logs de todas as ações do operador devem ser registrados
- Multi-tenant: toda query filtra por `provedor_id`

---

## Configuração Inicial

```bash
npm init -y
npm install express prisma @prisma/client @supabase/supabase-js dotenv jsonwebtoken socket.io pdfkit
npx prisma init
```

Configurar `DATABASE_URL` no `.env` com a string de conexão do Supabase.

---

## Testando as Rotas

Usar **Insomnia** ou **Postman**.  
Exportar a collection e versionar em `docs/api-collection.json`.