import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.1
import QtQuick.Controls.Material 2.0
import Components 1.0

Item {
    id: item
    property StackView stackView
    property var toolBarConfig: {
        "label": {"text":"New Conference", "bold": false, "color": "white"},
        "toolButton1": {"action":stackView.pop, "icon":"arrow-left"}
    }

    JSONListModel {
        id: addConferenceJsonListModel
        source: internal.baseServer + "/add_conferences"
        requestObject: {"acronym": acronymTextField.text, "name": nameTextField.text,
                        "city": cityTextField.text, "country": countryTextField.text,
                        "venue": venueTextField.text, "start_date": start_dateTextField.text,
                        "end_date": end_dateTextField.text}
        requestMethod: "POST"
        onStateChanged: {
            if (state === "ready" && httpStatus == 200) {
               appWindow.eventNotified("updateConferencesModel", {})
               stackView.pop()
            }
        }
    }

    QtObject {
        id: pluginInternal
        property int padding: 10
    }

    BusyIndicator {
        width: parent.width * 0.20
        height: parent.width * 0.20
        anchors.horizontalCenter: parent.horizontalCenter
        running: addConferenceJsonListModel.state === "loading"
    }

    Flickable {
        id: flickable
        visible: addConferenceJsonListModel.state !== "loading"
        clip: true
        anchors {
            left: parent.left; right: parent.right; top: parent.top; bottom: parent.bottom;
            leftMargin: 6; rightMargin: 6; topMargin: 6; bottomMargin: 6
        }
        flickableDirection: Flickable.VerticalFlick
        contentHeight: contentColumn.height
        contentWidth: contentColumn.width

        Column {
            id: contentColumn
            width: parent.width
            padding: pluginInternal.padding
            spacing: 15
            Column {
                width: flickable.width
                Label {
                    text: "Acronym" + ":"
                }
                TextField {
                    id: acronymTextField
                    width: parent.width-2*pluginInternal.padding
                }
            }
            Column {
                width: flickable.width
                Label {
                    text: "Name" + ":"
                }
                TextField {
                    id: nameTextField
                    width: parent.width-2*pluginInternal.padding
                }
            }
            Column {
                width: flickable.width
                Label {
                    text: "City" + ":"
                }
                TextField {
                    id: cityTextField
                    width: parent.width-2*pluginInternal.padding
                }
            }
            Column {
                width: flickable.width
                Label {
                    text: "Country" + ":"
                }
                TextField {
                    id: countryTextField
                    width: parent.width-2*pluginInternal.padding
                }
            }
            Column {
                width: flickable.width
                Label {
                    text: "Venue" + ":"
                }
                TextField {
                    id: venueTextField
                    width: parent.width-2*pluginInternal.padding
                }
            }
            Column {
                width: flickable.width
                Label {
                    text: "Start_date" + ":"
                }
                TextField {
                    id: start_dateTextField
                    width: parent.width-2*pluginInternal.padding
                }
            }
            Column {
                width: flickable.width
                Label {
                    text: "End_date" + ":"
                }
                TextField {
                    id: end_dateTextField
                    width: parent.width-2*pluginInternal.padding
                }
            }
            Button {
                text: "Salvar"
                onClicked: {
                    addConferenceJsonListModel.load()                    
                }
            }
        }
    }
}
