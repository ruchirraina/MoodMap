# MoodMap 🎨📔

A mood journaling app where you write daily entries, pick a color for your mood, and see your emotional journey as a gradient at the end of each month.

## What's This?

A journaling app I'm building as an engineering student. It uses colors to track moods - write one journal per day, pick a color that represents how you felt, and at the end of the month you get a gradient visualization showing your emotional patterns.

## Current Status 🚧

**Version 0.2.0** - Firebase integration complete, basic theming implemented.

### What's Working Now
- ✅ Firebase initialized and connected
- ✅ Material 3 theming (light & dark modes with custom surface colors)
- ✅ Custom fonts (Poppins for UI, Pacifico for special titles)
- ✅ Portrait-only orientation
- ✅ Platform-specific splash effects (Android & iOS)

## What I'm Planning to Build ✅

Here's what I'm definitely going to implement:

### Authentication
- Sign up and log in with email/password
- Google Sign-In
- Basic user accounts

### The Journaling Part
- Write one journal entry per day
- Can't write for future dates or go back and add old entries
- If you miss a day, it's missed (this is intentional!)
- Pick a color for each day's mood
- Local storage so it works offline
- Syncs to Firebase when you're online

### Monthly Mood View
- At the end of each month, see a gradient made from all your daily mood colors
- Visual way to see how your month went emotionally

### Spotify Integration
- Add a 10-second song preview to your daily entry
- Search and pick songs from Spotify

### Local Storage
- Offline-first functionality
- Data persists locally on device
- Automatic sync with Firebase when online

## Maybe Later (Ambitious Stuff) 💭

These are things I might add if I get time and motivation:

- **AI Summaries**: Opt-in feature where AI reads your journals and gives you insights (you'd control if you want to share data)
- **Social Features**: Make your profile or specific entries public, see other people's public journals
- **Photos**: Add pictures to your journal entries

## Tech Stack

- Flutter (Android & iOS only)
- Firebase (for backend, auth, and storage)
- Spotify API (for the song previews)
- Currently using `setState` but might switch to Riverpod later

## Running This

You'll need Flutter installed. Then:

```bash
git clone https://github.com/ruchirraina/MoodMap.git
cd moodmap
flutter pub get
flutter run
```

## License

Free to use however you want! Copy it, modify it, build on it - just don't abuse my Firebase backend. MIT License.

---

A learning project building real Flutter experience.