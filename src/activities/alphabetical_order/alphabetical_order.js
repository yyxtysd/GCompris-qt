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
var numberOfLevel = 4
var items
var alphabet = []
var solution
var dataSetUrl= "qrc:/gcompris/src/activities/gletters/resource/"

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
    // ['a','b','c','d']
    solution = getSolution(alphabet, 5)

    // 3 1 5 2 4
    var numbers = getNumbers(5)

    // ['a','_','c','_']
    var model = solution.slice()
    
    // ['b', 'd']
    var modelAux = []
    for (var i = 0; i < 2; i++) {
        model[numbers[i]] = '_'
        modelAux[i] = solution[numbers[i]]
    }

    //debugging
//    print(solution)
//    print("numbers: ", numbers)
//    print("solution: ",solution)
//    print("model: ",model)
//    print("modelAux: ",modelAux)

    items.listModel.clear()
    items.listModel2.clear()

    for (i = 0; i < modelAux.length; i++) {
        items.listModel2.append({"letter": modelAux[i]})
    }

    for (i = 0; i < model.length; i++) {
        items.listModel.append({"letter": model[i]})
    }
}

//goes through each level (in gletters json files) and appends all letters
//  (removing digits and uppercase duplicates) in the alphabet
function createAlphabet() {
    // all levels
    for (var i = 1; i < items.wordlist.wordList.levels.length; i++) {
        var words = items.wordlist.getLevelWordList(i).words
        // se
        for (var j = 0; j < words.length; j++) {
            if (alphabet.indexOf(words[j].toLowerCase()) < 0 && (words[j] >= '0' && words[j] <= '9') == false ) {
                alphabet = alphabet.concat(words[j])
            }
        }
    }
    alphabet = GCompris.ApplicationInfo.localeSort(alphabet)
//    print("alphabet: ",alphabet)
}

function sortNumber(a,b) {
    return a - b;
}

function getNumbers(len) {
    var numbers = []
    for (var i = 0; i < len; i++) {
        numbers[i] = i
    }
    numbers = Core.shuffle(numbers)

    return numbers
}

function getSolution(alphabet, noOfLetters) {
    var solution = []
    var aux = getNumbers(alphabet.length)
    //"noOfLetters" numbers sorted of "alphabet.length" numbers shuffeled
//    print("generate", aux)

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

function getModel(alphabet, noOfLetters) {
    var model

    for (var i = 0; i < noOfLetters; i++) {

    }
    return model
}

/* Receives the model (what the player has to complete)
and the solution (how the result should look like)
and returns the missing letters from the model
(the letters from bottom, which the user will place on top) */
function missingLetters(model,solution) {
    var missingLetters = []
    for (var i=0; i<solution.length; i++) {
        var found = false
        for (var j = 0; j < model.length; j++)
            if (model[j] == solution[i]) {
                found = true
                break
            }

        if (!found)
            missingLetters[missingLetters.length] = solution[i]

    }
    return missingLetters
}

function checkCorectness() {
    var nr = solution.length

    //if the two do not have the same length -> false
    if (nr !== items.listModel.count)
        return false

    for (var i = 0; i < nr; i++)
        if  (solution[i]!==items.listModel.get(i).letter)
            return false   // the letters are different at index i -> false

    return true
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
