-- 🏛️ Axiovital ULTIMATE Cloud Database Schema
-- Covers: Profiles, Doctors, Products, Vitals, Insurance, Labs, Communities, Habits, TrackCoins, and Appointments.

-- 1. EXTENSIONS
create extension if not exists vector;

-- 2. USER & PATIENTS
create table if not exists public.profiles (
  id uuid references auth.users on delete cascade primary key,
  clinical_id text unique,
  name text,
  avatar_url text,
  dob text,
  gender text,
  email text,
  phone text,
  address text,
  height text,
  weight text,
  blood_group text,
  membership_type text default 'FREE MEMBER',
  member_since text default to_char(now(), 'Mon YYYY'),
  is_two_factor_enabled boolean default false,
  digital_twin_status text default 'Inactive',
  wearable_status text default 'DISCONNECTED',
  created_at timestamptz default now()
);

create table if not exists public.patients (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users on delete cascade,
  name text not null,
  gender text,
  age integer,
  image_path text,
  relation text, -- Me, spouse, child, etc
  created_at timestamptz default now()
);

-- 3. MEDICAL CATALOG (Doctors, Products, Labs)
create table if not exists public.doctors (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  specialty text not null,
  qualifications text,
  image_url text,
  session_price integer,
  card_color_hex text default '#E2E8F0',
  rating real default 4.5,
  review_count integer default 0,
  about text,
  created_at timestamptz default now()
);

create table if not exists public.products (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  brand text,
  quantity text,
  rating real default 5.0,
  rating_count integer default 0,
  delivery_date text default 'Tomorrow',
  current_price real,
  original_price real,
  discount integer,
  image_path text,
  category text, 
  is_best_seller boolean default false,
  description text,
  created_at timestamptz default now()
);

create table if not exists public.lab_packages (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  discount_tag text,
  image_url text,
  test_count integer,
  current_price real,
  original_price real,
  is_most_booked boolean default false,
  category text, -- Women, Men, etc
  created_at timestamptz default now()
);

-- 4. INSURANCE
create table if not exists public.insurance_plans (
  id uuid primary key default gen_random_uuid(),
  insurer_name text not null,
  insurer_logo text,
  plan_name text not null,
  monthly_premium real,
  old_premium real,
  discount_percent real,
  tags text[], 
  highlights jsonb, -- Array of {title, subtitle, icon, color}
  features jsonb, -- Grouped features
  riders jsonb, 
  cashless_hospitals_count integer,
  created_at timestamptz default now()
);

-- 5. TRACKCOINS & HABITS
create table if not exists public.trackcoin_transactions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users on delete cascade,
  type text, -- earned, spent, refund, bonus, expired
  amount integer not null,
  title text not null,
  source text,
  status text default 'completed',
  reference_id text,
  created_at timestamptz default now()
);

create table if not exists public.user_habits (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users on delete cascade,
  activity text not null,
  target_value real,
  current_value real default 0.0,
  streak integer default 0,
  status text default 'available',
  color_hex text,
  icon_name text,
  last_updated timestamptz default now()
);

-- 6. COMMUNITY & CHAT
create table if not exists public.community_threads (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  avatar_url text,
  type text, -- oneOnOne, group
  created_by uuid references auth.users,
  created_at timestamptz default now()
);

create table if not exists public.community_messages (
  id uuid primary key default gen_random_uuid(),
  thread_id uuid references public.community_threads on delete cascade,
  sender_id uuid references auth.users,
  text text not null,
  is_call_log boolean default false,
  status text default 'sent', -- sent, delivered, read
  created_at timestamptz default now()
);

-- 7. APPOINTMENTS & ORDERS
create table if not exists public.orders (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users on delete cascade,
  total_amount real not null,
  status text default 'Processing',
  payment_method text,
  order_date timestamptz default now()
);

create table if not exists public.order_items (
  id uuid primary key default gen_random_uuid(),
  order_id uuid references public.orders on delete cascade,
  product_id text, -- ID of doctor, lab test, or product
  item_type text, -- LabTest, Appointment, Essential, etc
  name text,
  price real,
  patient_id uuid references public.patients,
  appointment_date text,
  time_slot text,
  created_at timestamptz default now()
);

create table if not exists public.vitals (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users on delete cascade,
  type text not null,
  value text not null,
  unit text,
  recorded_at timestamptz default now()
);

-- 8. ROW LEVEL SECURITY (RLS)
-- Profiles
alter table public.profiles enable row level security;
drop policy if exists "Users can view profile" on public.profiles;
create policy "Users can view profile" on public.profiles for select using (auth.uid() = id);
drop policy if exists "Users can update profile" on public.profiles;
create policy "Users can update profile" on public.profiles for update using (auth.uid() = id);

-- Patients
alter table public.patients enable row level security;
drop policy if exists "Users can manage patients" on public.patients;
create policy "Users can manage patients" on public.patients for all using (auth.uid() = user_id);

-- Orders & Items
alter table public.orders enable row level security;
drop policy if exists "Users can view orders" on public.orders;
create policy "Users can view orders" on public.orders for select using (auth.uid() = user_id);
drop policy if exists "Users can insert orders" on public.orders;
create policy "Users can insert orders" on public.orders for insert with check (auth.uid() = user_id);

alter table public.order_items enable row level security;
drop policy if exists "Users can view items" on public.order_items;
create policy "Users can view items" on public.order_items for select using (
  exists (select 1 from public.orders where id = order_id and user_id = auth.uid())
);

-- Messages
alter table public.community_messages enable row level security;
drop policy if exists "Users can view messages" on public.community_messages;
create policy "Users can view messages" on public.community_messages for select using (true); 
drop policy if exists "Users can send messages" on public.community_messages;
create policy "Users can send messages" on public.community_messages for insert with check (auth.uid() = sender_id);

-- Vitals
alter table public.vitals enable row level security;
drop policy if exists "Users can manage vitals" on public.vitals;
create policy "Users can manage vitals" on public.vitals for all using (auth.uid() = user_id);

-- Habit Tracking
alter table public.user_habits enable row level security;
drop policy if exists "Users can manage habits" on public.user_habits;
create policy "Users can manage habits" on public.user_habits for all using (auth.uid() = user_id);

-- Global Catalogs (Public View)
alter table public.doctors enable row level security;
drop policy if exists "Public Doctors" on public.doctors;
create policy "Public Doctors" on public.doctors for select using (true);

alter table public.products enable row level security;
drop policy if exists "Public Products" on public.products;
create policy "Public Products" on public.products for select using (true);

alter table public.lab_packages enable row level security;
drop policy if exists "Public Labs" on public.lab_packages;
create policy "Public Labs" on public.lab_packages for select using (true);

alter table public.insurance_plans enable row level security;
drop policy if exists "Public Insurance" on public.insurance_plans;
create policy "Public Insurance" on public.insurance_plans for select using (true);

-- 9. TRIGGERS
create or replace function public.handle_new_user_ultimate()
returns trigger as $$
begin
  insert into public.profiles (id, email, name, clinical_id)
  values (new.id, new.email, new.raw_user_meta_data->>'name', 'AX-' || floor(random() * 90000 + 10000)::text)
  on conflict (id) do nothing;
  
  -- Create "Me" as first patient
  insert into public.patients (user_id, name, relation, age, gender, image_path)
  values (new.id, coalesce(new.raw_user_meta_data->>'name', 'User'), 'Me', 19, 'Male', 'https://cdn-icons-png.flaticon.com/512/3135/3135715.png')
  on conflict do nothing;
  
  return new;
end;
$$ language plpgsql security definer;

drop trigger if exists on_auth_user_created_ultimate on auth.users;
create trigger on_auth_user_created_ultimate
  after insert on auth.users
  for each row execute procedure public.handle_new_user_ultimate();

-- 10. REALTIME
do $$
begin
  if not exists (select 1 from pg_publication_tables where pubname = 'supabase_realtime' and schemaname = 'public' and tablename = 'community_messages') then
    alter publication supabase_realtime add table public.community_messages;
  end if;
  if not exists (select 1 from pg_publication_tables where pubname = 'supabase_realtime' and schemaname = 'public' and tablename = 'user_habits') then
    alter publication supabase_realtime add table public.user_habits;
  end if;
  if not exists (select 1 from pg_publication_tables where pubname = 'supabase_realtime' and schemaname = 'public' and tablename = 'trackcoin_transactions') then
    alter publication supabase_realtime add table public.trackcoin_transactions;
  end if;
end $$;
