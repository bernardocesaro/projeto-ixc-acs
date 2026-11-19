const testService      = require("../services/testService");
const actionLogService = require("../services/actionLogService");

const VALID_STATUSES = ["SUCESSO", "ALERTA", "FALHA", "ERRO"];

// GET /testes
// Filtros opcionais na URL (todos podem ser combinados):
//   ?clienteId=1
//   ?dataInicio=2026-11-01&dataFim=2026-11-30
//   ?status=FALHA
async function getAllTests(req, res) {
    try {
        const { providerId, operatorId } = req.user;
        const { clienteId, dataInicio, dataFim, status } = req.query;

        const filters = {};

        if (clienteId) {
            filters.clientId = Number(clienteId);

            if (!Number.isInteger(filters.clientId)) {
                return res.status(400).json({
                    message: "clienteId deve ser um número"
                });
            }
        }

        if (status) {
            filters.status = status.toUpperCase();

            if (!VALID_STATUSES.includes(filters.status)) {
                return res.status(400).json({
                    message: "status deve ser SUCESSO, ALERTA, FALHA ou ERRO"
                });
            }
        }

        if (dataInicio) {
            filters.startDate = new Date(dataInicio);

            if (isNaN(filters.startDate)) {
                return res.status(400).json({
                    message: "dataInicio inválida (use AAAA-MM-DD)"
                });
            }
        }

        if (dataFim) {
            // Soma o horário final do dia para incluir o dia inteiro
            filters.endDate = new Date(`${dataFim}T23:59:59.999Z`);

            if (isNaN(filters.endDate)) {
                return res.status(400).json({
                    message: "dataFim inválida (use AAAA-MM-DD)"
                });
            }
        }

        const tests = await testService.getAllTests(providerId, filters);

        // Toda ação do operador gera um registro no log
        await actionLogService.createActionLog({
            providerId,
            operatorId,
            action:         "CONSULTA_TESTES",
            affectedEntity: "testes",
            details:        { clienteId, dataInicio, dataFim, status, total: tests.length },
            sourceIp:       req.ip
        });

        res.json(tests);
    } catch (error) {
        console.error("Erro ao buscar os testes: ", error);
        res.status(500).json({
            message: "Erro ao buscar os testes"
        });
    }
}

module.exports = {
    getAllTests
};
