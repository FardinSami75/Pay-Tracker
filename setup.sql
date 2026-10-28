-- Pay Tracker database setup. Paste this whole file into Supabase → SQL Editor → New query → Run.

create table if not exists public.shifts (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  date date not null,
  job text not null,
  time_in text not null,
  time_out text not null,
  updated_at timestamptz not null default now()
);

create table if not exists public.rates (
  user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  job text not null,
  effective_from date not null,
  rate numeric(8,2) not null,
  primary key (user_id, job, effective_from)
);

alter table public.shifts enable row level security;
alter table public.rates  enable row level security;

-- Each signed-in person can only see and change their own rows.
drop policy if exists "own shifts" on public.shifts;
create policy "own shifts" on public.shifts for all
  using (auth.uid() = user_id) with check (auth.uid() = user_id);
drop policy if exists "own rates" on public.rates;
create policy "own rates" on public.rates for all
  using (auth.uid() = user_id) with check (auth.uid() = user_id);

-- Mercor contract work (added 2026-10-27). Safe to run on its own.
create table if not exists public.mercor_tasks (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  date date not null,
  project text not null,
  hours numeric(6,2) not null,
  rate_usd numeric(8,2) not null,
  bonus_usd numeric(8,2) not null default 0,
  bonus_note text,
  fx numeric(8,4) not null,
  updated_at timestamptz not null default now()
);
alter table public.mercor_tasks enable row level security;
drop policy if exists "own mercor" on public.mercor_tasks;
create policy "own mercor" on public.mercor_tasks for all
  using (auth.uid() = user_id) with check (auth.uid() = user_id);
