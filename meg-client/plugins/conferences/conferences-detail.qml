import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.1
import QtQuick.Controls.Material 2.0
import Components 1.0

Item {
    id: item
    property var model
    property StackView stackView
    property bool editMode: false
    property var toolBarConfig: {
        "label": {"text":"Conference", "bold": false, "color": "white"},
        "toolButton1": editMode ? {"action":toggleOffEditMode, "icon":"close"} : {"action":stackView.pop, "icon":"arrow-left"},
        "toolButton3": editMode ? {} : {"action": openMessageDialog, "icon":"trash"},
        "toolButton4": editMode ? {} : {"action": toggleOnEditMode, "icon":"pencil"}
    }
    NumberAnimation on x {
            id: editAnimation
            from: 100
            to: 0
            duration: 300
            running: false
    }

    NumberAnimation on opacity {
            id: cancelAnimation
            from: 0
            to: 1
            duration: 500
            running: false
    }

    function toggleOnEditMode() {
        editAnimation.start()
        editMode = true
    }

    function toggleOffEditMode() {
        cancelAnimation.start()
        editMode = false
    }

    function openMessageDialog(){
        helloDialog.visible = true
    }

    JSONListModel {
        id: updateConferenceJsonListModel
        source: internal.baseServer + "/update_conferences/" +  model.id
        requestObject: {"acronym": acronymTextField.text, "name": nameTextField.text,
                        "city": cityTextField.text, "country": countryTextField.text,
                        "venue": venueTextField.text, "start_date": start_dateTextField.text,
                        "end_date": end_dateTextField.text}
        requestMethod: "POST"
        onStateChanged: {
            if (state === "ready" && httpStatus == 200) {
               appWindow.eventNotified("updateConferencesModel", {})
            }
        }
    }

    JSONListModel {
        id: deleteConferenceJsonListModel
        source: internal.baseServer + "/delete_conferences/" +  model.id
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
        running: updateConferenceJsonListModel.state === "loading"
    }

    Flickable {
        id: flickable
        visible: updateConferenceJsonListModel.state !== "loading"
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
                    text: item.model ? item.model["acronym"] : ""
                    width: parent.width-2*pluginInternal.padding
                    readOnly: !editMode
                }
            }
            Column {
                width: flickable.width
                Label {
                    text: "Name" + ":"
                }
                TextField {
                    id: nameTextField
                    text: item.model ? item.model["name"] : ""
                    width: parent.width-2*pluginInternal.padding
                    readOnly: !editMode
                }
            }
            Column {
                width: flickable.width
                Label {
                    text: "City" + ":"
                }
                TextField {
                    id: cityTextField
                    text: item.model ? item.model["city"] : ""
                    width: parent.width-2*pluginInternal.padding
                    readOnly: !editMode
                }
            }
            Column {
                width: flickable.width
                Label {
                    text: "Country" + ":"
                }
                TextField {
                    id: countryTextField
                    text: item.model ? item.model["country"] : ""
                    width: parent.width-2*pluginInternal.padding
                    readOnly: !editMode
                }
            }
            Column {
                width: flickable.width
                Label {
                    text: "Venue" + ":"
                }
                TextField {
                    id: venueTextField
                    text: item.model ? item.model["venue"] : ""
                    width: parent.width-2*pluginInternal.padding
                    readOnly: !editMode
                }
            }
            Column {
                width: flickable.width
                Label {
                    text: "Start_date" + ":"
                }
                TextField {
                    id: start_dateTextField
                    text: item.model ? item.model["start_date"] : ""
                    width: parent.width-2*pluginInternal.padding
                    readOnly: !editMode
                }
            }
            Column {
                width: flickable.width
                Label {
                    text: "End_date" + ":"
                }
                TextField {
                    id: end_dateTextField
                    text: item.model ? item.model["end_date"] : ""
                    width: parent.width-2*pluginInternal.padding
                    readOnly: !editMode
                }
            }
            Button {
                text: "Salvar"
                visible: editMode
                onClicked: {
                    updateConferenceJsonListModel.load()                    
                    toggleOffEditMode()
                }
            }
        }
    }    

    MessageDialog {
        id: helloDialog
        icon: StandardIcon.Critical
        standardButtons: StandardButton.Ok | StandardButton.Cancel
        title: "May I have your attention please"
        text: "It's so cool that you are using Qt Quick."
        onAccepted: {
            deleteConferenceJsonListModel.load()
        }
    }
}
