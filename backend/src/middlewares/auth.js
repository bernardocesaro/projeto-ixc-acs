// Middleware de autenticação dos operadores.
// O dashboard web faz o login direto no Firebase Auth (e-mail e senha)
// e envia o ID token recebido no cabeçalho "Authorization: Bearer <token>".
// Aqui o token é validado pelo Firebase e o operador é buscado no nosso banco.
const { getFirebaseAuth } = require("../config/firebase");
const operatorService     = require("../services/operatorService");

async function authenticate(req, res, next) {
    const header = req.headers.authorization;

    if (!header || !header.startsWith("Bearer ")) {
        return res.status(401).json({
            message: "Token não informado"
        });
    }

    // Tira o "Bearer " da frente e fica só com o token
    const token = header.replace("Bearer ", "");

    let decoded;

    try {
        // Confere assinatura, validade e projeto do token
        decoded = await getFirebaseAuth().verifyIdToken(token);
    } catch (error) {
        if (error.message.startsWith("Firebase não configurado")) {
            console.error(error.message);
            return res.status(500).json({
                message: "Erro de configuração do servidor"
            });
        }

        return res.status(401).json({
            message: "Token inválido ou expirado"
        });
    }

    try {
        // O usuário existe no Firebase, mas precisa estar cadastrado
        // como operador de algum provedor no nosso banco
        const operator = await operatorService.getOperatorByFirebaseUid(decoded.uid);

        if (!operator) {
            return res.status(403).json({
                message: "Usuário não cadastrado como operador"
            });
        }

        if (operator.status !== "ATIVO") {
            return res.status(403).json({
                message: "Operador inativo. Fale com o administrador"
            });
        }

        // As rotas protegidas usam req.user.providerId para filtrar
        // os dados do provedor (multi-tenant)
        req.user = {
            operatorId:  operator.id,
            providerId:  operator.providerId,
            accessLevel: operator.accessLevel,
            name:        operator.name
        };

        next();
    } catch (error) {
        console.error("Erro ao autenticar: ", error);
        return res.status(500).json({
            message: "Erro ao autenticar"
        });
    }
}

module.exports = authenticate;
