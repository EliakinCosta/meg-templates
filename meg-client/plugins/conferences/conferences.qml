import QtQuick 2.7
import QtQuick.Controls 2.1
import Qt.labs.settings 1.0
import Components 1.0
import Awesome 1.0

Item {
    property var toolBarConfig: {
        "label": {"text": "Conferences", "bold": false, "color": "white"},
        "toolButton1": {"action": function(){ return appWindow.eventNotified("openDrawer", {}); }, "icon": "bars"},
        "toolButton4": {"action": conferencesJsonListModel.load, "icon": "refresh"}
    }

    Connections {
        target: appWindow
        onEventNotified: {
            if (eventName === "updateConferencesModel"){
                conferencesJsonListModel.load()
            }
        }
    }

    JSONListModel {
        id: conferencesJsonListModel
        source: internal.baseServer + "/conferences"
        onStateChanged: {
            if (state === "ready" && httpStatus == 200) {
               settings.conferencesModel = json
            }
        }
    }

    Settings {
        id: settings
        property var conferencesModel
    }

    BusyIndicator {
        width: parent.width * 0.20
        height: parent.width * 0.20
        anchors.centerIn: parent
        running: conferencesJsonListModel.state === "loading"
    }

    MyStackView {
        id: _stackView
        visible: conferencesJsonListModel.state !== "loading"
        anchors.fill: parent
        model: settings.conferencesModel
        itemHead: contents[index].itemHead
        itensPage: pluginsDir + "/conferences/conferences-detail.qml"
        editPage: pluginsDir + "/conferences/conferences-edit.qml"
        icon: contents[index].icon
    }

    RoundButton {
        text: FontAwesome.icons["plus"]
        radius: 200; width: 50; height: width
        visible: _stackView.depth <= 1
        anchors {
                horizontalCenter: undefined
                bottom: parent.bottom
                bottomMargin: 16
                right: parent.right
                rightMargin: 16
        }
        onClicked: {
            _stackView.push(_stackView.editPage, {"stackView": _stackView })
        }
    }    

    Component.onCompleted: {
        if (settings.conferencesModel === undefined)
            conferencesJsonListModel.load()
    }
}
