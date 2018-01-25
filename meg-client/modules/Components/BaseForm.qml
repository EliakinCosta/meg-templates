import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.1
import Qt.labs.platform 1.0

Item {
    id: _item

    property bool active
    property bool readOnly
    property int padding
    property var fieldsProperties
    property var fields : []
    property var cleanedForm: ({})
    property var model

    signal submit()    

    function is_valid() {
        var invalid_fields = 0;
        for (var i=0; i < fieldsProperties.length; i++) {
            var field = repeater.itemAt(i).children[1].item
            var errorField = repeater.itemAt(i).children[2]            
            if (!field.text) {
                invalid_fields++;
                errorField.visible = true;
            } else {
                errorField.visible = false;
                cleanedForm[fieldsProperties[i]["name"]] = field.text;
            }
        }
        return !invalid_fields;
    }

    Flickable {
        id: flickable
        visible: _item.active
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
            padding: padding
            spacing: 15
            width: parent.width

            Repeater {
                id: repeater
                model: fieldsProperties

                Column {
                    width: flickable.width

                    Label {
                        text: modelData["name"] + ":"
                    }

                    Loader {
                        width:  parent.width
                        source: (modelData["type"]==="string") ? "CustomTextField.qml" : "CustomDateField.qml"
                        onLoaded: {                                                                
                                if (_item.model && _item.model[modelData["name"]])
                                    item.setText(_item.model[modelData["name"]])
                                else
                                    item.setText("")
                        }
                    }

                    Label {
                        font.pixelSize: 10
                        color: "red"
                        text: "cannot be blank"
                        visible: false
                    }
                }
                onItemAdded: {
                    fields.push(item.children)
                }
            }

            Button {
                text: "Salvar"
                onClicked: {
                    if (is_valid()) {
                        submit()
                    }
                }
            }
        }
    }
}
