using Toybox.WatchUi;
using Toybox.Graphics;

class AlertView extends WatchUi.View {
    private var message;
    private var selectedItem;
    
    function initialize(msg) {
        message = msg;
        selectedItem = 0;
        View.initialize();
    }

    function onLayout(dc) {
    }

    function onShow() {
    }

    function onHide() {
    }

    function onUpdate(dc) {
        var width = dc.getWidth();
        var height = dc.getHeight();
        
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();
        
        var titleFont = Graphics.FONT_TINY;
        var optionFont = Graphics.FONT_TINY;
        
        var centerX = width / 2;
        var titleY = height * 0.15;
        var optionsStartY = height * 0.45;
        var spacing = height * 0.14;
        
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.drawText(centerX, titleY, titleFont, message, Graphics.TEXT_JUSTIFY_CENTER);
        
        var options = ["Start Work", "Start Break", "Dismiss"];
        
        for (var i = 0; i < options.size(); i++) {
            var y = optionsStartY + i * spacing;
            
            if (selectedItem == i) {
                dc.setColor(Graphics.COLOR_GREEN, Graphics.COLOR_BLACK);
            } else {
                dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_BLACK);
            }
            
            dc.drawText(centerX, y, optionFont, options[i], Graphics.TEXT_JUSTIFY_CENTER);
        }
    }
    
    function getSelectedItem() {
        return selectedItem;
    }
    
    function setSelectedItem(item) {
        selectedItem = item;
    }
}
