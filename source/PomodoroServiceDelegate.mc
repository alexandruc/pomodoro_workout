using Toybox.Background;
using Toybox.System;
using Toybox.Time;
using Toybox.Attention;
using Toybox.WatchUi;

(:background)
class PomodoroServiceDelegate extends System.ServiceDelegate {
    function initialize() {
        ServiceDelegate.initialize();
    }

    function onTemporalEvent() {
        var app = Application.getApp();
        
        if (app != null && app has :getState) {
            var state = app.getState();
            
            if (state == :working or state == :breakTime) {
                var remaining = app.getRemainingSeconds();
                
                if (remaining <= 0) {
                    app.onTimerTick();
                } else {
                    app.decrementRemainingSeconds();
                    app.saveTimerState();
                    
                    if (app.getRemainingSeconds() <= 0) {
                        vibrate();
                        
                        if (state == :working) {
                            app.sendNotification("Work Done!", "Starting break...");
                        } else if (state == :breakTime) {
                            app.sendNotification("Break Done!", "Ready to work?");
                        }
                    }
                    
                    app.triggerForegroundUpdate();
                }
            }
        }
        
        Background.exit(null);
    }
    
    function vibrate() {
        if (Attention has :vibrate) {
            var profile = [new Attention.VibeProfile(100, 1000)];
            Attention.vibrate(profile);
        }
    }
}
