-- =====================================================
-- Supabase Setup — Portfólio Marco Albornoz
-- Execute todo este SQL no SQL Editor do Supabase
-- (Dashboard > SQL Editor > New Query > Colar > Run)
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

-- Adiciona colunas que podem faltar em tabelas já existentes
ALTER TABLE public.portfolio_config ADD COLUMN IF NOT EXISTS created_at TIMESTAMPTZ NOT NULL DEFAULT NOW();
ALTER TABLE public.portfolio_projects ADD COLUMN IF NOT EXISTS created_at TIMESTAMPTZ NOT NULL DEFAULT NOW();
ALTER TABLE public.portfolio_messages ADD COLUMN IF NOT EXISTS created_at TIMESTAMPTZ NOT NULL DEFAULT NOW();

-- 3. TABELA: portfolio_messages
CREATE TABLE IF NOT EXISTS public.portfolio_messages (
  id BIGSERIAL PRIMARY KEY,
  name TEXT NOT NULL DEFAULT '',
  email TEXT NOT NULL DEFAULT '',
  message TEXT NOT NULL DEFAULT '',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ── Índices ──
CREATE INDEX IF NOT EXISTS idx_projects_sort ON public.portfolio_projects (sort_order ASC);
CREATE INDEX IF NOT EXISTS idx_messages_created ON public.portfolio_messages (created_at DESC);

-- ── Triggers para atualizar created_at automaticamente ──
CREATE OR REPLACE FUNCTION public.set_created_at()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.created_at IS NULL THEN
    NEW.created_at = NOW();
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_projects_created ON public.portfolio_projects;
CREATE TRIGGER trg_projects_created
  BEFORE INSERT ON public.portfolio_projects
  FOR EACH ROW EXECUTE FUNCTION public.set_created_at();

DROP TRIGGER IF EXISTS trg_config_created ON public.portfolio_config;
CREATE TRIGGER trg_config_created
  BEFORE INSERT ON public.portfolio_config
  FOR EACH ROW EXECUTE FUNCTION public.set_created_at();

DROP TRIGGER IF EXISTS trg_messages_created ON public.portfolio_messages;
CREATE TRIGGER trg_messages_created
  BEFORE INSERT ON public.portfolio_messages
  FOR EACH ROW EXECUTE FUNCTION public.set_created_at();

-- ── Row Level Security ──
ALTER TABLE public.portfolio_projects ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.portfolio_config ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.portfolio_messages ENABLE ROW LEVEL SECURITY;

-- ── POLICIES: anon pode fazer tudo (necessário para o anon key do frontend) ──
-- portfolio_projects
DROP POLICY IF EXISTS "anon_all_projects" ON public.portfolio_projects;
CREATE POLICY "anon_all_projects" ON public.portfolio_projects
  FOR ALL USING (true) WITH CHECK (true);

-- portfolio_config
DROP POLICY IF EXISTS "anon_all_config" ON public.portfolio_config;
CREATE POLICY "anon_all_config" ON public.portfolio_config
  FOR ALL USING (true) WITH CHECK (true);

-- portfolio_messages
DROP POLICY IF EXISTS "anon_all_messages" ON public.portfolio_messages;
CREATE POLICY "anon_all_messages" ON public.portfolio_messages
  FOR ALL USING (true) WITH CHECK (true);

-- ═════════════════════════════════════════════════════════
-- STORAGE BUCKET: project-covers
-- ═════════════════════════════════════════════════════════

-- 4. Criar bucket de storage para imagens de capa dos projetos
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES ('project-covers', 'project-covers', true, 5242880, '{"image/jpeg","image/png","image/webp","image/gif"}')
ON CONFLICT (id) DO NOTHING;

-- 5. RLS Policies para o bucket project-covers
-- Permite leitura anônima (necessário para exibir imagens)
DROP POLICY IF EXISTS "Public Read project-covers" ON storage.objects;
CREATE POLICY "Public Read project-covers" ON storage.objects
  FOR SELECT USING (bucket_id = 'project-covers');

-- Permite inserção anônima (upload de imagens do frontend)
DROP POLICY IF EXISTS "Public Insert project-covers" ON storage.objects;
CREATE POLICY "Public Insert project-covers" ON storage.objects
  FOR INSERT WITH CHECK (bucket_id = 'project-covers');

-- Permite atualização anônima
DROP POLICY IF EXISTS "Public Update project-covers" ON storage.objects;
CREATE POLICY "Public Update project-covers" ON storage.objects
  FOR UPDATE USING (bucket_id = 'project-covers') WITH CHECK (bucket_id = 'project-covers');

-- Permite exclusão anônima (necessário para o delete-all-then-insert)
DROP POLICY IF EXISTS "Public Delete project-covers" ON storage.objects;
CREATE POLICY "Public Delete project-covers" ON storage.objects
  FOR DELETE USING (bucket_id = 'project-covers');

-- ═════════════════════════════════════════════════════════
-- VERIFICAÇÃO
-- ═════════════════════════════════════════════════════════
-- Após executar tudo, rode esta consulta para confirmar:
-- SELECT * FROM storage.buckets WHERE id = 'project-covers';

-- ── (Opcional) Criar função edge de ping para teste ──
CREATE OR REPLACE FUNCTION public.ping()
RETURNS TEXT LANGUAGE sql AS $$ SELECT 'pong'::TEXT; $$;

-- ── (Opcional) Seed inicial: insere alguns dados se a tabela estiver vazia ──
INSERT INTO public.portfolio_config (key, value)
SELECT k, v FROM (VALUES
  ('logoText', '"MA"'),
  ('logoType', '"text"'),
  ('aboutTitle', '"Sobre Mim"'),
  ('aboutHidePhoto', 'false'),
  ('aboutContent', '"Designer de produto com 6 anos de experiência transformando problemas complexos em experiências digitais memoráveis. Trabalhei com startups, fintechs e grandes marcas.\n\nAcredito que bom design é invisível — quando funciona, as pessoas não percebem.\n\nAtualmente sou Lead Designer em uma plataforma de saúde digital."'),
  ('socialLinks', '[{"platform":"Instagram","url":"","icon":"instagram"},{"platform":"WhatsApp","url":"","icon":"whatsapp"}]')
) AS t(k, v)
WHERE NOT EXISTS (SELECT 1 FROM public.portfolio_config WHERE key = t.k);
