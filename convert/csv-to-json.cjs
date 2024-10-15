const filename = "./input.csv";
const fs = require("node:fs");
const { readFileSync } = require("node:fs");

function readFile(filename) {
  try {
    const contents = readFileSync(filename, "utf-8");

    const text = contents.split(/\r?\n/);

    const array = [];

    for (let i = 0; i < text.length - 1; i++) {
      const line = text[i].split(/[;\t]/);

      const row = [];
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

const jsonArray = readFile(filename);

fs.writeFile(
  "output.json",
  JSON.stringify(jsonArray, null, 2),
  { flag: "w" },
  (err) => {
    if (err) {
      return console.log(err);
    }

    console.log("The file was saved!");
  }
);
