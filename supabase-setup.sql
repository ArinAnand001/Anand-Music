-- Anand Music shared library setup
-- Run once in Supabase Dashboard > SQL Editor > New query.
-- This version lets anyone with the APK read and manage the shared library.
-- Do not put a Supabase service_role / secret key in the APK.

create table if not exists public.songs (
  id text primary key,
  title text not null,
  artist text not null default '',
  album text not null default '',
  duration double precision not null default 0,
  size bigint not null default 0,
  type text not null default 'audio/mpeg',
  file_name text not null default '',
  file_path text not null unique,
  cover_path text,
  added_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.playlists (
  id text primary key,
  name text not null,
  song_ids text[] not null default '{}',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists songs_added_at_idx
  on public.songs (added_at desc);

alter table public.songs enable row level security;
alter table public.playlists enable row level security;

grant usage on schema public to anon, authenticated;
grant select, insert, update, delete on table public.songs to anon, authenticated;
grant select, insert, update, delete on table public.playlists to anon, authenticated;

drop policy if exists "Anand shared songs read" on public.songs;
create policy "Anand shared songs read"
  on public.songs for select to anon, authenticated
  using (true);

drop policy if exists "Anand shared songs insert" on public.songs;
create policy "Anand shared songs insert"
  on public.songs for insert to anon, authenticated
  with check (true);

drop policy if exists "Anand shared songs update" on public.songs;
create policy "Anand shared songs update"
  on public.songs for update to anon, authenticated
  using (true) with check (true);

drop policy if exists "Anand shared songs delete" on public.songs;
create policy "Anand shared songs delete"
  on public.songs for delete to anon, authenticated
  using (true);

drop policy if exists "Anand shared playlists read" on public.playlists;
create policy "Anand shared playlists read"
  on public.playlists for select to anon, authenticated
  using (true);

drop policy if exists "Anand shared playlists insert" on public.playlists;
create policy "Anand shared playlists insert"
  on public.playlists for insert to anon, authenticated
  with check (true);

drop policy if exists "Anand shared playlists update" on public.playlists;
create policy "Anand shared playlists update"
  on public.playlists for update to anon, authenticated
  using (true) with check (true);

drop policy if exists "Anand shared playlists delete" on public.playlists;
create policy "Anand shared playlists delete"
  on public.playlists for delete to anon, authenticated
  using (true);

-- The app downloads songs and artwork through public object URLs.
insert into storage.buckets (id, name, public, file_size_limit)
values ('mixtape', 'mixtape', true, 52428800)
on conflict (id) do update
set public = excluded.public,
    file_size_limit = excluded.file_size_limit;

drop policy if exists "Anand mixtape public read" on storage.objects;
create policy "Anand mixtape public read"
  on storage.objects for select to anon, authenticated
  using (bucket_id = 'mixtape');

drop policy if exists "Anand mixtape upload" on storage.objects;
create policy "Anand mixtape upload"
  on storage.objects for insert to anon, authenticated
  with check (bucket_id = 'mixtape');

drop policy if exists "Anand mixtape update" on storage.objects;
create policy "Anand mixtape update"
  on storage.objects for update to anon, authenticated
  using (bucket_id = 'mixtape')
  with check (bucket_id = 'mixtape');

drop policy if exists "Anand mixtape delete" on storage.objects;
create policy "Anand mixtape delete"
  on storage.objects for delete to anon, authenticated
  using (bucket_id = 'mixtape');

-- Setup complete.
