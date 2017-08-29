# This is the basic qmake template for the Ubuntu-SDK
# it handles creation and installation of the manifest
# file and takes care of subprojects
TEMPLATE = subdirs

#load Ubuntu specific features
load(ubuntu-click)

SUBDIRS += Arc-Music-Player \
           backend/Arc_Music_Player

# specify the manifest file, this file is required for click
# packaging and for the IDE to create runconfigurations
UBUNTU_MANIFEST_FILE=manifest.json.in

# specify translation domain, this must be equal with the
# app name in the manifest file
UBUNTU_TRANSLATION_DOMAIN="arc-music-player.arc676"

# specify the source files that should be included into
# the translation file, from those files a translation
# template is created in po/template.pot, to create a
# translation copy the template to e.g. de.po and edit the sources
UBUNTU_TRANSLATION_SOURCES+= \
    $$files(*.qml,true) \
    $$files(*.js,true)  \
    $$files(*.cpp,true) \
    $$files(*.h,true) \
    $$files(*.desktop,true)

# specifies all translations files and makes sure they are
# compiled and installed into the right place in the click package
UBUNTU_PO_FILES+=$$files(po/*.po)

aptest.target   = autopilot
aptest.commands = QML2_IMPORT_PATH=$$OUT_PWD/backend bash $$PWD/Arc-Music-Player/tests/autopilot/run
aptest.depends  = sub-Arc-Music-Player sub-backend-App

unittest.target   = check
unittest.commands = /usr/bin/qmltestrunner -input $$PWD/backend/tests/unit -import $$OUT_PWD/backend
unittest.commands += && /usr/bin/qmltestrunner -input $$PWD/Arc-Music-Player/tests/unit -import $$OUT_PWD/backend
unittest.depends  = sub-Arc-Music-Player sub-backend-App

QMAKE_EXTRA_TARGETS += aptest unittest

