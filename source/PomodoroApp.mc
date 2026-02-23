using Toybox.Application;
using Toybox.WatchUi;
using Toybox.Timer;
using Toybox.Attention;
using Toybox.Graphics;
using Toybox.Time;
using Toybox.Time.Gregorian;

class PomodoroApp extends Application.AppBase {
    private var timer;
    private var state;
    private var remainingSeconds;
    private var timerDelegate;
    
    private var workTime;
    private var breakTime;
    private var history;
    
    const HISTORY_DAYS = 7;
    
    function initialize() {
        AppBase.initialize();
        timer = new Timer.Timer();
        state = :idle;
        
        workTime = 25;
        breakTime = 5;
        history = createEmptyHistory();
        
        remainingSeconds = workTime * 60;
        timerDelegate = null;
    }

    function onStart(appState) {
    }

    function onStop(appState) {
        stopTimer();
    }

    function getInitialView() {
        var view = new PomodoroView(self);
        var delegate = new PomodoroDelegate(self);
        timerDelegate = delegate;
        return [view, delegate];
    }
    
    function getGlanceView() {
        return [new GlanceView(self)];
    }
    
    function getWorkTime() {
        return workTime;
    }
    
    function getBreakTime() {
        return breakTime;
    }
    
    function setWorkTime(minutes) {
        workTime = minutes;
        Application.Properties.setValue("workTime", minutes);
    }
    
    function setBreakTime(minutes) {
        breakTime = minutes;
        Application.Properties.setValue("breakTime", minutes);
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
        
        Application.Properties.setValue("history", history);
    }
    
    function startWork() {
        stopTimer();
        state = :working;
        remainingSeconds = workTime * 60;
        startTimer();
        WatchUi.requestUpdate();
    }
    
    function startBreak() {
        stopTimer();
        state = :breakTime;
        remainingSeconds = breakTime * 60;
        startTimer();
        WatchUi.requestUpdate();
    }
    
    function stopTimer() {
        timer.stop();
    }
    
    function startTimer() {
        timer.start(method(:onTimerTick), 1000, true);
    }
    
    function onTimerTick() {
        remainingSeconds = remainingSeconds - 1;
        
        if (remainingSeconds <= 0) {
            timer.stop();
            vibrate();
            
            if (state == :working) {
                addCompletedPomodoro();
                state = :breakTime;
                remainingSeconds = breakTime * 60;
                startTimer();
            } else if (state == :breakTime) {
                state = :idle;
                remainingSeconds = workTime * 60;
            }
        }
        
        WatchUi.requestUpdate();
    }
    
    function vibrate() {
        if (Attention has :vibrate) {
            var profile = [new Attention.VibeProfile(100, 1000)];
            Attention.vibrate(profile);
        }
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
        WatchUi.pushView(new SettingsView(self), new SettingsDelegate(self), WatchUi.SLIDE_IMMEDIATE);
    }
}

class GlanceView extends WatchUi.GlanceView {
    private var app;
    
    function initialize(a) {
        app = a;
        GlanceView.initialize();
    }
    
    function onLayout(dc) {
    }
    
    function onUpdate(dc) {
        var state = app.getState();
        var seconds = app.getRemainingSeconds();
        
        var minutes = seconds / 60;
        var secs = seconds % 60;
        var timeStr = Lang.format("$1$:$2$", [minutes.format("%02d"), secs.format("%02d")]);
        
        var status = "IDLE";
        if (state == :working) {
            status = "WORK";
        } else if (state == :breakTime) {
            status = "BREAK";
        }
        
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.clear();
        
        dc.drawText(dc.getWidth() / 2, dc.getHeight() / 2 - 10, Graphics.FONT_MEDIUM, timeStr, Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(dc.getWidth() / 2, dc.getHeight() / 2 + 20, Graphics.FONT_TINY, status, Graphics.TEXT_JUSTIFY_CENTER);
    }
}
