-- 🚚 Axiovital MASTER DATA SEEDER
-- Run this in your Supabase SQL Editor to populate your app with beautiful starting data.

-- 1. SETUP STORAGE BUCKETS
insert into storage.buckets (id, name, public) 
values ('avatars', 'avatars', true), ('reports', 'reports', false)
on conflict (id) do nothing;

-- 2. SEED DOCTORS
insert into public.doctors (id, name, specialty, qualifications, image_url, session_price, card_color_hex, rating, review_count, about)
values 
('ad111111-1111-1111-1111-111111111111', 'Dr. Saad Shaikh', 'General Physician', 'MD, MBBS, General Medicine', 'https://cdn-icons-png.flaticon.com/512/3774/3774299.png', 500, '#E0F2FE', 4.8, 124, 'Expert in holistic healthcare and chronic disease management with over 10 years of experience.'),
('ad222222-2222-2222-2222-222222222222', 'Dr. Jessica Smith', 'Cardiologist', 'MBBS, MD Cardiology', 'https://cdn-icons-png.flaticon.com/512/3774/3774292.png', 800, '#FCE7F3', 4.9, 89, 'Specialist in heart health, preventive cardiology and advanced diagnostics.'),
('ad333333-3333-3333-3333-333333333333', 'Dr. Robert Wilson', 'Orthopedic', 'MS Ortho, MBBS', 'https://cdn-icons-png.flaticon.com/512/3774/3774283.png', 600, '#F0F9FF', 4.7, 56, 'Expert in bone health, joint replacements and sports injuries.')
on conflict (id) do nothing;

-- 3. SEED INSURANCE PLANS
insert into public.insurance_plans (id, insurer_name, insurer_logo, plan_name, monthly_premium, old_premium, discount_percent, tags, highlights, features, cashless_hospitals_count)
values 
('b1111111-1111-1111-1111-111111111111', 'Axio Shield', 'https://cdn-icons-png.flaticon.com/512/9363/9363121.png', 'Ultimate Care (Direct)', 432, 650, 5, '{Popular,"Best Value"}', 
 '[{"title": "Unlimited Restore", "subtitle": "Unlimited restoration of cover for related illness", "icon": "auto_awesome", "color": "#FEF0C7"}]',
 '{"Coverage": [{"label": "Co-pay", "value": "0% Co-payment", "description": "No co-payment required.", "isCovered": true}]}', 320),
('b2222222-2222-2222-2222-222222222222', 'Star Health', 'https://cdn-icons-png.flaticon.com/512/2966/2966334.png', 'Super Star Value', 550, 800, 10, '{New}', 
 '[{"title": "Global Cover", "subtitle": "Emergency global coverage for planned treatments", "icon": "security", "color": "#D1FADF"}]',
 '{"Coverage": [{"label": "ICU Charges", "value": "No limit", "description": "No caps on ICU room rent.", "isCovered": true}]}', 450)
on conflict (id) do nothing;

-- 4. SEED LAB PACKAGES
insert into public.lab_packages (id, name, discount_tag, image_url, test_count, current_price, original_price, is_most_booked, category)
values 
('c1111111-1111-1111-1111-111111111111', 'Comprehensive Silver Package', '55% OFF', 'https://images.unsplash.com/photo-1576091160550-217359f42f8c?w=400', 84, 2026, 3598, true, 'General'),
('c2222222-2222-2222-2222-222222222222', 'Comprehensive Gold Package', '56% OFF', 'https://images.unsplash.com/photo-1581056771107-24ca5f033842?w=400', 86, 2498, 4098, false, 'General'),
('c3333333-3333-3333-3333-333333333333', 'Good Health Package (Women)', '60% OFF', 'https://images.unsplash.com/photo-1594824476967-48c8b964273f?w=200', 40, 1699, 3798, false, 'Women')
on conflict (id) do nothing;

-- 5. SEED PRODUCTS
insert into public.products (name, brand, quantity, current_price, original_price, discount, image_path, category, is_best_seller)
values 
('Honey Pure Natural', 'HealthKart', '500g', 299, 450, 33, 'https://images.unsplash.com/photo-1587049352846-4a222e784d38?w=200', 'Supplements', true),
('Multivitamin Men', 'MuscleBlaze', '60 tabs', 499, 750, 33, 'https://images.unsplash.com/photo-1584017444311-27bbbdd8097d?w=200', 'Supplements', false);

-- 6. SEARCH RPC (immediate search bridge)
-- This function allows your SearchProvider to work inside the DB instead of an Edge Function.
create or replace function public.hyper_search(query text)
returns json as $$
declare
    res json;
begin
    with results as (
        select id::text as entity_id, 'doctor' as type, name, specialty as subtitle, rating, 0.9 as score, session_price::numeric as price from public.doctors where name ilike '%' || query || '%'
        union all
        select id::text, 'lab', name, test_count || ' tests' as subtitle, 4.5, 0.8 as score, current_price::numeric from public.lab_packages where name ilike '%' || query || '%'
        union all
        select id::text, 'medicine', name, brand as subtitle, rating, 0.7 as score, current_price::numeric from public.products where name ilike '%' || query || '%'
    )
    select json_build_object(
        'intent', 'healthcare_query',
        'results', json_agg(r)
    ) into res from results r;
    
    return coalesce(res, json_build_object('results', '[]'::json, 'intent', 'none'));
end;
$$ language plpgsql stable;

-- 7. DEFAULT HABITS FOR EVERYONE
-- This ensures that as soon as a user signs up, their profile has habits to track.
insert into public.user_habits (activity, target_value, current_value, streak, status, color_hex, icon_name, user_id)
select 'Daily Steps', 10000, 0, 0, 'available', '#3B82F6', 'walk', profiles.id from public.profiles
on conflict do nothing;
