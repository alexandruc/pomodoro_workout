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
        var transitionMode = app.getTransitionMode();
        
        var screenWidth = dc.getWidth();
        var screenHeight = dc.getHeight();
        
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();
        
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        
        var titleFont = Graphics.FONT_TINY;
        var itemFont = Graphics.FONT_TINY;
        
        var centerX = screenWidth / 2;
        
        var titleY = screenHeight * 0.05;
        var startY = screenHeight * 0.18;
        var spacing = screenHeight * 0.12;
        
        dc.drawText(centerX, titleY, titleFont, "Settings", Graphics.TEXT_JUSTIFY_CENTER);
        
        if (selectedItem == 0) {
            dc.setColor(Graphics.COLOR_GREEN, Graphics.COLOR_BLACK);
        } else {
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        }
        dc.drawText(centerX, startY, itemFont, "Work: " + workTime + " min", Graphics.TEXT_JUSTIFY_CENTER);
        
        if (selectedItem == 1) {
            dc.setColor(Graphics.COLOR_GREEN, Graphics.COLOR_BLACK);
        } else {
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        }
        dc.drawText(centerX, startY + spacing, itemFont, "Break: " + breakTime + " min", Graphics.TEXT_JUSTIFY_CENTER);
        
        var transitionText = transitionMode == :auto ? "Transition: Auto" : "Transition: Manual";
        if (selectedItem == 2) {
            dc.setColor(Graphics.COLOR_GREEN, Graphics.COLOR_BLACK);
        } else {
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        }
        dc.drawText(centerX, startY + spacing * 2, itemFont, transitionText, Graphics.TEXT_JUSTIFY_CENTER);
        
        if (selectedItem == 3) {
            dc.setColor(Graphics.COLOR_GREEN, Graphics.COLOR_BLACK);
        } else {
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        }
        dc.drawText(centerX, startY + spacing * 3, itemFont, "History", Graphics.TEXT_JUSTIFY_CENTER);
        
              
    }
    
    function getSelectedItem() {
        return selectedItem;
    }
    
    function setSelectedItem(item) {
        selectedItem = item;
    }
}
