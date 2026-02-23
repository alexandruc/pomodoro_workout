using Toybox.WatchUi;
using Toybox.Graphics;

class PomodoroView extends WatchUi.View {
    private var app;
    
    function initialize(a) {
        app = a;
        View.initialize();
    }

    function onLayout(dc) {
    }

    function onShow() {
    }

    function onHide() {
    }

    function onUpdate(dc) {
        var state = app.getState();
        var seconds = app.getRemainingSeconds();
        
        var minutes = seconds / 60;
        var secs = seconds % 60;
        var timeStr = Lang.format("$1$:$2$", [minutes.format("%02d"), secs.format("%02d")]);
        
        var status = "READY";
        var statusColor = Graphics.COLOR_WHITE;
        
        if (state == :working) {
            status = "WORK";
            statusColor = Graphics.COLOR_RED;
        } else if (state == :breakTime) {
            status = "BREAK";
            statusColor = Graphics.COLOR_GREEN;
        }
        
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();
        
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        
        var width = dc.getWidth();
        var height = dc.getHeight();
        
        dc.drawText(width / 2, height / 2 - 40, Graphics.FONT_NUMBER_THAI_HOT, timeStr, Graphics.TEXT_JUSTIFY_CENTER);
        
        dc.setColor(statusColor, Graphics.COLOR_BLACK);
        dc.drawText(width / 2, height / 2 + 30, Graphics.FONT_SMALL, status, Graphics.TEXT_JUSTIFY_CENTER);
        
        dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_BLACK);
        
        if (state == :idle) {
            dc.drawText(width / 2, height - 30, Graphics.FONT_TINY, "START to work", Graphics.TEXT_JUSTIFY_CENTER);
        } else if (state == :working or state == :breakTime) {
            dc.drawText(width / 2, height - 30, Graphics.FONT_TINY, "DOWN to stop", Graphics.TEXT_JUSTIFY_CENTER);
        }
    }
}
