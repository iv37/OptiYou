create extension if not exists pgcrypto;

create table if not exists public.profiles (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null unique references auth.users(id) on delete cascade,
  email text not null,
  age integer,
  gender text,
  height_cm integer,
  weight_kg numeric(5,2),
  neck_cm numeric(5,2),
  waist_cm numeric(5,2),
  hip_cm numeric(5,2),
  body_fat_estimate numeric(4,1),
  skin_goals text[] not null default '{}',
  hair_goals text[] not null default '{}',
  body_goals text[] not null default '{}',
  grooming_goals text[] not null default '{}',
  sleep_hours numeric(4,1),
  hydration_liters numeric(4,1),
  exercise_days integer,
  diet_quality text,
  diet_notes text,
  calorie_intake integer,
  onboarding_completed boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create or replace function public.handle_profile_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists profiles_set_updated_at on public.profiles;
create trigger profiles_set_updated_at
before update on public.profiles
for each row execute function public.handle_profile_updated_at();

alter table public.profiles enable row level security;

create policy "Users can read own profile"
on public.profiles
for select
using (auth.uid() = user_id);

create policy "Users can insert own profile"
on public.profiles
for insert
with check (auth.uid() = user_id);

create policy "Users can update own profile"
on public.profiles
for update
using (auth.uid() = user_id);
