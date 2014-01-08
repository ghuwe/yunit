import QtQuick 2.0
import Ubuntu.Components 0.1

Item {
    id: root
    property var template
    property var components
    property var cardData

    width: {
        if (template !== undefined) {
            if (template["card-layout"] === "horizontal") return units.gu(38);
            switch (template['card-size']) {
                case "small": return units.gu(12);
                case "large": return units.gu(38);
            }
        }
        return units.gu(18.5);
    }
    height: childrenRect.height

    UbuntuShape {
        id: artShape
        objectName: "artShape"
        width: image.fillMode === Image.PreserveAspectCrop || aspect < image.aspect ? image.width : height * image.aspect
        height: image.fillMode === Image.PreserveAspectCrop || aspect > image.aspect ? image.height : width / image.aspect
        anchors.horizontalCenter: template && template["card-layout"] === "horizontal" ? undefined : parent.horizontalCenter

        property real aspect: components !== undefined ? components["art"]["aspect-ratio"] : 1

        image: Image {
            width: template && template["card-layout"] === "horizontal" ? height * artShape.aspect : root.width
            height: template && template["card-layout"] === "horizontal" ? header.height : width / artShape.aspect
            objectName: "artImage"
            source: cardData && cardData["art"] || ""
            // FIXME uncomment when having investigated / fixed the crash
            //sourceSize.width: width > height ? width : 0
            //sourceSize.height: height > width ? height : 0
            fillMode: components["art"]["fill-mode"] === "fit" ? Image.PreserveAspectFit: Image.PreserveAspectCrop

            property real aspect: implicitWidth / implicitHeight
        }
    }

    CardHeader {
        id: header
        objectName: "cardHeader"
        anchors {
            top: template && template["card-layout"] === "horizontal" ? artShape.top : artShape.bottom
            left: template && template["card-layout"] === "horizontal" ? artShape.right : parent.left
            right: parent.right
        }

        mascot: cardData && cardData["mascot"] || ""
        title: cardData && cardData["title"] || ""
        subtitle: cardData && cardData["subtitle"] || ""
    }

    Label {
        objectName: "summaryLabel"
        anchors { top: header.bottom; left: parent.left; right: parent.right }
        wrapMode: Text.Wrap
        maximumLineCount: 5
        elide: Text.ElideRight
        text: cardData && cardData["summary"] || ""
    }
}
