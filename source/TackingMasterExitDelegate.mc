import Toybox.WatchUi;

class TackingMasterExitDelegate extends WatchUi.Menu2InputDelegate {

    function initialize() {
        Menu2InputDelegate.initialize();
    }

    function onSelect(item) {
        if( item.getId().equals("idSaveExit") ) {
            if ($.isSessionRecording()) {
                $.stopSaveRecording();
            }  
            WatchUi.popView(WatchUi.SLIDE_DOWN);
            WatchUi.popView(WatchUi.SLIDE_DOWN);
        } else if ( item.getId().equals("idExit") ) {  
            if ($.isSessionRecording()) {
                $.stopRecording();
            }    
            WatchUi.popView(WatchUi.SLIDE_DOWN);
            WatchUi.popView(WatchUi.SLIDE_DOWN);
        }
    }
    
    function onBack() {
//        System.println("TackingMasterMenuDelegate::onBack()");
        WatchUi.popView(WatchUi.SLIDE_DOWN);
    }

}