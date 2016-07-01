/* GCompris - alphabetical_order.js
 *
 * Copyright (C) 2016 Stefan Toncu <stefan.toncu29@gmail.com>
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
.pragma library
.import QtQuick 2.0 as Quick
.import GCompris 1.0 as GCompris //for ApplicationInfo
.import "qrc:/gcompris/src/core/core.js" as Core

var currentLevel = 0
var numberOfLevel = 10
var items
var alphabet = []
var asciiAlphabet = ['a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z']
var solution = []
var dataSetUrl= "qrc:/gcompris/src/activities/gletters/resource/"

var totalLettersNoOk = [3,3,5,5,6,6,6,7,8,8]
var guessLettersNoOk = [2,3,2,2,2,2,3,3,4,5]

var totalLetters = 3
var guessLetters = 1

var modelAux
var model
var badAnswers = []   //[{model: [], modelAux: [], solution: []}]
var levelsPassed = 0
var difficulty = 0  // 0 = extremely easy; 1 = very easy; 2 = easy; 3 = normal; 4 = hard; 5 = very hard; 6 = insane
// 0 = extremely easy: totalLetters = [3]; guessLetters = [1-2]
// 1 = very easy: totalLetters = [3]; guessLetters = [2-3]
// 2 = easy: totalLetters = [4]; guessLetters = [2-4]
// 3 = normal: totalLetters = [5]; guessLetters = [3-4]
// 4 = hard: totalLetters = [6]; guessLetters = [3-5]
// 5 = very hard: totalLetters = [7]; guessLetters = [4-6]
// 6 = insane: totalLetters = [8]; guessLetters = [6-8]

var interchange = 0
//var progress = {totalPassed: 0, totalFailed: 0, lastSubLevel: 0} // lastSubLevel = 0 if lost; = 1 if won
var progress = []  // 0 if lost, 1 if won   => [1,1,0,1,1,0,0,1,1,1,1,1...]


function start(items_) {
    items = items_
    currentLevel = 0
    progress = []

    items.score.numberOfSubLevels = 5
    items.score.currentSubLevel = 1

//imported from "readingh" activity
    var locale = items.locale == "system" ? "$LOCALE" : items.locale

    items.wordlist.loadFromFile(GCompris.ApplicationInfo.getLocaleFilePath(
            dataSetUrl + "default-"+locale+".json"));
    // If wordlist is empty, we try to load from short locale and if not present again, we switch to default one
    var localeUnderscoreIndex = locale.indexOf('_')
    // probably exist a better way to see if the list is empty
    if(items.wordlist.maxLevel == 0) {
        var localeShort;
        // We will first look again for locale xx (without _XX if exist)
        if(localeUnderscoreIndex > 0) {
            localeShort = locale.substring(0, localeUnderscoreIndex)
        }
        else {
            localeShort = locale;
        }
        // If not found, we will use the default file
        items.wordlist.useDefault = true
        items.wordlist.loadFromFile(GCompris.ApplicationInfo.getLocaleFilePath(
        dataSetUrl + "default-"+localeShort+".json"));
        // We remove the using of default file for next time we enter this function
        items.wordlist.useDefault = false
    }

    //setup the alphabet from file
    createAlphabet()

    initLevel()
}

function stop() {
}

function initLevel() {
    items.bar.level = currentLevel + 1

    // custom levels - change difficulty starting from level two (so the user gives feedback from solving at least 5 sublevels)
    if (currentLevel > 0 && items.okBoxChecked) {
        print("PROGRESS: ",progress)
        var currentProgress = progress.slice(Math.max(progress.length - 5,0),progress.length)  // take only the last 6 levels
        var sum = currentProgress.reduce(function(a, b) { return a + b; }, 0)

        if (sum == 5) {
            // do not increase difficulty if the last 2 sublevels were fails
            if (progress[progress.length - 1] != 0 && progress[progress.length - 2] != 0) {
                if (difficulty <= 4)
                    difficulty += 2
                else difficulty = 6
                print("sum is 5; difficulty increased by 2: ", difficulty)
            }
        } else if (sum == 4) {
            if (progress[progress.length - 1] != 0 && progress[progress.length - 2] != 0) {
                if (difficulty <= 5)
                    difficulty ++
                print("sum is 4; difficulty increased by 1: ", difficulty)
            }
        } else if (sum == 2) {
            if (difficulty >= 1)
                difficulty --
            print("sum is 2; difficulty decreased by 1: ", difficulty)
        } else if (sum < 2) {
            if (difficulty >= 2)
                difficulty -= 2
            else difficulty = 0
            print("sum is lower than 2; difficulty decreased by 2: ", difficulty)
        }
    }

    init()
}

function init() {
    items.gameFinished = false

    if (!items.okBoxChecked) {
        totalLetters = totalLettersNoOk[currentLevel]
        guessLetters = guessLettersNoOk[currentLevel]
        if (currentLevel < 3)
            interchange = 0
        else interchange = Math.floor(currentLevel / 2)
    } else {
        // setup number of total letters and guess letters depending the difficulty
        if (difficulty == 0) {
            interchange = 0
            totalLetters = 3
            //var randMinMax = Math.floor(Math.random() * (max - min + 1)) + min;
            guessLetters = Math.floor(Math.random() * (2 - 1 + 1) + 1)
        } else if (difficulty == 1) {
            interchange = 0
            totalLetters = 3
            guessLetters = Math.floor(Math.random() * (3 - 2 + 1) + 2)
        } else if (difficulty == 2) {
            interchange = 0
            totalLetters = 4
            guessLetters = Math.floor(Math.random() * (4 - 2 + 1)) + 2
        } else if (difficulty == 3) {
            interchange = 0
            totalLetters = 5
            guessLetters = Math.floor(Math.random() * (4 - 3 + 1)) + 3
        } else if (difficulty == 4) {
            interchange = 1
            totalLetters = 6
            guessLetters = Math.floor(Math.random() * (5 - 3 + 1)) + 3
        } else if (difficulty == 5) {
            interchange = 2
            totalLetters = 7
            guessLetters = Math.floor(Math.random() * (6 - 4 + 1)) + 4
        } else if (difficulty == 6) {
            interchange = 4
            totalLetters = 8
            guessLetters = Math.floor(Math.random() * (8 - 6 + 1)) + 6
        } else {
            print("difficulty?? ",difficulty)
        }
    }

    // if 2 levels have past and there are badAnsers saved, assign them as model and modelAux
    if (levelsPassed >= 2 && badAnswers.length != 0) {

            // set as model and modelAux a previous state wrongly solved by the user
            if(badAnswers.length > 0) {
                model = badAnswers[0].model
                modelAux = badAnswers[0].modelAux
                solution = badAnswers[0].solution
            }

            print("len: ", badAnswers.length - 1)

            // remove first element in vector badAnsers
            badAnswers = badAnswers.slice(1,badAnswers.length)

            print("len: ", badAnswers.length)

            print("after ___________")
            for (var j = 0; j < badAnswers.length; j++) {
                print(badAnswers[j].model + "    " + badAnswers[j].modelAux + "      " + badAnswers[j].solution)
            }

    // else, use normal levels
    } else {
        if (badAnswers.length == 0)
            levelsPassed = 0

            // ['a','b','c','d']
            if (currentLevel > 1)
                solution = makeSolution(alphabet, totalLetters)
            // just for first level, use the standard english (ascii) alphabet
            else
                solution = makeSolution(asciiAlphabet, totalLetters)

            // 3 1 4 2
            var numbers = getNumbers(totalLetters)

            // ['a','_','c','_']
            model = solution.slice()

            // ['b', 'd']
            modelAux = []
            for (var i = 0; i < guessLetters; i++) {
                model[numbers[i]] = '_'
                modelAux[i] = solution[numbers[i]]
            }


            // from level 6 to 8 interchange two good letters
            // repeat the interchange
            for (var k = 0; k < interchange; k++) {
                print("interchange")
                var a = Math.floor(Math.random() * (totalLetters))
                var b = Math.floor(Math.random() * (totalLetters))
                while (b == a)
                    b = Math.floor(Math.random() * (totalLetters))

                var aux = model[a]
                model[a] = model[b]
                model[b] = aux
            }

                    //starting from level 9, shuffle the model so no letter is placed in the right spot
                    //model = Core.shuffle(model)


            // a level was passed
            levelsPassed ++
    }


    // setting levels to repeaters (listModels)
    items.listModel.clear()
    items.listModelInput.clear()

    for (i = 0; i < modelAux.length; i++)
        items.listModelInput.append({"letter": modelAux[i]})

    for (i = 0; i < model.length; i++)
        items.listModel.append({"letter": model[i]})

}

/* goes through each level (in gletters json files) and appends all letters
  (removing digits and uppercase duplicates) in the alphabet */
function createAlphabet() {
    alphabet = []
    // all "words"
    for (var i = 1; i < items.wordlist.wordList.levels.length; i++) {
        var words = items.wordlist.getLevelWordList(i).words
        // all letters in "words"
        for (var j = 0; j < words.length; j++) {
            if (alphabet.indexOf(words[j].toLowerCase()) < 0 &&
                    (words[j] >= '0' && words[j] <= '9') == false ) {
                alphabet = alphabet.concat(words[j])
            }
        }
    }
    // sort the alphabet
    alphabet = GCompris.ApplicationInfo.localeSort(alphabet)
}

function sortNumber(a,b) {
    return a - b;
}

// generate a randomized array with "len" numbers
function getNumbers(len) {
    var numbers = []
    for (var i = 0; i < len; i++) {
        numbers[i] = i
    }
    numbers = Core.shuffle(numbers)

    return numbers
}

// generate an array with "noOfLetters" letters taken from "alphabet"
function makeSolution(alphabet, noOfLetters) {
    var solution = []
    var aux = getNumbers(alphabet.length)
    //"noOfLetters" numbers sorted of "alphabet.length" numbers shuffeled

    var generate = []
    for (var i = 0; i < noOfLetters; i++) {
        generate[i] = aux[i]
    }
    generate.sort(sortNumber)

    for (i = 0; i < noOfLetters; i++) {
        solution[i] = alphabet[generate[i]]
    }

    return solution
}

// check if the user's answer matches the solution
function checkCorectness() {
    var nr = solution.length

    //if the two do not have the same length -> false
    if (nr !== items.listModel.count)
        return false

    for (var i = 0; i < nr; i++)
        if  (solution[i] !== items.listModel.get(i).letter) {
            return false   // the letters are different at index i -> false
        }

    return true
}


// compute maximum width of the letters in the repeater given as parameter
function computeWidth(repeater) {
    if (repeater == null)
        return 0
    var max = -1
    for (var i = 0; i < repeater.count; i++) {
        if (max < repeater.itemAt(i).width)
            max = repeater.itemAt(i).width
    }
    return max * repeater.count
}


function nextLevel() {
    items.score.currentSubLevel = 1

    if(numberOfLevel <= ++currentLevel ) {
        currentLevel = 0
    }
    initLevel();
}

function nextSubLevel() {
    if (items.score.numberOfSubLevels >= ++items.score.currentSubLevel) {
        initLevel()
    } else {
        nextLevel()
    }
}
function previousLevel() {
    items.score.currentSubLevel = 1

    if(--currentLevel < 0) {
        currentLevel = numberOfLevel - 1
    }
    initLevel();
}

function playLetter(letter) {
    var locale = GCompris.ApplicationInfo.getVoicesLocale(items.locale)
    items.audioVoices.append(GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/"+locale+"/alphabet/"
                                                                       + Core.getSoundFilenamForChar(letter)))
}

function focusTextInput() {
    if (!GCompris.ApplicationInfo.isMobile && items && items.textinput)
        items.textinput.forceActiveFocus();
}
