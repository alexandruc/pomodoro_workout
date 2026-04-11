using Toybox.Application;
using Toybox.WatchUi;
using Toybox.Timer;
using Toybox.Attention;
using Toybox.Graphics;
using Toybox.Time;
using Toybox.Time.Gregorian;
using Toybox.System;

class PomodoroApp extends Application.AppBase {
    private var timer;
    private var clockTimer;
    private var state;
    private var remainingSeconds;
    private var timerDelegate;
    private var endTime;
    private var mainView;
    private var mainDelegate;
    private var alertView;
    private var completedBlockType;
    
    private var workTime;
    private var breakTime;
    private var history;
    
    const HISTORY_DAYS = 7;
    
    function initialize() {
        AppBase.initialize();
        state = :idle;
        completedBlockType = null;
        
        workTime = 2;
        breakTime = 1;
        history = createEmptyHistory();
        
        remainingSeconds = workTime * 60;
        timerDelegate = null;
        endTime = null;
        timer = null;
        clockTimer = null;
    }

    function onStart(appState) {
    }

    function onStop(appState) {
        if (state == :working or state == :breakTime) {
            saveTimerState();
        }
    }
    
    function getInitialView() {
        var view = new PomodoroView(self);
        var delegate = new PomodoroDelegate(self);
        timerDelegate = delegate;
        mainView = view;
        mainDelegate = delegate;
        
        restoreTimerState();
        startClockTimer();
        
        if (state == :working or state == :breakTime) {
            startTimer();
            WatchUi.requestUpdate();
        }
        
        return [view, delegate];
    }
    
    function startClockTimer() {
        if (!(System has :ServiceLogin)) {
            if (clockTimer == null) {
                clockTimer = new Timer.Timer();
            }
            if (clockTimer has :start) {
                clockTimer.start(method(:onClockTick), 1000, true);
            }
        }
    }
    
    function stopClockTimer() {
        if (clockTimer != null and clockTimer has :stop) {
            clockTimer.stop();
        }
    }
    
    function onClockTick() {
        WatchUi.requestUpdate();
    }
    
    function getWorkTime() {
        return workTime;
    }
    
    function getBreakTime() {
        return breakTime;
    }
    
    function setWorkTime(minutes) {
        workTime = minutes;
        if (state == :idle) {
            remainingSeconds = workTime * 60;
            WatchUi.requestUpdate();
        }
    }
    
    function setBreakTime(minutes) {
        breakTime = minutes;
    }
    
    function getHistoryArray() {
        var today = getTodayKey();
        var result = new [HISTORY_DAYS];
        
        for (var i = 0; i < HISTORY_DAYS; i++) {
            var dayKey = today - i;
            if (dayKey % 100 > 28) {
                dayKey = dayKey - 72;
            }
            result[i] = history.hasKey(dayKey) ? history[dayKey] : 0;
        }
        
        return result;
    }
    
    function getTodayKey() {
        var info = Gregorian.info(Time.now(), Time.FORMAT_SHORT);
        return info.year * 10000 + info.month * 100 + info.day;
    }
    
    function createEmptyHistory() {
        var h = {};
        var today = getTodayKey();
        for (var i = 0; i < HISTORY_DAYS; i++) {
            h[today - i] = 0;
        }
        return h;
    }
    
    function addCompletedPomodoro() {
        var today = getTodayKey();
        
        var keys = history.keys();
        var hasToday = false;
        for (var i = 0; i < keys.size(); i++) {
            if (keys[i] == today) {
                hasToday = true;
                break;
            }
        }
        
        if (!hasToday) {
            var newHistory = {};
            var current = today;
            for (var i = 0; i < HISTORY_DAYS; i++) {
                if (history.hasKey(current)) {
                    newHistory[current] = history[current];
                } else {
                    newHistory[current] = 0;
                }
                current = current - 1;
                if (current % 100 > 28) {
                    current = current - 72;
                }
            }
            history = newHistory;
        }
        
        if (history.hasKey(today)) {
            history[today] = history[today] + 1;
        } else {
            history[today] = 1;
        }
    }
    
    function startWork() {
        stopTimer();
        state = :working;
        remainingSeconds = workTime * 60;
        saveTimerState();
        startTimer();
        WatchUi.requestUpdate();
    }
    
    function startBreak() {
        stopTimer();
        state = :breakTime;
        remainingSeconds = breakTime * 60;
        saveTimerState();
        startTimer();
        WatchUi.requestUpdate();
    }
    
    function startTimer() {
        if (!(System has :ServiceLogin)) {
            if (timer == null) {
                timer = new Timer.Timer();
            }
            if (timer has :start) {
                timer.start(method(:onTimerTick), 1000, true);
            }
        }
    }
    
    function stopTimer() {
        if (timer != null and timer has :stop) {
            timer.stop();
        }
        clearTimerState();
    }
    
    function onTimerTick() {
        remainingSeconds = remainingSeconds - 1;
        
        if (remainingSeconds <= 0) {
            if (timer != null and timer has :stop) {
                timer.stop();
            }
            
            if (state == :working) {
                addCompletedPomodoro();
                if (Attention has :vibrate) {
                    var workProfile = [new Attention.VibeProfile(200, 1000)];
                    Attention.vibrate(workProfile);
                }
                completedBlockType = :work;
                showAlertDialog("Work Done!");
            } else if (state == :breakTime) {
                if (Attention has :vibrate) {
                    var breakProfile = [new Attention.VibeProfile(200, 1000)];
                    Attention.vibrate(breakProfile);
                }
                completedBlockType = :break;
                showAlertDialog("Break Done!");
            }
        }
        
        WatchUi.requestUpdate();
    }
    
    function showAlertDialog(message) {
        if (Attention has :vibrate) {
            var profile = [new Attention.VibeProfile(100, 500)];
            Attention.vibrate(profile);
        }
        
        if (Attention has :playTone and Attention has :TONE_ALARM) {
            Attention.playTone(Attention.TONE_ALARM);
        }
        
        alertView = new AlertView(self, message);
        var alertDelegate = new AlertDelegate(self, alertView, mainView, mainDelegate);
        WatchUi.switchToView(alertView, alertDelegate, WatchUi.SLIDE_IMMEDIATE);
    }
    
    function handleAlertChoice(choice) {
        if (completedBlockType == :work) {
            if (choice == :startWork) {
                startWork();
            } else if (choice == :startBreak) {
                startBreak();
            } else {
                state = :idle;
                remainingSeconds = workTime * 60;
                clearTimerState();
            }
        } else if (completedBlockType == :break) {
            if (choice == :startWork) {
                startWork();
            } else if (choice == :startBreak) {
                startBreak();
            } else {
                state = :idle;
                remainingSeconds = workTime * 60;
            }
        }
        completedBlockType = null;
    }
    
    function getState() {
        return state;
    }
    
    function getRemainingSeconds() {
        return remainingSeconds;
    }
    
    function reset() {
        stopTimer();
        state = :idle;
        remainingSeconds = workTime * 60;
        WatchUi.requestUpdate();
    }
    
    function pushSettingsMenu() {
        var view = new SettingsView(self);
        var delegate = new SettingsDelegate(self);
        delegate.setView(view);
        WatchUi.pushView(view, delegate, WatchUi.SLIDE_IMMEDIATE);
    }
    
    function saveTimerState() {
        if (Application has :Storage) {
            var storage = Application.Storage;
            if (storage != null) {
                var stateInt = 0;
                if (state == :working) {
                    stateInt = 1;
                } else if (state == :breakTime) {
                    stateInt = 2;
                }
                storage.setValue("timerState", stateInt);
                storage.setValue("timerDuration", remainingSeconds);
                storage.setValue("timerStartTime", Time.now().value());
            }
        }
    }
    
    function clearTimerState() {
        if (Application has :Storage) {
            var storage = Application.Storage;
            if (storage != null) {
                storage.deleteValue("timerState");
                storage.deleteValue("timerDuration");
                storage.deleteValue("timerStartTime");
            }
        }
    }
    
    function restoreTimerState() {
        if (Application has :Storage) {
            var storage = Application.Storage;
            if (storage == null) {
                return;
            }
            
            var timerState = storage.getValue("timerState");
            var timerDuration = storage.getValue("timerDuration");
            var timerStartTime = storage.getValue("timerStartTime");
            
            if (timerState != null && timerDuration != null && timerStartTime != null) {
                var now = Time.now().value();
                var elapsed = now - timerStartTime;
                
                if (elapsed <= timerDuration) {
                    remainingSeconds = timerDuration - elapsed;
                    
                    if (timerState == 1) {
                        state = :working;
                    } else if (timerState == 2) {
                        state = :breakTime;
                    }
                } else {
                    state = :idle;
                    remainingSeconds = workTime * 60;
                    clearTimerState();
                }
            }
        }
    }
}
