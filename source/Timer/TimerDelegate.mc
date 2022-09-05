//
// Copyright 2016-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Lang;
import Toybox.WatchUi;

//! Input handler to stop timer on menu press
class TimerDelegate extends WatchUi.BehaviorDelegate {
    private var _view as TimerView;

    //! Constructor
    //! @param view The app view
    public function initialize(view as TimerView) {
        WatchUi.BehaviorDelegate.initialize();
        _view = view;
    }

    //! Stop the first timer on menu event
    //! @return true if handled, false otherwise
    public function onMenu() as Boolean {
        if(!_view.isRunning) {
            _view._count = 300;
        }
        return true;
    }

    //! Stop the first timer on menu event
    //! @return true if handled, false otherwise
    public function onSelect() as Boolean {
        if(!_view.isRunning) {
            _view.notify(_view.STATE_MINUTE);
            _view.startTimer();
            _view.isRunning = true;
        } else {
            _view.notify(_view.STATE_MINUTE);
            _view.stopTimer();
            _view.isRunning = false;
        }
        
        return true;
    }
    function onNextPage() {
        if(_view.isRunning) {
            _view.notify(_view.STATE_MINUTE);
		    return _view.sync(false);
        }

        return true;
	}
    
    function onBack() {
//        System.println("TackingMasterMenuDelegate::onBack()");
        WatchUi.popView(WatchUi.SLIDE_DOWN);
    }
}