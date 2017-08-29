import QtQuick 2.4
import QtQuick.Controls 1.4
import Ubuntu.Components 1.3
import QtQuick.Dialogs 1.2
import Arc_Music_Player 1.0

Rectangle {

    id: rect
    width: parent.width - 2 * sideMargin
    height: units.gu(10)
    color: "#CCCCCC"

    property real buttonWidth: parent.width / 6 - 2 * sideMargin
    property PlaybackControls playbackController

    FileIO {
        id: fileio
    }

    FileDialog {
        id: loadDialog
        title: i18n.tr("Select songs to load")
        nameFilters: ["Music files (*.mp3 *.m4a *.ogg *.wav)"]
        selectMultiple: true
        onAccepted: {
            var files = fileUrls
            for (var i = 0; i < files.length; i++){
                playbackController.addSongToPlaylist(files[i])
            }
        }
    }

    FileDialog {
        id: loadPlaylistDialog
        title: i18n.tr("Select playlist file")
        onAccepted: {
            var path = fileUrl.toString()
            path = path.replace(/^file:\/{2}/, "")
            path = decodeURIComponent(path)
            var files = fileio.readFromFile(path)
            var fileList = files.split("\n")
            for (var i = 0; i < fileList.length; i++) {
                if (fileList[i] !== "") {
                    playbackController.addSongToPlaylist(fileList[i])
                }
            }
        }
    }

    FileDialog {
        id: saveDialog
        title: i18n.tr("Select save location for playlist")
        selectExisting: false
        onAccepted: {
            var path = fileUrl.toString()
            path = path.replace(/^file:\/{2}/, "")
            path = decodeURIComponent(path)
            fileio.writeToFile(path, playbackController.getSongList())
        }
    }

    Label {
        id: label
        text: i18n.tr("Playlist control")
        anchors {
            top: rect.top
            topMargin: sideMargin
            left: parent.left
            leftMargin: sideMargin
        }
    }

    Button {
        id: addSongButton
        text: i18n.tr("Add")
        width: buttonWidth
        anchors {
            top: label.bottom
            topMargin: sideMargin / 2
            left: parent.left
            leftMargin: 2 * sideMargin
        }
        onClicked: loadDialog.open()
    }

    Button {
        id: removeSongButton
        text: i18n.tr("Remove")
        width: buttonWidth
        anchors {
            top: label.bottom
            topMargin: sideMargin / 2
            left: addSongButton.right
            leftMargin: sideMargin
        }
    }

    Button {
        id: loadPlaylistButton
        text: i18n.tr("Load")
        width: buttonWidth
        anchors {
            top: label.bottom
            topMargin: sideMargin / 2
            left: removeSongButton.right
            leftMargin: sideMargin
        }
        onClicked: loadPlaylistDialog.open()
    }

    Button {
        id: savePlaylistButton
        text: i18n.tr("Save")
        width: buttonWidth
        anchors {
            top: label.bottom
            topMargin: sideMargin / 2
            left: loadPlaylistButton.right
            leftMargin: sideMargin
        }
        onClicked: saveDialog.open()
    }

    Button {
        id: clearPlaylistButton
        text: i18n.tr("Clear Playlist")
        // 2 * (W + 2M) - 2M = 2W + 4M - 2M = 2W + 2M
        width: 2 * buttonWidth + 2 * sideMargin
        anchors {
            top: label.bottom
            topMargin: sideMargin / 2
            left: savePlaylistButton.right
            leftMargin: sideMargin
        }
        onClicked: {
            playbackController.clearPlaylist()
        }
    }

}
