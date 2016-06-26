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
var solution = []
var dataSetUrl= "qrc:/gcompris/src/activities/gletters/resource/"
var totalLetters = [3,4,5,5,6,6,6,7,8,8]
var guessLetters = [1,2,2,2,2,2,3,3,4,5]

function start(items_) {
    items = items_
    currentLevel = 0

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
    init()
}

function init() {
    items.gameFinished = false

    // ['a','b','c','d']
    solution = makeSolution(alphabet, totalLetters[currentLevel])

    // 3 1 4 2
    var numbers = getNumbers(totalLetters[currentLevel])

    // ['a','_','c','_']
    var model = solution.slice()
    
    // ['b', 'd']
    var modelAux = []
    for (var i = 0; i < guessLetters[currentLevel]; i++) {
        model[numbers[i]] = '_'
        modelAux[i] = solution[numbers[i]]
    }

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
        if  (solution[i] !== items.listModel.get(i).letter)
            return false   // the letters are different at index i -> false

    return true
}


// compute maximum width of the letters in the repeater given as parameter
function computeWidth(repeater) {
    if (repeater == null)
        return 0
    var max = -1
    for (var i = 0; i < repeater.count; i++) {
        if (max < repeater.itemAt(i).width && repeater.itemAt(i).text != '_')
            max = repeater.itemAt(i).width
    }
    return max * repeater.count
}


function nextLevel() {
    if(numberOfLevel <= ++currentLevel ) {
        currentLevel = 0
    }
    initLevel();
}

function previousLevel() {
    if(--currentLevel < 0) {
        currentLevel = numberOfLevel - 1
    }
    initLevel();
}

function focusTextInput() {
    if (!GCompris.ApplicationInfo.isMobile && items && items.textinput)
        items.textinput.forceActiveFocus();
}
