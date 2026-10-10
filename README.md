# Guia técnico — Frontend web

## 1. Escopo

A responsabilidade desta frente é implementar e manter o painel web para operadores, usando o protótipo do Figma como referência. O protótipo contém as seguintes visualizações web:

- Login.
- Dashboard.
- Grid de testes.
- Teste remoto.
- Relatórios.
- Logs de auditoria.

O arquivo principal do protótipo é `src/app/components/WebPrototype.tsx`. Ele contém componentes para sidebar, cabeçalho, cards de KPI, dashboard, badges de status, grid, teste remoto, relatórios, logs e login.

## 2. Tecnologias

- React + TypeScript.
- Vite.
- Tailwind CSS e CSS do projeto.
- Lucide React para ícones.
- Recharts para visualizações gráficas.
- Componentes de UI presentes em `src/app/components/ui/`.

Consultar `package.json` antes de adicionar ou atualizar dependências. Evitar introduzir bibliotecas duplicadas para a mesma finalidade sem alinhamento da equipe.

## 3. Estrutura recomendada para evolução

A estrutura abaixo é uma proposta para a implementação, não a estrutura atual completa:

```text
src/
├── app/
│   ├── App.tsx
│   └── routes/
├── components/
│   ├── layout/
│   ├── feedback/
│   └── data-display/
├── features/
│   ├── auth/
│   ├── dashboard/
│   ├── tests/
│   ├── remote-tests/
│   ├── reports/
│   └── audit-logs/
├── services/
│   ├── api-client.ts
│   └── endpoints/
├── hooks/
├── types/
├── utils/
└── styles/
```

Organizar por funcionalidade quando isso facilitar manutenção e testes. A migração deve ser gradual para não perder a referência visual já validada.

## 4. Regras de implementação

- Preferir componentes pequenos, com uma responsabilidade clara.
- Definir tipos TypeScript para as respostas da API; evitar `any` sem justificativa.
- Manter chamadas HTTP em uma camada de serviços, fora dos componentes visuais.
- Centralizar URL base e configuração de ambiente.
- Nunca armazenar senhas de Wi-Fi ou segredos no frontend.
- Não assumir que ocultar um botão é controle de autorização suficiente.
- Tratar erros de rede, sessão expirada, respostas vazias e indisponibilidade do serviço.
- Usar formatação consistente para datas, horários, milissegundos, dBm, GHz e percentuais.
- Gráficos devem ter legenda, unidades e tratamento para ausência de dados.
- A grid e o histórico são somente leitura: não criar ações de edição ou exclusão de registros.
- Usar confirmação e feedback claro para ações relevantes, especialmente solicitação de teste remoto.
- Evitar atualizar a tela artificialmente como se houvesse tempo real. O método real (polling, WebSocket, SSE ou outro) será definido com backend.
- Garantir navegação por teclado, foco visível, rótulos acessíveis e contraste adequado.

## 5. Estado da interface

Os componentes devem representar claramente os estados:

- `loading`: carregamento em andamento.
- `success`: dados carregados ou ação confirmada.
- `empty`: nenhuma informação encontrada.
- `error`: falha na consulta ou ação.
- `unauthorized`: usuário sem autorização ou sessão inválida.
- `stale`: dados cuja atualização não pôde ser confirmada, quando aplicável.

Para teste remoto, usar os estados acordados no contrato da API. Não inferir conclusão do teste a partir de uma resposta de aceite da solicitação.

## 6. Dashboard

A dashboard deve consumir os mesmos dados oficiais disponibilizados para consulta na grid, conforme os requisitos do projeto. Os indicadores previstos no protótipo incluem volume de testes, clientes testados, ping médio, taxa de sucesso, distribuição de status e gráficos de comportamento da conexão.

Antes da integração, alinhar com backend:
- Definição e fórmula de cada KPI.
- Período padrão e fuso horário.
- Critérios de classificação de status.
- Tratamento de dados incompletos.
- Frequência de atualização.
- Paginação/agregação no servidor para grandes volumes.

Não calcular ou inventar definições de negócio sem aprovação.

## 7. Grid de testes

Campos presentes no protótipo incluem identificador do teste, cliente, dispositivo, data, hora, SSID, sinal em dBm, frequência em GHz, ping, jitter, perda de pacotes, status e tipo de teste.

A implementação final deve alinhar nomes, tipos e disponibilidade dos campos com o contrato do backend. A grid deve suportar filtros, ordenação e paginação conforme o escopo aprovado, sem permitir alteração ou exclusão do histórico.

## 8. Variáveis de ambiente

Usar variáveis de ambiente do Vite para configurações não secretas, por exemplo:

```env
VITE_API_BASE_URL=http://localhost:3000
```

O valor acima é apenas um exemplo local; a porta e a URL reais devem ser definidas pela equipe. Variáveis `VITE_*` ficam disponíveis no bundle do navegador e **não podem conter segredos**.

## 9. Critério de pronto para uma funcionalidade

Uma funcionalidade web pode ser considerada pronta quando:
- Está alinhada ao protótipo aprovado ou possui alteração validada.
- Funciona com dados da API, sem depender de mocks em produção.
- Tem estados de carregamento, vazio, erro e sucesso pertinentes.
- Respeita autenticação e autorização aplicadas pelo backend.
- Não viola imutabilidade do histórico nem isolamento de dados.
- É responsiva e utilizável por teclado.
- Foi validada em navegador moderno e não apresenta erros críticos no console.
- Possui instruções atualizadas quando a mudança afeta configuração ou integração.
