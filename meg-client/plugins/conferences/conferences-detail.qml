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
    property var formFields: [{"name": "acronym", "type": "string"},
                              {"name": "name", "type": "string"},
                              {"name": "city", "type": "string"},
                              {"name": "country", "type": "string"},
                              {"name": "venue", "type": "string"},
                              {"name": "start_date", "type": "date"},
                              {"name": "end_date", "type": "date"}]


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
        requestObject: form.cleanedForm
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

    BaseForm {
        id: form
        active: updateConferenceJsonListModel.state !== "loading"
        padding: pluginInternal.padding
        fieldsProperties: formFields
        model: item.model
        onSubmit: {
            updateConferenceJsonListModel.load();
            toggleOffEditMode();
        }
        width: parent.width
        height: parent.height
        readOnly: !editMode        
    }

    MessageDialog {
        id: helloDialog
        icon: StandardIcon.Critical
        standardButtons: StandardButton.Ok | StandardButton.Cancel
        title: "May I have your attention please"
        text: "Do you really want to delete it?."
        onAccepted: {
            deleteConferenceJsonListModel.load()
        }
    }
}
