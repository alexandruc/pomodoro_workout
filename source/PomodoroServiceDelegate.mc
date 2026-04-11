using Toybox.Background;
using Toybox.System;
using Toybox.Time;
using Toybox.Lang;
using Toybox.Notifications;

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
                
                if (app.recalculateRemainingSeconds() <= 0) {
                    if (state == :working) {
                        app.setCompletedBlockType(:work);
                    } else if (state == :breakTime) {
                        app.setCompletedBlockType(:break);
                    }
                    
                    if (Notifications has :showNotification) {
                        var title = "Pomodoro";
                        var subTitle = "Work Done!";
                        if (state == :breakTime) {
                            subTitle = "Break Done!";
                        }
                        
                        var options = {
                            :body => "Tap to start a new block",
                            :actions => [
                                {:label => "Start Work", :data => 0},
                                {:label => "Start Break", :data => 1}
                            ] as Lang.Array<Notifications.Action>,
                            :dismissPrevious => true
                        };
                        
                        Notifications.showNotification(title, subTitle, options);
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
