import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Controls.Material

Item {
    id: root
    signal loginSuccess(string username, int durationMinutes, string sessionToken)
    signal loginFailed(string message)

    property string apiUrl: "http://52.66.13.171:8002/api/auth/login"
    property bool busy: false

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
                source: "qrc:/icons/pre-logo.png"
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
                placeholderText: "Customer ID"
                Layout.fillWidth: true
                Material.accent: "#96a6fd"
                enabled: !root.busy
            }

            TextField {
                id: passwordField
                placeholderText: "Password"
                echoMode: TextInput.Password
                Layout.fillWidth: true
                Material.accent: "#96a6fd"
                enabled: !root.busy
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

            BusyIndicator {
                Layout.alignment: Qt.AlignHCenter
                visible: root.busy
                running: root.busy
            }

            Button {
                id: loginButton
                text: root.busy ? "Checking..." : "Login"
                Layout.fillWidth: true
                Material.background: "#6b4fd8"
                enabled: !root.busy && usernameField.text !== "" && passwordField.text !== ""
                onClicked: {
                    doLogin()
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

    function doLogin() {
        errorLabel.text = ""
        root.busy = true
        var xhr = new XMLHttpRequest()
        xhr.open("POST", root.apiUrl)
        xhr.setRequestHeader("Content-Type", "application/json")
        xhr.timeout = 15000
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                root.busy = false
                if (xhr.status === 200) {
                    try {
                        var resp = JSON.parse(xhr.responseText)
                        if (resp.ok) {
                            var dur = parseInt(resp.duration_minutes) || 60
                            root.loginSuccess(resp.username || usernameField.text, dur, resp.session_token || "")
                        } else {
                            root.showError(resp.error || "Login failed")
                            root.loginFailed(resp.error || "Login failed")
                        }
                    } catch (e) {
                        root.showError("Server error, try again")
                        root.loginFailed("Server error")
                    }
                } else if (xhr.status === 401) {
                    root.showError("Galat ID ya password")
                    root.loginFailed("Invalid credentials")
                } else {
                    root.showError("Server se connect nahi ho paya")
                    root.loginFailed("Connection failed")
                }
            }
        }
        xhr.ontimeout = function() {
            root.busy = false
            root.showError("Server timeout, try again")
            root.loginFailed("Timeout")
        }
        xhr.onerror = function() {
            root.busy = false
            root.showError("Server se connect nahi ho paya")
            root.loginFailed("Connection failed")
        }
        var payload = JSON.stringify({
            username: usernameField.text,
            password: passwordField.text
        })
        xhr.send(payload)
    }

    function showError(msg) {
        errorLabel.text = msg
    }
}
