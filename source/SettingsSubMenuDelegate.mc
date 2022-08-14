import Toybox.WatchUi;
import Toybox.Lang;

/*class SettingsMenu extends Rez.Menus.SettingsMenu {

  function initialize() {
    Rez.Menus.SettingsMenu.initialize();
    var itemId = me.findItemById("boat_symbol");
    System.println(itemId);
    item.setEnabled(Application.Storage.getValue("DrawBaot"));
    me.updateItem(item, itemId);
  }

}*/

class SettingsSubMenuDelegate extends WatchUi.Menu2InputDelegate {
    function initialize() {
        Menu2InputDelegate.initialize();
 /*       //Menu2.findItemById("boat_symbol").setEnabled(Application.Storage.getValue("DrawBaot"));
        var itemId = submenu.findItemById("boat_symbol");
        System.println(itemId);
        var menu_item   = WatchUi.Menu2.getItem(itemId);
        System.println(menu_item);
        //menu_item.setEnabled(Application.Storage.getValue("DrawBaot"));*/
    }

    function onSelect(item as WatchUi.ToggleMenuItem) {
        if (item.getId() == :boat_symbol) {
            Application.Storage.setValue("DrawBoat", item.isEnabled());
        }
        if (item.getId() == :cardinal_points) {
            Application.Storage.setValue("DrawNWSE", item.isEnabled()); 
        }
        if (item.getId() == :speed_history) {
            Application.Storage.setValue("DrawSpeedPlot", item.isEnabled());
        }
        if (item.getId() == :cog_history) {
            Application.Storage.setValue("DrawPolarCogPlot", item.isEnabled());
        }
    }

    function onBack() {
        System.println("Menu2SettingsSubMenuDelegate::onBack()");
        WatchUi.popView(WatchUi.SLIDE_DOWN);
        WatchUi.popView(WatchUi.SLIDE_DOWN);
    }

    function onDone() {
        System.println("Menu2SettingsSubMenuDelegate::onDone()");
        WatchUi.popView(WatchUi.SLIDE_DOWN);
    }
}