using Toybox.WatchUi;

class TransitionDelegate extends WatchUi.BehaviorDelegate {
    private var app;
    private var transitionView;
    private var previousView;
    private var previousDelegate;
    private var nextAction;

    function initialize(a, view, prevView, prevDelegate, action) {
        app = a;
        transitionView = view;
        previousView = prevView;
        previousDelegate = prevDelegate;
        nextAction = action;
        BehaviorDelegate.initialize();
    }

    function onTransitionComplete() {
        if (nextAction == :startBreak) {
            app.startBreak();
        } else if (nextAction == :startWork) {
            app.startWork();
        }
        returnToMainView();
    }
    
    function returnToMainView() {
        if (previousView != null and previousDelegate != null) {
            WatchUi.switchToView(previousView, previousDelegate, WatchUi.SLIDE_IMMEDIATE);
        }
    }
}