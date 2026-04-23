-- 🏥 Axiovital Booking System Schema
-- Covers: Doctor Slots, Appointments, Lab Bookings

-- 1. DOCTOR SLOTS (available time slots per doctor)
create table if not exists public.doctor_slots (
  id uuid primary key default gen_random_uuid(),
  doctor_id uuid references public.doctors on delete cascade,
  slot_date date not null,
  slot_time text not null,
  slot_type text default 'clinic',  -- 'clinic' | 'online'
  is_booked boolean default false,
  created_at timestamptz default now()
);

-- 2. APPOINTMENTS (booked doctor appointments)
create table if not exists public.appointments (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users on delete cascade,
  doctor_id uuid references public.doctors on delete cascade,
  patient_id uuid references public.patients,
  doctor_name text,
  doctor_specialty text,
  doctor_image_url text,
  slot_date date not null,
  slot_time text not null,
  slot_type text default 'clinic',
  status text default 'confirmed',  -- confirmed | completed | cancelled | rescheduled
  notes text,
  payment_method text,
  amount real,
  confirmation_code text,
  pin_code text,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

-- 3. LAB BOOKINGS (booked lab tests)
create table if not exists public.lab_bookings (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users on delete cascade,
  patient_id uuid references public.patients,
  package_name text not null,
  collection_date date not null,
  collection_slot text not null,
  collection_address text,
  status text default 'confirmed',  -- confirmed | sample_collected | processing | report_ready | cancelled
  payment_method text,
  amount real,
  confirmation_code text,
  report_url text,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

-- 4. RLS POLICIES

-- Doctor Slots (public read, no user write needed - managed by system)
alter table public.doctor_slots enable row level security;
drop policy if exists "Public can view slots" on public.doctor_slots;
create policy "Public can view slots" on public.doctor_slots for select using (true);

-- Appointments (user-scoped CRUD)
alter table public.appointments enable row level security;
drop policy if exists "Users manage own appointments" on public.appointments;
create policy "Users manage own appointments" on public.appointments for all using (auth.uid() = user_id);

-- Lab Bookings (user-scoped CRUD)
alter table public.lab_bookings enable row level security;
drop policy if exists "Users manage own lab bookings" on public.lab_bookings;
create policy "Users manage own lab bookings" on public.lab_bookings for all using (auth.uid() = user_id);

-- 5. SEED DOCTOR SLOTS (next 7 days for all doctors)
-- Run this after inserting doctors
do $$
declare
  doc record;
  d integer;
  slots text[] := array[
    '09:00 AM','09:30 AM','10:00 AM','10:30 AM','11:00 AM','11:30 AM',
    '02:00 PM','02:30 PM','03:00 PM','03:30 PM','04:00 PM',
    '05:00 PM','05:30 PM','06:00 PM'
  ];
  s text;
begin
  for doc in select id from public.doctors loop
    for d in 0..6 loop
      foreach s in array slots loop
        insert into public.doctor_slots (doctor_id, slot_date, slot_time)
        values (doc.id, current_date + d, s)
        on conflict do nothing;
      end loop;
    end loop;
  end loop;
end $$;

-- 6. REALTIME for bookings
do $$
begin
  if not exists (select 1 from pg_publication_tables where pubname = 'supabase_realtime' and schemaname = 'public' and tablename = 'appointments') then
    alter publication supabase_realtime add table public.appointments;
  end if;
  if not exists (select 1 from pg_publication_tables where pubname = 'supabase_realtime' and schemaname = 'public' and tablename = 'lab_bookings') then
    alter publication supabase_realtime add table public.lab_bookings;
  end if;
end $$;
