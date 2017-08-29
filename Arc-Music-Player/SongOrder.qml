import QtQuick 2.4
import QtQuick.Controls 1.4
import Ubuntu.Components 1.3

Rectangle {

    id: rect
    width: parent.width - 2 * sideMargin
    height: units.gu(10)
    color: "#CCCCCC"

    property alias enableShuffle: shuffle
    property alias repeatMode: repeatMode

    Label {
        id: label
        text: i18n.tr("Shuffle/Repeat")
        anchors {
            top: rect.top
            topMargin: sideMargin
            left: parent.left
            leftMargin: sideMargin
        }
    }

    CheckBox {
        id: shuffle
        anchors {
            top: label.bottom
            topMargin: sideMargin
            left: parent.left
            leftMargin: sideMargin
        }
    }

    Label {
        text: i18n.tr("Enable Shuffle")
        anchors {
            top: label.bottom
            topMargin: sideMargin
            left: shuffle.right
            leftMargin: sideMargin / 2
        }
    }

    ExclusiveGroup {
        id: repeatMode
    }

    Label {
        id: repeatLabel
        text: i18n.tr("Repeat Mode")
        anchors {
            top: rect.top
            topMargin: sideMargin
            left: label.right
            leftMargin: 6 * sideMargin
        }
    }

    RadioButton {
        id: noRepeat
        objectName: "NO_REPEAT"
        text: i18n.tr("Off")
        exclusiveGroup: repeatMode
        checked: true
        anchors {
            top: repeatLabel.bottom
            topMargin: sideMargin
            right: songRepeat.left
            rightMargin: sideMargin
        }
    }

    RadioButton {
        id: songRepeat
        objectName: "SONG_REPEAT"
        text: i18n.tr("Song")
        exclusiveGroup: repeatMode
        anchors {
            top: repeatLabel.bottom
            topMargin: sideMargin
            horizontalCenter: repeatLabel.horizontalCenter
        }
    }

    RadioButton {
        id: allRepeat
        objectName: "ALL_REPEAT"
        text: i18n.tr("All")
        exclusiveGroup: repeatMode
        anchors {
            top: repeatLabel.bottom
            topMargin: sideMargin
            left: songRepeat.right
            leftMargin: sideMargin
        }
    }

}
