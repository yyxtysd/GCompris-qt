/* GCompris - oware
 *
 * Copyright (C) 2016 shivansh Bajaj <bajajshivansh1@gmail.com>
 *
 * Authors:
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation; either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program; if not, see <http://www.gnu.org/licenses/>.
 */
import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Controls.Styles 1.0
import GCompris 1.0
import "../../core"

import "awele.js" as Activity
ActivityBase{
    id: activity
    property bool player: false
    property var rule: qsTr("Oware is played on a board of two rows and six holes. The row in front of you is your own ground. The game starts with 4 seeds in each hole.")+"\n"+qsTr("Oware Rule 1 : sowing")+"\n"+qsTr("To sow you must take all the seeds of  any of your holes and lay its out along the holes against the direction of the clockwise. In every hole you should lay it out one seed.  If you reach the last hole of your ground you must continue in the land of the other player. Remember, you always have to lay out seeds in the direction against the clockwise")+"\n"+qsTr("Oware Rule 2: harvesting")+"\n"+qsTr("If the last hole where you sow is in the land of the other player and there are two or three seeds in the last hole remove from the board and keep them.If the previous holes also contain two or three seeds also remove them and remove all the seeds of your opponent that contains two or three seeds.")+"\n"+qsTr("Oware Rule 3: The Kroo ")+"\n"+qsTr("As the game progresses, is possible that one hole contains more than 12 seeds. This hole is called Kroo and makes possible complete one round.When the harvest starts at the Kroo, this hole must finish empty what means that the player shouldn’t lay out any seed.")+"\n"+qsTr("Oware Rule 4: You can’t permit other players feel hungry")+"\n"+qsTr("If the other player has only one seed in his field you will have to remove it in order to harvest and continue playing. This situation means that the other player will not be able keep playing.Players must provide in advance to avoid this situation. For example, having at least one seed in the last hole to harvest immediately to our opponent side and allow him to keep playing.If this is impossible, because we only have one seed in our land. The game is finished. Teh winner is the one that harvest more.")+"\n"+qsTr("Oware Rule 5: The final agreement ")+"\n"+qsTr("When there are few seeds left on the counter, the game may be perpetuating and hardly any of the 2 players can capture any new seed. By mutual agreement player can agree the end of the game. In this case every player is the owner of the seeds in his side.  As always, who has garnered more wins the match.")
    property bool learn:false
    property bool playerTwo:false
    property int xStart
    property int xEnd
    property int yStart
    property int yEnd
    onStart:{focus=true
    }
    onStop: {Activity.reload()}

    pageComponent:Image{
        id: background
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
        sourceSize.width: parent.width
        source: Activity.url + "/background.jpg"
        signal start
        signal stop

        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
        }


        // Add here the QML items you need to access in javascript
        QtObject{
            id:items

            property Item main: activity.main
            property alias learnOware:learnOware
            property alias background: background
            property alias row: rowButton
            property alias rowTop: rowButtonTop
            property alias textOneSource: playerOneText
            property alias textTwoSource: playerTwoText
            property alias repeator: repeator
            property alias player1turn: player1turn
            property alias bar: bar
            property alias rotatekonqi: rotatekonqi
        }

        onStart:{ Activity.start(items)}
        onStop: {Activity.stop()}
        QtObject {
            id: item
            property var dataset: {
                "none": "",
                        "south":qsTr("its South turn"),
                        "north":qsTr("its north turn"),

            }

            property bool cycleDone: false
            property GCAudio audioEffects: activity.audioEffects
        }

        Rectangle {
            id: infoRec
            radius: 30
            border.width: 5
            color:"#c68c53"
            border.color: "white"
            width: parent.width
            height: parent.height
            visible: false
            z: 100
            onVisibleChanged: {
                if(visible) {
                    animDescription.start()
                }
                else {
                    // stop if audio was playing
                    items.audioEffects.stop()
                }
            }

            NumberAnimation {
                id: animDescription
                target: infoRec
                property:"y"
                from:-height
                to: 0
                duration: 1200
                easing.type: Easing.OutBack
            }

            MouseArea {
                anchors.fill: parent
                onPressed: parent.close()
            }


            property var description: qsTr("If the last hole where you sow is in the land of the other player and there are two or three seeds in the last hole remove from the board and keep them. If the previous holes also contain two or three seeds also remove them and remove all the seeds of your opponent that contains two or three seeds." )+qsTr("As the game progresses, is possible that one hole contains more than 12 seeds. This hole is called Kroo and makes possible complete one round. When the harvest starts at the Kroo, this hole must finish empty what means that the player shouldn’t lay out any seed.")
            property var imageSource:Activity.url+"/background.jpg"

            property bool horizontalLayout: background.width > background.height

            GCText {
                id: heading
                fontSize: largeSize
                horizontalAlignment: Text.AlignHCenter
                font.weight: Font.DemiBold
                anchors.centerIn: parent.Center
                color: "white"
                width: parent.width
                text:qsTr("Rules")
                wrapMode: Text.WordWrap
            }

            GCText {
                id: descriptionText
                font.weight: Font.DemiBold
                fontSizeMode: Text.Fit
                horizontalAlignment: Text.AlignHCenter
                anchors {
                    top: heading.bottom
                    horizontalCenter: parent.horizontalCenter
                }
                color: "white"
                width:  parent.width*0.9
                height: parent.height*0.9
                text:rule
                wrapMode: Text.WordWrap
            }

            // The cancel button
            GCButtonCancel {
                onClose: parent.close()
            }

            function close() {
                infoRec.visible = false;

            }


        }


        IntroMessage {
            id: message
            anchors {
                top: parent.top
                topMargin: 10
                right: parent.right
                rightMargin: 5
                left: parent.left
                leftMargin: 5
            }
            z: 100
            onIntroDone: {

                info.visible = true

            }
            intro: [
                qsTr("At the beginning of the game four seeds are placed in each house. Players take turns moving the seeds. In each turn, a player chooses one of the six houses under his or her control. The player removes all seeds from this house, and distributes them, dropping one in each house counter-clockwise from the original house, in a process called sowing."),
                qsTr("Seeds are not distributed into the end scoring houses, nor into the house drawn from. That is, the starting house is left empty; if it contained 12 seeds, it is skipped, and the twelfth seed is placed in the next house. After a turn, if the last seed was placed into an opponent's house and brought its total to two or three, all the seeds in that house are captured and placed in the player's scoring house (or set aside if the board has no scoring houses). If the previous-to-last seed also brought the total seeds in an opponent's house to two or three, these are captured as well, and so on."),
                qsTr(". However, if a move would capture all an opponent's seeds, the capture is forfeited, and the seeds are instead left on the board, since this would prevent the opponent from continuing the game. The proscription against capturing all an opponent's seeds is related to a more general idea, that one ought to make a move that allows the opponent to continue playing. If an opponent's houses are all empty, the current player must make a move that gives the opponent seeds. If no such move is possible, the current player captures all seeds in his/her own territory, ending the game.")
            ]
        }

        function learnOwares(level){
            if(level==0){
                info.setText("none");
                learn=false;
            }
            if(level==1){
                info.setText("sowing");

                rule=2;
            }
            if(level==2){
                info.setText("harvesting");
                Activity.Harvesting();
                rule=3;
            }
            if(level==3){
                info.setText("The Kroo");
                Activity.TheKroos();
                rule=4;
            }
            if(level==4){
                info.setText("hungry");
                rule=5;
            }
            if(level==5){
                info.setText("final");
                rule=0;
            }

        }

        Rectangle{
            id:playerOneScore
            height: board.height/2
            width: height
            border.color: "transparent"
            color:"transparent"
            border.width: 5*ApplicationInfo.ratio
            anchors{
                left:board.right
                verticalCenter: parent.verticalCenter

            }
            Image{
                id:imageOne
                anchors.centerIn: parent
                source:Activity.url+"/score.png"
                GCText {
                    id: playerTwoText
                    color: "white"
                    property var textSource:Activity.playerTwoPoints
                    anchors.centerIn: parent
                    fontSize: smallSize
                    text: textSource
                    horizontalAlignment: Text.AlignHCenter
                    wrapMode: TextEdit.WordWrap
                }
            }
            //            GCText {
            //                id: south
            //                color: "white"
            //                anchors.top: imageOne.bottom
            //                anchors.horizontalCenter: imageOne.horizontalCenter
            //                fontSize: smallSize
            //                text: qsTr("South")
            //                horizontalAlignment: Text.AlignHCenter
            //                wrapMode: TextEdit.WordWrap
            //            }
            Image {
                id: player1image
                source: Activity.url+"stone_1.svg"
                anchors.top: imageOne.bottom
                anchors.horizontalCenter: imageOne.horizontalCenter

            }
            SequentialAnimation {
                id: rotatekonqi

                loops: Animation.Infinite
                NumberAnimation {
                    target: player1image
                    property: "rotation"
                    from: -30; to: 30
                    duration: 750
                    easing.type: Easing.InOutQuad
                }
                NumberAnimation {
                    target: player1image
                    property: "rotation"
                    from: 30; to: -30
                    duration: 750
                    easing.type: Easing.InOutQuad
                }
            }
            states: [
                State {
                    name: "first"
                    PropertyChanges {
                        target: playerOneScore
                        border.color: "transparent"
                    }
                },
                State {
                    name: "win"

                    PropertyChanges {
                        target: playerOneScore
                        color: "#f7ec5d"
                    }
                }
            ]

            transform: Scale {
                id: changeScale1
                property real scale: 1
                xScale: scale
                yScale: scale
            }
        }
        ParallelAnimation{

            id:translate
            onStarted: {
                transImage.state="true"
            }
            onStopped: {
                transImage.state="false"
            }

            NumberAnimation {
                target: transImage
                property: "y"
                from:yStart+boardGrid.y/4
                to:yEnd+boardGrid.y+boardGrid.width/4
                duration:1700

            }
            NumberAnimation {
                target: transImage
                property: "x"
                from:xStart+boardGrid.x
                to:xEnd+boardGrid.x
                duration:1700
            }
        }
        PropertyAnimation {
            id: player1turn
            target: changeScale1
            properties: "scale"
            from: 1.0
            to: 1.4
            duration: 500
            onStarted:{
                info.setText("south")
                player2shrink.start()
                rotatekonqi.start()
            }
            onStopped: {}
        }

        PropertyAnimation {
            id: player1shrink
            target: changeScale1
            properties: "scale"
            from: 1.4
            to: 1.0
            duration: 500
        }
        PropertyAnimation {
            id: player2turn
            target: changeScale2
            properties: "scale"
            from: 1.0
            to: 1.4
            duration: 500
            onStarted:{
                info.setText("north")
                player1shrink.start()
                rotateTux.start()
            }
            onStopped: {}
        }

        PropertyAnimation {
            id: player2shrink
            target: changeScale2
            properties: "scale"
            from: 1.4
            to: 1.0
            duration: 500
        }
        Image {
            id: board
            source: Activity.url + "/awele_board.png"
            anchors.centerIn: parent
            //anchors.fill:parent
            width:parent.width*0.7
            height:width*0.4
        }
        Rectangle{
            id:playerTwoScore
            height: board.height/2
            width: height
            color:"transparent"
            anchors{
                right:board.left
                verticalCenter: parent.verticalCenter

            }
            Image{
                id:imageTwo
                anchors.leftMargin: 5*ApplicationInfo.ratio
                source:Activity.url+"/score.png"

                GCText {
                    id: playerOneText
                    color: "white"
                    property var textSource:Activity.playerOnePoints
                    anchors.centerIn: parent
                    fontSize: smallSize
                    text: textSource
                    horizontalAlignment: Text.AlignHCenter
                    wrapMode: TextEdit.WordWrap
                }
            }
            //            GCText {
            //                id: tux
            //                color: "white"
            //                anchors.bottom: imageTwo.top
            //                anchors.horizontalCenter: imageTwo.horizontalCenter
            //                fontSize: smallSize
            //                text: qsTr("tux")
            //                horizontalAlignment: Text.AlignHCenter
            //                wrapMode: TextEdit.WordWrap
            //            }
            Image {
                id: player2image
                source: Activity.url + "stone_2.svg"
                anchors.bottom: imageTwo.top
                height:parent.height*0.3
                width: height
                anchors.horizontalCenter: imageTwo.horizontalCenter
            }
            states: [
                State {
                    name: "first"
                    PropertyChanges {
                        target: playerTwoScore
                        color: "transparent"
                    }
                },
                State {
                    name: "win"

                    PropertyChanges {
                        target: playerTwoScore
                        color: "#f7ec5d"
                    }
                }
            ]
            SequentialAnimation {
                id: rotateTux
                loops: Animation.Infinite
                NumberAnimation {
                    target: player2image
                    property: "rotation"
                    from: -30; to: 30
                    duration: 750
                    easing.type: Easing.InOutQuad
                }
                NumberAnimation {
                    target: player2image
                    property: "rotation"
                    from: 30; to:-30
                    duration: 750
                    easing.type: Easing.InOutQuad
                }
            }

            transform: Scale {
                id: changeScale2
                property real scale: 1
                xScale: scale
                yScale: scale
            }
        }
        ListView{
            id: rowButtonTop
            width:boardGrid.width
            visible: false
            height: boardGrid.height/6
            orientation: ListView.Horizontal
            model:6
            anchors {
                horizontalCenter: board.horizontalCenter
                bottom: board.top
            }
            states: [
                State {
                    name: "true"
                    PropertyChanges {
                        target: rowButtonTop
                        visible: true
                    }
                },
                State {
                    name: "false"

                    PropertyChanges {
                        target: rowButtonTop
                        visible: false
                    }
                }
            ]

            delegate: Item{
                height: parent.height
                width: boardGrid.width/6
                Rectangle{
                    anchors.fill:parent
                    color:"transparent"
                    Image {
                        property var sourceString: Activity.url + "bouton"+(5-index+1)+".png"
                        source: sourceString
                        anchors.centerIn: parent
                        MouseArea {
                            anchors.fill:parent
                            hoverEnabled: true
                            onClicked:{
                                if(playerTwo==true){
                                    multiPlayer(index);
                                }
                                else
                                    singlePlayer(5-index);
                                sourceString: Activity.url + "bouton"+(5-index+1)+".png"

                            }
                            onPressed: {

                                sourceString=Activity.url + "bouton"+(5-index+1)+"_clic.png";
                            }
                            onReleased: {
                                sourceString=Activity.url + "bouton"+(5-index+1)+".png";
                            }

                            onEntered: {

                                sourceString=Activity.url + "bouton"+(5-index+1)+"_notify.png";
                            }
                            onExited: {

                                sourceString=Activity.url + "bouton"+(5-index+1)+".png";

                            }
                        }
                    }
                }
            }
        }
        Grid {
            id:boardGrid
            columns:6
            rows:2


            anchors {
                horizontalCenter: board.horizontalCenter
                top : board.top

            }
            Repeater{
                id:repeator
                model:12
                Rectangle {
                    color: "transparent"
                    height: board.height/2
                    width: board.width*(1/6.25)
                    //  height:width
                    property var circleRadius: width
                    property var value: Activity.getValueByIndex(index,player)
                    GCText{
                        text:value
                        color: "white"
                        font.bold: true
                        font.family: "Helvetica"
                        fontSize: smallSize
                        anchors.top: parent.top
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                    Repeater {
                        model: value
                        Image {
                            source: Activity.url+"graine2.png"
                            height:circleRadius*0.2
                            width:circleRadius*0.2
                            x:circleRadius/2+Activity.getX(circleRadius/6,index,value)
                            y:circleRadius/2+Activity.getY(circleRadius/5,index,value)
                            Loader {
                                id: loader
                                onLoaded: { view.state="fadeIn"; }
                            }


                            //                               MouseArea{
                            //                                   anchors.fill: parent
                            //                               }
                        }
                    }
                }
            }
            // spacing: 10*ApplicationInfo.ratio
        }
        Image {
            id: transImage
            visible: false
            source: Activity.url+"graine1.png"
            states: [
                State {
                    name: "true"
                    PropertyChanges {
                        target: transImage
                        visible: true
                    }
                },
                State {
                    name: "false"

                    PropertyChanges {
                        target: transImage
                        visible: false
                    }
                }
            ]

        }
        ListView{
            id: rowButton
            width:boardGrid.width
            height: boardGrid.height/6
            orientation: ListView.Horizontal
            model:6
            anchors {
                horizontalCenter: board.horizontalCenter
                top: board.bottom
            }
            states: [
                State {
                    name: "true"
                    PropertyChanges {
                        target: rowButton
                        visible: true
                    }
                },
                State {
                    name: "false"

                    PropertyChanges {
                        target: rowButton
                        visible: false
                    }
                }
            ]

            delegate: Item{
                height: parent.height
                width: boardGrid.width/6

                Rectangle{
                    anchors.fill:parent
                    color:"transparent"
                    Image {
                        property var sourceString: Activity.url + "bouton"+(index+1)+".png"
                        source: sourceString
                        anchors.centerIn: parent
                        MouseArea {
                            anchors.fill:parent
                            hoverEnabled: true
                            onClicked:{
                                if(playerTwo==true){
                                    multiPlayer(index);
                                }
                                else
                                    singlePlayer(index);
                                sourceString: Activity.url + "bouton"+(index+1)+".png"

                            }
                            onPressed: {

                                sourceString=Activity.url + "bouton"+(index+1)+"_clic.png";
                            }
                            onReleased: {
                                sourceString=Activity.url + "bouton"+(index+1)+".png";
                            }

                            onEntered: {

                                sourceString=Activity.url + "bouton"+(index+1)+"_notify.png";
                            }
                            onExited: {

                                sourceString=Activity.url + "bouton"+(index+1)+".png";

                            }
                        }
                    }
                }
            }
        }

        //        Row {
        //            id:rowButton
        //            height: boardGrid.height*(1/6)
        //            width: parent.width*0.7
        //            spacing: board.width*(1/10)
        //            anchors {
        //                horizontalCenter: board.horizontalCenter
        //                top: board.bottom
        //                topMargin: 5*ApplicationInfo.ratio
        //            }
        //            Repeater {
        //                id:rowButtonRepeator
        //                model:6
        //                Component{
        //                    Image {
        //                        property var sourceString: Activity.url + "bouton"+(index+1)+".png"
        //                        source: sourceString

        //                        MouseArea {
        //                            anchors.fill:parent
        //                            hoverEnabled: true
        //                            onClicked:{
        //                                if(playerTwo==true){
        //                                    multiPlayer(index);
        //                                }
        //                                else
        //                                    singlePlayer(index);
        //                                sourceString: Activity.url + "bouton"+(index+1)+".png"

        //                            }
        //                            onPressed: {

        //                                sourceString=Activity.url + "bouton"+(index+1)+"_clic.png";
        //                            }
        //                            onReleased: {
        //                                sourceString=Activity.url + "bouton"+(index+1)+".png";
        //                            }

        //                            onEntered: {

        //                                sourceString=Activity.url + "bouton"+(index+1)+"_notify.png";
        //                            }
        //                            onExited: {

        //                                sourceString=Activity.url + "bouton"+(index+1)+".png";

        //                            }
        //                        }
        //                    }
        //                }
        //            }
        //        }

        Button{
            id:learnOware
            text: qsTr("Rules")
            anchors.right: parent.right
            anchors.rightMargin: 20*ApplicationInfo.ratio
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 20*ApplicationInfo.ratio
            onClicked: {
                infoRec.visible=true;
            }
            opacity: enabled
            Behavior on opacity {
                PropertyAnimation {
                    easing.type: Easing.InQuad
                    duration: 200
                }
            }
            style: ButtonStyle {

                background: Rectangle {
                    implicitWidth: 50*ApplicationInfo.ratio
                    implicitHeight: 50*ApplicationInfo.ratio
                    border.width: control.activeFocus ? 4 : 2

                    radius: 50*ApplicationInfo.ratio
                    gradient: Gradient {
                        GradientStop { position: 0 ; color: control.pressed ? "white" : "#d0c47e" }
                        GradientStop { position: 1 ; color: control.pressed ? "white" : "#d0c47e" }
                    }
                }
            }
        }

        GCText {
            id: info
            visible: true
            fontSize: smallSize
            color: "white"
            font.weight: Font.DemiBold
            horizontalAlignment: Text.AlignHCenter
            anchors {
                top: rowButton.bottom
                topMargin: 10 *ApplicationInfo.ratio
                horizontalCenter: parent.horizontalCenter
            }
            width: parent.width
            wrapMode: Text.WordWrap

            onTextChanged: textanim.start()
            property string newKey
            SequentialAnimation {
                id: textanim
                NumberAnimation {
                    target: info
                    property: "opacity"
                    duration: 200
                    from: 1
                    to: 0
                }
                PropertyAction {
                    target: info
                    property: 'text'
                    value: item.dataset[info.newKey]
                }
                NumberAnimation {
                    target: info
                    property: "opacity"
                    duration: 200
                    from: 0
                    to: 1
                }
            }

            function setText(key) {
                if(newKey != key) {
                    newKey = key
                    textanim.start()
                }
            }
        }

        function singlePlayer(index){
            Activity.newAi(index,player);
            Activity.updateValues();
            Activity.updateScores();
        }


        function multiPlayer(index){
            console.log("player",player,index,Activity.getValueByIndex(index,player));
            if(Activity.getValueByIndex(index,player)!=0){
                for(var i=index;i<index+Activity.getValueByIndex(index,player);i++){
                    xStart=repeator.itemAt(index).x;
                    xEnd=repeator.itemAt((index+i)%6).x;
                    yStart=repeator.itemAt(index).y;
                    yEnd=repeator.itemAt((index+i)%6).y;
                    console.log(xStart,xEnd,yStart,yEnd);
                    translate.start();
                }
                if(player){
                    player2turn.stop();
                    player1turn.start();
                    rowButton.state="true"
                    rowButtonTop.state="false"
                    rotateTux.stop();
                }
                else{
                    player1turn.stop();
                    player2turn.start();
                    rowButton.state="false"
                    rowButtonTop.state="true"
                    rotatekonqi.stop();
                }

                Activity.twoPlayer(index,player);
                player=!player;
            }
            Activity.updateValues();
            Activity.updateScores();
        }
        DialogHelp {
            id: dialogHelp
            onClose: home()
        }
        Bar {
            id: bar
            content: BarEnumContent { value: help | home | reload |(playerTwo ? 0 : level)}
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onHomeClicked: activity.home()
            onReloadClicked: {Activity.reload();player=false}
            onNextLevelClicked: Activity.nextLevel()
            onPreviousLevelClicked: Activity.previousLevel()

        }

    }
}

