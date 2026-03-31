using Toybox.Background;
using Toybox.System;
using Toybox.Time;
using Toybox.Attention;

(:background)
class PomodoroServiceDelegate extends System.ServiceDelegate {
    private var lastState;

    function initialize() {
        ServiceDelegate.initialize();
        lastState = :idle;
    }

    function onTemporalEvent() {
        var app = Application.getApp();
        
        if (app != null && app has :getState) {
            var state = app.getState();
            
            if (state == :working or state == :breakTime) {
                lastState = state;
                
                for (var i = 0; i < 300; i++) {
                    app.decrementRemainingSeconds();
                }
                app.saveTimerState();
                
                if (app.getRemainingSeconds() <= 0) {
                    if (Attention has :vibrate) {
                        var profile = [new Attention.VibeProfile(100, 500)];
                        Attention.vibrate(profile);
                    }
                    
                    if (Background has :requestApplicationWake) {
                        if (state == :working) {
                            Background.requestApplicationWake("Pomodoro: Work done!");
                        } else if (state == :breakTime) {
                            Background.requestApplicationWake("Pomodoro: Break done!");
                        }
                    }
                }
                
                app.triggerForegroundUpdate();
            }
        }
        
        Background.exit({
            "type" => (lastState == :working) ? "workDone" : "breakDone"
        });
    }
}
