// Ponto de entrada da API do Projeto IXC ACS
require("dotenv").config();

const express = require("express");
const cors    = require("cors");

const authRoutes = require("./routes/authRoutes");
const testRoutes = require("./routes/testRoutes");

const app = express();

// Permite que o dashboard web (outra origem) chame a API
app.use(cors());
// Converte o corpo das requisições JSON em req.body
app.use(express.json());

// Rota simples para conferir se a API está no ar
app.get("/health", (req, res) => {
    res.json({ status: "ok" });
});

app.use("/auth", authRoutes);
app.use("/testes", testRoutes);

const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
    console.log(`Servidor iniciado em http://localhost:${PORT}`);
});
