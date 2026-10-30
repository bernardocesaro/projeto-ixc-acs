# CLAUDE.md — Frente Mobile

> Leia também o `CLAUDE.md` raiz do projeto para contexto geral.

---

## Responsabilidade desta frente

Aplicativo mobile Android/iOS para clientes dos provedores executarem testes de rede.  
Inicia na **Semana 3** — depende do backend base estar funcional.  
Branch: `feature/mobile`

---

## Stack

- **Expo** + **React Native**
- **Expo Go** — para testes durante desenvolvimento (sem build nativo)
- **axios** — consumo da API backend

---

## Estrutura de Pastas

```
mobile/
├── app/
│   ├── pages/
│   │   ├── Login.tsx          ← usuário/senha Wi-Fi do roteador
│   │   ├── Home.tsx           ← tela principal pós-login
│   │   ├── Teste.tsx          ← execução e resultado do teste
│   │   ├── Historico.tsx      ← histórico de testes do dispositivo
│   │   └── Termos.tsx         ← aceite de termos (LGPD)
│   └── components/
├── app.json
└── package.json
```

---

## Fluxo do Usuário

```
Abrir app
  → Aceitar Termos de Uso (primeira vez)
  → Login com usuário/senha Wi-Fi do roteador
  → Validação: rede deve ser do provedor
  → Tela principal
      → Executar teste manualmente
      → Receber notificação de teste remoto → Aceitar ou Recusar
  → Resultado exibido em linguagem simples (não técnica)
  → Histórico de testes anteriores
```

---

## Dados Coletados no Teste

| Dado | Descrição |
|------|-----------|
| SSID | Nome da rede Wi-Fi |
| dBm | Intensidade do sinal |
| GHz | Frequência (2.4 ou 5) |
| Ping | Latência em ms |
| Jitter | Variação da latência |
| Perda de pacotes | % de pacotes perdidos |
| MAC | Capturado automaticamente (identifica modelo do dispositivo) |

---

## Regras Importantes

- Login com **usuário/senha do Wi-Fi do roteador** — não criar conta no app
- MAC capturado **automaticamente** (não digitado pelo usuário)
- Testes só executam se conectado à **rede do provedor**
- Testes só executam com app em **primeiro plano**
- Solicitar permissões de rede e localização — sem elas, bloquear execução
- Usuário aceita **Termos de Uso** antes do primeiro uso (LGPD)
- Teste remoto: mostrar mensagem **clara e simples** antes do aceite
- Após envio, dados são **imutáveis** — sem edição local
- Notificar ao término do teste e ao normalizar parâmetros críticos
- Suporte a **múltiplos dispositivos** por conta

---

## Configuração Inicial

```bash
npx create-expo-app mobile
cd mobile
npx expo install expo-network expo-device
npm install axios
npx expo start
```

Instalar **Expo Go** no celular para testar sem precisar buildar.

---

## Comunicação com a API

```javascript
// Exemplo: enviar resultado do teste
await axios.post('http://SEU_IP:3000/testes', {
  ssid, dbm, ghz, ping, jitter, perda_pacotes, mac
}, {
  headers: { Authorization: `Bearer ${token}` }
});
```

> Durante desenvolvimento, usar o IP local da máquina (não `localhost`).