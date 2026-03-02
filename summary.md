# Pomodoro Workout - Garmin Connect IQ App

## Overview

A Pomodoro timer app for Garmin wearable devices that helps users manage work sessions with customizable work and break intervals.

## Project Location

`/home/anon/workplace/garmin_apps/projects/pomodoro_workout/`

## Features

| Feature | Description |
|---------|-------------|
| **Glance Support** | Shows timer countdown and status (WORK/BREAK/IDLE) in the glance view |
| **Timer** | Default 25-minute work block followed by 5-minute break |
| **Vibration** | Vibrates when a work or break block completes |
| **Toast Notifications** | Shows "Starting break..." and "Ready to work?" messages |
| **Background Timer** | Timer continues counting when leaving the widget |
| **Customizable Settings** | Long-press MENU to access settings |
| **Work Time** | Adjustable 5-60 minutes (default: 25 min) |
| **Break Time** | Adjustable 1-30 minutes (default: 5 min) |
| **History** | 7-day bar graph showing completed work blocks |

## Controls

| Button | Action |
|--------|--------|
| **START / ENTER** | Start a work block immediately |
| **DOWN** | Stop/reset timer |
| **MENU (long-press)** | Open settings menu |

## Settings Menu

- **Work Time**: Set work duration (5-60 min, wraps around)
- **Break Time**: Set break duration (1-30 min, wraps around)
- **History**: View 7-day completion graph

## Project Structure

```
pomodoro_workout/
├── manifest.xml                   # App manifest (widget type)
├── monkey.jungle                  # Build configuration
├── .github/workflows/
│   └── build.yml                 # CI/CD workflow
├── source/
│   ├── PomodoroApp.mc            # Main app class + GlanceView
│   ├── PomodoroView.mc           # Timer display UI
│   ├── PomodoroDelegate.mc        # Input handling
│   ├── PomodoroServiceDelegate.mc # Background temporal events
│   ├── SettingsView.mc            # Settings screen
│   ├── SettingsDelegate.mc         # Settings input
│   ├── HistoryView.mc             # 7-day history graph
│   ├── HistoryDelegate.mc          # History input
│   └── Storage.mc                  # Persistent storage
└── resources/
    ├── strings.xml                # App strings
    ├── drawables.xml              # Icon configuration
    └── images/
        └── launcher_icon.png      # Tomato icon
```

## Build

```bash
cd /home/anon/workplace/garmin_apps/projects/pomodoro_workout
/home/anon/.Garmin/ConnectIQ/Sdks/connectiq-sdk-lin-8.4.1-2026-02-03-e9f77eeaa/bin/monkeyc \
  -f monkey.jungle -o bin/pomodoro_workout.prg -d fenix3 \
  -y ../developer_key
```

## GitHub Actions CI/CD

The project includes a GitHub Actions workflow (`.github/workflows/build.yml`) that:
- Builds for `fenix3` and `fr970` devices on push/PR to main
- Uploads `.prg` files as artifacts

**Required secrets:**
- `DEVELOPER_KEY` - Developer key (base64 encoded)
- `SDK_ZIP_BASE64` - Connect IQ SDK (base64 encoded)

## Run in Simulator

```bash
# Start simulator (requires GUI)
/home/anon/.Garmin/ConnectIQ/Sdks/connectiq-sdk-lin-8.4.1-2026-02-03-e9f77eeaa/bin/simulator &

# Run app
/home/anon/.Garmin/ConnectIQ/Sdks/connectiq-sdk-lin-8.4.1-2026-02-03-e9f77eeaa/bin/monkeydo \
  /home/anon/workplace/garmin_apps/projects/pomodoro_workout/bin/pomodoro_workout.prg fenix3
```

## Technical Details

- **App Type**: Widget (with glance + background support)
- **SDK Version**: Connect IQ 8.4.1
- **Language**: Monkey C
- **Storage**: Application.Storage (persists timer state)
- **Timer**: Toybox.Timer (1-second interval in foreground)
- **Background**: Toybox.Background.registerForTemporalEvent (60-second intervals)
- **Notifications**: WatchUi.showToast() + Toybox.Attention.vibrate()

## Supported Devices

- Fenix 3, 6 series
- Vivoactive 4/5 series
- Forerunner 245/255/945/955/965/970 series
- Instinct 2 series
- Edge 530/540/830/840 series
- MARQ Gen 2 series

## Build Output

- `bin/pomodoro_workout.prg` - Compiled app
