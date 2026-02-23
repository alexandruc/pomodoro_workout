using Toybox.WatchUi;
using Toybox.Graphics;

class SettingsView extends WatchUi.View {
    private var app;
    private var selectedItem;
    
    function initialize(a) {
        app = a;
        View.initialize();
        selectedItem = 0;
    }

    function onLayout(dc) {
    }

    function onShow() {
    }

    function onHide() {
    }

    function onUpdate(dc) {
        var workTime = app.getWorkTime();
        var breakTime = app.getBreakTime();
        
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();
        
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.drawText(dc.getWidth() / 2, 10, Graphics.FONT_SMALL, "Settings", Graphics.TEXT_JUSTIFY_CENTER);
        
        var y = 50;
        var spacing = 40;
        
        if (selectedItem == 0) {
            dc.setColor(Graphics.COLOR_GREEN, Graphics.COLOR_BLACK);
        } else {
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        }
        dc.drawText(20, y, Graphics.FONT_SMALL, "Work: " + workTime + " min", Graphics.TEXT_JUSTIFY_LEFT);
        
        y = y + spacing;
        
        if (selectedItem == 1) {
            dc.setColor(Graphics.COLOR_GREEN, Graphics.COLOR_BLACK);
        } else {
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        }
        dc.drawText(20, y, Graphics.FONT_SMALL, "Break: " + breakTime + " min", Graphics.TEXT_JUSTIFY_LEFT);
        
        y = y + spacing;
        
        if (selectedItem == 2) {
            dc.setColor(Graphics.COLOR_GREEN, Graphics.COLOR_BLACK);
        } else {
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        }
        dc.drawText(20, y, Graphics.FONT_SMALL, "History", Graphics.TEXT_JUSTIFY_LEFT);
        
        dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_BLACK);
        dc.drawText(dc.getWidth() / 2, dc.getHeight() - 20, Graphics.FONT_TINY, "UP/DN: select  +/-: change", Graphics.TEXT_JUSTIFY_CENTER);
    }
    
    function getSelectedItem() {
        return selectedItem;
    }
    
    function setSelectedItem(item) {
        selectedItem = item;
    }
}
