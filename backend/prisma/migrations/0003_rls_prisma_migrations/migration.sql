-- Ativa o RLS na tabela interna do Prisma que guarda o histórico de migrations.
-- Sem isso, quem tiver a chave pública (anon) do Supabase consegue ler e
-- alterar esse histórico pela API do Supabase.
-- O Prisma continua funcionando normalmente: ele conecta como dono da
-- tabela, e o dono não é bloqueado pelo RLS.
ALTER TABLE "_prisma_migrations" ENABLE ROW LEVEL SECURITY;
