const fs = require('fs');
const cheerio = require('cheerio');
const html = fs.readFileSync('profile_debug.html', 'utf-8');
const $ = cheerio.load(html);

console.log("Looking for Name in Arabic...");
const regex = /الاسم باللغة العربية/;
$('*').each((i, el) => {
    if ($(el).children().length === 0 && regex.test($(el).text())) {
        console.log(`Found in tag: ${el.tagName}`);
        console.log(`Parent tag: ${el.parent.tagName}`);
        console.log(`Parent HTML: ${$(el.parent).html().trim().substring(0, 200)}`);
    }
});
