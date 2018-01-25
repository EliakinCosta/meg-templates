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
    property var formFields: [{"name": "acronym", "type": "string"},
                              {"name": "name", "type": "string"},
                              {"name": "city", "type": "string"},
                              {"name": "country", "type": "string"},
                              {"name": "venue", "type": "string"},
                              {"name": "start_date", "type": "date"},
                              {"name": "end_date", "type": "date"}]

    JSONListModel {
        id: addConferenceJsonListModel
        source: internal.baseServer + "/add_conferences"
        requestObject: form.cleanedForm
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
        anchors.centerIn: parent
        running: addConferenceJsonListModel.state === "loading"
    }

    BaseForm {
        id: form
        active: addConferenceJsonListModel.state !== "loading"
        padding: pluginInternal.padding
        fieldsProperties: formFields
        onSubmit: addConferenceJsonListModel.load()
        width: parent.width
        height: parent.height
        readOnly: false
    }

}
