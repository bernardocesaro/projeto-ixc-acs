const prisma = require("../database/prisma");

// Busca os testes de um provedor, com filtros opcionais.
// Os testes são somente leitura: este service não tem update nem delete.
async function getAllTests(providerId, filters) {
    // Multi-tenant: sempre filtra pelo provedor do operador logado
    const where = {
        providerId
    };

    // O teste não tem id_cliente direto: o cliente vem pelo dispositivo
    if (filters.clientId) {
        where.device = {
            clientId: filters.clientId
        };
    }

    if (filters.status) {
        where.status = filters.status;
    }

    if (filters.startDate || filters.endDate) {
        where.startedAt = {};

        if (filters.startDate) {
            where.startedAt.gte = filters.startDate; // gte = maior ou igual
        }

        if (filters.endDate) {
            where.startedAt.lte = filters.endDate; // lte = menor ou igual
        }
    }

    return await prisma.test.findMany({
        where,
        orderBy: {
            startedAt: "desc"
        },
        include: {
            device: {
                select: {
                    id:         true,
                    macAddress: true,
                    model:      true,
                    client: {
                        select: {
                            id:   true,
                            name: true
                        }
                    }
                }
            }
        }
    });
};

module.exports = {
    getAllTests
};
