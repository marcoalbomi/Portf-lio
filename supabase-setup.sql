-- ============================================================
-- Supabase Setup for Marco Albornoz Portfolio
-- Run this in Supabase SQL Editor
-- https://supabase.com/dashboard/project/ncupaiqjsqkuzjaeonkp/sql/new
-- ============================================================

-- 1. SITE SETTINGS TABLE
CREATE TABLE IF NOT EXISTS site_settings (
  id bigint PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  site_name text DEFAULT 'Marco Albornoz',
  logo_url text DEFAULT '',
  favicon_url text DEFAULT '',
  banner_home_url text DEFAULT '',
  primary_color text DEFAULT '#111111',
  secondary_color text DEFAULT '#f5f5f5',
  whatsapp text DEFAULT '',
  email text DEFAULT '',
  instagram text DEFAULT '',
  facebook text DEFAULT '',
  address text DEFAULT '',
  seo_title text DEFAULT '',
  seo_description text DEFAULT '',
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE site_settings ENABLE ROW LEVEL SECURITY;

CREATE POLICY "public_select_site_settings" ON site_settings
  FOR SELECT TO anon USING (true);
CREATE POLICY "public_insert_site_settings" ON site_settings
  FOR INSERT TO anon WITH CHECK (true);
CREATE POLICY "public_update_site_settings" ON site_settings
  FOR UPDATE TO anon USING (true);
CREATE POLICY "public_delete_site_settings" ON site_settings
  FOR DELETE TO anon USING (true);

-- Ensure there's always exactly one row
INSERT INTO site_settings (site_name, seo_title, seo_description)
VALUES ('Marco Albornoz', 'Portfólio · Marco Albornoz', 'Portfólio de design de Marco Albornoz — UI/UX, produto e direção de arte.')
ON CONFLICT DO NOTHING;

-- 2. STORAGE BUCKET for site images
INSERT INTO storage.buckets (id, name, public)
VALUES ('site-images', 'site-images', true)
ON CONFLICT (id) DO NOTHING;

-- Allow public reads on site-images
CREATE POLICY "public_read_site_images" ON storage.objects
  FOR SELECT TO anon
  USING (bucket_id = 'site-images');

-- Allow anon uploads to site-images
CREATE POLICY "public_insert_site_images" ON storage.objects
  FOR INSERT TO anon
  WITH CHECK (bucket_id = 'site-images');

-- Allow anon deletes from site-images
CREATE POLICY "public_delete_site_images" ON storage.objects
  FOR DELETE TO anon
  USING (bucket_id = 'site-images');
