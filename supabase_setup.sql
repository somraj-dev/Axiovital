-- 1. Enable the pgvector extension to work with embeddings
create extension if not exists vector;

-- 2. Create the unified search index table
-- This table stores a "searchable snapshot" of all entities
create table if not exists kavaan_index (
  id uuid primary key default gen_random_uuid(),
  entity_id text not null,       -- Original ID (e.g. VS-99283)
  type text not null,            -- doctor, medicine, lab, user, etc
  name text not null,
  subtitle text,
  description text,
  popularity real default 0.0,
  rating real default 0.0,
  review_count integer default 0,
  price real,
  embedding vector(384),         -- Vector for all-MiniLM-L6-v2 (384 dims)
  metadata jsonb default '{}'    -- Additional info (specialization, location, etc)
);

-- 3. Create high-performance index for vector search
create index on kavaan_index using hnsw (embedding vector_cosine_ops);

-- 4. Create the hybrid search function (RPC)
-- This function handles the vector similarity and returns ranked results
create or replace function match_kavaan(
  query_embedding vector(384),
  match_threshold float,
  match_count int,
  intent_filter text default 'all'
)
returns table (
  id uuid,
  entity_id text,
  type text,
  name text,
  subtitle text,
  description text,
  popularity real,
  rating real,
  review_count integer,
  price real,
  similarity float
)
language plpgsql
as $$
begin
  return query
  select
    ki.id,
    ki.entity_id,
    ki.type,
    ki.name,
    ki.subtitle,
    ki.description,
    ki.popularity,
    ki.rating,
    ki.review_count,
    ki.price,
    1 - (ki.embedding <=> query_embedding) as similarity
  from kavaan_index ki
  where (intent_filter = 'all' or ki.type = intent_filter)
    and 1 - (ki.embedding <=> query_embedding) > match_threshold
  order by similarity desc
  limit match_count;
end;
$$;
