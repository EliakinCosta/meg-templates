
import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.1
import QtQuick.Controls.Material 2.0
import Components 1.0

Item {
    id: item
    states: [
        State {
            name: "add"
            PropertyChanges { target: item
                              topLeft: {"action":stackView.pop, "icon":"close"}
                              topRight: {"action": submit, "icon":"save"}
                              toolBarText: "Add Speaker" }
        },
        State {
            name: "edit"
            PropertyChanges { target: item
                              topLeft: {"action":toggleOffEditMode, "icon":"close"}
                              topRight:{"action": submit, "icon":"save"}
                              toolBarText: "Edit Speaker" }
        },
        State {
            name: "details"
            PropertyChanges { target: item
                              topLeft: {"action":toggleOffEditMode, "icon":"close"}
                              topRightCenter: {"action": openMessageDialog, "icon":"trash"}
                              topRight: {"action": toggleOnEditMode, "icon":"pencil"}
                              toolBarText: "Speaker Details" }
        }
    ]
    property var model
    property int modelIndex
    property bool modelIsEmpty: Object.keys(model).length === 0 && model.constructor === Object
    property StackView stackView
    property bool editMode: state === "add" || state === "edit"
    property var topLeft: ({})
    property var topRightCenter: ({})
    property var topRight: ({})
    property string toolBarText
    property var cleanedForm: ({})

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
        console.log("antes", JSON.stringify(stackView.model), modelIndex)
        stackView.push(itensPage, { "model": stackView.model[modelIndex], "stackView": stackView, "state": "edit" })
        console.log("depois", JSON.stringify(stackView.model), modelIndex)
    }

    function toggleOffEditMode() {
        currentStack.pop()
    }

    function openMessageDialog(){
        deleteDialog.visible = true
    }

    function is_valid() {
        var form = [
          {"name": "acronym", "field": acronymStringField, "errorLabel": acronymErrorLabel},
          {"name": "name", "field": nameStringField, "errorLabel": nameErrorLabel},
          {"name": "city", "field": cityStringField, "errorLabel": cityErrorLabel},
          {"name": "venue", "field": venueStringField, "errorLabel": venueErrorLabel},
          {"name": "start_date", "field": start_dateDatetimeField, "errorLabel": start_dateErrorLabel},
          {"name": "end_date", "field": end_dateDatetimeField, "errorLabel": end_dateErrorLabel}
        ]
        var invalid_fields = 0;
        for (var i=0; i < form.length; i++) {
            var field = form[i]["field"]
            var errorLabel = form[i]["errorLabel"]
            if (!field.value) {
                invalid_fields++;
                errorLabel.visible = true;
            } else {
                errorLabel.visible = false;
                cleanedForm[form[i]["name"]] = field.value;
            }
        }
        return !invalid_fields;
    }

    function submit() {
        if (is_valid()) {
            if (state === "add")
                addConferencesJsonListModel.load()
            else
                updateConferencesJsonListModel.load()
            toggleOffEditMode()
        }
    }

    JSONListModel {
        id: addConferencesJsonListModel
        source: internal.baseServer + "/add_conferences"
        requestObject: cleanedForm
        requestMethod: "POST"
        onStateChanged: {
            if (state === "ready" && httpStatus == 200) {
               appWindow.eventNotified("updateConferencesModel", {})
               stackView.pop()
            }
        }
    }

    JSONListModel {
        id: updateConferencesJsonListModel
        source: internal.baseServer + "/update_conferences/" +  model.id
        requestObject: cleanedForm
        requestMethod: "POST"
        onStateChanged: {
            if (state === "ready" && httpStatus == 200) {
                appWindow.eventNotified("updateConferencesModel", {})
            }
        }
    }

    JSONListModel {
        id: deleteConferencesJsonListModel
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
        running: updateConferencesJsonListModel.state === "loading"
    }

    Flickable {
        id: flickable
        clip: true
        anchors {
            fill: parent
            margins: parent.width * 0.05
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
                    text: "Acronym"
                }

                CustomTextField {
                    id: acronymStringField
                    width: parent.width
                    text: modelIsEmpty ? "" : model["acronym"]
                    readOnly: !editMode
                }

                Label {
                    id: acronymErrorLabel
                    font.pixelSize: 10
                    color: "red"
                    text: "cannot be blank"
                    visible: false
                }
            }

            Column {
                width: flickable.width

                Label {
                    text: "Name"
                }

                CustomTextField {
                    id: nameStringField
                    width: parent.width
                    text: modelIsEmpty ? "" : model["name"]
                    readOnly: !editMode
                }

                Label {
                    id: nameErrorLabel
                    font.pixelSize: 10
                    color: "red"
                    text: "cannot be blank"
                    visible: false
                }
            }

            Column {
                width: flickable.width

                Label {
                    text: "City"
                }

                CustomTextField {
                    id: cityStringField
                    width: parent.width
                    text: modelIsEmpty ? "" : model["city"]
                    readOnly: !editMode
                }

                Label {
                    id: cityErrorLabel
                    font.pixelSize: 10
                    color: "red"
                    text: "cannot be blank"
                    visible: false
                }
            }

            Column {
                width: flickable.width

                Label {
                    text: "Venue"
                }

                CustomTextField {
                    id: venueStringField
                    width: parent.width
                    text: modelIsEmpty ? "" : model["venue"]
                    readOnly: !editMode
                }

                Label {
                    id: venueErrorLabel
                    font.pixelSize: 10
                    color: "red"
                    text: "cannot be blank"
                    visible: false
                }
            }

            Column {
                width: flickable.width

                Label {
                    text: "Start_date"
                }

                CustomDateField {
                    id: start_dateDatetimeField
                    width: parent.width
                    text: modelIsEmpty ? "" : model["start_date"]
                    readOnly: !editMode
                }

                Label {
                    id: start_dateErrorLabel
                    font.pixelSize: 10
                    color: "red"
                    text: "cannot be blank"
                    visible: false
                }
            }

            Column {
                width: flickable.width

                Label {
                    text: "End_date"
                }

                CustomDateField {
                    id: end_dateDatetimeField
                    width: parent.width
                    text: modelIsEmpty ? "" : model["end_date"]
                    readOnly: !editMode
                }

                Label {
                    id: end_dateErrorLabel
                    font.pixelSize: 10
                    color: "red"
                    text: "cannot be blank"
                    visible: false
                }
            }
        }
    }

    Dialog {
        id: deleteDialog
        standardButtons: StandardButton.Ok | StandardButton.Cancel
        title: "Do you really want to delete it?"
        onAccepted: {
            deleteConferencesJsonListModel.load()
        }
    }    
}
