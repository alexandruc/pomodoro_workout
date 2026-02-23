using Toybox.WatchUi;

class SettingsDelegate extends WatchUi.InputDelegate {
    private var app;
    private var view;
    
    function initialize(a) {
        app = a;
        view = null;
        InputDelegate.initialize();
    }
    
    function setView(v) {
        view = v;
    }

    function onKey(keyEvent) {
        var key = keyEvent.getKey();
        var v = view;
        
        if (v == null) {
            return false;
        }
        
        var selected = v.getSelectedItem();
        
        if (key == WatchUi.KEY_UP) {
            if (selected > 0) {
                v.setSelectedItem(selected - 1);
            }
            WatchUi.requestUpdate();
            return true;
        }
        
        if (key == WatchUi.KEY_DOWN) {
            if (selected < 2) {
                v.setSelectedItem(selected + 1);
            }
            WatchUi.requestUpdate();
            return true;
        }
        
        if (key == WatchUi.KEY_ENTER or key == WatchUi.KEY_START) {
            if (selected == 0) {
                var current = app.getWorkTime();
                if (current < 60) {
                    app.setWorkTime(current + 5);
                }
            } else if (selected == 1) {
                var current = app.getBreakTime();
                if (current < 30) {
                    app.setBreakTime(current + 1);
                }
            } else if (selected == 2) {
                WatchUi.pushView(new HistoryView(app), new HistoryDelegate(), WatchUi.SLIDE_IMMEDIATE);
                return true;
            }
            WatchUi.requestUpdate();
            return true;
        }
        
        if (key == WatchUi.KEY_ESC) {
            WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
            return true;
        }
        
        if (key == WatchUi.KEY_MENU) {
            if (selected == 0) {
                var current = app.getWorkTime();
                if (current > 5) {
                    app.setWorkTime(current - 5);
                }
            } else if (selected == 1) {
                var current = app.getBreakTime();
                if (current > 1) {
                    app.setBreakTime(current - 1);
                }
            }
            WatchUi.requestUpdate();
            return true;
        }
        
        return false;
    }
}
