/**
 * Quick test: parse the actual UMS profile HTML and see what fields come out.
 */
const fs = require('fs');
const cheerio = require('cheerio');

function labelToKey(label) {
  if (/القومي|رقم قومي|SSN/i.test(label))                          return 'studentId';
  if (/جواز|Passport/i.test(label))                                return 'passportNumber';
  if (/بالعربية|Arabic/i.test(label))                              return 'nameAr';
  if (/بالإنجليزية|English/i.test(label))                          return 'nameEn';
  if (/المستخدم|username/i.test(label))                            return 'nameAr';
  if (/الإلكتروني|email/i.test(label))                             return 'email';
  if (/الهاتف|تليفون|موبايل|Mobile|phone/i.test(label))           return 'phone';
  if (/الكلية|Faculty|كلية/i.test(label))                          return 'faculty';
  if (/القسم|Department|قسم/i.test(label))                         return 'department';
  if (/البرنامج|Program/i.test(label))                             return 'program';
  if (/اللائحة.*نوع|نوع.*اللائحة/i.test(label))                   return 'regulationType';
  if (/اللائحة/i.test(label))                                      return 'regulation';
  if (/العنوان|address/i.test(label))                              return 'address';
  if (/المستوى|Level/i.test(label))                                return 'level';
  if (/المعدل|GPA|معدل/i.test(label))                             return 'gpa';
  if (/الفصل|semester/i.test(label))                               return 'semester';
  if (/الأكاديمية|السنة|academicYear/i.test(label))                return 'academicYear';
  if (/الجنس|Gender/i.test(label))                                 return 'gender';
  return null;
}

function parseProfileHtml(html) {
  if (!html) return {};
  const $ = cheerio.load(html);
  const profile = {};

  const clean = (s) => s
    ? s.replace(/<[^>]*>/g, '').trim().replace(/\s{2,}/g, ' ')
    : null;

  const set = (key, val) => {
    if (!key || !val || profile[key]) return;
    const v = clean(val);
    if (v && v.length > 0) profile[key] = v;
  };

  // Strategy 1: div.row > h5 (label) + p or span (value)
  $('div.row').each((_, row) => {
    const h5 = $(row).find('> div > h5, > div > div > h5').first();
    const p  = $(row).find('> div > p, > div > div > p').first();
    const label = clean(h5.text());
    const value = clean(p.text());
    if (label && value) {
      const key = labelToKey(label);
      if (key) {
        console.log(`  ✅ Strategy 1: "${label}" → ${key} = "${value}"`);
        set(key, value);
      }
    }
  });

  // Strategy 2: dl > dt + dd
  $('dl').each((_, dl) => {
    $(dl).find('dt').each((_, dt) => {
      const label = clean($(dt).text());
      const value = clean($(dt).next('dd').text());
      if (label && value) {
        const key = labelToKey(label);
        if (key) {
          console.log(`  ✅ Strategy 2: "${label}" → ${key} = "${value}"`);
          set(key, value);
        }
      }
    });
  });

  // Convert level text to number
  if (profile.level) {
    const m = profile.level.match(/(\d+)/);
    if (m) profile.levelNum = parseInt(m[1], 10);
  }

  return profile;
}

// Load the actual debug HTML
const htmlFile = 'ums_profile_debug.html';
if (!fs.existsSync(htmlFile)) {
  console.error('❌ Debug HTML file not found:', htmlFile);
  process.exit(1);
}

const html = fs.readFileSync(htmlFile, 'utf-8');
console.log(`\nLoaded HTML: ${html.length} chars\n`);
console.log('=== Parsing with DIRECT children selector ===\n');

const profile = parseProfileHtml(html);

console.log('\n=== RESULT ===\n');
console.log(JSON.stringify(profile, null, 2));

console.log('\n=== KEY FIELDS ===');
console.log(`faculty:      ${profile.faculty || '❌ MISSING'}`);
console.log(`department:   ${profile.department || '❌ MISSING'}`);
console.log(`program:      ${profile.program || '❌ MISSING'}`);
console.log(`level:        ${profile.level || '❌ MISSING'}`);
console.log(`levelNum:     ${profile.levelNum || '❌ MISSING'}`);
console.log(`semester:     ${profile.semester || '❌ MISSING'}`);
console.log(`academicYear: ${profile.academicYear || '❌ MISSING'}`);
console.log(`studentId:    ${profile.studentId || '❌ MISSING'}`);
console.log(`email:        ${profile.email || '❌ MISSING'}`);
console.log(`phone:        ${profile.phone || '❌ MISSING'}`);
