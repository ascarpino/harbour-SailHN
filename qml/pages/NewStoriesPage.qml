/*
  The MIT License (MIT)

  Copyright (c) 2015-2016 Andrea Scarpino <me@andreascarpino.it>

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
import harbour.sailhn 1.0

Page {

    property bool storiesLoadedOnce: false

    allowedOrientations: Orientation.All

    SilicaListView {
        anchors.fill: parent

        PullDownMenu {

            MenuItem {
                text: qsTr("Settings")
                onClicked: pageStack.push(Qt.resolvedUrl("Settings.qml"))
            }

            MenuItem {
                text: qsTr("Refresh")
                onClicked: loadStories()
            }
        }

        PushUpMenu {

            MenuItem {
                text: qsTr("Load more")
                onClicked: model.nextItems()
            }
        }

        model: NewsModel {
            id: model
        }

        header: PageHeader {
            title: "Newest"
        }

        delegate: ItemDelegate {}

        VerticalScrollDecorator {}
    }

    onStatusChanged: {
        if (status === PageStatus.Activating) {
            if (!storiesLoadedOnce) {
                loadStories();
            }
        } else if (status === PageStatus.Active) {
            pageStack.pushAttached(Qt.resolvedUrl("ShowStoriesPage.qml"));
        } else if (status === PageStatus.Deactivating) {
            storiesLoadedOnce = true;
        }
    }

    function loadStories() {
        model.loadNewStories();
    }
}
