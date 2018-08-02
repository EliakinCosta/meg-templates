import QtQuick 2.7
import QtQuick.Controls 2.1
import Components 1.0
import Awesome 1.0

Item {
    property var topLeft: {"action": function(){ return appWindow.eventNotified("openDrawer", {}); }, "icon": "bars"}    
    property string toolBarText: "Gustavo"


    Rectangle {
        anchors.fill: parent
        color: "brown"
    }
}
