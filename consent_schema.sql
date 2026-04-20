-- 🛡️ ABHA++ Consent Infrastructure Schema
-- Run AFTER the main supabase_schema.sql

-- 1. CONSENT REQUESTS (incoming requests from HIUs)
create table if not exists public.consent_requests (
  id uuid primary key default gen_random_uuid(),
  patient_id uuid references auth.users on delete cascade not null,
  requester_id uuid references public.doctors,
  requester_name text not null,
  requester_specialty text,
  requester_avatar text,
  data_scope text[] not null, -- e.g. {'lab_reports','prescriptions','vitals'}
  purpose text not null, -- treatment, insurance, second_opinion, research
  duration_days integer default 7,
  access_type text default 'view_only', -- view_only, download, continuous
  status text default 'pending', -- pending, approved, denied, expired
  message text, -- optional message from requester
  created_at timestamptz default now(),
  responded_at timestamptz
);

-- 2. CONSENTS (signed consent artifacts)
create table if not exists public.consents (
  id uuid primary key default gen_random_uuid(),
  request_id uuid references public.consent_requests on delete cascade,
  patient_id uuid references auth.users on delete cascade not null,
  requester_name text not null,
  requester_specialty text,
  data_scope text[] not null,
  purpose text not null,
  access_type text default 'view_only',
  valid_from timestamptz default now(),
  valid_till timestamptz not null,
  status text default 'approved', -- approved, revoked, expired
  revoked_at timestamptz,
  blockchain_hash text, -- future: Polygon TX hash
  created_at timestamptz default now()
);

-- 3. DATA RECORDS (encrypted health records)
create table if not exists public.data_records (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users on delete cascade not null,
  record_type text not null, -- lab_reports, prescriptions, radiology, vitals
  title text not null,
  description text,
  file_url text, -- Supabase Storage path
  file_hash text, -- SHA-256 hash for integrity verification
  metadata jsonb, -- flexible: test results, doctor name, etc.
  is_verified boolean default false,
  uploaded_at timestamptz default now()
);

-- 4. ACCESS LOGS (immutable audit trail)
create table if not exists public.access_logs (
  id uuid primary key default gen_random_uuid(),
  patient_id uuid references auth.users on delete cascade not null,
  actor_name text not null, -- who performed the action
  action text not null, -- VIEW, GRANT, DENY, REVOKE, UPLOAD, DOWNLOAD
  record_type text, -- what type of data was accessed
  record_id uuid,
  consent_id uuid references public.consents,
  ip_address text,
  details text, -- human-readable description
  blockchain_hash text, -- future: Polygon TX hash
  created_at timestamptz default now()
);

-- 5. RLS POLICIES

-- Consent Requests: users see only their own
alter table public.consent_requests enable row level security;
drop policy if exists "Users see own requests" on public.consent_requests;
create policy "Users see own requests" on public.consent_requests
  for select using (auth.uid() = patient_id);
drop policy if exists "Users respond to requests" on public.consent_requests;
create policy "Users respond to requests" on public.consent_requests
  for update using (auth.uid() = patient_id);
-- Allow system/doctors to insert requests (simplified for now)
drop policy if exists "Anyone can create requests" on public.consent_requests;
create policy "Anyone can create requests" on public.consent_requests
  for insert with check (true);

-- Consents: users see only their own
alter table public.consents enable row level security;
drop policy if exists "Users see own consents" on public.consents;
create policy "Users see own consents" on public.consents
  for select using (auth.uid() = patient_id);
drop policy if exists "Users create consents" on public.consents;
create policy "Users create consents" on public.consents
  for insert with check (auth.uid() = patient_id);
drop policy if exists "Users update own consents" on public.consents;
create policy "Users update own consents" on public.consents
  for update using (auth.uid() = patient_id);

-- Data Records: users see only their own
alter table public.data_records enable row level security;
drop policy if exists "Users manage own records" on public.data_records;
create policy "Users manage own records" on public.data_records
  for all using (auth.uid() = user_id);

-- Access Logs: users see only their own, APPEND-ONLY (no update/delete)
alter table public.access_logs enable row level security;
drop policy if exists "Users see own logs" on public.access_logs;
create policy "Users see own logs" on public.access_logs
  for select using (auth.uid() = patient_id);
drop policy if exists "System inserts logs" on public.access_logs;
create policy "System inserts logs" on public.access_logs
  for insert with check (auth.uid() = patient_id);

-- 6. REALTIME for consent requests (push notifications)
do $$
begin
  if not exists (select 1 from pg_publication_tables where pubname = 'supabase_realtime' and schemaname = 'public' and tablename = 'consent_requests') then
    alter publication supabase_realtime add table public.consent_requests;
  end if;
end $$;

-- 7. SEED SAMPLE CONSENT REQUESTS (for testing)
-- These will only work after a user signs up. Run manually or skip.
-- insert into public.consent_requests (patient_id, requester_name, requester_specialty, data_scope, purpose, duration_days, access_type, message)
-- values ('<YOUR_USER_UUID>', 'Dr. Sarah Jenkins', 'Cardiology', '{lab_reports,vitals}', 'treatment', 7, 'view_only', 'I need your recent lab results for your upcoming cardiac checkup.');
