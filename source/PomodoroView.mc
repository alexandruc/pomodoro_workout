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
        
        var timeFont = Graphics.FONT_NUMBER_THAI_HOT;
        var statusFont = Graphics.FONT_SMALL;
        
        var timeHeight = dc.getFontHeight(timeFont);
        var statusHeight = dc.getFontHeight(statusFont);
        var hintFont = Graphics.FONT_TINY;
        var hintHeight = dc.getFontHeight(hintFont);
        
        var centerY = height / 2;
        var timeY = centerY - timeHeight / 2;
        var statusY = timeY + timeHeight / 2 + statusHeight / 2 + 30;
        var hintY = statusY + statusHeight / 2 + hintHeight / 2 + 10;
        
        dc.drawText(width / 2, timeY, timeFont, timeStr, Graphics.TEXT_JUSTIFY_CENTER);
        
        dc.setColor(statusColor, Graphics.COLOR_BLACK);
        dc.drawText(width / 2, statusY, statusFont, status, Graphics.TEXT_JUSTIFY_CENTER);
        
        dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_BLACK);
        
        if (state == :idle) {
            dc.drawText(width / 2, hintY, hintFont, "START to work", Graphics.TEXT_JUSTIFY_CENTER);
        } else if (state == :working or state == :breakTime) {
            dc.drawText(width / 2, hintY, hintFont, "DOWN to stop", Graphics.TEXT_JUSTIFY_CENTER);
        }
    }
}
