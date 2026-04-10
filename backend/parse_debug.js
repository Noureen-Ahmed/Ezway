const cheerio = require('cheerio');
const fs = require('fs');

try {
  const html = fs.readFileSync('ums_profile_debug.html', 'utf8');
  const $ = cheerio.load(html);

  let out = "=== FINDING NAME AND PHONE ===\n";
  
  $('*').each((i, el) => {
    // skip script/style tags
    if (el.tagName === 'script' || el.tagName === 'style' || el.tagName === 'html' || el.tagName === 'body' || el.tagName === 'head') return;
    
    // Only looking at text nodes of elements directly
    const text = $(el).clone().children().remove().end().text().trim();
    if (text.includes('نورين') || text.includes('0101')) {
      out += `\n--- MATCH IN <${el.tagName}> ---\n`;
      out += `Text: ${text}\n`;
      out += `Parent HTML: ${$(el).parent().html()?.substring(0, 300)}\n`;
    }
  });

  fs.writeFileSync('parse_output_utf8.txt', out, 'utf8');

  out += "\n=== KENDO DATA IN JS ===\n";
  const scripts = $('script').map((i, el) => $(el).html()).get();
  scripts.forEach(s => {
    if (s && s.includes('StudentName')) {
       out += s.substring(0, 500) + "\n";
    }
  });
  fs.writeFileSync('parse_output_utf8.txt', out, 'utf8');

} catch (e) {
  console.error("Error", e);
}
