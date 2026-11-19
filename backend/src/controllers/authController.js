const operatorService  = require("../services/operatorService");
const actionLogService = require("../services/actionLogService");

// POST /auth/operator
// Chamado pelo dashboard logo depois do login no Firebase, com o
// cabeçalho "Authorization: Bearer <ID token do Firebase>".
// A senha é conferida pelo próprio Firebase; quando chega aqui, o
// middleware "authenticate" já validou o token e o operador (req.user).
// Esta rota registra o login e devolve os dados do operador.
async function loginOperator(req, res) {
    try {
        const { operatorId, providerId, accessLevel, name } = req.user;

        await operatorService.updateLastAccess(operatorId);

        await actionLogService.createActionLog({
            providerId,
            operatorId,
            action:           "LOGIN",
            affectedEntity:   "operadores",
            affectedEntityId: operatorId,
            sourceIp:         req.ip
        });

        res.json({
            operator: {
                id: operatorId,
                name,
                accessLevel,
                providerId
            }
        });
    } catch (error) {
        console.error("Erro ao fazer login: ", error);
        res.status(500).json({
            message: "Erro ao fazer login"
        });
    }
}

module.exports = {
    loginOperator
};
