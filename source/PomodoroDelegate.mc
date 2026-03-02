using Toybox.WatchUi;
using Toybox.System;
using Toybox.Timer;

class PomodoroDelegate extends WatchUi.BehaviorDelegate {
    private var app;
    private var menuHeld;
    private var holdTimer;
    
    function initialize(a) {
        app = a;
        menuHeld = false;
        holdTimer = new Timer.Timer();
        BehaviorDelegate.initialize();
    }

    function onKey(keyEvent) {
        var key = keyEvent.getKey();
        
        if (key == WatchUi.KEY_START or key == WatchUi.KEY_ENTER) {
            if (app.getState() == :idle) {
                app.startWork();
            }
            return true;
        }
        
        if (key == WatchUi.KEY_DOWN) {
            app.reset();
            return true;
        }
        
        if (key == WatchUi.KEY_MENU) {
            if (!menuHeld) {
                menuHeld = true;
                holdTimer.start(method(:onMenuHold), 800, false);
            }
            return true;
        }
        
        return false;
    }
    
    function onKeyReleased(keyEvent) {
        var key = keyEvent.getKey();
        if (key == WatchUi.KEY_MENU) {
            menuHeld = false;
            holdTimer.stop();
        }
        return false;
    }
    
    function onMenuHold() {
        menuHeld = false;
        app.pushSettingsMenu();
    }
}
