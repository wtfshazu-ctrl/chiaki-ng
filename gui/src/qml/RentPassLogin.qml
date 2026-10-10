import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Controls.Material

Item {
    id: root
    signal loginSuccess(string username)
    signal loginFailed(string message)

    property string apiUrl: "https://rentpass.store/api/rentpass-auth"

    Material.theme: Material.Dark
    Material.accent: "#96a6fd"

    Rectangle {
        anchors.fill: parent
        color: "#0a0a14"

        ColumnLayout {
            anchors.centerIn: parent
            width: Math.min(parent.width * 0.85, 400)
            spacing: 16

            // Logo
            Image {
                source: "qrc:/res/pre-logo.png"
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: 200
                Layout.preferredHeight: 120
                fillMode: Image.PreserveAspectFit
            }

            Label {
                text: "RentPass"
                font.pixelSize: 32
                font.bold: true
                color: "#ffffff"
                Layout.alignment: Qt.AlignHCenter
            }

            Label {
                text: "Login to start your gaming session"
                font.pixelSize: 14
                color: "#96a6fd"
                Layout.alignment: Qt.AlignHCenter
            }

            TextField {
                id: usernameField
                placeholderText: "Username / Email"
                Layout.fillWidth: true
                Material.accent: "#96a6fd"
            }

            TextField {
                id: passwordField
                placeholderText: "Password"
                echoMode: TextInput.Password
                Layout.fillWidth: true
                Material.accent: "#96a6fd"
                onAccepted: loginButton.clicked()
            }

            Label {
                id: errorLabel
                text: ""
                color: "#ff5555"
                font.pixelSize: 12
                Layout.alignment: Qt.AlignHCenter
                visible: text !== ""
            }

            Button {
                id: loginButton
                text: "Login"
                Layout.fillWidth: true
                Material.background: "#6b4fd8"
                enabled: usernameField.text !== "" && passwordField.text !== ""
                onClicked: {
                    // TODO: Verify against rentpass.store API
                    // For now, accept any non-empty credentials
                    // In production, this will call the API
                    if (usernameField.text !== "" && passwordField.text !== "") {
                        root.loginSuccess(usernameField.text)
                    } else {
                        root.loginFailed("Please enter username and password")
                    }
                }
            }

            Label {
                text: "Don't have an account? Visit rentpass.store"
                font.pixelSize: 11
                color: "#888888"
                Layout.alignment: Qt.AlignHCenter
            }
        }
    }

    function showError(msg) {
        errorLabel.text = msg
    }
}
