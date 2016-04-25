'use strict';

const fs = require('fs');
const path = require('path');

const _ = require('lodash');
const glob = require('glob');

const args = process.argv.slice(2);
if (args.length < 3) {
    console.log('Usage: node rename_objc_prefix.js <globs> <old> <new>');
    return;
}

glob(args[0], (err, files) => {
    if (err) throw err;

    _.each(files, (name) => {
        processFile(name, args[1], args[2]);
    });
    console.log('...done!');
});

function processFile(name, p1, p2) {
    let k1 = path.parse(name).name;
    let k2 = replacePrefix(k1, p1, p2);
    fs.readFile(name, (err, data) => {
        if (err) throw err;

        let content = replacePrefix(data.toString(), k1, k2);
        console.log(`${k1} => ${k2}`);
        fs.writeFile(replacePrefix(name, p1, p2), content);
    });
}

function replacePrefix(str, p1, p2) {
    return str.replace(new RegExp(`([^/]*/)?${p1}`, 'g'), p2);
}
