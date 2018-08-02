import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.1
import QtQuick.Controls.Material 2.0
import Components 1.0 as Components

Item {
    id: item
    states: [
        State {
            name: "add"
            PropertyChanges { target: item
                              topLeft: {"action":mainStack.pop, "icon":"close"}
                              topRight: {"action": submit, "icon":"save"}
                              toolBarText: "Add Conference"
                              rest_client: addConferencesJsonListModel}
        },
        State {
            name: "edit"
            PropertyChanges { target: item
                              topLeft: {"action":toggleOffEditMode, "icon":"close"}
                              topRightCenter: {"action": openMessageDialog, "icon":"trash"}
                              topRight:{"action": submit, "icon":"save"}
                              toolBarText: "Edit Conference"
                              rest_client: updateConferencesJsonListModel}
        }
    ]

    property Components.JSONListModel rest_client
    property var model
    property int modelIndex
    property bool modelIsEmpty: Object.keys(model).length === 0 && model.constructor === Object    
    property bool editMode: state === "add" || state === "edit"
    property var topLeft: ({})
    property var topRightCenter: ({})
    property var topRight: ({})
    property string toolBarText
    property var cleanedForm: ({})        

    function toggleOffEditMode() {
        mainStack.pop()
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
            rest_client.requestObject = cleanedForm
            rest_client.load()
        }
    }    

    Components.JSONListModel {
        id: addConferencesJsonListModel
        source: internal.baseServer + "/add_conferences"
        requestMethod: "POST"
        onStateChanged: {
            if (state === "ready" && httpStatus == 200) {
               mainStack.pop()
               appWindow.eventNotified("updateConferencesModel", {})
            }
        }
    }

    Components.JSONListModel {
        id: updateConferencesJsonListModel
        source: internal.baseServer + "/update_conferences/" +  model.id        
        requestMethod: "POST"
        onStateChanged: {
            if (state === "ready" && httpStatus == 200) {                
                appWindow.eventNotified("updateConferencesModel", {})
                mainStack.pop()
            }
        }
    }

    Components.JSONListModel {
        id: deleteConferencesJsonListModel
        source: internal.baseServer + "/delete_conferences/" +  model.id
        requestMethod: "POST"
        onStateChanged: {
            if (state === "ready" && httpStatus == 200) {
                appWindow.eventNotified("updateConferencesModel", {})
                mainStack.pop()
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

                Components.CustomTextField {
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

                Components.CustomTextField {
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

                Components.CustomTextField {
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

                Components.CustomTextField {
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

                Components.CustomDateField {
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

                Components.CustomDateField {
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
