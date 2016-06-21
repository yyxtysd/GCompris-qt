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
.import "qrc:/gcompris/src/core/core.js" as Core

var currentLevel = 0
var numberOfLevel = 4
var items
var alphabet = ['a','b','c','d','e','f','g','h','i',
                'j','k','l','m','n','o','p','q','r',
                's','t','u','v','w','x','y','z']
var solution

function start(items_) {
    items = items_
    currentLevel = 0
    initLevel()
}

function stop() {
}

function initLevel() {
    items.bar.level = currentLevel + 1
    init()
}

function init() {


    print("localeee: ", items.locale)
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
