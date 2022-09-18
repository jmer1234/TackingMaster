import Toybox.Application;
import Toybox.WatchUi;
import Toybox.System;
import Toybox.Position;
import Toybox.Lang;
import Toybox.ActivityRecording;

var _session as Session?;

//Main master-class
class TackingMasterApp extends Application.AppBase {

	var m_TackingMasterView as TackingMasterView?;
	var m_TackingMasterDelegate as TackingMasterDelegate?;


    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up 
    function onStart(state as Dictionary?) as Void {
//        System.println("TackingMasterView.onUpdate"); 

        //Start GPS
        Position.enableLocationEvents( Position.LOCATION_CONTINUOUS, method(:onPosition) );

		// read our settings
		var WindDirection;
		WindDirection = Application.getApp().getProperty("WindDirection_prop");
		if (WindDirection==null){
			WindDirection = 180;
		}

    }

    // onStop() is called when your application is exiting
    function onStop(state as Dictionary?) as Void {
        
        var TackingMasterView = m_TackingMasterView;

        //Stop GPS
        Position.enableLocationEvents(Position.LOCATION_DISABLE, method(:onPosition));

        // Stop recording the session
        if (TackingMasterView != null) {
            TackingMasterView.stopRecording();
        }

    	// Save settings to next time
		var WindDirection = Application.Storage.getValue("WindDirection");
		Application.getApp().setProperty("WindDirection_prop", WindDirection);

    }

    function onPosition(info as Info) as Void { 
        m_TackingMasterView.setPosition(info);
    }
	
    // Return the initial view of your application here
    function getInitialView() {
		m_TackingMasterView = new TackingMasterView();
		m_TackingMasterDelegate = new TackingMasterDelegate();

        return [ m_TackingMasterView, m_TackingMasterDelegate ] as Array<Views or InputDelegates>;
    }

}

//! Stop the recording and save
public function stopSaveRecording() as Void {
    var session = _session;
    if ((Toybox has :ActivityRecording) && isSessionRecording() && (session != null)) {
        session.stop();
        session.save();
        _session = null;
        WatchUi.requestUpdate();
    }
}

//! Stop the recording and don't save
public function stopRecording() as Void {
    var session = _session;
    if ((Toybox has :ActivityRecording) && isSessionRecording() && (session != null)) {
        session.stop();
        session.discard();
        _session = null;
        WatchUi.requestUpdate();
    }
}

//! Start recording a session
public function startRecording() as Void {
    var session = ActivityRecording.createSession({:name=>"Tacking Master Sailing", :sport=>ActivityRecording.SPORT_SAILING});
    _session = session;
    session.start();
    WatchUi.requestUpdate();
}

//! Get whether a session is currently recording
//! @return true if there is a session currently recording, false otherwise
public function isSessionRecording() as Boolean {
    var session = _session;
    if (session != null) {
        return session.isRecording();
    }
    return false;
}