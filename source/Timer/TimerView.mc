//
// Copyright 2016-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Timer;
import Toybox.WatchUi;
import Toybox.Attention;

class TimerView extends WatchUi.View {

	const FORMAT_TIME = "$1$:$2$$3$";
	const FORMAT_UP_TIME = "$1$:$2$:$3$";
	const FORMAT_TIMER = "$1$:$2$";
	const FORMAT_MIN_SEC = "%02d";

	const STATE_MINUTE = 0;
	const STATE_SIGNAL = 1;
	const STATE_COUNTDOWN = 2;
	const STATE_START = 3;
	const STATE_STARTED = 4;

    private var _timer as Timer.Timer?;
    private var _clockTimer as Timer.Timer?;
    private var _center = new [2];
    private var _vibes = false;
    private var _string as String?;
    var isRunning = false as Boolean;
    var _count as Number = 300;

    //! Constructor
    public function initialize() {

		if(Attention has :VibeProfile && _vibes == false) {
			_vibes = [
				[ new Attention.VibeProfile(30, 300) ], // STATE_MINUTE
				[ new Attention.VibeProfile(50, 500) ], // STATE_SIGNAL
				[ new Attention.VibeProfile(50, 300) ], // STATE_COUNTDOWN
				[ new Attention.VibeProfile(50, 1000) ], // STATE_START
				false // STATE_STARTED
			];
		}

        WatchUi.View.initialize();
    }

    //! Callback for timer
    public function timeCallback() as Void {
        if(isRunning) {
            if (_count > 0) {
                _count--;
            }
        }
    }

    //! Callback for clockTimer
    public function clockTimeCallback() as Void {
        //WatchUi.requestUpdate();
    }

    //! Load your resources here
    //! @param dc Device context
    public function onLayout(dc as Dc) as Void {
        _center[0] = dc.getWidth() / 2;
		_center[1] = (dc.getHeight() - dc.getFontHeight(Graphics.FONT_NUMBER_THAI_HOT)) / 2;
        var timer = new Timer.Timer();
        timer.start(method(:timeCallback), 1000, true);

        var clockTimer = new Timer.Timer();
        clockTimer.start(method(:clockTimeCallback), 1000, true);

        _timer = timer;
        _clockTimer = clockTimer;
    }

    //! Update the view
    //! @param dc Device Context
    public function onUpdate(dc as Dc) as Void {
		// vibrate
        if(isRunning) {
            if(_count == 0) { // pulse at start
                notify(STATE_START);
            } else if(_count == 30 || _count == 20 || _count == 10) {
                notify(STATE_SIGNAL);
            } else if(_count <= 5) {
                notify(STATE_COUNTDOWN);
            } else {
                var isMainMinute = (_count % 60) == 0;
                if(isMainMinute ) { // pulse on minute
                    notify(STATE_MINUTE);
                }
            }
        }
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        _string = timerString();
        dc.drawText(_center[0], _center[1]-30, Graphics.FONT_NUMBER_THAI_HOT, _string, Graphics.TEXT_JUSTIFY_CENTER);// Draw Time-text
		
        var myTime = System.getClockTime(); // ClockTime object
		var myTimeText = myTime.hour.format("%02d") + ":" + myTime.min.format("%02d") + ":" + myTime.sec.format("%02d");
		dc.drawText(_center[0], _center[1]+40, Graphics.FONT_NUMBER_MEDIUM, myTimeText, Graphics.TEXT_JUSTIFY_CENTER);

        var startStopLabel = (!isRunning) ? "Start" : "Stop";
        var syncLabel = "Syn";
        var resetLabel = "R";
        dc.drawText(220, 45, Graphics.FONT_XTINY, startStopLabel, Graphics.TEXT_JUSTIFY_RIGHT);
        if(!isRunning) {
            dc.drawText(2, _center[1] + 13, Graphics.FONT_XTINY, resetLabel, Graphics.TEXT_JUSTIFY_LEFT);
        } else {
            dc.drawText(25, 170, Graphics.FONT_XTINY, syncLabel, Graphics.TEXT_JUSTIFY_LEFT);
        }

        if (_count == 0) {
            isRunning = false;
        }
    }

    //! Stop the first timer
    public function stopTimer() as Void {
        var timer = _timer;
        if (timer != null) {
            timer.stop();
        }
    }

    //! Stop the first timer
    public function startTimer() as Void {
        var timer = _timer;
        _count--;
        if (timer != null) {
            timer.start(method(:timeCallback), 1000, true);
        }
    }

	function timerString() {
		var min;
		var sec;
		min = _count / 60;
		sec = _count % 60;
		var timerString;
		timerString = Lang.format(FORMAT_TIMER, [min, sec.format(FORMAT_MIN_SEC)]);
 		return timerString;
 	}

	function sync(inc) {
		if(isRunning) {
			//stopTimer();
			//isRunning = false;
			var min = (_count / 60).toNumber();
			if(inc && min < 5) {
				min++;
			}
			_count = min * 60;
			//startTimer();
            //isRunning = true;
			//WatchUi.requestUpdate();
		    return true;
		} else {
			return false;
		}
	}

	function notify(state) {
		if(_vibes != false && _vibes[state] != false) {
			Attention.vibrate(_vibes[state]);
		}
	}

	function onHide() {
        var timer = _timer;
        var clockTimer = _clockTimer;
        isRunning = false;
		timer.stop();
        clockTimer.stop();
	}
}
