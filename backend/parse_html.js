const fs = require('fs');
const cheerio = require('cheerio');
const html = fs.readFileSync('dashboard_debug.html', 'utf-8');
const $ = cheerio.load(html);
$('div.row').each((i, el) => {
    const h5 = $(el).find('h5').text().trim();
    const p = $(el).find('p, span').text().trim();
    if(h5 && p) {
        console.log(`H5: ${h5} | P: ${p}`);
    }
});
