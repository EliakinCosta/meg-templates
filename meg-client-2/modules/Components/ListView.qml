import QtQuick 2.7
import QtQuick.Controls 2.1
import Awesome 1.0

ListView {
    model: listModel
    property string titleField
    property string awesomeIcon
    property var listModel
    property string detailPage

    signal itemClicked(var dataIndex)

    delegate: ItemDelegate {
        text: "         " + modelData[titleField]
        width: parent.width

        AwesomeToolButton {
            text: FontAwesome.icons[awesomeIcon]
            enabled: false
        }
        onClicked: itemClicked(modelData)
    }
}

