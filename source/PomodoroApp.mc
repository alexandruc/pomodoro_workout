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
    private var weekStartDate;
    private var previousState;
    private var transitionMode;
    private var nextTransitionAction;
    
    const HISTORY_DAYS = 7;
    
    function initialize() {
        AppBase.initialize();
        state = :idle;
        completedBlockType = null;
        
        workTime = 5;
        breakTime = 1;
        transitionMode = :manual;
        nextTransitionAction = null;
        history = createEmptyHistory();
        weekStartDate = getWeekStartDate();
        previousState = 0;
        
        remainingSeconds = workTime * 60;
        timerDelegate = null;
        endTime = null;
        timer = null;
        clockTimer = null;
    }

    function onStart(appState) {
    }

    function onStop(appState) {
        if (state == :working or state == :breakTime or state == :paused) {
            saveTimerState();
        }
        saveHistory();
        saveSettings();
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
        
        if (state == :paused) {
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
    
    function getTransitionMode() {
        return transitionMode;
    }
    
    function setTransitionMode(mode) {
        transitionMode = mode;
    }
    
    function toggleTransitionMode() {
        if (transitionMode == :manual) {
            transitionMode = :auto;
        } else {
            transitionMode = :manual;
        }
    }
    
    function getHistoryArray() {
        var currentWeekStart = getWeekStartDate();
        var result = new [HISTORY_DAYS];
        
        for (var i = 0; i < HISTORY_DAYS; i++) {
            var dayKey = currentWeekStart + i;
            result[i] = history.hasKey(dayKey) ? history[dayKey] : 0;
        }
        
        return result;
    }
    
    function checkAndResetWeek() {
        var currentWeekStart = getWeekStartDate();
        if (weekStartDate != currentWeekStart) {
            weekStartDate = currentWeekStart;
            history = createEmptyHistory();
            saveHistory();
        }
    }
    
    function getTodayKey() {
        var info = Gregorian.info(Time.now(), Time.FORMAT_SHORT);
        return info.year * 10000 + info.month * 100 + info.day;
    }
    
    function getTodayWeekdayIndex() {
        var info = Gregorian.info(Time.now(), Time.FORMAT_SHORT);
        var day = info.day_of_week;
        return day == 1 ? 6 : day - 2;
    }
    
    function getWeekStartDate() {
        var now = Time.now();
        var info = Gregorian.info(now, Time.FORMAT_SHORT);
        var weekday = info.day_of_week;
        var todayKey = getTodayKey();
        var daysSinceMonday = weekday == 1 ? 6 : weekday - 2;
        var startKey = todayKey - daysSinceMonday;
        if (startKey % 100 < 1) {
            var month = info.month - 1;
            var year = info.year;
            if (month < 1) {
                month = 12;
                year = year - 1;
            }
            var daysInPrevMonth = getDaysInMonth(year, month);
            startKey = year * 10000 + month * 100 + daysInPrevMonth + (startKey % 100);
        }
        return startKey;
    }
    
    function getDaysInMonth(year, month) {
        var days = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
        if (month == 2 and year % 4 == 0 and (year % 100 != 0 or year % 400 == 0)) {
            return 29;
        }
        return days[month - 1];
    }
    
    function createEmptyHistory() {
        var h = {};
        var weekStart = getWeekStartDate();
        for (var i = 0; i < HISTORY_DAYS; i++) {
            h[weekStart + i] = 0;
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
    
    function pauseTimer() {
        if (state == :working) {
            previousState = 1;
        } else if (state == :breakTime) {
            previousState = 2;
        }
        stopTimer();
        state = :paused;
        saveTimerState();
        WatchUi.requestUpdate();
    }
    
    function resumeTimer() {
        if (state == :paused) {
            if (previousState == 1) {
                state = :working;
            } else if (previousState == 2) {
                state = :breakTime;
            }
            startTimer();
            saveTimerState();
            WatchUi.requestUpdate();
        }
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
                    var vibTimer = new Timer.Timer();
                    vibTimer.start(method(:onWorkVibrateSecond), 1200, false);
                }
                
                if (transitionMode == :auto) {
                    showTransitionPopup("Starting break", :startBreak);
                } else {
                    completedBlockType = :work;
                    showAlertDialog("Work Done!");
                }
            } else if (state == :breakTime) {
                if (Attention has :vibrate) {
                    var breakProfile = [new Attention.VibeProfile(200, 1000)];
                    Attention.vibrate(breakProfile);
                }
                
                if (transitionMode == :auto) {
                    showTransitionPopup("Starting work", :startWork);
                } else {
                    completedBlockType = :break;
                    showAlertDialog("Break Done!");
                }
            }
        }
        
        WatchUi.requestUpdate();
    }
    
    function onWorkVibrateSecond() as Void {
        if (Attention has :vibrate) {
            var workProfile = [new Attention.VibeProfile(200, 1000)];
            Attention.vibrate(workProfile);
        }
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
    
    function showTransitionPopup(message, nextAction) {
        nextTransitionAction = nextAction;
        var transitionView = new TransitionView(self, message);
        var transitionDelegate = new TransitionDelegate(self, transitionView, mainView, mainDelegate, nextAction);
        WatchUi.switchToView(transitionView, transitionDelegate, WatchUi.SLIDE_IMMEDIATE);
        
        var transitionTimer = new Timer.Timer();
        transitionTimer.start(method(:onTransitionTimerDone), 3000, false);
    }
    
    function onTransitionTimerDone() as Void {
        if (nextTransitionAction == :startBreak) {
            startBreak();
        } else if (nextTransitionAction == :startWork) {
            startWork();
        }
        nextTransitionAction = null;
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
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
                } else if (state == :paused) {
                    stateInt = 3;
                }
                storage.setValue("timerState", stateInt);
                storage.setValue("timerDuration", remainingSeconds);
                storage.setValue("timerStartTime", Time.now().value());
                storage.setValue("previousState", previousState);
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
    
    function saveHistory() {
        if (Application has :Storage) {
            var storage = Application.Storage;
            if (storage != null) {
                storage.setValue("history", history);
                storage.setValue("weekStartDate", weekStartDate);
            }
        }
    }
    
    function loadHistory() {
        if (Application has :Storage) {
            var storage = Application.Storage;
            if (storage != null) {
                var savedHistory = storage.getValue("history");
                if (savedHistory != null) {
                    history = savedHistory;
                }
                var savedWeekStart = storage.getValue("weekStartDate");
                if (savedWeekStart != null) {
                    weekStartDate = savedWeekStart;
                }
            }
        }
    }
    
    function saveSettings() {
        if (Application has :Storage) {
            var storage = Application.Storage;
            if (storage != null) {
                storage.setValue("workTime", workTime);
                storage.setValue("breakTime", breakTime);
                var modeInt = transitionMode == :auto ? 1 : 0;
                storage.setValue("transitionMode", modeInt);
            }
        }
    }
    
    function loadSettings() {
        if (Application has :Storage) {
            var storage = Application.Storage;
            if (storage != null) {
                var savedWorkTime = storage.getValue("workTime");
                var savedBreakTime = storage.getValue("breakTime");
                var savedTransition = storage.getValue("transitionMode");
                if (savedWorkTime != null) {
                    workTime = savedWorkTime;
                }
                if (savedBreakTime != null) {
                    breakTime = savedBreakTime;
                }
                if (savedTransition != null) {
                    transitionMode = savedTransition == 1 ? :auto : :manual;
                }
            }
        }
    }
    
    function restoreTimerState() {
        loadSettings();
        loadHistory();
        checkAndResetWeek();
        
        if (Application has :Storage) {
            var storage = Application.Storage;
            if (storage == null) {
                remainingSeconds = workTime * 60;
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
                    } else if (timerState == 3) {
                        state = :paused;
                    }
                    
                    var savedPrev = storage.getValue("previousState");
                    if (savedPrev != null) {
                        previousState = savedPrev;
                    }
                } else {
                    state = :idle;
                    remainingSeconds = workTime * 60;
                    clearTimerState();
                }
            } else {
                remainingSeconds = workTime * 60;
            }
        } else {
            remainingSeconds = workTime * 60;
        }
    }
}
