import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.1
import Qt.labs.platform 1.0

import Awesome 1.0
import Components 1.0

ToolBar {
    id: toolbar

    width: parent.width

    property string toolBarText: currentPage.toolBarText ? currentPage.toolBarText : ""
    property var topLeft: currentPage.topLeft
    property var topLeftCenter: currentPage.topLeftCenter
    property var topRightCenter: currentPage.topRightCenter
    property var topRight: currentPage.topRight

    RowLayout {
        anchors.fill: parent

        AwesomeToolButton {
            text: enabled ? FontAwesome.icons[topLeft.icon] : ""
            onClicked: topLeft.action()
            enabled: topLeft ? true : false
        }

        AwesomeToolButton {
            text: enabled ? FontAwesome.icons[topLeftCenter.icon] : ""
            onClicked: topLeftCenter.action()
            enabled: topLeftCenter ? true : false
        }

        Label {
            id: _label
            text: toolBarText
            color: "white"
            elide: Label.ElideRight
            horizontalAlignment: Qt.AlignHCenter
            verticalAlignment: Qt.AlignVCenter
            Layout.fillWidth: true
            Layout.fillHeight: true
        }

        AwesomeToolButton {
            text: enabled ? FontAwesome.icons[topRightCenter.icon] : ""
            onClicked: topRightCenter.action()
            enabled: topRightCenter ? true : false
        }

        AwesomeToolButton {
            text: enabled ? FontAwesome.icons[topRight.icon] : ""
            onClicked: topRight.action()
            enabled: topRight ? true : false
        }
    }    
}

