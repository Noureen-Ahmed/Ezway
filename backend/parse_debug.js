const fs = require('fs');
const cheerio = require('cheerio');
const html = fs.readFileSync('ums_profile_debug.html', 'utf8');
const $ = cheerio.load(html);

let out = "=== HTML CONTEXT AROUND LABELS ===\n";
const searchTerms = ['اسم الكلية', 'المستوى', 'البرنامج', 'القومي', 'تليفون', 'العنوان'];

for (const term of searchTerms) {
  let idx = html.indexOf(term);
  if (idx !== -1) {
    out += `\n--- Context for: ${term} ---\n`;
    out += html.substring(Math.max(0, idx - 50), idx + 500).replace(/\r\n/g, '\n') + "\n";
  }
}

out += "\n=== EXTRACTING INPUTS ===\n";
$('input[type="text"]').each((i, el) => {
  out += `Input: id=${$(el).attr('id')} name=${$(el).attr('name')} value='${$(el).val()}' placeholder='${$(el).attr('placeholder')}'\n`;
});

fs.writeFileSync('parse_output_utf8.txt', out, 'utf8');
