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

- **Work Time**: Set work duration (5-60 min, default: 25)
- **Break Time**: Set break duration (1-30 min, default: 5)
- **History**: View 7-day completion graph

## Project Structure

```
pomodoro_workout/
├── manifest.xml              # App manifest (widget type)
├── monkey.jungle            # Build configuration
├── source/
│   ├── PomodoroApp.mc       # Main app class + GlanceView
│   ├── PomodoroView.mc      # Timer display UI
│   ├── PomodoroDelegate.mc  # Input handling
│   ├── SettingsView.mc      # Settings screen
│   ├── SettingsDelegate.mc  # Settings input
│   ├── HistoryView.mc       # 7-day history graph
│   ├── HistoryDelegate.mc   # History input
│   └── Storage.mc           # Persistent storage (Properties)
└── resources/
    ├── strings.xml           # App strings
    ├── drawables.xml        # Icon configuration
    └── images/
        └── launcher_icon.png # Tomato icon
```

## Build

```bash
cd /home/anon/workplace/garmin_apps/projects/pomodoro_workout
/home/anon/.Garmin/ConnectIQ/Sdks/connectiq-sdk-lin-8.4.1-2026-02-03-e9f77eeaa/bin/monkeyc \
  -f monkey.jungle -o bin/pomodoro_workout.prg -d fenix6 \
  -y ../developer_key
```

## Run in Simulator

```bash
# Start simulator (requires GUI)
/home/anon/.Garmin/ConnectIQ/Sdks/connectiq-sdk-lin-8.4.1-2026-02-03-e9f77eeaa/bin/simulator &

# Run app
/home/anon/.Garmin/ConnectIQ/Sdks/connectiq-sdk-lin-8.4.1-2026-02-03-e9f77eeaa/bin/monkeydo \
  /home/anon/workplace/garmin_apps/projects/pomodoro_workout/bin/pomodoro_workout.prg fenix6
```

## Technical Details

- **App Type**: Widget (with glance support)
- **SDK Version**: Connect IQ 8.4.1
- **Language**: Monkey C
- **Storage**: In-memory (defaults: 25min work, 5min break)
- **Timer**: Toybox.Timer (1-second interval)
- **Attention**: Toybox.Attention.vibrate() for notifications

**Note**: The app uses in-memory storage for simplicity. Settings changes persist during the session but are not saved to long-term storage in this version.

## Supported Devices

- Fenix 6 series
- Vivoactive 4/5 series
- Forerunner 245/255/945/955/965 series
- Instinct 2 series
- Edge 530/540/830/840 series
- MARQ Gen 2 series

## Build Output

- `bin/pomodoro_workout.prg` (106KB)
- `bin/pomodoro_workout.prg.debug.xml`
