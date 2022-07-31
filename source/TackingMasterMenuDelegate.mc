import Toybox.WatchUi;
import Toybox.System;
import Toybox.Position;
import Toybox.Math;
import Toybox.Lang;


// Find COG / Heading
//===================
function getCOG() {
	var positionInfo = Position.getInfo();
	var Heading_deg = 0;
	if(positionInfo!=null){
		Heading_deg = (positionInfo.heading)/Math.PI*180;
	}
	return Heading_deg;
}


class TackingMasterMenuDelegate extends WatchUi.Menu2InputDelegate {

    function initialize() {
        Menu2InputDelegate.initialize();
    }

    function onSelect(item) {
        var tackAngle = Application.Storage.getValue("TackAngle");
        if( item.getId().equals("idSetPortWD") ) {
            // When the toggle menu item is selected, push a new menu that demonstrates
            // left and right toggles with automatic substring toggles.
            //Set port tack
//            System.println("TackingMasterMenuDelegate::onSelect() - idSetPortWD");
	        var COG = getCOG();
	        //var WindDirection = COG-45;
            var WindDirection = COG - (tackAngle / 2);
        	Application.Storage.setValue("WindDirection", WindDirection);
	        WatchUi.popView(WatchUi.SLIDE_DOWN);
            System.println("COG: " + COG);
            System.println("PortWD: " +WindDirection);
        } else if ( item.getId().equals("idSetStarbWD") ) {
            //Set starboard tack
//          System.println("TackingMasterMenuDelegate::onSelect() - idSetStarbWD");
	        var COG = getCOG();
	        //var WindDirection = COG+45;
            var WindDirection = COG + (tackAngle / 2);
        	Application.Storage.setValue("WindDirection", WindDirection);
	        WatchUi.popView(WatchUi.SLIDE_DOWN);
            System.println("COG: " + COG);
            System.println("StbdWD: " +WindDirection);
        } else if ( item.getId().equals("idTackAngle") ) {
            var tackAngleMenu = new WatchUi.Menu2({:title=>WatchUi.loadResource(Rez.Strings.menu_label_TackAngle)});
            var tackAngleLabel = WatchUi.loadResource(Rez.Strings.menu_label_TackAngle);
            var tackAngle80 = WatchUi.loadResource(Rez.Strings.menu_label_TackAngle80);
            var tackAngle90 = WatchUi.loadResource(Rez.Strings.menu_label_TackAngle90);
            var tackAngle100 = WatchUi.loadResource(Rez.Strings.menu_label_TackAngle100);
            var tackAngle110 = WatchUi.loadResource(Rez.Strings.menu_label_TackAngle110);

            //Build the settings-menu
            tackAngleMenu.addItem(new WatchUi.MenuItem(tackAngleLabel, tackAngle80, "idSetTackAngle80", null));
            //WatchUi.pushView(tackAngleMenu, new Menu2TackAngleSubMenuDelegate(), WatchUi.SLIDE_UP );
            tackAngleMenu.addItem(new WatchUi.MenuItem(tackAngleLabel, tackAngle90, "idSetTackAngle90", null));
            //WatchUi.pushView(tackAngleMenu, new Menu2TackAngleSubMenuDelegate(), WatchUi.SLIDE_UP );
            tackAngleMenu.addItem(new WatchUi.MenuItem(tackAngleLabel, tackAngle100, "idSetTackAngle100", null));
            //WatchUi.pushView(tackAngleMenu, new Menu2TackAngleSubMenuDelegate(), WatchUi.SLIDE_UP );
            tackAngleMenu.addItem(new WatchUi.MenuItem(tackAngleLabel, tackAngle110, "idSetTackAngle110", null));
            WatchUi.pushView(tackAngleMenu, new Menu2TackAngleSubMenuDelegate(), WatchUi.SLIDE_UP );
        } else if ( item.getId().equals("idSettings") ) {
//          System.println("TackingMasterMenuDelegate::onSelect() - idSettings");
            var settingsMenu = new WatchUi.Menu2({:title=>WatchUi.loadResource(Rez.Strings.menu_label_Settings)});

			//Get string resources for Settings-menu
			var strDrawBoat = WatchUi.loadResource(Rez.Strings.menu_label_DrawBoat);
			var strShow = WatchUi.loadResource(Rez.Strings.menu_label_Show);
			var strHide = WatchUi.loadResource(Rez.Strings.menu_label_Hide);
			var strDrawNWSE = WatchUi.loadResource(Rez.Strings.menu_label_DrawNWSE);
			var strDrawSpeedPlot = WatchUi.loadResource(Rez.Strings.menu_label_DrawSpeedPlot);
			var strDrawPolarCogPlot = WatchUi.loadResource(Rez.Strings.menu_label_DrawPolarCogPlot);

    		// Get settings
    		var bDrawBoat = Application.Storage.getValue("DrawBoat");   	
    		if (bDrawBoat!=false) {bDrawBoat = true;} 
    			else {bDrawBoat = false;}
    		var bDrawNWSE = Application.Storage.getValue("DrawNWSE");   
    		if (bDrawNWSE!=false) {bDrawNWSE = true;} 
    			else {bDrawNWSE = false;}
    		var bDrawSpeedPlot = Application.Storage.getValue("DrawSpeedPlot");   
    		if (bDrawSpeedPlot!=false) {bDrawSpeedPlot = true;} 
    			else {bDrawSpeedPlot = false;}
    		var bDrawPolarCogPlot = Application.Storage.getValue("DrawPolarCogPlot");   
    		if (bDrawPolarCogPlot!=false) {bDrawPolarCogPlot = true;} 
    			else {bDrawPolarCogPlot = false;}


			//Build the settings-menu
            settingsMenu.addItem(new WatchUi.ToggleMenuItem(strDrawBoat, {:enabled=>strShow, :disabled=>strHide}, "idDrawBoat", bDrawBoat, {:alignment=>WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}));
            WatchUi.pushView(settingsMenu, new Menu2SettingsSubMenuDelegate(), WatchUi.SLIDE_UP );
            settingsMenu.addItem(new WatchUi.ToggleMenuItem(strDrawNWSE, {:enabled=>strShow, :disabled=>strHide}, "idDrawNWSE", bDrawNWSE, {:alignment=>WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}));
            WatchUi.pushView(settingsMenu, new Menu2SettingsSubMenuDelegate(), WatchUi.SLIDE_UP );
            settingsMenu.addItem(new WatchUi.ToggleMenuItem(strDrawSpeedPlot, {:enabled=>strShow, :disabled=>strHide}, "idDrawSpeedPlot", bDrawSpeedPlot, {:alignment=>WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}));
            WatchUi.pushView(settingsMenu, new Menu2SettingsSubMenuDelegate(), WatchUi.SLIDE_UP );
            settingsMenu.addItem(new WatchUi.ToggleMenuItem(strDrawPolarCogPlot, {:enabled=>strShow, :disabled=>strHide}, "idDrawPolarCogPlot", bDrawPolarCogPlot, {:alignment=>WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}));
            WatchUi.pushView(settingsMenu, new Menu2SettingsSubMenuDelegate(), WatchUi.SLIDE_UP );
/*
        } else {
            WatchUi.requestUpdate();
*/
        }
    }
    
    function onBack() {
//        System.println("TackingMasterMenuDelegate::onBack()");
        WatchUi.popView(WatchUi.SLIDE_DOWN);
    }

}


//This is the menu input delegate shared by all the basic sub-menus in the application
class Menu2SettingsSubMenuDelegate extends WatchUi.Menu2InputDelegate {
    function initialize() {
        Menu2InputDelegate.initialize();
    }

    function onSelect(item as WatchUi.ToggleMenuItem) {

        //Draw Boat
        var MenuItem = item.getId();
 //       System.println("Menu2SettingsSubMenuDelegate::onSelect() - iD=" + MenuItem + " enabled=" + item.isEnabled() );
        if (MenuItem.equals("idDrawBoat")){
//	        System.println("Menu2SettingsSubMenuDelegate::onSelect()::DrawBoat");
    		Application.Storage.setValue("DrawBoat", item.isEnabled()); 
    	} else if (MenuItem.equals("idDrawNWSE")){
//	        System.println("Menu2SettingsSubMenuDelegate::onSelect()::DrawNWSE");
    		Application.Storage.setValue("DrawNWSE", item.isEnabled()); 
		} else if (MenuItem.equals("idDrawSpeedPlot")){
//	        System.println("Menu2SettingsSubMenuDelegate::onSelect()::DrawSpeedPlot");
    		Application.Storage.setValue("DrawSpeedPlot", item.isEnabled()); 
		} else if (MenuItem.equals("idDrawPolarCogPlot")){
//	        System.println("Menu2SettingsSubMenuDelegate::onSelect()::DrawPolarCogPlot");
    		Application.Storage.setValue("DrawPolarCogPlot", item.isEnabled()); 
		} else {
//	        System.println("Menu2SettingsSubMenuDelegate::onSelect()::else");
        }

        WatchUi.requestUpdate();
    }

    function onBack() {
//        System.println("Menu2SettingsSubMenuDelegate::onBack()");
        WatchUi.popView(WatchUi.SLIDE_DOWN);
        WatchUi.popView(WatchUi.SLIDE_DOWN);
        WatchUi.popView(WatchUi.SLIDE_DOWN);
        WatchUi.popView(WatchUi.SLIDE_DOWN);
    }

    function onDone() {
        System.println("Menu2SettingsSubMenuDelegate::onDone()");
        WatchUi.popView(WatchUi.SLIDE_DOWN);
    }
}

class Menu2TackAngleSubMenuDelegate extends WatchUi.Menu2InputDelegate {
    function initialize() {
        Menu2InputDelegate.initialize();
    }

    function onSelect(item) {
        if (item.getId().equals("idSetTackAngle80") ) {
            Application.Storage.setValue("TackAngle", 80);
            WatchUi.popView(WatchUi.SLIDE_DOWN);
        }
        if (item.getId().equals("idSetTackAngle90") ) {
            Application.Storage.setValue("TackAngle", 90);
            WatchUi.popView(WatchUi.SLIDE_DOWN);
        }
        if (item.getId().equals("idSetTackAngle100") ) {
            Application.Storage.setValue("TackAngle", 100);
            WatchUi.popView(WatchUi.SLIDE_DOWN);
        }
        if (item.getId().equals("idSetTackAngle110") ) {
            Application.Storage.setValue("TackAngle", 110);
            WatchUi.popView(WatchUi.SLIDE_DOWN);
        }
    }
}
