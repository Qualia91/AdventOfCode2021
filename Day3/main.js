const fs = require('fs')

var fileData = fs.readFileSync('input.txt', 'utf8');

var lines = fileData.split('\n');

var binaryDigits = lines[0].length - 1;

var counters = [];
for (let index = 0; index < binaryDigits; index++) {
    counters[index] = 0;
}

lines.forEach(line => {
    for (let index = 0; index < binaryDigits; index++) {
        if (line.charAt(index) === "0") {
            counters[index] -= 1;
        } else {
            counters[index] += 1;
        }
    }
});

// Now work out the most and least common, and the value
var sumMost = 0;
var sumLeast = 0;
var bitVal = 1;
for (let index = binaryDigits - 1; index >= 0; index--) {
    if (counters[index] > 0) {
        sumMost += bitVal;
    } else {
        sumLeast += bitVal;
    }
    bitVal *= 2;
}

// Part 1 Answer
console.log("Part One Answer: " + (sumMost * sumLeast));


// Part 2

var oxygenList = lines.slice();
var co2List = lines.slice();

for (let index = 0; index < binaryDigits; index++) {

    // get the most and least common values for both lists
    if (oxygenList.length > 1) {
        var oxySwing = 0;
        oxygenList.forEach(line => {
            if (line.charAt(index) === "0") {
                oxySwing--;
            } else {
                oxySwing++;
            }
        });

        oxygenList = oxygenList.filter(oxyElem => {
            if (oxySwing < 0) {
                return oxyElem.charAt(index) === "0";
            }
            if (oxySwing >= 0) {
                return oxyElem.charAt(index) === "1";
            }
        });
    }

    if (co2List.length > 1) {
        var co2Swing = 0;
        co2List.forEach(line => {
            if (line.charAt(index) === "0") {
                co2Swing--;
            } else {
                co2Swing++;
            }
        });

        co2List = co2List.filter(co2Elem => {
            if (co2Swing < 0) {
                return co2Elem.charAt(index) === "1";
            }
            if (co2Swing >= 0) {
                return co2Elem.charAt(index) === "0";
            }
        });
    }
}

// to decimal conversion
function convertToDecimal(input) {
    var index = input.length;
    var sum = 0;
    var currentBinDig = 1;
    while (index--) {
        if (input.charAt(index) === "1") {
            sum += currentBinDig;
        };
        currentBinDig *= 2;
    }
    return sum;
};

// Part 2 Answer
console.log("Part Two Answer: " + (convertToDecimal(oxygenList[0].trim()) * convertToDecimal(co2List[0].trim())));