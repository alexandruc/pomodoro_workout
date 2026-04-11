using Toybox.WatchUi;
using Toybox.Attention;

class AlertDelegate extends WatchUi.BehaviorDelegate {
    private var app;
    private var alertView;
    private var previousView;
    private var previousDelegate;

    function initialize(a, view, prevView, prevDelegate) {
        app = a;
        alertView = view;
        previousView = prevView;
        previousDelegate = prevDelegate;
        BehaviorDelegate.initialize();
    }

    function onKey(keyEvent) {
        var key = keyEvent.getKey();
        var selected = alertView.getSelectedItem();
        
        if (key == WatchUi.KEY_UP or key == WatchUi.KEY_LEFT) {
            if (selected > 0) {
                alertView.setSelectedItem(selected - 1);
            }
            WatchUi.requestUpdate();
            return true;
        }
        
        if (key == WatchUi.KEY_DOWN or key == WatchUi.KEY_RIGHT) {
            if (selected < 2) {
                alertView.setSelectedItem(selected + 1);
            }
            WatchUi.requestUpdate();
            return true;
        }
        
        if (key == WatchUi.KEY_ENTER or key == WatchUi.KEY_START) {
            executeSelected();
            return true;
        }
        
        if (key == WatchUi.KEY_ESC) {
            dismissAlert();
            return true;
        }
        
        return false;
    }
    
    function executeSelected() {
        if (Attention has :backing) {
            Attention.backing(false);
        }
        
        var selected = alertView.getSelectedItem();
        
        if (selected == 0) {
            app.handleAlertChoice(:startWork);
        } else if (selected == 1) {
            app.handleAlertChoice(:startBreak);
        } else if (selected == 2) {
            app.handleAlertChoice(:dismiss);
        }
        
        returnToMainView();
    }
    
    function dismissAlert() {
        if (Attention has :backing) {
            Attention.backing(false);
        }
        returnToMainView();
    }
    
    function returnToMainView() {
        if (previousView != null and previousDelegate != null) {
            WatchUi.switchToView(previousView, previousDelegate, WatchUi.SLIDE_IMMEDIATE);
        }
    }
}
