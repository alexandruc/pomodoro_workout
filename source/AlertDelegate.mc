using Toybox.WatchUi;
using Toybox.Attention;

class AlertDelegate extends WatchUi.ConfirmationDelegate {
    private var app;
    private var nextAction;

    function initialize(a, action) {
        app = a;
        nextAction = action;
        ConfirmationDelegate.initialize();
    }

    function onConfirm() {
        if (Attention has :backing) {
            Attention.backing(false);
        }
        
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
