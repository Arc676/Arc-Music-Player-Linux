import QtQuick 2.4
import QtQuick.Controls 1.4
import Ubuntu.Components 1.3
import QtMultimedia 5.5
import QtQuick.Dialogs 1.2

Rectangle {

    id: rect
    width: parent.width - 2 * sideMargin
    height: units.gu(23)
    color: "#CCCCCC"

    property ExclusiveGroup repeatSelection
    property CheckBox enableShuffle

    function addSongToPlaylist(url) {
        playlist.append({"text":url})
        playbackControl.playSelectedSong()
        audioSource.pause()
    }

    function clearPlaylist() {
        playlist.clear()
        songChooser.currentIndex = 0
        audioSource.stop()
        audioSource.source = ""
    }

    function getSongList() {
        var songList = ""
        for (var i = 0; i < playlist.count; i++) {
            songList += playlist.get(i)["text"] + "\n"
        }
        return songList
    }

    QtObject {
        id: playbackControl
        property int currentSongIndex: 0

        function seek(dp) {
            dp *= 1000
            if (audioSource.playbackState == Audio.PlayingState) {
                if (dp < 0) {
                    audioSource.seek(Math.max(0, audioSource.position + dp))
                } else {
                    audioSource.seek(Math.min(audioSource.duration, audioSource.position + dp))
                }
            }
        }

        function selectPreviousSong() {
            if (enableShuffle.checked) {
                cannotGoBackDialog.open()
            } else if (currentSongIndex <= 0) {
                audioSource.seek(0)
            } else {
                if (audioSource.position >= 10 * 1000) {
                    audioSource.seek(0)
                } else {
                    currentSongIndex--
                    playSelectedSong()
                }
            }
        }

        function selectNextSong() {
            if (enableShuffle.checked) {
                if (playlist.count > 0){
                    playlist.remove(currentSongIndex)
                }
                if (playlist.count > 0) {
                    currentSongIndex = Math.floor(Math.random(
                                                      ) * playlist.count)
                    playSelectedSong()
                }
            } else if (repeatSelection.current.objectName == "SONG_REPEAT") {
                audioSource.seek(0)
                playSelectedSong()
            } else if (currentSongIndex >= playlist.count - 1) {
                if (repeatSelection.current.objectName == "ALL_REPEAT") {
                    currentSongIndex = 0
                    playSelectedSong()
                } else {
                    audioSource.seek(audioSource.duration)
                    audioSource.stop()
                }
            } else {
                currentSongIndex++
                playSelectedSong()
            }
        }

        function playSelectedSong() {
            songChooser.currentIndex = currentSongIndex
            audioSource.source = playlist.get(currentSongIndex)["text"]
            audioSource.play()
        }
    }

    Audio {
        id: audioSource
        property string totTime: ""
        onStatusChanged: {
            if (status == Audio.Buffered) {
                var totmin = Math.floor(duration / 60000)
                var totsec = Math.floor(duration % 60000 / 1000)
                totTime = totmin + (totsec < 10 ? ":0" : ":") + totsec
            } else if (status == Audio.EndOfMedia) {
                playbackControl.selectNextSong()
            }
        }
        onPositionChanged: {
            var min = Math.floor(position / 60000)
            var sec = Math.floor(position % 60000 / 1000)
            positionLabel.text = min + (sec < 10 ? ":0" : ":") + sec + "/" + totTime
        }
    }

    ListModel {
        id: playlist
    }

    MessageDialog {
        id: cannotGoBackDialog
        title: i18n.tr("Error")
        text: i18n.tr("Cannot go to previous song with shuffle enabled")
    }

    Label {
        id: label
        text: i18n.tr("Playback")
        anchors {
            top: rect.top
            topMargin: sideMargin
            left: parent.left
            leftMargin: sideMargin
        }
    }

    Label {
        id: positionLabel
        text: "-/-"
        anchors {
            top: rect.top
            topMargin: sideMargin
            right: rect.right
            rightMargin: sideMargin
        }
    }

    ComboBox {
        id: songChooser
        model: playlist
        anchors {
            top: label.bottom
            left: parent.left
            topMargin: sideMargin / 2
            leftMargin: sideMargin
        }
        onCurrentIndexChanged: {
            playbackControl.currentSongIndex = currentIndex
            playbackControl.playSelectedSong()
        }

        width: parent.width - 2 * sideMargin
    }

    Button {
        id: rew30
        text: "<<30s"
        anchors {
            top: songChooser.bottom
            topMargin: sideMargin
            left: rect.left
            leftMargin: sideMargin * 2
        }
        width: (parent.width - 2 * sideMargin) / 4 - 2 * sideMargin
        onClicked: playbackControl.seek(-30)
    }

    Button {
        id: rew10
        text: "<<10s"
        anchors {
            top: songChooser.bottom
            topMargin: sideMargin
            left: rew30.right
            leftMargin: sideMargin * 2
        }
        width: (parent.width - 2 * sideMargin) / 4 - 2 * sideMargin
        onClicked: playbackControl.seek(-10)
    }

    Button {
        id: fwd10
        text: "10s>>"
        anchors {
            top: songChooser.bottom
            topMargin: sideMargin
            left: rew10.right
            leftMargin: sideMargin * 2
        }
        width: (parent.width - 2 * sideMargin) / 4 - 2 * sideMargin
        onClicked: playbackControl.seek(+10)
    }

    Button {
        id: fwd30
        text: "30s>>"
        anchors {
            top: songChooser.bottom
            topMargin: sideMargin
            left: fwd10.right
            leftMargin: sideMargin * 2
        }
        width: (parent.width - 2 * sideMargin) / 4 - 2 * sideMargin
        onClicked: playbackControl.seek(+30)
    }

    Button {
        id: playpauseButton
        text: i18n.tr("Play/Pause")
        anchors {
            top: fwd10.bottom
            topMargin: sideMargin
            left: prevButton.right
            leftMargin: sideMargin * 2
        }
        width: (parent.width - 2 * sideMargin) / 3 - 2 * sideMargin

        onClicked: {
            if (audioSource.playbackState == Audio.PlayingState) {
                audioSource.pause()
            } else {
                audioSource.play()

            }
        }
    }

    Button {
        id: prevButton
        text: "<"
        onClicked: playbackControl.selectPreviousSong()
        anchors {
            top: fwd10.bottom
            topMargin: sideMargin
            left: parent.left
            leftMargin: sideMargin * 2
        }
        width: (parent.width - 2 * sideMargin) / 3 - 2 * sideMargin
    }

    Button {
        id: nextButton
        text: ">"
        onClicked: playbackControl.selectNextSong()
        anchors {
            top: fwd10.bottom
            topMargin: sideMargin
            left: playpauseButton.right
            leftMargin: sideMargin * 2
        }
        width: (parent.width - 2 * sideMargin) / 3 - 2 * sideMargin
    }
}
