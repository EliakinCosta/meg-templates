import QtQuick 2.7
import QtQuick.Controls 2.1
import Qt.labs.settings 1.0
import Components 1.0 as Components
import Awesome 1.0

Item {
    property var topLeft: {"action": function(){ return appWindow.eventNotified("openDrawer", {}); }, "icon": "bars"}
    property var topRight: {"action": conferencesJsonListModel.load, "icon": "refresh"}
    property string toolBarText: "Conferences"
    property string pageName: "conferences.qml"

    Connections {
        target: appWindow
        onEventNotified: {
            if (eventName === "updateConferencesModel"){
                conferencesJsonListModel.load()
            }
        }
    }    

    Components.JSONListModel {
        id: conferencesJsonListModel
        source: internal.baseServer + "/conferences"
        additionalHeaders: [settings.authHeader]
        onStateChanged: {
            if (state === "ready" && httpStatus == 200) {
                conferencesSettings.conferencesModel = json
            }
        }
    }       

    Settings {
        id: conferencesSettings
        property var conferencesModel
    }

    BusyIndicator {
        width: parent.width * 0.20
        height: parent.width * 0.20
        anchors.centerIn: parent
        running: conferencesJsonListModel.state === "loading"
    }

    Components.ListView {
        anchors.fill: parent
        visible: true
        listModel: conferencesSettings.conferencesModel
        titleField: "name"
        awesomeIcon: "university"
        detailPage: core.pluginsDir() + "/conferences/conferences-detail.qml"
        onItemClicked: { mainStack.push(detailPage, {"model": dataIndex, "state": "edit"}) }
    }

    RoundButton {
        text: FontAwesome.icons["plus"]
        radius: 200; width: 50; height: width        
        anchors {
            bottom: parent.bottom
            bottomMargin: 16
            right: parent.right
            rightMargin: 16
        }
        onClicked: {
            mainStack.push(core.pluginsDir() + "/conferences/conferences-detail.qml", {"state": "add", "model": ({})})
        }
    }

    Component.onCompleted: {
        if (conferencesSettings.conferencesModel === undefined)
            conferencesJsonListModel.load()
    }
}
