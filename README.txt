ANAND: SHARED MUSIC PLAYER
==========================

What it does
- Add songs from your phone (MP3, M4A, WAV, OGG and more). Title, artist and cover art are read from the file.
- Playlists, liked songs, shuffle and repeat.
- Shared library (optional): everyone with the app sees the same songs and playlists. Anyone can add songs,
  edit playlists, rename or delete songs, and the change reaches every phone within about a minute.
- Every phone keeps its own copy of the songs, so the library plays with no internet.
- Liked songs stay personal to each phone.

Set up the shared library (one time, free)
1. Create a free account at https://supabase.com and make a new project.
2. In the project, open SQL Editor > New query, paste everything from supabase-setup.sql, and tap Run.
3. Open Project Settings > API Keys. Copy the Project URL and the Publishable key.
4. In your GitHub repo: Settings > Secrets and variables > Actions > Variables tab > New repository variable:
     SUPABASE_URL  = the Project URL
     SUPABASE_KEY  = the Publishable key
5. Upload this zip to the repo (or run the "Build Android app" workflow again). Share the new APK.

Without these settings the app still works, on one phone only.

Limits of the free Supabase plan
- 1 GB of songs in total (roughly 200 to 250 songs), 50 MB per song.
- 5 GB of downloads a month. Each phone downloads each song once.
- The project pauses after a week with no use. Restore it from the Supabase dashboard; songs already
  saved on phones keep playing meanwhile.

Good to know
- Anyone who has the APK can add or delete songs for everyone.
- Only share music you have the right to share.

Files
- index.html             the app
- config.js              shared library connection (filled in by the GitHub build)
- sw.js                  lets the web version open offline
- manifest.webmanifest   home-screen name and icon
- icons/                 app icons
