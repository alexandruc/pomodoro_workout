using Toybox.WatchUi;
using Toybox.Graphics;

class TransitionView extends WatchUi.View {
    private var app;
    private var message;
    
    function initialize(a, msg) {
        app = a;
        message = msg;
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
        var centerY = height / 2;
        
        dc.setColor(0x9900FF, Graphics.COLOR_BLACK);
        dc.drawText(centerX, centerY - 20, titleFont, message, Graphics.TEXT_JUSTIFY_CENTER);
        
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.drawText(centerX, centerY + 20, optionFont, "...", Graphics.TEXT_JUSTIFY_CENTER);
    }
}