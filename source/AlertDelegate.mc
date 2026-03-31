using Toybox.WatchUi;
using Toybox.Attention;

class AlertDelegate extends WatchUi.BehaviorDelegate {
    private var app;
    private var nextAction;

    function initialize(a, action) {
        app = a;
        nextAction = action;
        BehaviorDelegate.initialize();
    }

    function onConfirm() {
        if (nextAction == :startBreak) {
            app.startBreak();
        } else if (nextAction == :startWork) {
            app.startWork();
        } else if (nextAction == :idle) {
            app.reset();
        }
        
        return true;
    }
}
