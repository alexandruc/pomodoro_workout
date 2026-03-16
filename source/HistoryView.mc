using Toybox.WatchUi;
using Toybox.Graphics;

class HistoryView extends WatchUi.View {
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
        var history = app.getHistoryArray();
        
        var screenWidth = dc.getWidth();
        var screenHeight = dc.getHeight();
        
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();
        
        var titleFont = Graphics.FONT_TINY;
        var labelFont = Graphics.FONT_TINY;
        var totalFont = Graphics.FONT_TINY;
        
        var centerX = screenWidth / 2;
        
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.drawText(centerX, screenHeight * 0.08, titleFont, "7-Day History", Graphics.TEXT_JUSTIFY_CENTER);
        
        var chartWidth = screenWidth * 0.7;
        var chartHeight = screenHeight * 0.35;
        var barWidth = chartWidth / 7 - 4;
        var startX = screenWidth * 0.15;
        var startY = screenHeight * 0.70;
        
        var maxVal = 1;
        for (var i = 0; i < history.size(); i++) {
            if (history[i] > maxVal) {
                maxVal = history[i];
            }
        }
        
        for (var i = 0; i < history.size(); i++) {
            var x = startX + i * (barWidth + 4);
            var barHeight = history[i] * chartHeight / maxVal;
            if (barHeight < 2) {
                barHeight = 2;
            }
            
            if (history[i] > 0) {
                dc.setColor(Graphics.COLOR_GREEN, Graphics.COLOR_BLACK);
            } else {
                dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_BLACK);
            }
            
            dc.fillRectangle(x, startY - barHeight, barWidth, barHeight);
            
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
            var label = (i + 1).toString();
            dc.drawText(x + barWidth / 2, startY + 2, labelFont, label, Graphics.TEXT_JUSTIFY_CENTER);
        }
        
        var total = 0;
        for (var i = 0; i < history.size(); i++) {
            total = total + history[i];
        }
        
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.drawText(centerX, startY + 60, totalFont, "Total: " + total, Graphics.TEXT_JUSTIFY_CENTER);
    }
}
