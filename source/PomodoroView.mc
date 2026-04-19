using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Time;

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
        
        var timeFont;
        var statusFont;
        
        if (width <= 218) {
            timeFont = Graphics.FONT_NUMBER_MEDIUM;
            statusFont = Graphics.FONT_TINY;
        } else if (width <= 260) {
            timeFont = Graphics.FONT_NUMBER_THAI_HOT;
            statusFont = Graphics.FONT_TINY;
        } else {
            timeFont = Graphics.FONT_NUMBER_THAI_HOT;
            statusFont = Graphics.FONT_SMALL;
        }
        
        var timeHeight = dc.getFontHeight(timeFont);
        var statusHeight = dc.getFontHeight(statusFont);
        var hintFont = Graphics.FONT_TINY;
        var hintHeight = dc.getFontHeight(hintFont);
        var todFont = Graphics.FONT_TINY;
        var todHeight = dc.getFontHeight(todFont);
        
        var clockTime = System.getClockTime();
        var todStr = Lang.format("$1$:$2$:$3$", [
            clockTime.hour.format("%02d"),
            clockTime.min.format("%02d"),
            clockTime.sec.format("%02d")
        ]);
        
        var centerY = height / 2;
        var labelY = centerY - timeHeight / 2 - todHeight * 2 - (height * 0.02);
        var todY = centerY - timeHeight / 2 - todHeight - (height * 0.01);
        var timeY = centerY - timeHeight / 2;
        var statusY = timeY + timeHeight / 2 + statusHeight / 2 + (height * 0.06);
        var hintY = statusY + statusHeight / 2 + hintHeight / 2 + (height * 0.02);
        
        var purple = 0x9900FF;
        var line1Y = todY + todHeight + (timeY - (todY + todHeight)) / 2;
        var line2Y = statusY + statusHeight + (hintY - (statusY + statusHeight)) / 2;
        
        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_BLACK);
        dc.drawText(width / 2, labelY, todFont, "Time of day", Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(width / 2, todY, todFont, todStr, Graphics.TEXT_JUSTIFY_CENTER);
        
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.drawText(width / 2, timeY, timeFont, timeStr, Graphics.TEXT_JUSTIFY_CENTER);
        
        dc.setColor(purple, Graphics.COLOR_BLACK);
        dc.drawLine(width * 0.2, line1Y, width * 0.8, line1Y);
        
        dc.setColor(statusColor, Graphics.COLOR_BLACK);
        dc.drawText(width / 2, statusY, statusFont, status, Graphics.TEXT_JUSTIFY_CENTER);
        
        dc.setColor(purple, Graphics.COLOR_BLACK);
        dc.drawLine(width * 0.2, line2Y, width * 0.8, line2Y);
        
        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_BLACK);
        
        if (state == :idle) {
            dc.drawText(width / 2, hintY, hintFont, "START to work", Graphics.TEXT_JUSTIFY_CENTER);
        } else if (state == :working or state == :breakTime) {
            dc.drawText(width / 2, hintY, hintFont, "DOWN to stop", Graphics.TEXT_JUSTIFY_CENTER);
        }
    }
}
