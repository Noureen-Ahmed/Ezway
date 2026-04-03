const fs = require('fs');
const html = fs.readFileSync('profile_debug.html', 'utf-8');
const cheerio = require('cheerio');
const $ = cheerio.load(html);

const results = [];
$('div.row').each((i, row) => {
    const h5 = $(row).find('h5');
    const val_el = $(row).find('p').length ? $(row).find('p') : $(row).find('span');
    if (h5.length && val_el.length) {
        results.push({
            h5: h5.text().trim(),
            val: val_el.text().trim()
        });
    }
});
console.log(JSON.stringify(results, null, 2));
