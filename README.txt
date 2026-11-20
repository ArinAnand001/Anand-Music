ANAND MUSIC PLAYER — SHARED LIBRARY
====================================

What the app supports
- Add songs from a phone (MP3, M4A, WAV, OGG and more).
- Shared songs and playlists: every APK connected to the same Supabase project sees the same library.
- Changes made on one phone sync to the others when they next connect (the app checks about every 45 seconds while open).
- Each phone can save a local copy of every shared song for offline playback.
- Liked songs remain personal to each phone.

ONE-TIME SHARED LIBRARY SETUP

1. Create a free project at https://supabase.com.
2. In the Supabase project, open SQL Editor > New query. Open supabase-setup.sql from this GitHub repository, copy all of it into the SQL editor, and click Run.
3. In Supabase, open Project Settings > API Keys. Copy the Project URL and the Publishable key. Do NOT use a secret key or service_role key.
4. In this GitHub repository, open Settings > Secrets and variables > Actions > Variables. Add these two repository variables:
     SUPABASE_URL = your Supabase Project URL
     SUPABASE_KEY = your Supabase Publishable key
5. Open the Actions tab > Build Android app > Run workflow. Wait until the run is green, then download the new Anand.apk from the release.
6. Install that same new APK on your phone and every friend's/family member's phone. All of them must use the same build / Supabase connection.

The existing APK can also connect manually: tap the cloud icon > Connection, then enter the same Project URL and Publishable key on each phone. A new configured APK is easier to distribute.

IMPORTANT ACCESS NOTE
This basic shared-library setup allows anyone who has the APK to add, rename, edit playlists, or delete shared songs/playlists for everyone. Only distribute the APK to people you trust. A later owner-only mode would require account sign-in and stricter database permissions.

STORAGE AND OFFLINE BEHAVIOUR
- The cloud copy is stored in Supabase Storage; song and playlist details are stored in its database.
- The app attempts to cache the full shared library on each phone for offline playback. Keep “Save every song on this phone” enabled in the Shared library panel.
- Cloud storage is not literally guaranteed to last forever. The Supabase Free plan currently includes 1 GB file storage and 5 GB egress; individual uploads in this app are capped at 50 MB. Free projects can pause after a week with too little activity. Data remains while paused, but you may need to restore the project. For a library people rely on continuously, review the current Supabase paid plan and backup options.
- Uninstalling the app or clearing its app data can remove that phone's offline cache. The cloud library is separate and can be downloaded again when the app is reinstalled.

Only upload music and artwork that you own or have permission to share.

Files
- Anand-music-player.zip   source project used by the Android build
- index.html               music player and shared-library sync code
- config.js                shared-library connection (injected during the build)
- supabase-setup.sql       database, policies and Storage bucket setup
- .github/workflows        Android APK build workflow
