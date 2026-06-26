-- =====================================================
-- Supabase Setup — Portfólio Marco Albornoz
-- Execute todo este SQL no SQL Editor do Supabase
-- Dashboard > SQL Editor > New Query > Colar > Run
-- =====================================================

-- 1. TABELA: portfolio_projects
CREATE TABLE IF NOT EXISTS public.portfolio_projects (
  id BIGSERIAL PRIMARY KEY,
  title TEXT NOT NULL DEFAULT '',
  category TEXT NOT NULL DEFAULT '',
  description TEXT NOT NULL DEFAULT '',
  image TEXT NOT NULL DEFAULT '',
  link TEXT NOT NULL DEFAULT '',
  sort_order BIGINT NOT NULL DEFAULT 0,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 2. TABELA: portfolio_config
CREATE TABLE IF NOT EXISTS public.portfolio_config (
  key TEXT PRIMARY KEY,
  value TEXT NOT NULL DEFAULT '',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 3. TABELA: portfolio_messages
CREATE TABLE IF NOT EXISTS public.portfolio_messages (
  id BIGSERIAL PRIMARY KEY,
  name TEXT NOT NULL DEFAULT '',
  email TEXT NOT NULL DEFAULT '',
  message TEXT NOT NULL DEFAULT '',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Adiciona colunas que podem faltar em tabelas já existentes
ALTER TABLE public.portfolio_config ADD COLUMN IF NOT EXISTS created_at TIMESTAMPTZ NOT NULL DEFAULT NOW();
ALTER TABLE public.portfolio_projects ADD COLUMN IF NOT EXISTS created_at TIMESTAMPTZ NOT NULL DEFAULT NOW();
ALTER TABLE public.portfolio_messages ADD COLUMN IF NOT EXISTS created_at TIMESTAMPTZ NOT NULL DEFAULT NOW();

-- Índices
CREATE INDEX IF NOT EXISTS idx_projects_sort ON public.portfolio_projects (sort_order ASC);
CREATE INDEX IF NOT EXISTS idx_messages_created ON public.portfolio_messages (created_at DESC);

-- Row Level Security
ALTER TABLE public.portfolio_projects ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.portfolio_config ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.portfolio_messages ENABLE ROW LEVEL SECURITY;

-- POLICIES: anon pode fazer tudo (necessário para o anon key do frontend)
DROP POLICY IF EXISTS "anon_all_projects" ON public.portfolio_projects;
CREATE POLICY "anon_all_projects" ON public.portfolio_projects
  FOR ALL USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS "anon_all_config" ON public.portfolio_config;
CREATE POLICY "anon_all_config" ON public.portfolio_config
  FOR ALL USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS "anon_all_messages" ON public.portfolio_messages;
CREATE POLICY "anon_all_messages" ON public.portfolio_messages
  FOR ALL USING (true) WITH CHECK (true);

-- =====================================================
-- STORAGE BUCKET: portfolio
-- IMPORTANTE: O bucket de storage PRECISA ser criado
-- via SQL porque a chave anon não pode criar buckets.
-- Após executar este SQL, o bucket "portfolio" estará
-- disponível para upload público de imagens.
-- =====================================================

-- Cria o bucket "portfolio" (público, até 20MB por arquivo)
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES ('portfolio', 'portfolio', true, 20971520, '{"image/jpeg","image/png","image/webp","image/avif","image/gif"}')
ON CONFLICT (id) DO NOTHING;

-- Remove bucket antigo se existir
DELETE FROM storage.buckets WHERE id = 'project-covers' AND id NOT IN (SELECT id FROM storage.buckets WHERE id = 'portfolio');

-- RLS Policies para o bucket portfolio
DROP POLICY IF EXISTS "Public Read portfolio" ON storage.objects;
CREATE POLICY "Public Read portfolio" ON storage.objects
  FOR SELECT USING (bucket_id = 'portfolio');

DROP POLICY IF EXISTS "Public Insert portfolio" ON storage.objects;
CREATE POLICY "Public Insert portfolio" ON storage.objects
  FOR INSERT WITH CHECK (bucket_id = 'portfolio');

DROP POLICY IF EXISTS "Public Update portfolio" ON storage.objects;
CREATE POLICY "Public Update portfolio" ON storage.objects
  FOR UPDATE USING (bucket_id = 'portfolio') WITH CHECK (bucket_id = 'portfolio');

DROP POLICY IF EXISTS "Public Delete portfolio" ON storage.objects;
CREATE POLICY "Public Delete portfolio" ON storage.objects
  FOR DELETE USING (bucket_id = 'portfolio');

-- =====================================================
-- (Opcional) Seed inicial para config
-- =====================================================
INSERT INTO public.portfolio_config (key, value)
SELECT k, v FROM (VALUES
  ('logoText', '"MA"'),
  ('logoType', '"text"'),
  ('aboutTitle', '"Sobre Mim"'),
  ('aboutHidePhoto', 'false'),
  ('aboutContent', '"Designer de produto com 6 anos de experiência transformando problemas complexos em experiências digitais memoráveis."'),
  ('socialLinks', '[{"platform":"Instagram","url":"","icon":"instagram"},{"platform":"WhatsApp","url":"","icon":"whatsapp"}]')
) AS t(k, v)
WHERE NOT EXISTS (SELECT 1 FROM public.portfolio_config WHERE key = t.k);
