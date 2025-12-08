import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import SddmComponents 2.0

Rectangle {
    id: root
    width: 1920
    height: 1080
    color: "#04060a"

    property int sessionIndex: sessionModel.lastIndex

    TextConstants { id: textConstants }

    // Background image
    Image {
        anchors.fill: parent
        source: "background.png"
        fillMode: Image.PreserveAspectCrop
        opacity: 1
    }

    // Soft glow behind the form
    Rectangle {
        anchors.centerIn: parent
        width: 770
        height: 320
        radius: 400
        color: "#0eb8ff"
        opacity: 0.07
        rotation: -10
        anchors.horizontalCenterOffset: 140
        anchors.verticalCenterOffset: -40
    }

    // Login Form on the right side
    Rectangle {
        id: loginForm
        width: 520
        height: 560
        color: "#03060cff"
        radius: 18
        border.color: "#cdcbcbff"
        border.width: 1
        anchors.right: parent.right
        anchors.rightMargin: 360
        anchors.verticalCenter: parent.verticalCenter
        opacity: 0.9
        layer.enabled: true
        layer.smooth: true

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 34
            spacing: 22

            // Title
            Text {
                text: "SECURE LOGIN"
                color: "#e9f4ff"
                font.pixelSize: 26
                font.bold: true
                font.family: "monospace"
                Layout.alignment: Qt.AlignHCenter
                Layout.bottomMargin: 6
            }

            Text {
                text: "AUTHORIZED USERS ONLY"
                color: "#79caff"
                font.pixelSize: 12
                font.letterSpacing: 2
                font.family: "monospace"
                opacity: 0.8
                Layout.alignment: Qt.AlignHCenter
                Layout.bottomMargin: 10
            }

            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: "#0e2f45"
                opacity: 0.7
            }

            // Username Label
            Text {
                text: "USERNAME"
                color: "#e6f0ff"
                font.pixelSize: 13
                Layout.fillWidth: true
                font.family: "monospace"
                font.bold: true
            }

            // Username Input
            TextField {
                id: usernameField
                Layout.fillWidth: true
                height: 48
                placeholderText: "Enter username"
                text: userModel.lastUser
                background: Rectangle {
                    radius: 10
                    border.color: control.activeFocus ? "#0eb8ff" : "#0d2237"
                    border.width: 1
                    gradient: Gradient {
                        GradientStop { position: 0.0; color: "#0a1020" }
                        GradientStop { position: 1.0; color: "#0d1b32" }
                    }
                }

                color: "#f7fcff"
                placeholderTextColor: "#6ea2c7"
                padding: 12
                font.pixelSize: 14
                font.family: "monospace"
                
                Keys.onPressed: {
                    if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                        passwordField.forceActiveFocus()
                        event.accepted = true
                    }
                }
            }

            // Password Label
            Text {
                text: "PASSWORD"
                color: "#e6f0ff"
                font.pixelSize: 13
                Layout.fillWidth: true
                font.family: "monospace"
                font.bold: true
            }

            // Password Input
            TextField {
                id: passwordField
                Layout.fillWidth: true
                height: 48
                placeholderText: "Enter password"
                echoMode: TextInput.Password
                background: Rectangle {
                    radius: 10
                    border.color: control.activeFocus ? "#0eb8ff" : "#0d2237"
                    border.width: 1
                    gradient: Gradient {
                        GradientStop { position: 0.0; color: "#0a1020" }
                        GradientStop { position: 1.0; color: "#0d1b32" }
                    }
                }

                color: "#f7fcff"
                placeholderTextColor: "#6ea2c7"
                padding: 12
                font.pixelSize: 14
                font.family: "monospace"
                
                Keys.onPressed: {
                    if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                        sddm.login(usernameField.text, passwordField.text, sessionIndex)
                        event.accepted = true
                    }
                }
            }

            // Status row for visual trust cues
            RowLayout {
                Layout.fillWidth: true
                spacing: 10

                Rectangle { width: 10; height: 10; radius: 5; color: "#0eb8ff"; opacity: 0.9 }
                Rectangle { width: 10; height: 10; radius: 5; color: "#0eb8ff"; opacity: 0.55 }
                Rectangle { width: 10; height: 10; radius: 5; color: "#ffffff"; opacity: 0.4 }

                Text {
                    text: "ENCRYPTED SESSION" 
                    color: "#b9dbff"
                    font.pixelSize: 12
                    font.family: "monospace"
                    Layout.fillWidth: true
                    elide: Text.ElideRight
                }
            }

            // Spacer
            Item {
                Layout.fillHeight: true
            }

            // Login Button
            Rectangle {
                id: loginButton
                Layout.fillWidth: true
                height: 50
                color: mouseArea.containsMouse ? "#10c8ff" : "#0eb8ff"
                radius: 10
                border.color: "#0fc1ff"
                border.width: 2

                Text {
                    text: "Login"
		color: "#01060d"
                    font.bold: true
                    font.pixelSize: 16
                    font.family: "monospace"
                    anchors.centerIn: parent
                }

                MouseArea {
                    id: mouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        sddm.login(usernameField.text, passwordField.text, sessionIndex)
                    }
                }
            }
        }
    }

    Connections {
        target: sddm
        function onLoginFailed() {
            passwordField.text = ""
            passwordField.focus = true
            errorText.visible = true
        }
    }

    // Error message
    Text {
        id: errorText
        text: "Login failed. Please try again."
        color: "#ff4444"
        font.pixelSize: 14
        font.bold: true
        visible: false
        anchors.horizontalCenter: loginForm.horizontalCenter
        anchors.top: loginForm.bottom
        anchors.topMargin: 20
    }

    Component.onCompleted: {
        usernameField.focus = true
    }
}
