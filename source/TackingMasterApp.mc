import Toybox.Application;
import Toybox.WatchUi;
import Toybox.System;
import Toybox.Position;
import Toybox.Lang;

//Main master-class
class TackingMasterApp extends Application.AppBase {

	var m_TackingMasterView;
	var m_TackingMasterDelegate;


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

        //Stop GPS
        Position.enableLocationEvents(Position.LOCATION_DISABLE, method(:onPosition));

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
