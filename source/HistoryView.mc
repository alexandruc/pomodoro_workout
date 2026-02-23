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
        
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();
        
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.drawText(dc.getWidth() / 2, 5, Graphics.FONT_SMALL, "7-Day History", Graphics.TEXT_JUSTIFY_CENTER);
        
        var chartWidth = dc.getWidth() - 40;
        var chartHeight = 80;
        var barWidth = chartWidth / 7 - 4;
        var startX = 20;
        var startY = dc.getHeight() - 40;
        
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
            var label = (6 - i + 1).toString();
            dc.drawText(x + barWidth / 2, startY + 3, Graphics.FONT_TINY, label, Graphics.TEXT_JUSTIFY_CENTER);
        }
        
        var total = 0;
        for (var i = 0; i < history.size(); i++) {
            total = total + history[i];
        }
        
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.drawText(dc.getWidth() / 2, dc.getHeight() - 15, Graphics.FONT_TINY, "Total: " + total, Graphics.TEXT_JUSTIFY_CENTER);
    }
}
