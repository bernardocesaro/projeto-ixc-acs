-- Recriada a partir do banco: o arquivo original foi aplicado em outra máquina
-- e não foi versionado. O checksum em _prisma_migrations foi atualizado para
-- corresponder a este arquivo.

-- AlterTable
-- Autenticação dos operadores passa a ser feita pelo Firebase Auth:
-- o operador é ligado ao usuário do Firebase pelo firebase_uid
-- e a senha deixa de ficar no nosso banco
ALTER TABLE "operadores" ADD COLUMN "firebase_uid" VARCHAR(128) NOT NULL,
ALTER COLUMN "senha_hash" DROP NOT NULL;

-- CreateIndex
CREATE UNIQUE INDEX "operadores_firebase_uid_key" ON "operadores"("firebase_uid");
