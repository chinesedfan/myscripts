#!/usr/bin/env node

'use strict';

const fs = require('fs');
const path = require('path');

const _ = require('lodash');
const glob = require('glob');

const args = process.argv.slice(2);
if (args.length < 3) {
    console.log('Usage: node rename_objc_prefix.js <globs> <old> <new> [output]');
    return;
}
args[3] = args[3] || '.'; // output to cwd by default

glob(args[0], (err, files) => {
    if (err) throw err;

    _.each(files, (name) => {
        processFile(name, args[1], args[2]);
    });
    console.log('...done!');
});

function processFile(name, p1, p2) {
    let obj = path.parse(name);
    if (!obj) {
        throw new Error(`failed to parse ${name}`);
    }

    let k1 = obj.name;
    let k2 = k1.replace(new RegExp(`^${p1}`), p2);

    fs.readFile(name, (err, data) => {
        if (err) throw err;

        let content = data.toString().replace(new RegExp(`${k1}`, 'g'), k2);
        console.log(`${k1} => ${k2}`);
        let name2 = path.join(args[3], k2 + obj.ext);
        console.log(`writing to ${name2}...`);
        fs.writeFile(name2, content, (err2) => {
            if (err2) throw err2;
        });
    });
}
