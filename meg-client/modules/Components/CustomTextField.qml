import QtQuick 2.7
import QtQuick.Controls 2.1

Item {
    id: item
    height: childrenRect.height

    property bool readOnly
    property string text: textField.text

    function setText(_text) {
        textField.text = _text;
    }

    TextField {
        id: textField
        text: item.text
        width: parent.width
        readOnly: item.readOnly
    }
}
