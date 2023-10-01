const filename = "./input.csv";
const fs = require("fs");
const { readFileSync } = require("fs");

function readFile(filename) {
  try {
    const contents = readFileSync(filename, "utf-8");

    const text = contents.split(/\r?\n/);

    let array = [];

    for (let i = 0; i < text.length - 1; i++) {
      let line = text[i].split(/[;\t]/);

      let row = [];
      for (let j = 0; j < line.length; j++) {
        row.push(line[j]);
      }

      array.push(row);
    }

    return array;
  } catch (err) {
    console.log(err);
  }
}

let jsonArray = readFile(filename);

fs.writeFile("output.json", JSON.stringify(jsonArray, null, 2), { flag: "w" }, function (err) {
  if (err) {
    return console.log(err);
  } else {
    console.log("The file was saved!");
  }
});
