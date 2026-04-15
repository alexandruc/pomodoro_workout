# Garmin Connect IQ - Pomodoro Workout

## Build Commands

```bash
# For FR970
monkeyc -f pomodoro_workout/monkey.jungle -o pomodoro_workout/bin/pomodoro_workout.prg -d fr970 -y developer_key

# For FR570
monkeyc -f pomodoro_workout/monkey.jungle -o pomodoro_workout/bin/pomodoro_workout.prg -d fr57047mm -y developer_key

# For FR255 / FR255 Music
monkeyc -f pomodoro_workout/monkey.jungle -o pomodoro_workout/bin/pomodoro_workout.prg -d fr255 -y developer_key
monkeyc -f pomodoro_workout/monkey.jungle -o pomodoro_workout/bin/pomodoro_workout.prg -d fr255m -y developer_key

# For FR255s / FR255s Music
monkeyc -f pomodoro_workout/monkey.jungle -o pomodoro_workout/bin/pomodoro_workout.prg -d fr255s -y developer_key
monkeyc -f pomodoro_workout/monkey.jungle -o pomodoro_workout/bin/pomodoro_workout.prg -d fr255sm -y developer_key

# For Venu 2 Plus
monkeyc -f pomodoro_workout/monkey.jungle -o pomodoro_workout/bin/pomodoro_workout.prg -d venu2plus -y developer_key
```

Key flags: `-f` manifest file, `-o` output, `-d` device, `-y` developer key

## Developer Key

Location: `developer_key` (in workspace root)

## SDK Location

```
/Users/<username>/Library/Application Support/Garmin/ConnectIQ/Sdks/connectiq-sdk-mac-9.1.0-2026-03-09-6a872a80b/
```

Monkeyc in PATH: `/Users/<username>/Library/Application Support/Garmin/ConnectIQ/Sdks/connectiq-sdk-mac-9.1.0-2026-03-09-6a872a80b/bin/monkeyc`

## Simulator

Launch: `open "/Users/<username>/Library/Application Support/Garmin/ConnectIQ/Sdks/connectiq-sdk-mac-9.1.0-2026-03-09-6a872a80b/bin/ConnectIQ.app"`

Run app: `monkeydo pomodoro_workout/bin/pomodoro_workout.prg fr970`

## App Architecture

- **Type**: Watch App (standalone app, no background service)
- **State persistence**: `Application.Storage` saves timerState, timerDuration, timerStartTime
- **Alert**: Custom popup (`AlertView`) with Start Work/Break/Dismiss options

## Timer Resume Logic

When user exits app:
- Timer stops at current position
- State is saved via `onStop()` → `saveTimerState()`

When user returns:
- `restoreTimerState()` restores timer position
- Timer resumes from saved position

## Supported Devices

- fr255 (Forerunner 255)
- fr255m (Forerunner 255 Music)
- fr255s (Forerunner 255s)
- fr255sm (Forerunner 255s Music)
- fr57047mm (Forerunner 570)
- fr970 (Forerunner 970)
- venu2plus (Venu 2 Plus)
