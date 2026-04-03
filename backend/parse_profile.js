const fs = require('fs');
const cheerio = require('cheerio');
const html = fs.readFileSync('profile_debug.html', 'utf-8');
const $ = cheerio.load(html);

// Dump all h5 texts to see how labels match
$('h5').each((i, el) => {
    const text = $(el).text().trim();
    // find nearest p or span in the same row
    const row = $(el).closest('.row');
    const p = row.length ? row.find('p').first().text().trim() : '';
    const span = row.length ? row.find('span').not('.sort-icon').first().text().trim() : '';
    console.log(`[H5] ${text} -> [P] ${p} | [SPAN] ${span}`);
});
