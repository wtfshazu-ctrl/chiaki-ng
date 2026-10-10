import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material

Item {
    id: root
    signal timeExpired()

    // Session duration in seconds (3600 = 1 hour)
    property int sessionDuration: 3600
    property int timeRemaining: sessionDuration
    property bool running: false

    function start() {
        timeRemaining = sessionDuration
        running = true
        countdownTimer.start()
    }

    function stop() {
        running = false
        countdownTimer.stop()
    }

    function formatTime(seconds) {
        var h = Math.floor(seconds / 3600)
        var m = Math.floor((seconds % 3600) / 60)
        var s = seconds % 60
        return (h < 10 ? "0" + h : h) + ":" +
               (m < 10 ? "0" + m : m) + ":" +
               (s < 10 ? "0" + s : s)
    }

    Timer {
        id: countdownTimer
        interval: 1000
        repeat: true
        onTriggered: {
            if (root.timeRemaining > 0) {
                root.timeRemaining--
                // Warning at 5 minutes
                if (root.timeRemaining === 300) {
                    warningDialog.open()
                }
                // Warning at 1 minute
                if (root.timeRemaining === 60) {
                    finalWarningDialog.open()
                }
            } else {
                root.stop()
                root.timeExpired()
            }
        }
    }

    // Timer display (top overlay during stream)
    Rectangle {
        id: timerDisplay
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 10
        width: 140
        height: 36
        radius: 18
        color: timeRemaining < 300 ? "#aa2222" : "#1a1a2e"
        border.color: "#96a6fd"
        border.width: 1
        visible: root.running

        Label {
            anchors.centerIn: parent
            text: "⏱ " + formatTime(timeRemaining)
            color: "white"
            font.pixelSize: 16
            font.bold: true
        }
    }

    Dialog {
        id: warningDialog
        title: "RentPass"
        modal: true
        standardButtons: Dialog.Ok
        Label {
            text: "5 minutes remaining in your session!"
            color: "white"
        }
    }

    Dialog {
        id: finalWarningDialog
        title: "RentPass"
        modal: true
        standardButtons: Dialog.Ok
        Label {
            text: "1 minute remaining! Your session will end soon."
            color: "white"
        }
    }
}
