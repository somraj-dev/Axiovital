-- 🚀 Axiovital Vector Search Setup (Supabase Edition)
-- This script enables semantic search for Doctors, Products, and the AI Health Assistant.

-- 1. Ensure extension is enabled
create extension if not exists vector;

-- 2. Add embedding support to existing catalogs
-- We use vector(384) which is optimized for light, fast models like all-MiniLM-L6-v2
alter table public.doctors add column if not exists embedding vector(384);
alter table public.products add column if not exists embedding vector(384);

-- 3. Create a specialized Knowledge Base for the AI Assistant
create table if not exists public.ai_knowledge_base (
  id uuid primary key default gen_random_uuid(),
  content text not null,
  metadata jsonb,
  embedding vector(384),
  created_at timestamptz default now()
);

-- 4. Enable RLS for Knowledge Base
alter table public.ai_knowledge_base enable row level security;
create policy "Public Knowledge Access" on public.ai_knowledge_base for select using (true);

-- 5. Create the Vector Search Function (RPC)
-- This function will be called from the Flutter app via supabase.rpc('match_doctors', { query_embedding: [...] })
create or replace function match_doctors (
  query_embedding vector(384),
  match_threshold float,
  match_count int
)
returns table (
  id uuid,
  name text,
  specialty text,
  similarity float
)
language plpgsql
as $$
begin
  return query
  select
    doctors.id,
    doctors.name,
    doctors.specialty,
    1 - (doctors.embedding <=> query_embedding) as similarity
  from doctors
  where 1 - (doctors.embedding <=> query_embedding) > match_threshold
  order by similarity desc
  limit match_count;
end;
$$;

-- 6. Generic Knowledge Search Function
create or replace function search_health_assistant (
  query_embedding vector(384),
  match_threshold float,
  match_count int
)
returns table (
  id uuid,
  content text,
  metadata jsonb,
  similarity float
)
language plpgsql
as $$
begin
  return query
  select
    kb.id,
    kb.content,
    kb.metadata,
    1 - (kb.embedding <=> query_embedding) as similarity
  from ai_knowledge_base kb
  where 1 - (kb.embedding <=> query_embedding) > match_threshold
  order by similarity desc
  limit match_count;
end;
$$;

-- 7. Add HNSW Index for ultra-fast performance
create index if not exists doctors_embedding_idx on public.doctors using hnsw (embedding vector_cosine_ops);
create index if not exists ai_kb_embedding_idx on public.ai_knowledge_base using hnsw (embedding vector_cosine_ops);
