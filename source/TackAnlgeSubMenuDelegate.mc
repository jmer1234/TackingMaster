import Toybox.WatchUi;
import Toybox.Lang;

class TackAngleSubMenuDelegate extends WatchUi.Menu2InputDelegate {
    function initialize() {
        Menu2InputDelegate.initialize();
    }

    function onSelect(item as WatchUi.MenuItem) as Void{
        if (item.getId() == :tack_angle_80) {
            Application.Storage.setValue("TackAngle", 80);
            WatchUi.popView(WatchUi.SLIDE_DOWN);
            WatchUi.popView(WatchUi.SLIDE_DOWN);
        }
        if (item.getId() == :tack_angle_90) {
            Application.Storage.setValue("TackAngle", 90);
            WatchUi.popView(WatchUi.SLIDE_DOWN);
            WatchUi.popView(WatchUi.SLIDE_DOWN);
        }
        if (item.getId() == :tack_angle_100) {
            Application.Storage.setValue("TackAngle", 100);
            WatchUi.popView(WatchUi.SLIDE_DOWN);
            WatchUi.popView(WatchUi.SLIDE_DOWN);
        }
        if (item.getId() == :tack_angle_110) {
            Application.Storage.setValue("TackAngle", 110);
            WatchUi.popView(WatchUi.SLIDE_DOWN);
            WatchUi.popView(WatchUi.SLIDE_DOWN);
        }
    }
}