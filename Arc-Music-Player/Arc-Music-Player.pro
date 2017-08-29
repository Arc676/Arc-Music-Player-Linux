TEMPLATE = aux
TARGET = Arc-Music-Player

RESOURCES += Arc-Music-Player.qrc

QML_FILES += $$files(*.qml,true) \
             $$files(*.js,true)

CONF_FILES +=  Arc-Music-Player.apparmor \
               Arc-Music-Player.png

AP_TEST_FILES += tests/autopilot/run \
                 $$files(tests/*.py,true)

OTHER_FILES += $${CONF_FILES} \
               $${QML_FILES} \
               $${AP_TEST_FILES} \
               Arc-Music-Player.desktop 

#specify where the qml/js files are installed to
qml_files.path = /Arc-Music-Player
qml_files.files += $${QML_FILES}

#specify where the config files are installed to
config_files.path = /Arc-Music-Player
config_files.files += $${CONF_FILES}

#install the desktop file, a translated version is automatically created in 
#the build directory
desktop_file.path = /Arc-Music-Player
desktop_file.files = $$OUT_PWD/Arc-Music-Player.desktop 
desktop_file.CONFIG += no_check_exist 

INSTALLS+=config_files qml_files desktop_file

DISTFILES += \
    PlaybackControls.qml \
    SongLoader.qml \
    SongOrder.qml

