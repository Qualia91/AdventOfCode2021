const fs = require('fs')

var fileData = fs.readFileSync('input.txt', 'utf8');

var lines = fileData.split('\n');

var binaryDigits = lines[0].length - 1;

var counters = [];
var bitValues = [];
var currentBitCounter = 1;
for (let index = 0; index < binaryDigits; index++) {
    counters.push([0, 0]);
    bitValues.push(currentBitCounter);
    currentBitCounter *= 2;
}
bitValues.reverse();

lines.forEach(line => {
    for (let index = 0; index < binaryDigits; index++) {
        if (line.charAt(index) === "0") {
            counters[index][0] += 1;
        } else {
            counters[index][1] += 1;
        }
    }
});

// Now work out most and least common
var sumMost = 0;
var sumLeast = 0;
for (let index = 0; index < binaryDigits; index++) {

    if (counters[index][0] <= counters[index][1]) {
        sumMost += bitValues[index]  
    } else {
        sumLeast += bitValues[index]  
    }
}

// Part 1 answers
console.log("Most Sum: " + sumMost);
console.log("Least Sum: " + sumLeast);
console.log("Answer: " + sumMost * sumLeast);

// Part 2 -
//  iterate over binary digits
//  iterate over lines (Oxygen and Co2)
//  get most and least common
//  update lines list with only survivors of checks


var oxygenList = lines.slice();
var co2List = lines.slice();
for (let index = 0; index < binaryDigits; index++) {

    // Get most and least common values of this binary digit for both lists
    if (oxygenList.length > 1) {
        var oxySwing = 0;
        oxygenList.forEach(line => {
            if (line.charAt(index) === "0") {
                oxySwing--;
            } else {
                oxySwing++;
            }
        });
        oxygenList = oxygenList.filter((oxyElem) => {
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
        co2List = co2List.filter((co2Elem) => {
            if (co2Swing < 0) {
                return co2Elem.charAt(index) === "1";
            }
            if (co2Swing >= 0) {
                return co2Elem.charAt(index) === "0";
            }
        });
    }

}

// convert to decimal
function convertBinaryToDecimal(inputBinary) {
    var index = inputBinary.length;
    var sum = 0;
    var currentBinDig = 1;
    while (index--) {
        if (inputBinary.charAt(index) === "1") {
            sum += currentBinDig;
        }
        currentBinDig *= 2;
    }
    return sum;
}

console.log("Part 2");
var binOxy = oxygenList[0].trim();
var binCo2 = co2List[0].trim();
var decOxy = convertBinaryToDecimal(binOxy);
var decCo2 = convertBinaryToDecimal(binCo2);
console.log("Oxygen binary: " + binOxy);
console.log("Oxygen Decimal: " + decOxy);
console.log("Co2 binary: " + binCo2);
console.log("Co2 Decimal: " + decOxy);
console.log("Combination: " + (decOxy * decCo2));
