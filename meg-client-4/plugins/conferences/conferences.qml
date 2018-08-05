import QtQuick 2.7
import QtQuick.Controls 2.1
import Qt.labs.settings 1.0
import Components 1.0 as Components
import Awesome 1.0

Item {
    property string searchText
    property string toolBarState: "normal"
    property var topLeft: {"action": function(){ return appWindow.eventNotified("openDrawer", {}); }, "icon": "bars"}
    property var topRightCenter: {
        if (toolBarState === "normal") {
            return {"action": function(){ return appWindow.eventNotified("changeToolBarState", {"state": "search"}); }, "icon": "search"}
        } else {
            return {"action": function(){ return appWindow.eventNotified("changeToolBarState", {"state": "normal"}); }, "icon": "close"}
        }
    }
    property var topRight: {"action": conferencesJsonListModel.load, "icon": "refresh"}
    property string toolBarText: "Conferences"
    property string pageName: "conferences.qml"    

    Connections {
        target: appWindow
        onEventNotified: {
            if (eventName === "updateConferencesModel"){
                conferencesJsonListModel.load()
            } else if (eventName === "changeToolBarState") {
                toolBarState = eventData["state"]
            }
        }
    }

    Components.JSONListModel {
        id: revalidateTokenJsonListModel
        source: internal.baseServer + "/api/token"
        requestMethod: "GET"
        additionalHeaders: [{"key": "Authorization", "value": "Basic " + settings.base64StringOfUserColonPassword }]
        onStateChanged: {
            if (state === "ready" && httpStatus == 200) {
                settings.authToken = revalidateTokenJsonListModel.json["token"]
                conferencesJsonListModel.load()
            } else if (state === "error") {
                //show toast with error message here
            }
        }
    }

    Components.JSONListModel {
        id: conferencesJsonListModel
        source: internal.baseServer + "/conferences"
        additionalHeaders: [{"key": "Authorization", "value": "Token " + settings.authToken}]
        onStateChanged: {
            if (state === "ready" && httpStatus == 200) {
                conferencesSettings.conferencesModel = json
            } else if (state === "error" && httpStatus == 401) {
                revalidateTokenJsonListModel.load()
            }
        }
    }       

    Settings {
        id: conferencesSettings
        property var conferencesModel
    }

    BusyIndicator {
        id: busyIndicator
        width: parent.width * 0.20
        height: parent.width * 0.20
        anchors.centerIn: parent
        running: conferencesJsonListModel.state === "loading"|| revalidateTokenJsonListModel.state === "loading"
    }

    Components.ListView {
        id: listView
        anchors.fill: parent
        visible: true        
        titleField: "name"
        awesomeIcon: "university"
        detailPage: core.pluginsDir() + "/conferences/conferences-detail.qml"
        showEmptyLabel: !busyIndicator.running
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
        if (conferencesSettings.conferencesModel)
            listView.listModel = conferencesSettings.conferencesModel
        conferencesJsonListModel.load()
    }
}
