const prisma = require("../database/prisma");

// Grava uma ação do operador no log.
// A tabela logs_acoes só aceita INSERT (UPDATE e DELETE são bloqueados no banco).
async function createActionLog(data) {
    return await prisma.actionLog.create({
        data
    });
};

module.exports = {
    createActionLog
};
