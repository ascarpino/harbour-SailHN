/*
  The MIT License (MIT)

  Copyright (c) 2016 Andrea Scarpino <me@andreascarpino.it>

  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the "Software"), to deal
  in the Software without restriction, including without limitation the rights
  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:

  The above copyright notice and this permission notice shall be included in all
  copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  SOFTWARE.
*/

import QtQuick 2.0
import Sailfish.Silica 1.0

Page {

    allowedOrientations: Orientation.All

    Connections {
        target: manager

        onAuthenticated: {
            console.log("Authenticated: " + result);

            busy.visible = busy.running = false;

            isAuthenticated();

            if (!result) {
                msg.text = qsTr("Login failed");
                msg.visible = true;
            }
        }
    }

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height

        PullDownMenu {

            MenuItem {
                id: logout
                text: qsTr("Logout")

                onClicked: {
                    manager.logout();
                    isAuthenticated();
                }
            }
        }

        Column {
            id: column
            x: Theme.horizontalPageMargin
            width: parent.width - Theme.horizontalPageMargin * 2

            PageHeader {
                title: qsTr("Settings")
            }

            TextField {
                id: username
                width: parent.width
                focus: true
                placeholderText: qsTr("Username")
                text: manager.loggedUser()
            }

            TextField {
                id: password
                width: parent.width
                placeholderText: qsTr("Password")
                echoMode: TextInput.Password
            }

            Button {
                id: login
                text: qsTr("Login");
                anchors.horizontalCenter: parent.horizontalCenter

                onClicked: {
                    if (username.text.length > 0 && password.text.length > 0) {
                        manager.authenticate(username.text, password.text);
                        login.enabled = false;
                        busy.visible = busy.running = true;
                        msg.visible = false;
                    }
                }
            }

            Label {
                id: msg
                visible: false
                color: Theme.highlightColor
                anchors.horizontalCenter: parent.horizontalCenter
            }

            BusyIndicator {
                id: busy
                visible: false
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
    }

    Component.onCompleted: isAuthenticated()

    function isAuthenticated() {
        var isAuth = manager.isAuthenticated();
        username.enabled = password.enabled = login.enabled = !isAuth;
        logout.enabled = isAuth;

        if (isAuth) {
            login.text = qsTr("Logged");
        } else {
            login.text = qsTr("Login");
        }
    }
}
