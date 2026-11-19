// Instância única do PrismaClient compartilhada por toda a API.
// Criar vários PrismaClient abre várias conexões com o banco,
// por isso todo arquivo importa esta mesma instância.
const { PrismaClient } = require("@prisma/client");

const prisma = new PrismaClient();

module.exports = prisma;
