/*
 * This file is part of kdictionary_qml.

 * kdictionary_qml is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.

 * kdictionary_qml is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.

 * You should have received a copy of the GNU Lesser General Public License
 * along with kdictionary_qml.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.2

ApplicationWindow {
    title: qsTr("KDictionary")
    width: 480
    height: 320
    visible: true

    menuBar: MenuBar {
        Menu {
            title: qsTr("&File")
            MenuItem {
                text: qsTr("&Exit")
                onTriggered: Qt.quit()
            }
        }

        Menu {
            title: qsTr("&About")
            MenuItem {
                text: qsTr("About KDictionary")
                onTriggered: aboutDialog.show()
            }
        }
    }

    TextField {
        id: inputField
        anchors.left: parent.left
        anchors.right: parent.right

        placeholderText: qsTr("Enter word(s) here")

        onAccepted: youdao.query(inputField.text)
    }

    TextArea {
        id: resultTextArea
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: inputField.bottom
        anchors.bottom: parent.bottom

        text: youdao.resultText
        readOnly: true
        textFormat: TextEdit.RichText
    }

    BusyIndicator {
        id: busyIndicator
        anchors.centerIn: parent
        running: true
        visible: youdao.progress < 1.0
    }

    MessageDialog {
        id: aboutDialog
        title: qsTr("About KDictionary")
        text: qsTr("<h2>KDictionary</h2><p>Results are obtained via online API provided by <a href='http://youdao.com'>NetEase Youdao</a></p>")
        informativeText: qsTr("Copyright 2015 Symeon Huang <hzwhuang@gmail.com>\nLicensed under LGPLv3")

        function show() {
            aboutDialog.open()
        }
    }
    
    YOUDAO {
        id: youdao
    }
}
