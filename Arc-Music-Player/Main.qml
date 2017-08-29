import QtQuick 2.4
import Ubuntu.Components 1.3

MainView {
    // objectName for functional testing purposes (autopilot-qt5)
    objectName: "mainView"

    // Note! applicationName needs to match the "name" field of the click manifest
    applicationName: "arc-music-player.arc676"

    width: units.gu(100)
    height: units.gu(58)

    property real sideMargin: units.gu(2)

    Page {
        header: PageHeader {
            id: pageHeader
            title: i18n.tr("Arc Music Player")
//            StyleHints {
//                foregroundColor: UbuntuColors.orange
//                backgroundColor: UbuntuColors.porcelain
//                dividerColor: UbuntuColors.slate
//            }
        }

        PlaybackControls {
            id: playbackControls
            enableShuffle: songOrder.enableShuffle
            repeatSelection: songOrder.repeatMode
            anchors {
                top: pageHeader.bottom
                topMargin: sideMargin
                left: parent.left
                leftMargin: sideMargin
            }
        }

        SongLoader {
            id: songLoader
            playbackController: playbackControls
            anchors {
                top: playbackControls.bottom
                topMargin: sideMargin
                left: parent.left
                leftMargin: sideMargin
            }
        }

        SongOrder {
            id: songOrder
            anchors {
                top: songLoader.bottom
                topMargin: sideMargin
                left: parent.left
                leftMargin: sideMargin
            }
        }

    }
}
