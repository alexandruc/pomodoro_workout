using Toybox.WatchUi;
using Toybox.Timer;

class TransitionDelegate extends WatchUi.BehaviorDelegate {
    private var app;
    private var transitionView;
    private var previousView;
    private var previousDelegate;
    private var nextAction;
    private var transitionTimer;

    function initialize(a, view, prevView, prevDelegate, action) {
        app = a;
        transitionView = view;
        previousView = prevView;
        previousDelegate = prevDelegate;
        nextAction = action;
        BehaviorDelegate.initialize();
        
        transitionTimer = new Timer.Timer();
        transitionTimer.start(method(:onTimerExpired), 3000, false);
    }
    
    function onTimerExpired() as Void {
        app.executeTransition();
        returnToMainView();
    }
    
    function returnToMainView() {
        if (previousView != null and previousDelegate != null) {
            WatchUi.switchToView(previousView, previousDelegate, WatchUi.SLIDE_IMMEDIATE);
        }
    }
}