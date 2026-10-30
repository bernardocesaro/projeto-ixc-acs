-- CreateSchema
CREATE SCHEMA IF NOT EXISTS "public";

-- CreateEnum
CREATE TYPE "status_contrato" AS ENUM ('ATIVO', 'SUSPENSO', 'CANCELADO');

-- CreateEnum
CREATE TYPE "sistema_operacional" AS ENUM ('ANDROID', 'IOS', 'OUTRO');

-- CreateEnum
CREATE TYPE "status_teste" AS ENUM ('SUCESSO', 'ALERTA', 'FALHA', 'ERRO');

-- CreateEnum
CREATE TYPE "origem_teste" AS ENUM ('MANUAL', 'REMOTO');

-- CreateEnum
CREATE TYPE "tipo_teste" AS ENUM ('COMPLETO', 'WIFI', 'LATENCIA');

-- CreateEnum
CREATE TYPE "tipo_notificacao" AS ENUM ('SOLICITACAO_TESTE_REMOTO', 'TESTE_CONCLUIDO', 'PARAMETRO_NORMALIZADO', 'AVISO');

-- CreateEnum
CREATE TYPE "status_leitura" AS ENUM ('NAO_LIDA', 'LIDA');

-- CreateEnum
CREATE TYPE "tipo_relatorio" AS ENUM ('TESTES', 'CLIENTE', 'INCIDENTE');

-- CreateEnum
CREATE TYPE "formato_relatorio" AS ENUM ('PDF');

-- CreateEnum
CREATE TYPE "status_relatorio" AS ENUM ('PROCESSANDO', 'CONCLUIDO', 'ERRO');

-- CreateEnum
CREATE TYPE "nivel_acesso" AS ENUM ('ADMIN', 'OPERADOR', 'LEITURA');

-- CreateEnum
CREATE TYPE "status_operador" AS ENUM ('ATIVO', 'INATIVO');

-- CreateEnum
CREATE TYPE "status_autorizacao" AS ENUM ('PENDENTE', 'AUTORIZADO', 'RECUSADO', 'EXPIRADO');

-- CreateTable
CREATE TABLE "provedores" (
    "id_provedor" SERIAL NOT NULL,
    "nome" VARCHAR(150) NOT NULL,
    "cnpj" VARCHAR(14) NOT NULL,
    "faixas_ip" TEXT[],
    "ativo" BOOLEAN NOT NULL DEFAULT true,
    "data_cadastro" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "provedores_pkey" PRIMARY KEY ("id_provedor")
);

-- CreateTable
CREATE TABLE "clientes" (
    "id_cliente" SERIAL NOT NULL,
    "id_provedor" INTEGER NOT NULL,
    "codigo_ixc" VARCHAR(50),
    "nome" VARCHAR(150) NOT NULL,
    "email" VARCHAR(150),
    "telefone" VARCHAR(20),
    "usuario_wifi" VARCHAR(100) NOT NULL,
    "status_contrato" "status_contrato" NOT NULL DEFAULT 'ATIVO',
    "aceite_termos" BOOLEAN NOT NULL DEFAULT false,
    "data_aceite_termos" TIMESTAMP(3),
    "notificacoes_habilitadas" BOOLEAN NOT NULL DEFAULT true,
    "data_cadastro" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "clientes_pkey" PRIMARY KEY ("id_cliente")
);

-- CreateTable
CREATE TABLE "dispositivos" (
    "id_dispositivo" SERIAL NOT NULL,
    "id_provedor" INTEGER NOT NULL,
    "id_cliente" INTEGER NOT NULL,
    "mac_address" VARCHAR(17) NOT NULL,
    "modelo" VARCHAR(100),
    "sistema_operacional" "sistema_operacional",
    "versao_so" VARCHAR(30),
    "fabricante" VARCHAR(100),
    "data_cadastro" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "dispositivos_pkey" PRIMARY KEY ("id_dispositivo")
);

-- CreateTable
CREATE TABLE "testes" (
    "id_teste" SERIAL NOT NULL,
    "id_provedor" INTEGER NOT NULL,
    "id_dispositivo" INTEGER NOT NULL,
    "id_operador" INTEGER,
    "data_hora_inicio" TIMESTAMP(3) NOT NULL,
    "data_hora_fim" TIMESTAMP(3),
    "status" "status_teste" NOT NULL,
    "origem_teste" "origem_teste" NOT NULL DEFAULT 'MANUAL',
    "tipo_teste" "tipo_teste" NOT NULL DEFAULT 'COMPLETO',
    "autorizado_cliente" BOOLEAN NOT NULL DEFAULT true,
    "ssid" VARCHAR(64),
    "intensidade_sinal_dbm" DOUBLE PRECISION,
    "frequencia_ghz" DOUBLE PRECISION,
    "latencia_ping_ms" DOUBLE PRECISION,
    "jitter_ms" DOUBLE PRECISION,
    "perda_pacotes_percentual" DOUBLE PRECISION,
    "outros_parametros" JSONB,
    "data_registro" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "testes_pkey" PRIMARY KEY ("id_teste")
);

-- CreateTable
CREATE TABLE "operadores" (
    "id_operador" SERIAL NOT NULL,
    "id_provedor" INTEGER NOT NULL,
    "nome" VARCHAR(150) NOT NULL,
    "login" VARCHAR(100) NOT NULL,
    "senha_hash" VARCHAR(255) NOT NULL,
    "nivel_acesso" "nivel_acesso" NOT NULL DEFAULT 'OPERADOR',
    "status" "status_operador" NOT NULL DEFAULT 'ATIVO',
    "ultimo_acesso" TIMESTAMP(3),
    "data_cadastro" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "operadores_pkey" PRIMARY KEY ("id_operador")
);

-- CreateTable
CREATE TABLE "notificacoes" (
    "id_notificacao" SERIAL NOT NULL,
    "id_provedor" INTEGER NOT NULL,
    "id_cliente" INTEGER NOT NULL,
    "id_teste" INTEGER,
    "mensagem" TEXT NOT NULL,
    "tipo" "tipo_notificacao" NOT NULL,
    "status_leitura" "status_leitura" NOT NULL DEFAULT 'NAO_LIDA',
    "data_envio" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "notificacoes_pkey" PRIMARY KEY ("id_notificacao")
);

-- CreateTable
CREATE TABLE "relatorios" (
    "id_relatorio" SERIAL NOT NULL,
    "id_provedor" INTEGER NOT NULL,
    "id_operador" INTEGER NOT NULL,
    "data_geracao" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "tipo_relatorio" "tipo_relatorio" NOT NULL DEFAULT 'TESTES',
    "formato" "formato_relatorio" NOT NULL DEFAULT 'PDF',
    "status" "status_relatorio" NOT NULL DEFAULT 'PROCESSANDO',
    "filtros_aplicados" JSONB,

    CONSTRAINT "relatorios_pkey" PRIMARY KEY ("id_relatorio")
);

-- CreateTable
CREATE TABLE "logs_acoes" (
    "id_log" SERIAL NOT NULL,
    "id_provedor" INTEGER NOT NULL,
    "id_operador" INTEGER NOT NULL,
    "acao" VARCHAR(100) NOT NULL,
    "entidade_afetada" VARCHAR(50),
    "id_entidade_afetada" INTEGER,
    "detalhes" JSONB,
    "data_hora" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "ip_origem" VARCHAR(45),

    CONSTRAINT "logs_acoes_pkey" PRIMARY KEY ("id_log")
);

-- CreateTable
CREATE TABLE "autorizacoes_teste_remoto" (
    "id_autorizacao" SERIAL NOT NULL,
    "id_provedor" INTEGER NOT NULL,
    "id_cliente" INTEGER NOT NULL,
    "id_operador" INTEGER NOT NULL,
    "id_teste" INTEGER,
    "status" "status_autorizacao" NOT NULL DEFAULT 'PENDENTE',
    "data_solicitacao" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "data_resposta" TIMESTAMP(3),

    CONSTRAINT "autorizacoes_teste_remoto_pkey" PRIMARY KEY ("id_autorizacao")
);

-- CreateIndex
CREATE UNIQUE INDEX "provedores_cnpj_key" ON "provedores"("cnpj");

-- CreateIndex
CREATE INDEX "clientes_id_provedor_idx" ON "clientes"("id_provedor");

-- CreateIndex
CREATE UNIQUE INDEX "clientes_id_provedor_usuario_wifi_key" ON "clientes"("id_provedor", "usuario_wifi");

-- CreateIndex
CREATE UNIQUE INDEX "clientes_id_provedor_codigo_ixc_key" ON "clientes"("id_provedor", "codigo_ixc");

-- CreateIndex
CREATE INDEX "dispositivos_id_cliente_idx" ON "dispositivos"("id_cliente");

-- CreateIndex
CREATE UNIQUE INDEX "dispositivos_id_provedor_mac_address_key" ON "dispositivos"("id_provedor", "mac_address");

-- CreateIndex
CREATE INDEX "testes_id_provedor_data_hora_inicio_idx" ON "testes"("id_provedor", "data_hora_inicio");

-- CreateIndex
CREATE INDEX "testes_id_dispositivo_data_hora_inicio_idx" ON "testes"("id_dispositivo", "data_hora_inicio");

-- CreateIndex
CREATE INDEX "testes_id_provedor_status_idx" ON "testes"("id_provedor", "status");

-- CreateIndex
CREATE UNIQUE INDEX "operadores_login_key" ON "operadores"("login");

-- CreateIndex
CREATE INDEX "operadores_id_provedor_idx" ON "operadores"("id_provedor");

-- CreateIndex
CREATE INDEX "notificacoes_id_cliente_data_envio_idx" ON "notificacoes"("id_cliente", "data_envio");

-- CreateIndex
CREATE INDEX "relatorios_id_provedor_data_geracao_idx" ON "relatorios"("id_provedor", "data_geracao");

-- CreateIndex
CREATE INDEX "logs_acoes_id_provedor_data_hora_idx" ON "logs_acoes"("id_provedor", "data_hora");

-- CreateIndex
CREATE INDEX "logs_acoes_id_operador_idx" ON "logs_acoes"("id_operador");

-- CreateIndex
CREATE UNIQUE INDEX "autorizacoes_teste_remoto_id_teste_key" ON "autorizacoes_teste_remoto"("id_teste");

-- CreateIndex
CREATE INDEX "autorizacoes_teste_remoto_id_provedor_status_idx" ON "autorizacoes_teste_remoto"("id_provedor", "status");

-- CreateIndex
CREATE INDEX "autorizacoes_teste_remoto_id_cliente_idx" ON "autorizacoes_teste_remoto"("id_cliente");

-- AddForeignKey
ALTER TABLE "clientes" ADD CONSTRAINT "clientes_id_provedor_fkey" FOREIGN KEY ("id_provedor") REFERENCES "provedores"("id_provedor") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "dispositivos" ADD CONSTRAINT "dispositivos_id_provedor_fkey" FOREIGN KEY ("id_provedor") REFERENCES "provedores"("id_provedor") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "dispositivos" ADD CONSTRAINT "dispositivos_id_cliente_fkey" FOREIGN KEY ("id_cliente") REFERENCES "clientes"("id_cliente") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "testes" ADD CONSTRAINT "testes_id_provedor_fkey" FOREIGN KEY ("id_provedor") REFERENCES "provedores"("id_provedor") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "testes" ADD CONSTRAINT "testes_id_dispositivo_fkey" FOREIGN KEY ("id_dispositivo") REFERENCES "dispositivos"("id_dispositivo") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "testes" ADD CONSTRAINT "testes_id_operador_fkey" FOREIGN KEY ("id_operador") REFERENCES "operadores"("id_operador") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "operadores" ADD CONSTRAINT "operadores_id_provedor_fkey" FOREIGN KEY ("id_provedor") REFERENCES "provedores"("id_provedor") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "notificacoes" ADD CONSTRAINT "notificacoes_id_provedor_fkey" FOREIGN KEY ("id_provedor") REFERENCES "provedores"("id_provedor") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "notificacoes" ADD CONSTRAINT "notificacoes_id_cliente_fkey" FOREIGN KEY ("id_cliente") REFERENCES "clientes"("id_cliente") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "notificacoes" ADD CONSTRAINT "notificacoes_id_teste_fkey" FOREIGN KEY ("id_teste") REFERENCES "testes"("id_teste") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "relatorios" ADD CONSTRAINT "relatorios_id_provedor_fkey" FOREIGN KEY ("id_provedor") REFERENCES "provedores"("id_provedor") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "relatorios" ADD CONSTRAINT "relatorios_id_operador_fkey" FOREIGN KEY ("id_operador") REFERENCES "operadores"("id_operador") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "logs_acoes" ADD CONSTRAINT "logs_acoes_id_provedor_fkey" FOREIGN KEY ("id_provedor") REFERENCES "provedores"("id_provedor") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "logs_acoes" ADD CONSTRAINT "logs_acoes_id_operador_fkey" FOREIGN KEY ("id_operador") REFERENCES "operadores"("id_operador") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "autorizacoes_teste_remoto" ADD CONSTRAINT "autorizacoes_teste_remoto_id_provedor_fkey" FOREIGN KEY ("id_provedor") REFERENCES "provedores"("id_provedor") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "autorizacoes_teste_remoto" ADD CONSTRAINT "autorizacoes_teste_remoto_id_cliente_fkey" FOREIGN KEY ("id_cliente") REFERENCES "clientes"("id_cliente") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "autorizacoes_teste_remoto" ADD CONSTRAINT "autorizacoes_teste_remoto_id_operador_fkey" FOREIGN KEY ("id_operador") REFERENCES "operadores"("id_operador") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "autorizacoes_teste_remoto" ADD CONSTRAINT "autorizacoes_teste_remoto_id_teste_fkey" FOREIGN KEY ("id_teste") REFERENCES "testes"("id_teste") ON DELETE SET NULL ON UPDATE CASCADE;


-- ---------------------------------------------------------------------------
-- Regras de negócio que o Prisma não expressa no schema
-- ---------------------------------------------------------------------------

-- Testes e logs de ações são imutáveis: qualquer UPDATE ou DELETE é bloqueado
-- pelo próprio banco, mesmo que alguém tente pelo painel do Supabase ou SQL.
CREATE OR REPLACE FUNCTION bloquear_alteracao()
RETURNS trigger AS $$
BEGIN
  RAISE EXCEPTION 'Registros da tabela % são imutáveis (operação % não permitida)', TG_TABLE_NAME, TG_OP;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER testes_imutaveis
  BEFORE UPDATE OR DELETE ON "testes"
  FOR EACH ROW EXECUTE FUNCTION bloquear_alteracao();

CREATE TRIGGER logs_acoes_imutaveis
  BEFORE UPDATE OR DELETE ON "logs_acoes"
  FOR EACH ROW EXECUTE FUNCTION bloquear_alteracao();

-- O Supabase expõe o schema public pela API REST (chave anon). Ativar RLS sem
-- políticas bloqueia esse acesso direto: os dados só passam pela nossa API
-- (o Prisma conecta como dono das tabelas, que não é afetado pelo RLS).
ALTER TABLE "provedores" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "clientes" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "dispositivos" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "testes" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "operadores" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "notificacoes" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "relatorios" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "logs_acoes" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "autorizacoes_teste_remoto" ENABLE ROW LEVEL SECURITY;
