using Toybox.WatchUi;

class HistoryDelegate extends WatchUi.InputDelegate {
    function initialize() {
        InputDelegate.initialize();
    }

    function onKey(keyEvent) {
        var key = keyEvent.getKey();
        
        if (key == WatchUi.KEY_DOWN or key == WatchUi.KEY_ESC) {
            WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
            return true;
        }
        
        return false;
    }
}
