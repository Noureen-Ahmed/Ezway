const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

const batch1 = [
  { "Day": "السبت", "Lesson/Type": "محاضرة", "Course Code": "MATH 402", "Hours": "3", "Time": "8-11", "Course Name": "الجبر المجرد 2 (الحلقات والحقول)", "Location": "فصل 228ب" },
  { "Day": "السبت", "Lesson/Type": "محاضرة", "Course Code": "MATH 404", "Hours": "3", "Time": "2-5", "Course Name": "المعادلات التفاضلية الجزئيئة", "Location": "فصل 228ب" },
  { "Day": "الأحد", "Lesson/Type": "محاضرة خ", "Course Code": "MATH 432", "Hours": "2", "Time": "11-1", "Course Name": "الضوء الكمى", "Location": "القسم" },
  { "Day": "الأحد", "Lesson/Type": "تمارين", "Course Code": "MATH 416", "Hours": "2", "Time": "2-4", "Course Name": "مشروع بحثى", "Location": "القسم" },
  { "Day": "الاثنين", "Lesson/Type": "محاضرة", "Course Code": "MATH 412", "Hours": "3", "Time": "8-11", "Course Name": "المكيانيكية الإحصائية", "Location": "القسم" },
  { "Day": "الاثنين", "Lesson/Type": "محاضرة خ", "Course Code": "MATH 434", "Hours": "2", "Time": "11-1", "Course Name": "ميكانيكا الكم النسبية", "Location": "القسم" },
  { "Day": "الاثنين", "Lesson/Type": "محاضرة خ", "Course Code": "MATH 418", "Hours": "2", "Time": "2-4", "Course Name": "كوزمولوجى", "Location": "قاعة 104" },
  { "Day": "الثلاثاء", "Lesson/Type": "محاضرة", "Course Code": "MATH 414", "Hours": "3", "Time": "8-11", "Course Name": "المكانيكا الفضائية", "Location": "القسم" },
  { "Day": "السبت", "Lesson/Type": "تمارين", "Course Code": "COMP418", "Hours": "2", "Time": "8-10", "Course Name": "مشروع حاسب", "Location": "القسم" },
  { "Day": "السبت", "Lesson/Type": "محاضرة خ", "Course Code": "STAT412", "Hours": "2", "Time": "10-12", "Course Name": "نظرية الطوابير", "Location": "قاعة 2" },
  { "Day": "الأحد", "Lesson/Type": "محاضرة", "Course Code": "COMP402", "Hours": "3", "Time": "8-11", "Course Name": "المعلوماتية الحيوية", "Location": "مدرج حماد" },
  { "Day": "الاثنين", "Lesson/Type": "تمارين", "Course Code": "STAT424", "Hours": "2", "Time": "8-10", "Course Name": "مشروع بحثى فى الإحصاء", "Location": "القسم" },
  { "Day": "الاثنين", "Lesson/Type": "معمل", "Course Code": "--", "Hours": "2", "Time": "10-12", "Course Name": "مشروع إحصاء", "Location": "القسم" },
  { "Day": "الاثنين", "Lesson/Type": "معمل", "Course Code": "--", "Hours": "4", "Time": "1-5", "Course Name": "حاسب", "Location": "القسم" },
  { "Day": "الثلاثاء", "Lesson/Type": "محاضرة خ", "Course Code": "COMP416", "Hours": "3", "Time": "2-5", "Course Name": "إستخلاص البيانات والويب", "Location": "نوح" },
  { "Day": "الخميس", "Lesson/Type": "محاضرة", "Course Code": "STAT418", "Hours": "2", "Time": "11-1", "Course Name": "عمليات عشوائية (2)", "Location": "فصل 7" },
  { "Day": "الخميس", "Lesson/Type": "محاضرة", "Course Code": "STAT408", "Hours": "3", "Time": "1-4", "Course Name": "سلاسل زمنية", "Location": "فصل 7" },
  { "Day": "السبت", "Lesson/Type": "محاضرة", "Course Code": "COMP408", "Hours": "3", "Time": "8-11", "Course Name": "موضوعات متقدمة فى الذكاء الإصطناعى", "Location": "قاعة (5)" },
  { "Day": "السبت", "Lesson/Type": "محاضرة", "Course Code": "COMP404", "Hours": "2", "Time": "12-2", "Course Name": "هندسة البرمجيات", "Location": "قاعة (3)" },
  { "Day": "الأحد", "Lesson/Type": "معمل", "Course Code": "COMP406", "Hours": "4", "Time": "12-4", "Course Name": "حاسب (مشروع)", "Location": "القسم" },
  { "Day": "الأربعاء", "Lesson/Type": "معمل", "Course Code": "--", "Hours": "2", "Time": "8-10", "Course Name": "حاسب", "Location": "القسم" },
  { "Day": "الخميس", "Lesson/Type": "تمارين", "Course Code": "--", "Hours": "4", "Time": "12-4", "Course Name": "حاسب (مشروع)", "Location": "القسم" },
  { "Day": "الإثنين", "Lesson/Type": "محاضرة", "Course Code": "BIOP442", "Hours": "2", "Time": "8-10", "Course Name": "تقنيات الأغشية البيولوجية الرقيقة", "Location": "قاعة 1" },
  { "Day": "الإثنين", "Lesson/Type": "عملى", "Course Code": "--", "Hours": "3", "Time": "11-2", "Course Name": "فيزياءحيوية", "Location": "القسم" },
  { "Day": "الإثنين", "Lesson/Type": "محاضرة", "Course Code": "BIOC 422 - E", "Hours": "2", "Time": "3-5", "Course Name": "بيولوجيا الأورام", "Location": "فصل (228ب)" },
  { "Day": "الأربعاء", "Lesson/Type": "محاضرة", "Course Code": "BIOP402", "Hours": "2", "Time": "8-10", "Course Name": "أساسيات الرنين المغناطيسى والتصوير الطبى", "Location": "فصل أ228" },
  { "Day": "الأربعاء", "Lesson/Type": "محاضرة خ", "Course Code": "BIOP472", "Hours": "2", "Time": "10-12", "Course Name": "إتصال وتحكم", "Location": "القسم" },
  { "Day": "الأربعاء", "Lesson/Type": "محاضرة", "Course Code": "BIOP422", "Hours": "2", "Time": "1-3", "Course Name": "إستخدام أشعة أكس لإيجاد وتركيب الجزيئيات البيولوجية الكبيرة", "Location": "فصل أ228" },
  { "Day": "الخميس", "Lesson/Type": "محاضرة", "Course Code": "BIOP432", "Hours": "2", "Time": "8-10", "Course Name": "مواد حيوية بديلة وأجهزة تعويضية", "Location": "فصل (228ب)" },
  { "Day": "الخميس", "Lesson/Type": "محاضرة خ", "Course Code": "BIOP482", "Hours": "2", "Time": "11-1", "Course Name": "نمذجة حيوية ومحاكاة", "Location": "القسم" },
  { "Day": "الخميس", "Lesson/Type": "محاضرة", "Course Code": "BIOP452", "Hours": "2", "Time": "1-3", "Course Name": "إلكترونيات الأنظمة الحيوية", "Location": "فصل أ228" },
  { "Day": "السبت", "Lesson/Type": "عملى", "Course Code": "PHYS 458", "Hours": "4", "Time": "8-12", "Course Name": "فيزياء تجريبية", "Location": "القسم" },
  { "Day": "السبت", "Lesson/Type": "محاضرة خ", "Course Code": "PHYS 474", "Hours": "2", "Time": "1-3", "Course Name": "أساسيات علم البلورات و تطبيقاتها", "Location": "قاعة 5" },
  { "Day": "الأحد", "Lesson/Type": "محاضرة", "Course Code": "CHEM 460", "Hours": "3", "Time": "8-11", "Course Name": "كيمياء عضوية متجانسة", "Location": "مدرج حجازى" },
  { "Day": "الأحد", "Lesson/Type": "عملى", "Course Code": "--", "Hours": "3", "Time": "11-2", "Course Name": "كيمياء فيزيائية", "Location": "القسم" },
  { "Day": "الأحد", "Lesson/Type": "عملى", "Course Code": "PHYS438", "Hours": "4", "Time": "8-12", "Course Name": "فيزياء تجريبية", "Location": "القسم" },
  { "Day": "الأحد", "Lesson/Type": "محاضرة", "Course Code": "PHYS 476", "Hours": "3", "Time": "12-3", "Course Name": "فيزياء حسابية متقدم", "Location": "قاعة 1" },
  { "Day": "الأحد", "Lesson/Type": "تمارين", "Course Code": "--", "Hours": "1", "Time": "3-4", "Course Name": "ت. فيزياء", "Location": "القسم" },
  { "Day": "الإثنين", "Lesson/Type": "محاضرة", "Course Code": "PHYS468", "Hours": "2", "Time": "8-10", "Course Name": "خواص كهربية وضوئية ومغناطيسية", "Location": "قاعة (6)" },
  { "Day": "الإثنين", "Lesson/Type": "محاضرة", "Course Code": "PHYS470", "Hours": "2", "Time": "10-12", "Course Name": "نبائط أشباه موصلات وتطبيقاتها", "Location": "قاعة (6)" },
  { "Day": "الأربعاء", "Lesson/Type": "تمارين", "Course Code": "COMP418", "Hours": "2", "Time": "8-10", "Course Name": "مشروع حاسب", "Location": "القسم" },
  { "Day": "الخميس", "Lesson/Type": "عملى", "Course Code": "COMP418", "Hours": "4", "Time": "12-4", "Course Name": "حاسب (مشروع)", "Location": "القسم" },
  { "Day": "السبت", "Lesson/Type": "محاضرة خ", "Course Code": "CHEM 410", "Hours": "1", "Time": "2-3", "Course Name": "اعادة تدوير المخلفات", "Location": "نوح" },
  { "Day": "الأحد", "Lesson/Type": "عملى", "Course Code": "CHEM 444", "Hours": "3", "Time": "8-11", "Course Name": "كيمياء فيزيائية عملى متقدم", "Location": "القسم" },
  { "Day": "الأحد", "Lesson/Type": "عملى", "Course Code": "--", "Hours": "2", "Time": "12-2", "Course Name": "تطبيقات على الحاسب", "Location": "القسم" },
  { "Day": "الإثنين", "Lesson/Type": "عملى", "Course Code": "--", "Hours": "3", "Time": "8-11", "Course Name": "كيمياء عضوية", "Location": "القسم" },
  { "Day": "الإثنين", "Lesson/Type": "عملى", "Course Code": "CHEM 414", "Hours": "3", "Time": "11-2", "Course Name": "(5 كيمياء عضوية عملى)", "Location": "القسم" },
  { "Day": "الإثنين", "Lesson/Type": "محاضرة", "Course Code": "CHEM 428", "Hours": "2", "Time": "3-5", "Course Name": "كيمياء ضوئيه غير عضوية", "Location": "حجازى" },
  { "Day": "الثلاثاء", "Lesson/Type": "محاضرة", "Course Code": "CHEM 412", "Hours": "2", "Time": "10-12", "Course Name": "منتجات طبيعية", "Location": "نوح" },
  { "Day": "الثلاثاء", "Lesson/Type": "محاضرة خ", "Course Code": "CHEM 424", "Hours": "2", "Time": "2-4", "Course Name": "كيمياء ضوئية غير عضوية", "Location": "حجازى" },
  { "Day": "الثلاثاء", "Lesson/Type": "محاضرة", "Course Code": "CHEM 432", "Hours": "1", "Time": "4-5", "Course Name": "كيمياء تحليلية 4 طرق الفصل (1)", "Location": "حجازى" },
  { "Day": "الأربعاء", "Lesson/Type": "محاضرة", "Course Code": "CHEM 422", "Hours": "2", "Time": "8-10", "Course Name": "كيمياء غير عضوية 6 (نظرية المجموعات + طيفية)", "Location": "أ.د. انتصارات" },
  { "Day": "السبت", "Lesson/Type": "محاضرة", "Course Code": "APCH 442", "Hours": "2", "Time": "8-10", "Course Name": "كيمياء فيزيائية تطبيقية 4 (كيمياء صناعية وتآكل)", "Location": "فصل ب225" },
  { "Day": "السبت", "Lesson/Type": "محاضرة", "Course Code": "APCH 444", "Hours": "2", "Time": "11-1", "Course Name": "كيمياء فيزيائية تطبيقية 5 (كيمياء الأسمنت علم المواد)", "Location": "فصل ب225" },
  { "Day": "السبت", "Lesson/Type": "محاضرة خ", "Course Code": "CHEM 416", "Hours": "1", "Time": "2-3", "Course Name": "كيمياء النسيج", "Location": "نوح" },
  { "Day": "الإثنين", "Lesson/Type": "محاضرة", "Course Code": "APCH 412", "Hours": "1", "Time": "8-9", "Course Name": "كيمياء عضوية تطبيقية صناعة المطاط", "Location": "فصل ب225" },
  { "Day": "الإثنين", "Lesson/Type": "محاضرة", "Course Code": "APCH 416", "Hours": "1", "Time": "10-11", "Course Name": "بلمرات عضوية", "Location": "فصل أ225" },
  { "Day": "الإثنين", "Lesson/Type": "عملى", "Course Code": "APCH 446", "Hours": "3", "Time": "11-2", "Course Name": "كيمياء فيزيائية تطبيقية", "Location": "القسم" },
  { "Day": "الإثنين", "Lesson/Type": "محاضرة", "Course Code": "APCH 424", "Hours": "2", "Time": "3-5", "Course Name": "كيمياء صناعبه 2", "Location": "حجازى" },
  { "Day": "الثلاثاء", "Lesson/Type": "عملى", "Course Code": "APCH 414", "Hours": "3", "Time": "8-11", "Course Name": "كيمياء (4 عضوية تطبيقية)", "Location": "القسم" },
  { "Day": "الأحد", "Lesson/Type": "محاضرة", "Course Code": "BOTA402", "Hours": "2", "Time": "8-10", "Course Name": "أيض وطاقة أحيائية", "Location": "القسم" },
  { "Day": "الأحد", "Lesson/Type": "محاضرة", "Course Code": "BOTA404", "Hours": "2", "Time": "10-12", "Course Name": "فلورة النباتات الزهرية فلورة حزازية", "Location": "القسم" },
  { "Day": "الأحد", "Lesson/Type": "عملى", "Course Code": "--", "Hours": "3", "Time": "1-4", "Course Name": "نبات", "Location": "القسم" },
  { "Day": "الإثنين", "Lesson/Type": "محاضرة", "Course Code": "BOTA408", "Hours": "1", "Time": "8-9", "Course Name": "هندسة وراثية", "Location": "القسم" },
  { "Day": "الإثنين", "Lesson/Type": "محاضرة", "Course Code": "BOTA406", "Hours": "1", "Time": "9-10", "Course Name": "تطبيقات علم البيئة", "Location": "القسم" },
  { "Day": "الإثنين", "Lesson/Type": "عملى", "Course Code": "BOTA410", "Hours": "3", "Time": "11-2", "Course Name": "مشروع بحثى", "Location": "القسم" },
  { "Day": "الإثنين", "Lesson/Type": "عملى", "Course Code": "--", "Hours": "2", "Time": "3-5", "Course Name": "نباتات", "Location": "القسم" },
  { "Day": "الثلاثاء", "Lesson/Type": "محاضرة", "Course Code": "BOTA412", "Hours": "1", "Time": "8-9", "Course Name": "علم الأجنة", "Location": "القسم" },
  { "Day": "الثلاثاء", "Lesson/Type": "محاضرة خ", "Course Code": "BOTA420", "Hours": "2", "Time": "9-11", "Course Name": "نماذج المحاكاة للجزيئيات الكبيرة", "Location": "القسم" },
  { "Day": "الثلاثاء", "Lesson/Type": "محاضرة خ", "Course Code": "BOTA414", "Hours": "1", "Time": "11-12", "Course Name": "إدارة الحياة البرية", "Location": "القسم" },
  { "Day": "الثلاثاء", "Lesson/Type": "عملى", "Course Code": "--", "Hours": "4", "Time": "1-5", "Course Name": "نبات", "Location": "القسم" },
  { "Day": "الأربعاء", "Lesson/Type": "محاضرة خ", "Course Code": "BOTA416", "Hours": "1", "Time": "8-9", "Course Name": "النواحى التطبيقية للأرشيجونيات", "Location": "القسم" },
  { "Day": "الأربعاء", "Lesson/Type": "محاضرة خ", "Course Code": "BOTA418", "Hours": "1", "Time": "9-10", "Course Name": "أيض المنتجات النباتية الثانوية", "Location": "القسم" },
  { "Day": "الأربعاء", "Lesson/Type": "عملى", "Course Code": "--", "Hours": "3", "Time": "11-2", "Course Name": "نبات", "Location": "القسم" },
  { "Day": "الخميس", "Lesson/Type": "عملى", "Course Code": "--", "Hours": "2", "Time": "8-10", "Course Name": "نبات", "Location": "القسم" },
  { "Day": "الخميس", "Lesson/Type": "عملى", "Course Code": "--", "Hours": "2", "Time": "10-12", "Course Name": "نبات", "Location": "القسم" },
  { "Day": "السبت", "Lesson/Type": "محاضرة", "Course Code": "BOTA426", "Hours": "1", "Time": "8-9", "Course Name": "تقنيات تضاعف الحمض النووى", "Location": "قاعة (104)" },
  { "Day": "السبت", "Lesson/Type": "محاضرة", "Course Code": "BOTA424", "Hours": "2", "Time": "10-12", "Course Name": "فلورا نباتات عقاقير طبية (تصنيف كيميائى)", "Location": "قاعة (104)" },
  { "Day": "السبت", "Lesson/Type": "عملى", "Course Code": "--", "Hours": "3", "Time": "12-3", "Course Name": "نبات", "Location": "القسم" },
  { "Day": "السبت", "Lesson/Type": "عملى", "Course Code": "--", "Hours": "2", "Time": "3-5", "Course Name": "نبات", "Location": "القسم" },
  { "Day": "الإثنين", "Lesson/Type": "محاضرة", "Course Code": "CHEM460", "Hours": "3", "Time": "8-11", "Course Name": "كيمياء عضوية (غير متجانسة +قلويدات)", "Location": "مدرج حجازى" },
  { "Day": "الإثنين", "Lesson/Type": "محاضرة", "Course Code": "CHEM 490", "Hours": "1", "Time": "11-12", "Course Name": "كيمياءفيزيائية (كيمياء ضوئية)", "Location": "مدرج حجازى" },
  { "Day": "الإثنين", "Lesson/Type": "عملى", "Course Code": "BOTA 434 - E", "Hours": "2", "Time": "12-2", "Course Name": "تطبيقات زراعة الأنسجة فى مقاومة الإجهاد", "Location": "القسم" },
  { "Day": "الإثنين", "Lesson/Type": "عملى", "Course Code": "--", "Hours": "3", "Time": "2-5", "Course Name": "كيمياء عضوية", "Location": "القسم" },
  { "Day": "الثلاثاء", "Lesson/Type": "عملى", "Course Code": "--", "Hours": "2", "Time": "8-10", "Course Name": "نبات", "Location": "القسم" },
  { "Day": "الثلاثاء", "Lesson/Type": "محاضرة خ", "Course Code": "BOTA 434 - E", "Hours": "1", "Time": "10-11", "Course Name": "تطبيقات زراعة الأنسجة فى مقاومة الإجهاد", "Location": "قاعة 1" },
  { "Day": "الثلاثاء", "Lesson/Type": "محاضرة", "Course Code": "CHEM470", "Hours": "1", "Time": "11-12", "Course Name": "كيمياء غير عضوية (سلاسل المتراكبات)", "Location": "مدرج حماد" },
  { "Day": "الثلاثاء", "Lesson/Type": "محاضرة خ", "Course Code": "BOTA430", "Hours": "1", "Time": "1-2", "Course Name": "الأيض الثانوى فى النبات", "Location": "قاعة 1" },
  { "Day": "الأربعاء", "Lesson/Type": "محاضرة", "Course Code": "BOTA422", "Hours": "2", "Time": "8-10", "Course Name": "أيض النبات", "Location": "قاعة ب" },
  { "Day": "الأربعاء", "Lesson/Type": "محاضرة خ", "Course Code": "BOTA 432", "Hours": "1", "Time": "10-11", "Course Name": "تطبيقات التكنولوجيا الحيوية فى الطحالب", "Location": "قاعة ب" },
  { "Day": "الأربعاء", "Lesson/Type": "محاضرة خ", "Course Code": "CHEM492", "Hours": "2", "Time": "11-1", "Course Name": "كيمياء فيزيائية كيمياء", "Location": "قاعة ب" },
  { "Day": "السبت", "Lesson/Type": "عملى", "Course Code": "--", "Hours": "3", "Time": "8-11", "Course Name": "كيمياء عضوية (1)", "Location": "القسم" },
  { "Day": "السبت", "Lesson/Type": "عملى", "Course Code": "--", "Hours": "3", "Time": "11-2", "Course Name": "كيمياء عضوية (2)", "Location": "القسم" },
  { "Day": "الأحد", "Lesson/Type": "عملى", "Course Code": "--", "Hours": "3", "Time": "8-11", "Course Name": "علم الحيوان (1+2)", "Location": "القسم" },
  { "Day": "الأحد", "Lesson/Type": "عملى", "Course Code": "--", "Hours": "3", "Time": "8-11", "Course Name": "علم الحيوان (3+4)", "Location": "القسم" },
  { "Day": "الأحد", "Lesson/Type": "محاضرة", "Course Code": "ZOOL406", "Hours": "1", "Time": "11-12", "Course Name": "علم الأنسجة", "Location": "قاعة (أ)" },
  { "Day": "الأحد", "Lesson/Type": "محاضرة", "Course Code": "ZOOL416", "Hours": "1", "Time": "12-1", "Course Name": "سلوك الحيوان", "Location": "قاعة (أ)" },
  { "Day": "الأحد", "Lesson/Type": "محاضرة", "Course Code": "ZOOL430", "Hours": "1", "Time": "1-2", "Course Name": "مقدمة فى علم الأوليات", "Location": "قاعة (أ)" },
  { "Day": "الأحد", "Lesson/Type": "عملى", "Course Code": "--", "Hours": "3", "Time": "2-5", "Course Name": "كيمياء فيزيائية (1+2)", "Location": "القسم" },
  { "Day": "الإثنين", "Lesson/Type": "محاضرة", "Course Code": "CHEM460", "Hours": "3", "Time": "8-11", "Course Name": "كيمياء عضوية (غير متجانسة +قلويدات)", "Location": "حجازى" },
  { "Day": "الإثنين", "Lesson/Type": "محاضرة", "Course Code": "CHEM490", "Hours": "1", "Time": "11-12", "Course Name": "كيمياءفيزيائية (كيمياء ضوئية)", "Location": "حجازى" },
  { "Day": "الإثنين", "Lesson/Type": "عملى", "Course Code": "--", "Hours": "2", "Time": "12-2", "Course Name": "حيوان (3+4)", "Location": "القسم" },
  { "Day": "الإثنين", "Lesson/Type": "عملى", "Course Code": "--", "Hours": "2", "Time": "4-6", "Course Name": "حيوان (1+2)", "Location": "القسم" },
  { "Day": "الثلاثاء", "Lesson/Type": "عملى", "Course Code": "--", "Hours": "2", "Time": "8-10", "Course Name": "حيوان", "Location": "القسم" },
  { "Day": "الثلاثاء", "Lesson/Type": "محاضرة خ", "Course Code": "ZOOL424", "Hours": "1", "Time": "10-11", "Course Name": "أساسيات علم التشريح المقارن", "Location": "قاعة (5)" },
  { "Day": "الثلاثاء", "Lesson/Type": "محاضرة", "Course Code": "CHEM470", "Hours": "1", "Time": "11-12", "Course Name": "كيمياء غير عضوية (سلاسل المتراكبات)", "Location": "مدرج حماد" },
  { "Day": "الثلاثاء", "Lesson/Type": "عملى", "Course Code": "--", "Hours": "3", "Time": "12-3", "Course Name": "علم الحيوان (3+4)", "Location": "القسم" },
  { "Day": "الثلاثاء", "Lesson/Type": "عملى", "Course Code": "--", "Hours": "2", "Time": "4-6", "Course Name": "حيوان (1+2)", "Location": "القسم" },
  { "Day": "الأحد", "Lesson/Type": "عملى", "Course Code": "--", "Hours": "3", "Time": "11-2", "Course Name": "كيمياء فيزيائية", "Location": "القسم" },
  { "Day": "الأحد", "Lesson/Type": "عملى", "Course Code": "CHEM 460-P", "Hours": "3", "Time": "2-5", "Course Name": "كيمياء عضوية", "Location": "القسم" },
  { "Day": "الاثنين", "Lesson/Type": "محاضرة خ", "Course Code": "ENTM 424", "Hours": "2", "Time": "8-10", "Course Name": "اسس التصنيف العددي", "Location": "قاعة 3" },
  { "Day": "الاثنين", "Lesson/Type": "محاضرة خ", "Course Code": "ENTM410", "Hours": "1", "Time": "11-12", "Course Name": "تخطيط برامج إدارة الآفات", "Location": "فصل (أ225)" },
  { "Day": "الثلاثاء", "Lesson/Type": "عملى", "Course Code": "--", "Hours": "4", "Time": "8-12", "Course Name": "حشرات", "Location": "القسم" },
  { "Day": "الثلاثاء", "Lesson/Type": "محاضرة خ", "Course Code": "ENTM416", "Hours": "1", "Time": "12-1", "Course Name": "الغدد واالفرازات في الحشرات", "Location": "فصل (أ424)" },
  { "Day": "الثلاثاء", "Lesson/Type": "محاضرة", "Course Code": "ENTM422", "Hours": "1", "Time": "2-3", "Course Name": "مفاهيم المكافحة المتكاملة", "Location": "فصل (أ424)" },
  { "Day": "الأربعاء", "Lesson/Type": "محاضرة", "Course Code": "ENTM420", "Hours": "3", "Time": "8-11", "Course Name": "مبيدات الآفات الحشرية والمقاومة", "Location": "قاعة 4" },
  { "Day": "الأربعاء", "Lesson/Type": "محاضرة خ", "Course Code": "CHEM492", "Hours": "2", "Time": "11-1", "Course Name": "كيمياء فيزيائية كيمياء السطوح (2)", "Location": "مدرج حجازى" },
  { "Day": "الأربعاء", "Lesson/Type": "محاضرة خ", "Course Code": "CHEM462", "Hours": "2", "Time": "3-5", "Course Name": "كيمياء عضوية (ضوئية + لبيدات)", "Location": "قاعة ج" },
  { "Day": "الخميس", "Lesson/Type": "محاضرة", "Course Code": "CHEM490", "Hours": "1", "Time": "8-9", "Course Name": "كيمياء فيزيائية (كيمياء ضوئية)", "Location": "مدرج نوح" },
  { "Day": "الخميس", "Lesson/Type": "محاضرة", "Course Code": "CHEM470", "Hours": "1", "Time": "9-10", "Course Name": "كيمياءغير عضوية (سلاسل + المتراكبات)", "Location": "مدرج نوح" },
  { "Day": "السبت", "Lesson/Type": "عملى", "Course Code": "--", "Hours": "3", "Time": "8-11", "Course Name": "كيمياء عضوية", "Location": "القسم" },
  { "Day": "السبت", "Lesson/Type": "محاضرة", "Course Code": "BIOC418", "Hours": "2", "Time": "12-2", "Course Name": "مقدمة فى البرتيوم والجينوم", "Location": "قاعة (104)" },
  { "Day": "الأحد", "Lesson/Type": "محاضرة", "Course Code": "BIOC402", "Hours": "3", "Time": "12-3", "Course Name": "بيولوجيا الأورام وبيولوجيا بيئية", "Location": "قاعة (104)" },
  { "Day": "الاثنين", "Lesson/Type": "محاضرة خ", "Course Code": "BIOC412", "Hours": "2", "Time": "8-10", "Course Name": "كيمياء حيوية الأمراض", "Location": "قاعة (104)" },
  { "Day": "السبت", "Lesson/Type": "محاضرة خ", "Course Code": "MICR486", "Hours": "2", "Time": "8-10", "Course Name": "مزارع خلايا وأنسجة", "Location": "قاعة 1" },
  { "Day": "السبت", "Lesson/Type": "محاضرة خ", "Course Code": "MICR482", "Hours": "1", "Time": "10-11", "Course Name": "أمراض نبات", "Location": "قاعة 1" },
  { "Day": "السبت", "Lesson/Type": "محاضرة", "Course Code": "MICR432", "Hours": "2", "Time": "11-1", "Course Name": "فطريات طبية", "Location": "قاعة 1" },
  { "Day": "الأحد", "Lesson/Type": "عملى", "Course Code": "--", "Hours": "4", "Time": "9-1", "Course Name": "ميكروبيولوجى", "Location": "القسم" },
  { "Day": "الأحد", "Lesson/Type": "محاضرة", "Course Code": "ZOOL426", "Hours": "1", "Time": "2-3", "Course Name": "مقدمة فى علم الطفيليات", "Location": "فصل (أ225)" },
  { "Day": "الأحد", "Lesson/Type": "عملي", "Course Code": "ZOOL426", "Hours": "2", "Time": "3-5", "Course Name": "مقدمة فى علم الطفيليات", "Location": "القسم" },
  { "Day": "الأحد", "Lesson/Type": "محاضرة خ", "Course Code": "MICR490", "Hours": "1", "Time": "5-6", "Course Name": "بحث تخرج", "Location": "القسم" },
  { "Day": "الاثنين", "Lesson/Type": "عملى", "Course Code": "--", "Hours": "3", "Time": "8-11", "Course Name": "ميكروبيولوجى", "Location": "القسم" },
  { "Day": "الاثنين", "Lesson/Type": "عملى", "Course Code": "BIOC424", "Hours": "4", "Time": "12-2", "Course Name": "سوائل الجسم", "Location": "القسم" },
  { "Day": "الثلاثاء", "Lesson/Type": "عملى", "Course Code": "--", "Hours": "2", "Time": "8-10", "Course Name": "ميكروبيولوجى", "Location": "القسم" },
  { "Day": "الثلاثاء", "Lesson/Type": "محاضرة", "Course Code": "BIOC424", "Hours": "2", "Time": "11-1", "Course Name": "سوائل الجسم", "Location": "قاعة 1" },
  { "Day": "الأربعاء", "Lesson/Type": "محاضرة", "Course Code": "MICR472", "Hours": "1", "Time": "10-11", "Course Name": "تقنية حيوية", "Location": "قاعة 6" },
  { "Day": "الأربعاء", "Lesson/Type": "محاضرة", "Course Code": "MICR422", "Hours": "2", "Time": "11-1", "Course Name": "بكتريا طبية", "Location": "قاعة 6" },
  { "Day": "السبت", "Lesson/Type": "محاضرة", "Course Code": "MICR482", "Hours": "1", "Time": "1-2", "Course Name": "أمراض نبات", "Location": "قاعة 1" },
  { "Day": "السبت", "Lesson/Type": "عملى", "Course Code": "--", "Hours": "3", "Time": "2-5", "Course Name": "كيمياء عضوية", "Location": "القسم" },
  { "Day": "الأحد", "Lesson/Type": "عملى", "Course Code": "--", "Hours": "2", "Time": "12-2", "Course Name": "ميكروبيولوجى", "Location": "القسم" },
  { "Day": "الأحد", "Lesson/Type": "عملى", "Course Code": "CHEM490", "Hours": "3", "Time": "2-5", "Course Name": "كيمياء فيزيائية", "Location": "القسم" },
  { "Day": "الاثنين", "Lesson/Type": "عملى", "Course Code": "--", "Hours": "4", "Time": "1-5", "Course Name": "ميكروبيولوجى", "Location": "القسم" },
  { "Day": "الأربعاء", "Lesson/Type": "محاضرة", "Course Code": "MICR422", "Hours": "2", "Time": "8-10", "Course Name": "بكتيريا طبية", "Location": "قاعة 101" },
  { "Day": "الأربعاء", "Lesson/Type": "محاضرة خ", "Course Code": "CHEM492", "Hours": "2", "Time": "11-1", "Course Name": "كيمياء فيزيائية كيمياء السطوح (2)", "Location": "حجازى" },
  { "Day": "الأربعاء", "Lesson/Type": "محاضرة خ", "Course Code": "CHEM462", "Hours": "2", "Time": "1-3", "Course Name": "كيمياء عضوية ( ضوئية +لبيدات )", "Location": "مدرج هلال" },
  { "Day": "الأربعاء", "Lesson/Type": "عملى", "Course Code": "--", "Hours": "2", "Time": "3-5", "Course Name": "ميكروبيولوجى", "Location": "القسم" },
  { "Day": "السبت", "Lesson/Type": "محاضرة", "Course Code": "GEOL 412 - E", "Hours": "1", "Time": "10-11", "Course Name": "نمذجة هيدروجيولوحية", "Location": "القسم" },
  { "Day": "السبت", "Lesson/Type": "محاضرة", "Course Code": "GEOL 416 - E", "Hours": "1", "Time": "11-12", "Course Name": "التنقيب و االستكشاف", "Location": "القسم" },
  { "Day": "السبت", "Lesson/Type": "عملى", "Course Code": "--", "Hours": "2", "Time": "1-3", "Course Name": "جيولوجيا", "Location": "القسم" },
  { "Day": "الأحد", "Lesson/Type": "محاضرة", "Course Code": "GEOL406", "Hours": "2", "Time": "8-10", "Course Name": "جيولوجيا هندسية", "Location": "القســم" },
  { "Day": "الأحد", "Lesson/Type": "محاضرة", "Course Code": "GEOL410", "Hours": "2", "Time": "10-12", "Course Name": "جيولوجيا البترول", "Location": "القســـم" },
  { "Day": "الأحد", "Lesson/Type": "عملى", "Course Code": "--", "Hours": "2", "Time": "1-3", "Course Name": "جيولوجيا", "Location": "القسم" },
  { "Day": "الأحد", "Lesson/Type": "عملى", "Course Code": "--", "Hours": "2", "Time": "3-5", "Course Name": "جيولوجيا", "Location": "القسم" },
  { "Day": "الاثنين", "Lesson/Type": "محاضرة", "Course Code": "GEOL404", "Hours": "1", "Time": "8-9", "Course Name": "جيولوجيا المناجم", "Location": "القسم" },
  { "Day": "الاثنين", "Lesson/Type": "عملى", "Course Code": "--", "Hours": "2", "Time": "9-11", "Course Name": "جيولوجيا", "Location": "القسم" },
  { "Day": "الاثنين", "Lesson/Type": "عملى", "Course Code": "--", "Hours": "3", "Time": "11-2", "Course Name": "جيولوجيا", "Location": "القسم" },
  { "Day": "الأربعاء", "Lesson/Type": "محاضرة", "Course Code": "GEOL 402", "Hours": "2", "Time": "8-10", "Course Name": "صخور الفانيروزوى فى مصر", "Location": "القسم" },
  { "Day": "الأربعاء", "Lesson/Type": "عملى", "Course Code": "--", "Hours": "4", "Time": "10-2", "Course Name": "جيولوجيا", "Location": "القسم" },
  { "Day": "الأربعاء", "Lesson/Type": "عملى", "Course Code": "GEOL408", "Hours": "4", "Time": "2-6", "Course Name": "مشروع التخرج", "Location": "القسم" },
  { "Day": "الخميس", "Lesson/Type": "محاضرة (خ)", "Course Code": "GEOL418", "Hours": "1", "Time": "11-12", "Course Name": "جيوكيمياء المياه", "Location": "قاعة (1)" },
  { "Day": "الخميس", "Lesson/Type": "محاضرة (خ)", "Course Code": "GEOL430", "Hours": "1", "Time": "12-1", "Course Name": "معالجة الخامات", "Location": "قاعة (1)" },
  { "Day": "الخميس", "Lesson/Type": "عملى", "Course Code": "--", "Hours": "2", "Time": "1-3", "Course Name": "جيولوجيا", "Location": "القسم" },
  { "Day": "الاثنين", "Lesson/Type": "عملى", "Course Code": "CHEM 490-P", "Hours": "3", "Time": "8-11", "Course Name": "كيمياء فيزيائية", "Location": "القسم" },
  { "Day": "الاثنين", "Lesson/Type": "محاضرة", "Course Code": "GEOL 420", "Hours": "1", "Time": "11-12", "Course Name": "اساسيات جيولوجيا المناجم", "Location": "فصل 7" },
  { "Day": "الاثنين", "Lesson/Type": "عملى", "Course Code": "CHEM 460-P", "Hours": "3", "Time": "2-5", "Course Name": "كيمياء عضوية", "Location": "القسم" },
  { "Day": "الثلاثاء", "Lesson/Type": "محاضرة", "Course Code": "GEOL 422", "Hours": "2", "Time": "8-10", "Course Name": "أسس الجيولوجيا الهندسية", "Location": "قاعة (6)" },
  { "Day": "الثلاثاء", "Lesson/Type": "عملى", "Course Code": "--", "Hours": "3", "Time": "1-4", "Course Name": "جيولوجيا", "Location": "القسم" },
  { "Day": "الأربعاء", "Lesson/Type": "عملى", "Course Code": "--", "Hours": "2", "Time": "8-10", "Course Name": "جيولوجيا", "Location": "القسم" },
  { "Day": "السبت", "Lesson/Type": "محاضرة", "Course Code": "GEOP404", "Hours": "1", "Time": "8-9", "Course Name": "جيوفيزياء المناجم", "Location": "قاعة (6)" },
  { "Day": "السبت", "Lesson/Type": "محاضرة", "Course Code": "GEOP416", "Hours": "2", "Time": "9-11", "Course Name": "تقييم تكاوين البترول", "Location": "قاعة (6)" },
  { "Day": "الاثنين", "Lesson/Type": "محاضرة", "Course Code": "GEOP412", "Hours": "1", "Time": "10-11", "Course Name": "تطبيقات جيولوجية لتسجيلات الابار", "Location": "قاعة (5)" },
  { "Day": "الاثنين", "Lesson/Type": "محاضرة", "Course Code": "GEOP410", "Hours": "1", "Time": "12-1", "Course Name": "ديناميكا الموائع فى الخزانات البترولية", "Location": "قاعة (4)" },
  { "Day": "الاثنين", "Lesson/Type": "عملى", "Course Code": "--", "Hours": "2", "Time": "3-1", "Course Name": "جيوفيزياء", "Location": "القسم" },
  { "Day": "الثلاثاء", "Lesson/Type": "عملى", "Course Code": "--", "Hours": "3", "Time": "4-1", "Course Name": "جيوفيزياء", "Location": "القسم" },
  { "Day": "الأربعاء", "Lesson/Type": "عملى", "Course Code": "--", "Hours": "4", "Time": "12-8", "Course Name": "جيوفيزياء", "Location": "القسم" },
  { "Day": "الأربعاء", "Lesson/Type": "عملى", "Course Code": "--", "Hours": "3", "Time": "4-1", "Course Name": "جيولوجيا", "Location": "القسم" },
  { "Day": "الخميس", "Lesson/Type": "عملى", "Course Code": "--", "Hours": "2", "Time": "10-8", "Course Name": "جيولوجيا", "Location": "القسم" },
  { "Day": "السبت", "Lesson/Type": "محاضرة (خ)", "Course Code": "GEOP410", "Hours": "1", "Time": "10-11", "Course Name": "ديناميكا الموائع الخزانات البترولية", "Location": "قاعة (أ)" },
  { "Day": "السبت", "Lesson/Type": "محاضرة", "Course Code": "GEOP402", "Hours": "2", "Time": "11-1", "Course Name": "علم الزلازل", "Location": "قاعة (أ)" },
  { "Day": "الأحد", "Lesson/Type": "محاضرة (خ)", "Course Code": "GEOP404", "Hours": "1", "Time": "8-9", "Course Name": "جيوفيزياء المناجم", "Location": "قاعة (1)" },
  { "Day": "الأحد", "Lesson/Type": "عملى", "Course Code": "--", "Hours": "2", "Time": "9-11", "Course Name": "جيوفيزياء", "Location": "القسم" },
  { "Day": "الأحد", "Lesson/Type": "عملى", "Course Code": "--", "Hours": "3", "Time": "12-3", "Course Name": "جيوفيزياء", "Location": "القسم" },
  { "Day": "الاثنين", "Lesson/Type": "عملى", "Course Code": "--", "Hours": "4", "Time": "8-12", "Course Name": "جيوفيزياء", "Location": "القسم" },
  { "Day": "الاثنين", "Lesson/Type": "عملى", "Course Code": "--", "Hours": "3", "Time": "1-4", "Course Name": "جيوفيزياء", "Location": "القسم" },
  { "Day": "الثلاثاء", "Lesson/Type": "محاضرة", "Course Code": "GEOP406", "Hours": "2", "Time": "10-12", "Course Name": "تفسير البيانات السيزمية", "Location": "قاعة (ب)" },
  { "Day": "الثلاثاء", "Lesson/Type": "محاضرة", "Course Code": "GEOP414", "Hours": "1", "Time": "12-1", "Course Name": "نظرية النمزجة العكسية", "Location": "قاعة (ب)" },
  { "Day": "الثلاثاء", "Lesson/Type": "محاضرة", "Course Code": "GEOP416", "Hours": "2", "Time": "1-3", "Course Name": "تقييم تكاوين البترول", "Location": "قاعة (3)" },
  { "Day": "الأربعاء", "Lesson/Type": "عملى", "Course Code": "--", "Hours": "4", "Time": "8-12", "Course Name": "جيوفيزياء", "Location": "القسم" },
  { "Day": "الأربعاء", "Lesson/Type": "عملى", "Course Code": "--", "Hours": "4", "Time": "1-5", "Course Name": "جيوفيزياء", "Location": "القسم" }
];

const batch2 = [
  { "Day": "السبت (Saturday)", "Lesson/Type": "محاضرة (Lecture)", "Course Code": "MATH 102", "Hours": "3", "Time": "8 - 11", "Course Name": "تفاضل وتكامل (2)", "Location": "مدرج حماد / مدرج هلال" },
  { "Day": "السبت (Saturday)", "Lesson/Type": "محاضرة (Lecture)", "Course Code": "PHYS 102", "Hours": "3", "Time": "11 - 2", "Course Name": "فيزياء (3)", "Location": "مدرج هلال" },
  { "Day": "السبت (Saturday)", "Lesson/Type": "محاضرة (Lecture)", "Course Code": "INCO 102", "Hours": "1", "Time": "5 - 6", "Course Name": "مدخل فى الحاسب الآلى", "Location": "مدرج حماد / مدرج نوح" },
  { "Day": "السبت (Saturday)", "Lesson/Type": "عملى (Practical)", "Course Code": "COMP 102", "Hours": "2", "Time": "8 - 10", "Course Name": "مقدمة فى الحاسب الآلى", "Location": "القسم" },
  { "Day": "السبت (Saturday)", "Lesson/Type": "تمارين (Tutorial)", "Course Code": "MATH 102", "Hours": "1", "Time": "3 - 4", "Course Name": "تفاضل وتكامل (2)", "Location": "مدرج حماد" },
  { "Day": "السبت (Saturday)", "Lesson/Type": "عملى (Practical)", "Course Code": "CHEM 104", "Hours": "3", "Time": "2 - 5", "Course Name": "كيمياء عامة (2)", "Location": "القسم" },
  { "Day": "السبت (Saturday)", "Lesson/Type": "عملى (Practical)", "Course Code": "COMP 102", "Hours": "2", "Time": "2.30 - 4.30", "Course Name": "مقدمة فى الحاسب الآلى", "Location": "القسم" },
  { "Day": "السبت (Saturday)", "Lesson/Type": "محاضرة (Lecture)", "Course Code": "PHYS 102", "Hours": "3", "Time": "12 - 3", "Course Name": "فيزياء (3) (ك 1)", "Location": "مدرج حجازى" },
  { "Day": "السبت (Saturday)", "Lesson/Type": "محاضرة (Lecture)", "Course Code": "BOTA 102", "Hours": "2", "Time": "8 - 10", "Course Name": "أساسيات علم النبات (2)", "Location": "مدرج نوح" },
  { "Day": "السبت (Saturday)", "Lesson/Type": "محاضرة (Lecture)", "Course Code": "MICR 102", "Hours": "1", "Time": "11 - 12", "Course Name": "ميكروبيولوجيا", "Location": "مدرج نوح" },
  { "Day": "السبت (Saturday)", "Lesson/Type": "عملى (Practical)", "Course Code": "ENTM 102", "Hours": "2", "Time": "10 - 12", "Course Name": "علم الحشرات", "Location": "القسم" },
  { "Day": "السبت (Saturday)", "Lesson/Type": "عملى (Practical)", "Course Code": "BOTA 102", "Hours": "3", "Time": "12 - 3", "Course Name": "أساسيات علم النبات (2)", "Location": "القسم" },
  { "Day": "السبت (Saturday)", "Lesson/Type": "تمارين (Tutorial)", "Course Code": "PHYS 102", "Hours": "1", "Time": "4 - 5", "Course Name": "فيزياء (3)", "Location": "قاعة 101" },
  { "Day": "الأحد (Sunday)", "Lesson/Type": "محاضرة (Lecture)", "Course Code": "MATH 112", "Hours": "3", "Time": "11 - 2", "Course Name": "ميكانيكا (1)", "Location": "قاعة (ج)" },
  { "Day": "الأحد (Sunday)", "Lesson/Type": "تمارين (Tutorial)", "Course Code": "MATH 112", "Hours": "1", "Time": "2 - 3", "Course Name": "ميكانيكا (1) (مجموعة 1)", "Location": "قاعة (ج)" },
  { "Day": "الأحد (Sunday)", "Lesson/Type": "تمارين (Tutorial)", "Course Code": "MATH 112", "Hours": "1", "Time": "2 - 3", "Course Name": "ميكانيكا (1) (مجموعة 2)", "Location": "قاعة (ب)" },
  { "Day": "الأحد (Sunday)", "Lesson/Type": "تمارين (Tutorial)", "Course Code": "STAT 102", "Hours": "1", "Time": "1 - 2", "Course Name": "نظرية الاحتمالات (1)", "Location": "قاعة 102" },
  { "Day": "الأحد (Sunday)", "Lesson/Type": "محاضرة (Lecture)", "Course Code": "STAT 102", "Hours": "3", "Time": "2 - 5", "Course Name": "نظرية الاحتمالات (1)", "Location": "قاعة 102" },
  { "Day": "الأحد (Sunday)", "Lesson/Type": "عملى (Practical)", "Course Code": "PHYS 106", "Hours": "4", "Time": "1 - 5", "Course Name": "فيزياء تجريبية (1)", "Location": "القسم" },
  { "Day": "الأحد (Sunday)", "Lesson/Type": "عملى (Practical)", "Course Code": "CHEM 104", "Hours": "3", "Time": "8 - 11", "Course Name": "كيمياء عامة (2) (ك 1)", "Location": "القسم" },
  { "Day": "الأحد (Sunday)", "Lesson/Type": "تمارين (Tutorial)", "Course Code": "PHYS 102", "Hours": "1", "Time": "4 - 5", "Course Name": "فيزياء (3) (ك 2)", "Location": "مدرج نوح" },
  { "Day": "الأحد (Sunday)", "Lesson/Type": "محاضرة (Lecture)", "Course Code": "INCO 102", "Hours": "1", "Time": "5 - 6", "Course Name": "مدخل فى الحاسب الآلى", "Location": "مدرج نوح / مدرج حماد" },
  { "Day": "الأحد (Sunday)", "Lesson/Type": "محاضرة (Lecture)", "Course Code": "CHEM 102", "Hours": "3", "Time": "8 - 11", "Course Name": "كيمياء (2)", "Location": "مدرج نوح" },
  { "Day": "الأحد (Sunday)", "Lesson/Type": "محاضرة (Lecture)", "Course Code": "BOTA 102", "Hours": "2", "Time": "11 - 1", "Course Name": "أساسيات علم النبات (2)", "Location": "مدرج نوح" },
  { "Day": "الأحد (Sunday)", "Lesson/Type": "علمى/عملى (Practical)", "Course Code": "CHEM 104", "Hours": "3", "Time": "2 - 5", "Course Name": "كيمياء عامة (2)", "Location": "القسم" },
  { "Day": "الأحد (Sunday)", "Lesson/Type": "عملى (Practical)", "Course Code": "BOTA 102", "Hours": "3", "Time": "12 - 3", "Course Name": "أساسيات علم النبات (2)", "Location": "القسم" },
  { "Day": "الأحد (Sunday)", "Lesson/Type": "عملى (Practical)", "Course Code": "ZOOL 102", "Hours": "2", "Time": "3 - 5", "Course Name": "علم الحيوان (2)", "Location": "القسم" },
  { "Day": "الأحد (Sunday)", "Lesson/Type": "عملى (Practical)", "Course Code": "BOTA 102", "Hours": "3", "Time": "9 - 12", "Course Name": "أساسيات علم النبات (2)", "Location": "القسم" },
  { "Day": "الأحد (Sunday)", "Lesson/Type": "محاضرة (Lecture)", "Course Code": "GEOP 102", "Hours": "2", "Time": "9 - 11", "Course Name": "أساسيات الجيوفيزياء", "Location": "قاعة ب" },
  { "Day": "الأحد (Sunday)", "Lesson/Type": "عملى (Practical)", "Course Code": "CHEM 104", "Hours": "3", "Time": "11 - 2", "Course Name": "كيمياء عامة (2)", "Location": "القسم" },
  { "Day": "الأحد (Sunday)", "Lesson/Type": "عملى (Practical)", "Course Code": "GEOL 106", "Hours": "2", "Time": "1 - 3", "Course Name": "علم المعادن (جف 1)", "Location": "القسم" },
  { "Day": "الاثنين (Monday)", "Lesson/Type": "تمارين (Tutorial)", "Course Code": "MATH 104", "Hours": "1", "Time": "9 - 10", "Course Name": "مفاهيم أساسية فى الرياضيات", "Location": "مدرج حماد" },
  { "Day": "الاثنين (Monday)", "Lesson/Type": "محاضرة (Lecture)", "Course Code": "MATH 104", "Hours": "3", "Time": "10 - 1", "Course Name": "مفاهيم أساسية فى الرياضيات", "Location": "مدرج حماد" },
  { "Day": "الاثنين (Monday)", "Lesson/Type": "تمارين (Tutorial)", "Course Code": "MATH 102", "Hours": "1", "Time": "1 - 2", "Course Name": "تفاضل وتكامل (2)", "Location": "مدرج حماد" },
  { "Day": "الاثنين (Monday)", "Lesson/Type": "تمارين (Tutorial)", "Course Code": "COMP 102", "Hours": "2", "Time": "3 - 5", "Course Name": "مقدمة فى الحاسب الآلى", "Location": "مدرج حماد" },
  { "Day": "الاثنين (Monday)", "Lesson/Type": "تمارين (Tutorial)", "Course Code": "COMP 104", "Hours": "2", "Time": "2 - 4", "Course Name": "برمجة حاسب (1)", "Location": "مدرج حماد" },
  { "Day": "الاثنين (Monday)", "Lesson/Type": "عملى (Practical)", "Course Code": "COMP 104", "Hours": "2", "Time": "2 - 4", "Course Name": "برمجة حاسب (1)", "Location": "القسم" },
  { "Day": "الاثنين (Monday)", "Lesson/Type": "تمارين (Tutorial)", "Course Code": "MATH 102", "Hours": "1", "Time": "1 - 2", "Course Name": "تفاضل وتكامل (2) (ك 1)", "Location": "قاعة (ب)" },
  { "Day": "الاثنين (Monday)", "Lesson/Type": "تمارين (Tutorial)", "Course Code": "MATH 102", "Hours": "1", "Time": "2 - 3", "Course Name": "تفاضل وتكامل (2) (ك 2)", "Location": "قاعة (ب)" },
  { "Day": "الاثنين (Monday)", "Lesson/Type": "تمارين (Tutorial)", "Course Code": "MATH 114", "Hours": "2", "Time": "3 - 5", "Course Name": "ت. ميكانيكا (1) (ك 2)", "Location": "قاعة (ب)" },
  { "Day": "الاثنين (Monday)", "Lesson/Type": "عملى (Practical)", "Course Code": "ZOOL 102", "Hours": "2", "Time": "8 - 10", "Course Name": "علم الحيوان (2)", "Location": "القسم" },
  { "Day": "الاثنين (Monday)", "Lesson/Type": "علمى (Practical)", "Course Code": "CHEM 104", "Hours": "3", "Time": "11 - 2", "Course Name": "كيمياء عامة (2)", "Location": "القسم" },
  { "Day": "الاثنين (Monday)", "Lesson/Type": "عملى (Practical)", "Course Code": "MICR 102", "Hours": "2", "Time": "8 - 10", "Course Name": "ميكروبيولوجيا", "Location": "القسم" },
  { "Day": "الاثنين (Monday)", "Lesson/Type": "عملى (Practical)", "Course Code": "MICR 102", "Hours": "2", "Time": "10 - 12", "Course Name": "ميكروبيولوجيا", "Location": "القسم" },
  { "Day": "الاثنين (Monday)", "Lesson/Type": "محاضرة (Lecture)", "Course Code": "CHEM 102", "Hours": "3", "Time": "8 - 11", "Course Name": "كيمياء (2)", "Location": "مدرج نوح" },
  { "Day": "الاثنين (Monday)", "Lesson/Type": "محاضرة (Lecture)", "Course Code": "ZOOL 102", "Hours": "2", "Time": "11 - 1", "Course Name": "علم الحيوان (2)", "Location": "مدرج نوح" },
  { "Day": "الاثنين (Monday)", "Lesson/Type": "محاضرة (Lecture)", "Course Code": "ENTM 102", "Hours": "1", "Time": "1 - 2", "Course Name": "علم الحشرات", "Location": "مدرج نوح" },
  { "Day": "الاثنين (Monday)", "Lesson/Type": "عملى (Practical)", "Course Code": "CHEM 104", "Hours": "3", "Time": "2 - 5", "Course Name": "كيمياء عامة (2)", "Location": "القسم" },
  { "Day": "الاثنين (Monday)", "Lesson/Type": "عملى (Practical)", "Course Code": "GEOL 104", "Hours": "3", "Time": "8 - 11", "Course Name": "علم البللورات والمعادن", "Location": "القسم" },
  { "Day": "الاثنين (Monday)", "Lesson/Type": "عملى (Practical)", "Course Code": "GEOL 102", "Hours": "3", "Time": "12 - 3", "Course Name": "مبادىء علم الحفريات وجيولوجيا تاريخية", "Location": "القسم" },
  { "Day": "الاثنين (Monday)", "Lesson/Type": "عملى (Practical)", "Course Code": "GEOP 104", "Hours": "3", "Time": "8 - 11", "Course Name": "طرق مغناطيسية", "Location": "القسم" },
  { "Day": "الاثنين (Monday)", "Lesson/Type": "محاضرة (Lecture)", "Course Code": "GEOL 106", "Hours": "2", "Time": "11 - 1", "Course Name": "علم المعادن", "Location": "فصل 9" },
  { "Day": "الثلاثاء (Tuesday)", "Lesson/Type": "محاضرة (Lecture)", "Course Code": "ENGL 102", "Hours": "2", "Time": "10 - 12", "Course Name": "لغة إنجليزية (1)", "Location": "مدرج حماد" },
  { "Day": "الثلاثاء (Tuesday)", "Lesson/Type": "محاضرة (Lecture)", "Course Code": "MATH 104", "Hours": "3", "Time": "1 - 4", "Course Name": "مفاهيم أساسية فى الرياضيات", "Location": "مدرج هلال" },
  { "Day": "الثلاثاء (Tuesday)", "Lesson/Type": "تمارين (Tutorial)", "Course Code": "PHYS 102", "Hours": "1", "Time": "12 - 1", "Course Name": "فيزياء (3)", "Location": "Classroom 101" },
  { "Day": "الثلاثاء (Tuesday)", "Lesson/Type": "تمارين (Tutorial)", "Course Code": "PHYS 104", "Hours": "1", "Time": "1 - 2", "Course Name": "فيزياء عامة (4)", "Location": "Classroom 101" },
  { "Day": "الثلاثاء (Tuesday)", "Lesson/Type": "تمارين (Tutorial)", "Course Code": "MATH 102", "Hours": "1", "Time": "2 - 3", "Course Name": "تفاضل وتكامل (2)", "Location": "Classroom 101" },
  { "Day": "الثلاثاء (Tuesday)", "Lesson/Type": "تمارين (Tutorial)", "Course Code": "PHYS 102", "Hours": "1", "Time": "1 - 2", "Course Name": "فيزياء (3)", "Location": "قاعة (ب)" },
  { "Day": "الثلاثاء (Tuesday)", "Lesson/Type": "تمارين (Tutorial)", "Course Code": "PHYS 104", "Hours": "1", "Time": "2 - 3", "Course Name": "فيزياء عامة (4)", "Location": "قاعة (ب)" },
  { "Day": "الثلاثاء (Tuesday)", "Lesson/Type": "محاضرة (Lecture)", "Course Code": "MATH 114", "Hours": "2", "Time": "12 - 2", "Course Name": "ميكانيكا", "Location": "مدرج حجازى" },
  { "Day": "الثلاثاء (Tuesday)", "Lesson/Type": "تمارين (Tutorial)", "Course Code": "PHYS 102", "Hours": "1", "Time": "2 - 3", "Course Name": "فيزياء (3) (ك 1)", "Location": "قاعة (أ)" },
  { "Day": "الثلاثاء (Tuesday)", "Lesson/Type": "تمارين (Tutorial)", "Course Code": "MATH 114", "Hours": "2", "Time": "3 - 5", "Course Name": "ت. ميكانيكا (1) (ك 1)", "Location": "قاعة (أ)" },
  { "Day": "الثلاثاء (Tuesday)", "Lesson/Type": "محاضرة (Lecture)", "Course Code": "ZOOL 102", "Hours": "2", "Time": "8 - 10", "Course Name": "علم الحيوان (2)", "Location": "مدرج نوح" },
  { "Day": "الثلاثاء (Tuesday)", "Lesson/Type": "محاضرة (Lecture)", "Course Code": "MICR 102", "Hours": "1", "Time": "12 - 1", "Course Name": "ميكروبيولوجيا", "Location": "مدرج نوح" },
  { "Day": "الثلاثاء (Tuesday)", "Lesson/Type": "محاضرة (Lecture)", "Course Code": "ENTM 102", "Hours": "1", "Time": "1 - 2", "Course Name": "علم الحشرات", "Location": "مدرج نوح" },
  { "Day": "الثلاثاء (Tuesday)", "Lesson/Type": "عملى (Practical)", "Course Code": "MICR 102", "Hours": "2", "Time": "12 - 2", "Course Name": "ميكروبيولوجيا", "Location": "القسم" },
  { "Day": "الثلاثاء (Tuesday)", "Lesson/Type": "محاضرة (Lecture)", "Course Code": "GEOP 104", "Hours": "2", "Time": "8 - 10", "Course Name": "طرق مغناطيسية", "Location": "قاعة أ" },
  { "Day": "الثلاثاء (Tuesday)", "Lesson/Type": "محاضرة (Lecture)", "Course Code": "GEOP 106", "Hours": "1", "Time": "12 - 1", "Course Name": "طرق حرارية ارضية", "Location": "قاعه أ" },
  { "Day": "الثلاثاء (Tuesday)", "Lesson/Type": "تمارين (Tutorial)", "Course Code": "PHYS 102", "Hours": "1", "Time": "1 - 2", "Course Name": "فيزياء (3)", "Location": "قاعة أ" },
  { "Day": "الأربعاء (Wednesday)", "Lesson/Type": "محاضرة (Lecture)", "Course Code": "PHYS 104", "Hours": "3", "Time": "8 - 11", "Course Name": "فيزياء عامة (4)", "Location": "مدرج حجازى" },
  { "Day": "الأربعاء (Wednesday)", "Lesson/Type": "عملى (Practical)", "Course Code": "COMP 104", "Hours": "2", "Time": "11 - 1", "Course Name": "برمجة حاسب (1)", "Location": "القسم" },
  { "Day": "الأربعاء (Wednesday)", "Lesson/Type": "تمارين (Tutorial)", "Course Code": "PHYS 102", "Hours": "1", "Time": "2 - 3", "Course Name": "فيزياء (3)", "Location": "Classroom 101" },
  { "Day": "الأربعاء (Wednesday)", "Lesson/Type": "تمارين (Tutorial)", "Course Code": "PHYS 104", "Hours": "1", "Time": "3 - 4", "Course Name": "فيزياء عامة (4)", "Location": "Classroom 101" },
  { "Day": "الأربعاء (Wednesday)", "Lesson/Type": "عملى (Practical)", "Course Code": "CHEM 104", "Hours": "3", "Time": "8 - 11", "Course Name": "كيمياء عامة (2) (ك 2)", "Location": "القسم" },
  { "Day": "الأربعاء (Wednesday)", "Lesson/Type": "محاضرة (Lecture)", "Course Code": "BIOC 102", "Hours": "2", "Time": "11 - 1", "Course Name": "اساسيات الكيمياء الحيوية", "Location": "مدرج حماد" },
  { "Day": "الأربعاء (Wednesday)", "Lesson/Type": "محاضرة (Lecture)", "Course Code": "CHEM 102", "Hours": "3", "Time": "1 - 4", "Course Name": "كيمياء (2)", "Location": "مدرج حجازى" },
  { "Day": "الأربعاء (Wednesday)", "Lesson/Type": "عملى (Practical)", "Course Code": "MICR 102", "Hours": "2", "Time": "12 - 2", "Course Name": "ميكروبيولوجيا", "Location": "القسم" },
  { "Day": "الأربعاء (Wednesday)", "Lesson/Type": "عملى (Practical)", "Course Code": "ZOOL 102", "Hours": "2", "Time": "10 - 12", "Course Name": "علم الحيوان (2)", "Location": "القسم" },
  { "Day": "الأربعاء (Wednesday)", "Lesson/Type": "عملى (Practical)", "Course Code": "ZOOL 102", "Hours": "2", "Time": "8 - 10", "Course Name": "علم الحيوان (2)", "Location": "القسم" },
  { "Day": "الأربعاء (Wednesday)", "Lesson/Type": "عملى (Practical)", "Course Code": "ENTM 102", "Hours": "2", "Time": "12 - 2", "Course Name": "علم الحشرات", "Location": "القسم" },
  { "Day": "الأربعاء (Wednesday)", "Lesson/Type": "عملى (Practical)", "Course Code": "GEOP 102", "Hours": "3", "Time": "10 - 1", "Course Name": "أساسيات الجيوفيزياء", "Location": "القسم" },
  { "Day": "الأربعاء (Wednesday)", "Lesson/Type": "عملى (Practical)", "Course Code": "GEOP 102", "Hours": "3", "Time": "11 - 2", "Course Name": "أساسيات الجيوفيزياء", "Location": "القسم" },
  { "Day": "الأربعاء (Wednesday)", "Lesson/Type": "عملى (Practical)", "Course Code": "GEOP 102", "Hours": "3", "Time": "9 - 12", "Course Name": "أساسيات الجيوفيزياء", "Location": "القسم" },
  { "Day": "الأربعاء (Wednesday)", "Lesson/Type": "عملى (Practical)", "Course Code": "GEOP 106", "Hours": "2", "Time": "12 - 2", "Course Name": "طرق حرارية أرضية", "Location": "القسم" },
  { "Day": "الخميس (Thursday)", "Lesson/Type": "محاضرة (Lecture)", "Course Code": "COMP 102", "Hours": "2", "Time": "8 - 10", "Course Name": "مقدمة فى الحاسب الآلى", "Location": "مدرج حماد" },
  { "Day": "الخميس (Thursday)", "Lesson/Type": "محاضرة (Lecture)", "Course Code": "COMP 104", "Hours": "2", "Time": "11 - 1", "Course Name": "برمجة حاسب (1)", "Location": "مدرج حماد" },
  { "Day": "الخميس (Thursday)", "Lesson/Type": "محاضرة (Lecture)", "Course Code": "COMP 106", "Hours": "2", "Time": "2 - 4", "Course Name": "تصميم منطق", "Location": "مدرج نوح" },
  { "Day": "الخميس (Thursday)", "Lesson/Type": "تمارين (Tutorial)", "Course Code": "COMP 106", "Hours": "2", "Time": "4 - 6", "Course Name": "تصميم منطق", "Location": "مدرج نوح" },
  { "Day": "الخميس (Thursday)", "Lesson/Type": "عملى (Practical)", "Course Code": "ENTM 102", "Hours": "2", "Time": "8 - 10", "Course Name": "علم الحشرات", "Location": "القسم" },
  { "Day": "الخميس (Thursday)", "Lesson/Type": "عملى (Practical)", "Course Code": "BOTA 102", "Hours": "3", "Time": "11 - 2", "Course Name": "أساسيات علم النبات (2)", "Location": "القسم" },
  { "Day": "الخميس (Thursday)", "Lesson/Type": "عملى (Practical)", "Course Code": "ZOOL 102", "Hours": "2", "Time": "12 - 2", "Course Name": "علم الحيوان (2)", "Location": "القسم" },
  { "Day": "الخميس (Thursday)", "Lesson/Type": "عملى (Practical)", "Course Code": "CHEM 104", "Hours": "3", "Time": "8 - 11", "Course Name": "كيمياء عامه 2", "Location": "القسم" },
  { "Day": "الخميس (Thursday)", "Lesson/Type": "عملى (Practical)", "Course Code": "ZOOL 102", "Hours": "2", "Time": "2 - 4", "Course Name": "علم الحيوان (2)", "Location": "القسم" },
  { "Day": "الخميس (Thursday)", "Lesson/Type": "محاضرة (Lecture)", "Course Code": "GEOL 104", "Hours": "3", "Time": "8 - 11", "Course Name": "علم البللورات والمعادن", "Location": "قاعة (أ)" },
  { "Day": "الخميس (Thursday)", "Lesson/Type": "محاضرة (Lecture)", "Course Code": "GEOL 102", "Hours": "2", "Time": "12 - 2", "Course Name": "مبادىء علم الحفريات وجيولوجيا تاريخية", "Location": "قاعة ب" }
];

const batch3 = [
  { "Day": "األحد", "Lesson/Type": "حماضرة", "Course Code": "204MATH", "Hours": "3", "Time": "8 - 11", "Course Name": "حقيقيحتليل", "Location": "قاعة (104)" },
  { "Day": "األحد", "Lesson/Type": "حماضرة", "Course Code": "212MATH", "Hours": "3", "Time": "11 - 2", "Course Name": "النظرية الكهرومغناطيسية", "Location": "قاعة (2)" },
  { "Day": "األحد", "Lesson/Type": "متارين", "Course Code": "202MATH", "Hours": "1", "Time": "2 - 3", "Course Name": "ت رايضيات", "Location": "قاعة (101)" },
  { "Day": "اإلثنني", "Lesson/Type": "حماضرة", "Course Code": "202MATH", "Hours": "3", "Time": "8 - 11", "Course Name": "معادالت تفاضلية عادية", "Location": "مدرج هال" },
  { "Day": "اإلثنني", "Lesson/Type": "حماضرة", "Course Code": "214MATH", "Hours": "3", "Time": "11 - 2", "Course Name": "ميكانيكا (3)", "Location": "قاعة (3)" },
  { "Day": "اإلثنني", "Lesson/Type": "حماضرة", "Course Code": "MATH 206", "Hours": "2", "Time": "2 - 4", "Course Name": "نظرية األلعاب", "Location": "قاعة (3)" },
  { "Day": "اإلثنني", "Lesson/Type": "متارين", "Course Code": "204MATH", "Hours": "1", "Time": "4 - 5", "Course Name": "ت رايضيات", "Location": "قاعة (5)" },
  { "Day": "األربعاء", "Lesson/Type": "متارين", "Course Code": "212MATH", "Hours": "1", "Time": "10 - 11", "Course Name": "النظرية الكهرومغناطيسية", "Location": "قاعة (1)" },
  { "Day": "األربعاء", "Lesson/Type": "متارين", "Course Code": "214MATH", "Hours": "1", "Time": "11 - 12", "Course Name": "ميكانيكا (3)", "Location": "قاعة ب" },
  { "Day": "األربعاء", "Lesson/Type": "حماضرة", "Course Code": "MATH 222 - E", "Hours": "2", "Time": "12 - 2", "Course Name": "املنطق الرايضي", "Location": "قاعة (4)" },
  { "Day": "اخلميس", "Lesson/Type": "حماضرة", "Course Code": "MATH 208 – E", "Hours": "2", "Time": "8 - 10", "Course Name": "الربجمة اخلطية", "Location": "قاعة (4)" },
  { "Day": "األحد", "Lesson/Type": "حماضرة", "Course Code": "204MATH", "Hours": "3", "Time": "8 - 11", "Course Name": "حتليل حقيقي", "Location": "قاعة (104)" },
  { "Day": "األحد", "Lesson/Type": "معمل", "Course Code": "206COMP", "Hours": "3", "Time": "11 - 2", "Course Name": "حاسب", "Location": "القسم" },
  { "Day": "األحد", "Lesson/Type": "متارين", "Course Code": "202MATH", "Hours": "1", "Time": "2 - 3", "Course Name": "معادال تفاضلية عادية", "Location": "قاعة (101)" },
  { "Day": "اإلثنني", "Lesson/Type": "حماضرة", "Course Code": "202MATH", "Hours": "3", "Time": "8 - 11", "Course Name": "معادال تفاضلية عادية", "Location": "مدرج هال" },
  { "Day": "اإلثنني", "Lesson/Type": "معمل", "Course Code": "-", "Hours": "2", "Time": "11 - 1", "Course Name": "حاسب", "Location": "القسم" },
  { "Day": "اإلثنني", "Lesson/Type": "حماضرة", "Course Code": "MATH 206", "Hours": "2", "Time": "2 - 4", "Course Name": "نظرية األلعاب", "Location": "قاعة (3)" },
  { "Day": "السبت", "Lesson/Type": "حماضرة", "Course Code": "STAT 202", "Hours": "3", "Time": "8 - 11", "Course Name": "نظرية اإلحصاء 2", "Location": "قاعة (101)" },
  { "Day": "السبت", "Lesson/Type": "متارين", "Course Code": "STAT 202", "Hours": "1", "Time": "11 - 12", "Course Name": "نظرية اإلحصاء 2", "Location": "فصل (9)" },
  { "Day": "السبت", "Lesson/Type": "معمل", "Course Code": "206COMP", "Hours": "3", "Time": "12 - 3", "Course Name": "حاسب", "Location": "القسم" },
  { "Day": "اإلثنني", "Lesson/Type": "حماضرة", "Course Code": "STAT 208 - E", "Hours": "3", "Time": "8 - 11", "Course Name": "مبادئ حتليل اإلحندار", "Location": "فصل (7)" },
  { "Day": "اإلثنني", "Lesson/Type": "معمل", "Course Code": "-", "Hours": "2", "Time": "11 - 1", "Course Name": "حاسب", "Location": "القسم" },
  { "Day": "اإلثنني", "Lesson/Type": "معمل", "Course Code": "STAT 208 - E", "Hours": "1", "Time": "1 - 2", "Course Name": "إحصاء", "Location": "القسم" },
  { "Day": "الثالاثء", "Lesson/Type": "حماضرة", "Course Code": "COMP 204 - E", "Hours": "2", "Time": "8 - 10", "Course Name": "شبكات حاسب", "Location": "قاعة (ج)" },
  { "Day": "الثالاثء", "Lesson/Type": "حماضرة", "Course Code": "COMP 208 - E", "Hours": "2", "Time": "10 - 12", "Course Name": "نظرية اآلليات الذاتية", "Location": "قاعة (ج)" },
  { "Day": "الثالاثء", "Lesson/Type": "متارين", "Course Code": "204STAT", "Hours": "1", "Time": "12 - 1", "Course Name": "طرق إحتمالية لبحوث العمليات 1", "Location": "فصل (9)" },
  { "Day": "الثالاثء", "Lesson/Type": "متارين", "Course Code": "208COMP", "Hours": "2", "Time": "1 - 3", "Course Name": "حاسب", "Location": "قاعة (ج)" },
  { "Day": "األربعاء", "Lesson/Type": "حماضرة", "Course Code": "204STAT", "Hours": "3", "Time": "10 - 1", "Course Name": "طرق إحتمالية لبحوث العمليات 1", "Location": "فصل (7)" },
  { "Day": "األربعاء", "Lesson/Type": "حماضرة", "Course Code": "212COMP", "Hours": "2", "Time": "1 - 3", "Course Name": "برجمة حاسب متقدم", "Location": "قاعة (ج)" },
  { "Day": "األربعاء", "Lesson/Type": "حماضرة", "Course Code": "202COMP", "Hours": "2", "Time": "3 - 5", "Course Name": "تراكيب بياانت", "Location": "مدرج هلال" },
  { "Day": "اخلميس", "Lesson/Type": "حماضرة", "Course Code": "COMP 206 - E", "Hours": "2", "Time": "10 - 12", "Course Name": "برجمة الويب", "Location": "مدرج هلال" },
  { "Day": "اخلميس", "Lesson/Type": "معمل", "Course Code": "-", "Hours": "4", "Time": "12 - 4", "Course Name": "حاسب", "Location": "القسم" },
  { "Day": "األحد", "Lesson/Type": "معمل", "Course Code": "206COMP", "Hours": "-", "Time": "11 - 2", "Course Name": "حاسب", "Location": "القسم" },
  { "Day": "األحد", "Lesson/Type": "متارين", "Course Code": "202MATH", "Hours": "1", "Time": "2 - 3", "Course Name": "ت رايضيات", "Location": "قاعة (101)" },
  { "Day": "اإلثنني", "Lesson/Type": "حماضرة", "Course Code": "MATH 202 - E", "Hours": "3", "Time": "8 - 11", "Course Name": "معادالت تفاضلية عادية", "Location": "مدرج هلال" },
  { "Day": "الثالاثء", "Lesson/Type": "حماضرة", "Course Code": "204COMP", "Hours": "2", "Time": "8 - 10", "Course Name": "شبكات احلاسب", "Location": "قاعة (ج)" },
  { "Day": "الثالاثء", "Lesson/Type": "حماضرة", "Course Code": "208COMP", "Hours": "2", "Time": "10 - 12", "Course Name": "نظرية اآلليات الذاتية", "Location": "قاعة (ج)" },
  { "Day": "األربعاء", "Lesson/Type": "متارين", "Course Code": "208COMP", "Hours": "2", "Time": "1 - 3", "Course Name": "حاسب", "Location": "قاعة (ج)" },
  { "Day": "األربعاء", "Lesson/Type": "حماضرة", "Course Code": "210COMP", "Hours": "2", "Time": "10 - 12", "Course Name": "خوارزميات الرسوم", "Location": "قاعة (102)" },
  { "Day": "األربعاء", "Lesson/Type": "معمل", "Course Code": "-", "Hours": "2", "Time": "1 - 3", "Course Name": "حاسب", "Location": "القسم" },
  { "Day": "األربعاء", "Lesson/Type": "حماضرة", "Course Code": "202COMP", "Hours": "2", "Time": "3 - 5", "Course Name": "تراكيب بياانت", "Location": "مدرج هلال" },
  { "Day": "اخلميس", "Lesson/Type": "حماضرة", "Course Code": "206COMP", "Hours": "2", "Time": "10 - 12", "Course Name": "برجمة الويب", "Location": "مدرج هلال" },
  { "Day": "اخلميس", "Lesson/Type": "معمل", "CourseCode": "-", "Hours": "2", "Time": "12 - 2", "Course Name": "حاسب", "Location": "القسم" },
  { "Day": "األحد", "Lesson/Type": "عملي", "Course Code": "PHYS 208 - E", "Hours": "4", "Time": "11 - 3", "Course Name": "فيزايء", "Location": "القسم" },
  { "Day": "االحد", "Lesson/Type": "متارين", "Course Code": "-", "Hours": "1", "Time": "8 - 9", "Course Name": "ت. فيزايء", "Location": "قاعة (3)" },
  { "Day": "االحد", "Lesson/Type": "متارين", "Course Code": "-", "Hours": "1", "Time": "9 - 10", "Course Name": "ت. فيزايء", "Location": "قاعة (3)" },
  { "Day": "االحد", "Lesson/Type": "حماضرة", "Course Code": "256PHYS", "Hours": "2", "Time": "10 - 12", "Course Name": "مقدمة ىف الفيزايء احلسابية", "Location": "فصل (225 ب)" },
  { "Day": "االحد", "Lesson/Type": "حماضرة", "Course Code": "CHEM 262 - E", "Hours": "2", "Time": "1 - 3", "Course Name": "كيمياء عضوية (البرتول والكيمياء البيئة)", "Location": "مدرج نوح" },
  { "Day": "اإلثنني", "Lesson/Type": "حماضرة", "Course Code": "202MATH", "Hours": "3", "Time": "8 - 11", "Course Name": "معادالت تفاضلية عادية", "Location": "مدرج هلال" },
  { "Day": "اإلثنني", "Lesson/Type": "حماضرة", "Course Code": "204PHYS", "Hours": "2", "Time": "12 - 2", "Course Name": "بصرايت فيزايئية", "Location": "قاعة أ.د. سعد" },
  { "Day": "الثالاثء", "Lesson/Type": "حماضرة", "Course Code": "CHEM 290", "Hours": "2", "Time": "8 - 10", "Course Name": "كيمياء فيزايئية (كيمياء الدينامكيا احلرارية + كهربية 1)", "Location": "مدرج حجازي" },
  { "Day": "الثالاثء", "Lesson/Type": "متارين", "Course Code": "PHYS 204", "Hours": "1", "Time": "11 - 12", "Course Name": "ت. فيزايء", "Location": "قاعة أ.د. سعد السيد" },
  { "Day": "الثالاثء", "Lesson/Type": "عملي", "Course Code": "CHEM 260", "Hours": "3", "Time": "2 - 5", "Course Name": "كيمياء عضوية", "Location": "القسم" },
  { "Day": "األربعاء", "Lesson/Type": "حماضرة", "Course Code": "CHEM 260", "Hours": "2", "Time": "8 - 10", "Course Name": "كيمياء عضوية أروماتيية أحادية وعديدة اجملموعة", "Location": "مدرج نوح" },
  { "Day": "األربعاء", "Lesson/Type": "حماضرة", "Course Code": "292CHEM", "Hours": "1", "Time": "10 - 11", "Course Name": "كيمياء فيزايئية حركية", "Location": "مدرج نوح" },
  { "Day": "األربعاء", "Lesson/Type": "حماضرة", "Course Code": "CHEM 294 - E", "Hours": "2", "Time": "11 - 1", "Course Name": "كيمياء فيزايئية (النظرية احلركية للغازات + اخلواص الفيزايئية والتركيب اجلزيئى)", "Location": "مدرج نوح" },
  { "Day": "األربعاء", "Lesson/Type": "عملي", "Course Code": "CHEM 292", "Hours": "3", "Time": "1 - 4", "Course Name": "كيمياء فيزايئية", "Location": "القسم" },
  { "Day": "اخلميس", "Lesson/Type": "حماضرة", "Course Code": "STAT 232", "Hours": "2", "Time": "12 - 2", "Course Name": "إحصاء وإحتمالت", "Location": "قاعة (102)" },
  { "Day": "اخلميس", "Lesson/Type": "متارين", "Course Code": "STAT 232", "Hours": "1", "Time": "2 - 3", "Course Name": "ت. إحصاء", "Location": "قاعة (102)" },
  { "Day": "اخلميس", "Lesson/Type": "متارين", "Course Code": "202MATH", "Hours": "1", "Time": "3 - 4", "Course Name": "ت رايضيات", "Location": "قاعة (102)" },
  { "Day": "األحد", "Lesson/Type": "متارين", "Course Code": "202MATH", "Hours": "1", "Time": "9 - 10", "Course Name": "ت رايضيات", "Location": "قاعة أ.د. سعد السيد" },
  { "Day": "األحد", "Lesson/Type": "معمل", "Course Code": "206COMP", "Hours": "3", "Time": "10 - 1", "Course Name": "حاسب", "Location": "القسم" },
  { "Day": "األحد", "Lesson/Type": "حماضرة", "Course Code": "216PHYS", "Hours": "2", "Time": "2 - 4", "Course Name": "فيزايء (دوائر كهربية)", "Location": "مدرج حجازى" },
  { "Day": "اإلثنني", "Lesson/Type": "حماضرة", "CourseCode": "MATH 202 - E", "Hours": "3", "Time": "8 - 11", "Course Name": "معادالت تفاضلية عادية", "Location": "مدرج هلال" },
  { "Day": "اإلثنني", "Lesson/Type": "معمل", "Course Code": "-", "Hours": "2", "Time": "11 - 1", "Course Name": "حاسب", "Location": "القسم" },
  { "Day": "اإلثنني", "Lesson/Type": "متارين", "Course Code": "PHYS 210 - E", "Hours": "1", "Time": "1 - 2", "Course Name": "ت. فيزايء", "Location": "فصل (225 ب)" },
  { "Day": "اإلثنني", "Lesson/Type": "حماضرة", "Course Code": "204PHYS", "Hours": "2", "Time": "3 - 5", "Course Name": "بصرايت فيزايئية", "Location": "قاعة 101" },
  { "Day": "الثالاثء", "Lesson/Type": "حماضرة", "Course Code": "COMP 204 - E", "Hours": "2", "Time": "8 - 10", "Course Name": "شبكات احلاسب", "Location": "قاعة (ج)" },
  { "Day": "الثالاثء", "Lesson/Type": "حماضرة", "Course Code": "COMP 208 - E", "Hours": "2", "Time": "10 - 12", "Course Name": "نظرية اآلليات الذاتية", "Location": "قاعة (ج)" },
  { "Day": "الثالاثء", "Lesson/Type": "متارين", "Course Code": "204PHYS", "Hours": "1", "Time": "12 - 1", "Course Name": "ت. فيزايء", "Location": "قاعة (ج)" },
  { "Day": "الثالاثء", "Lesson/Type": "متارين", "Course Code": "208COMP", "Hours": "2", "Time": "1 - 3", "Course Name": "حاسب", "Location": "قاعة (ج)" },
  { "Day": "األربعاء", "Lesson/Type": "حماضرة", "Course Code": "PHYS 210 - E", "Hours": "3", "Time": "10 - 1", "Course Name": "فيزايء حسابية", "Location": "قاعة (أ)" },
  { "Day": "األربعاء", "Lesson/Type": "حماضرة", "Course Code": "212COMP", "Hours": "2", "Time": "1 - 3", "Course Name": "برجمة حاسب متقدم", "Location": "قاعة (ج)" },
  { "Day": "األحـد", "Lesson/Type": "حماضرة", "Course Code": "204BOTA", "Hours": "2", "Time": "8 - 10", "Course Name": "أرشيجونيات", "Location": "القسم" },
  { "Day": "األحـد", "Lesson/Type": "حماضرة", "Course Code": "BOTA 210 – E", "Hours": "2", "Time": "10 - 12", "Course Name": "الصون البيئي", "Location": "القسم" },
  { "Day": "األحـد", "Lesson/Type": "عملي", "Course Code": "-", "Hours": "3", "Time": "12 - 3", "Course Name": "نبات", "Location": "القسم" },
  { "Day": "اإلثنني", "Lesson/Type": "حماضرة", "Course Code": "206BOTA", "Hours": "1", "Time": "8 - 9", "Course Name": "طحالب", "Location": "القسم" },
  { "Day": "اإلثنني", "Lesson/Type": "حماضرة", "Course Code": "208BOTA", "Hours": "1", "Time": "9 - 10", "Course Name": "علم حبوب اللقاح التطبيقى", "Location": "القسم" },
  { "Day": "اإلثنني", "Lesson/Type": "حماضرة", "Course Code": "ENTM 204 - E", "Hours": "1", "Time": "10 - 11", "Course Name": "احلشرات كناقالت لألمراض", "Location": "القسم" },
  { "Day": "اإلثنني", "Lesson/Type": "حماضرة", "Course Code": "BIOC 204 - E", "Hours": "2", "Time": "11 - 1", "Course Name": "كيمياء حيوية صناعية", "Location": "قاعة (ج)" },
  { "Day": "اإلثنني", "Lesson/Type": "عملى", "Course Code": "-", "Hours": "2", "Time": "2 - 4", "Course Name": "نبات", "Location": "القسم" },
  { "Day": "الثالاثء", "Lesson/Type": "حماضرة", "Course Code": "204CHEM", "Hours": "2", "Time": "8 - 10", "Course Name": "كيمياء فيزايئية (كيمياء الديناميكا احلرارية و احلركية)", "Location": "فصل (225 أ)" },
  { "Day": "السبت", "Lesson/Type": "عملى", "Course Code": "ZOOL 216 - E", "Hours": "2", "Time": "8 - 10", "Course Name": "حيوان (3+4) ح/ك", "Location": "القسم" },
  { "Day": "السبت", "Lesson/Type": "عملي", "Course Code": "292CHEM", "Hours": "3", "Time": "8 - 11", "Course Name": "كيمياء فيزايئية (حركية) (1+2) ح/ك", "Location": "القسم" },
  { "Day": "السبت", "Lesson/Type": "عملي", "Course Code": "292CHEM", "Hours": "3", "Time": "11 - 2", "Course Name": "كيمياء فيزايئية (حركية) (3+4) ح/ك", "Location": "القسم" },
  { "Day": "السبت", "Lesson/Type": "عملي", "Course Code": "260CHEM", "Hours": "3", "Time": "2 - 5", "Course Name": "كيمياء عضوية", "Location": "القسم" },
  { "Day": "األحد", "Lesson/Type": "حماضرة", "Course Code": "CHEM 262 - E", "Hours": "2", "Time": "1 - 3", "Course Name": "كيمياء عضوية (البرتول والكيمياء البيئة)", "Location": "مدرج نوح" },
  { "Day": "األحد", "Lesson/Type": "حماضرة", "Course Code": "208ZOOL", "Hours": "2", "Time": "3 - 5", "Course Name": "كيمياء األنسجة والتقنية اجملهرية", "Location": "قاعة ج" },
  { "Day": "الثالاثء", "Lesson/Type": "حماضرة", "Course Code": "202ZOOL", "Hours": "3", "Time": "8 - 11", "Course Name": "حبليات والتطور العضوي", "Location": "فصل 225 ب" },
  { "Day": "الثالاثء", "Lesson/Type": "حماضرة", "Course Code": "210ZOOL", "Hours": "2", "Time": "11 - 1", "Course Name": "التغذية واهلضم واأليض", "Location": "فصل 225 ب" },
  { "Day": "األربعاء", "Lesson/Type": "حماضرة", "Course Code": "204ZOOL", "Hours": "2", "Time": "8 - 10", "Course Name": "أساسيات علم الوراثة", "Location": "فصل 225 ب" },
  { "Day": "األربعاء", "Lesson/Type": "حماضرة", "Course Code": "ZOOL 216 - E", "Hours": "1", "Time": "10 - 11", "Course Name": "الالفقارايت الطبية", "Location": "قاعة (101)" },
  { "Day": "األربعاء", "Lesson/Type": "عملي", "Course Code": "208ZOOL", "Hours": "1", "Time": "11 - 12", "Course Name": "حيوان", "Location": "القسم" },
  { "Day": "األربعاء", "Lesson/Type": "عملي", "Course Code": "208ZOOL", "Hours": "3", "Time": "1 - 4", "Course Name": "حيوان", "Location": "القسم" },
  { "Day": "اخلميس", "Lesson/Type": "حماضرة", "Course Code": "ZOOL 220 - E", "Hours": "2", "Time": "8 - 10", "Course Name": "اجلغرافيا احليوية", "Location": "قاعة (ب)" },
  { "Day": "اخلميس", "Lesson/Type": "عملي", "Course Code": "ZOOL 216 - E", "Hours": "2", "Time": "8 - 10", "Course Name": "حيوان", "Location": "القسم" },
  { "Day": "اخلميس", "Lesson/Type": "حماضرة", "Course Code": "208ZOOL", "Hours": "2", "Time": "10 - 12", "Course Name": "كيمياء األنسجة والتقنية اجملهرية", "Location": "قاعة (ب)" },
  { "Day": "اخلميس", "Lesson/Type": "عملي", "Course Code": "ZOOL 210 - P", "Hours": "3", "Time": "12 - 3", "Course Name": "حيوان", "Location": "القسم" },
  { "Day": "اإلثنني", "Lesson/Type": "حماضرة", "Course Code": "ENTM 210-E", "Hours": "1", "Time": "8 - 9", "Course Name": "صحة اجملتمع و احلشرات", "Location": "قاعة (أ)" },
  { "Day": "اإلثنني", "Lesson/Type": "حماضرة", "Course Code": "ENTM 262 - E", "Hours": "1", "Time": "9 - 10", "Course Name": "ادارة اجلودة الشاملة", "Location": "فصل 225 ب" },
  { "Day": "اإلثنني", "Lesson/Type": "حماضرة", "Course Code": "254ENTM", "Hours": "1", "Time": "11 - 12", "Course Name": "تشريح احلشرات", "Location": "فصل 225 ب" },
  { "Day": "اإلثنني", "Lesson/Type": "عملي", "Course Code": "-", "Hours": "3", "Time": "12 - 3", "Course Name": "حشرات", "Location": "القسم" },
  { "Day": "الثالاثء", "Lesson/Type": "حماضرة", "Course Code": "260CHEM", "Hours": "2", "Time": "8 - 10", "Course Name": "كيمياء عضوية أروماتيية أحادية وعديدة اجملموعة", "Location": "مدرج حماد" },
  { "Day": "الثالاثء", "Lesson/Type": "حماضرة", "Course Code": "ENTM 218 - E", "Hours": "1", "Time": "11 - 12", "Course Name": "تعدد األشكال يف احلشرات", "Location": "قاعه (أ)" },
  { "Day": "الثالاثء", "Lesson/Type": "عملى", "Course Code": "-", "Hours": "2", "Time": "1 - 3", "Course Name": "حشرات", "Location": "القسم" },
  { "Day": "األربعاء", "Lesson/Type": "حماضرة", "Course Code": "290CHEM", "Hours": "2", "Time": "8 - 10", "Course Name": "كيمياء فيزايئية (كيمياء الدينامكيا احلرارية + كهربية 1)", "Location": "مدرج حماد" },
  { "Day": "األحد", "Lesson/Type": "حماضرة", "Course Code": "282MICR", "Hours": "1", "Time": "12 - 1", "Course Name": "تكنولوجيا النانو احليوية", "Location": "قاعة (102)" },
  { "Day": "األحد", "Lesson/Type": "عملي", "Course Code": "BOTA 206 - E", "Hours": "2", "Time": "1 - 3", "Course Name": "نبات", "Location": "القسم" },
  { "Day": "اإلثنني", "Lesson/Type": "حماضرة", "Course Code": "252MICR", "Hours": "1", "Time": "8 - 9", "Course Name": "ميكروبيولوجيا بيئية", "Location": "قاعة (101)" },
  { "Day": "اإلثنني", "Lesson/Type": "حماضرة", "Course Code": "254MICR", "Hours": "1", "Time": "9 - 10", "Course Name": "تلوث ميكرويب", "Location": "قاعة (101)" },
  { "Day": "اإلثنني", "Lesson/Type": "عملى", "Course Code": "284MICR", "Hours": "2", "Time": "2 - 4", "Course Name": "ميكروبيولوجي", "Location": "القسم" },
  { "Day": "الثالاثء", "Lesson/Type": "حماضرة", "Course Code": "272MICR", "Hours": "1", "Time": "9 - 10", "Course Name": "إنزميات ميكروبية", "Location": "قاعة (102)" },
  { "Day": "الثالاثء", "Lesson/Type": "حماضرة", "Course Code": "212MICR", "Hours": "1", "Time": "10 - 11", "Course Name": "مقدمة يف علم الفريوسات", "Location": "قاعة (102)" },
  { "Day": "الثالاثء", "Lesson/Type": "حماضرة", "Course Code": "262MICR", "Hours": "2", "Time": "11 - 1", "Course Name": "بيولوجيا جزيئية (1)", "Location": "قاعة (102)" },
  { "Day": "الثالاثء", "Lesson/Type": "حماضرة", "Course Code": "264MICR", "Hours": "1", "Time": "1 - 2", "Course Name": "وراثة ميكروبية", "Location": "قاعة (101)" },
  { "Day": "الثالاثء", "Lesson/Type": "عملي", "Course Code": "-", "Hours": "2", "Time": "8 - 10", "Course Name": "ميكروبيولوجي", "Location": "القسم" },
  { "Day": "األحد", "Lesson/Type": "عملي", "Course Code": "-", "Hours": "3", "Time": "8 - 11", "Course Name": "جيوفيزايء", "Location": "القسم" },
  { "Day": "األحد", "Lesson/Type": "عملي", "Course Code": "-", "Hours": "3", "Time": "12 - 3", "Course Name": "جيولوجيا", "Location": "القسم" },
  { "Day": "األحد", "Lesson/Type": "عملى", "Course Code": "268PHYS", "Hours": "2", "Time": "3 - 5", "Course Name": "فيزايء", "Location": "القسم" },
  { "Day": "اإلثنني", "Lesson/Type": "حماضرة", "Course Code": "202GEOL", "Hours": "2", "Time": "8 - 10", "Course Name": "صخور انرية", "Location": "أ.د. سعد السيد" },
  { "Day": "اإلثنني", "Lesson/Type": "حماضرة", "Course Code": "PHYS 268 - E", "Hours": "1", "Time": "10 - 11", "Course Name": "قواعد القياسات اجليومغناطيسة واإلشعاعية", "Location": "فصل (228 أ)" },
  { "Day": "اإلثنني", "Lesson/Type": "عملي", "Course Code": "-", "Hours": "3", "Time": "11 - 2", "Course Name": "جيوفيزايء", "Location": "القسم" },
  { "Day": "الثالاثء", "Lesson/Type": "حماضرة", "Course Code": "GEOP 210-E", "Hours": "1", "Time": "10 - 11", "Course Name": "مفاهيم الطرق احلرارية االرضية", "Location": "قاعة (أ)" },
  { "Day": "الثالاثء", "Lesson/Type": "عملي", "Course Code": "GEOP 210 - P", "Hours": "3", "Time": "11 - 2", "Course Name": "جيوفيزايء", "Location": "القسم" },
  { "Day": "الثالاثء", "Lesson/Type": "عملي", "Course Code": "-", "Hours": "3", "Time": "3 - 6", "Course Name": "جيولوجيا", "Location": "القسم" },
  { "Day": "األربعاء", "Lesson/Type": "حماضرة", "Course Code": "204GEOL", "Hours": "3", "Time": "8 - 11", "Course Name": "ترسيب وصخور رسوبية", "Location": "قاعة (5)" },
  { "Day": "األربعاء", "Lesson/Type": "حماضرة", "Course Code": "204GEOP", "Hours": "2", "Time": "11 - 1", "Course Name": "أسس الطرق املغناطيسية", "Location": "قاعة (5)" },
  { "Day": "األربعاء", "Lesson/Type": "حماضرة", "Course Code": "BOTA 226 - E", "Hours": "1", "Time": "1 - 2", "Course Name": "علم النبااتت ونبااتت حفرية", "Location": "قاعة (6)" },
  { "Day": "األربعاء", "Lesson/Type": "عملى", "Course Code": "-", "Hours": "3", "Time": "2 - 5", "Course Name": "جيوفيزايء", "Location": "القسم" },
  { "Day": "اخلميس", "Lesson/Type": "عملى", "Course Code": "BOTA 226 - E", "Hours": "2", "Time": "8 - 10", "Course Name": "علم النبااتت ونبااتت حفرية", "Location": "القسم" },
  { "Day": "اخلميس", "Lesson/Type": "حماضرة", "Course Code": "206GEOP", "Hours": "1", "Time": "11 - 12", "Course Name": "أسس الطرق الكهربية", "Location": "قاعة (6)" },
  { "Day": "اخلميس", "Lesson/Type": "حماضرة", "Course Code": "208GEOP", "Hours": "1", "Time": "12 - 1", "Course Name": "مفاهيم اخلواص الفيزايئية للصخور", "Location": "قاعة (6)" },
  { "Day": "اخلميس", "Lesson/Type": "حماضرة", "Course Code": "PHYS 264 - E", "Hours": "1", "Time": "1 - 2", "Course Name": "ديناميكا حرارية وكهرومغناطيسية", "Location": "قاعة (6)" },
  { "Day": "اخلميس", "Lesson/Type": "عملى", "Course Code": "264PHYS", "Hours": "3", "Time": "2 - 5", "Course Name": "فيزايء", "Location": "القسم" },
  { "Day": "األحـــد", "Lesson/Type": "عملي", "Course Code": "-", "Hours": "3", "Time": "9 - 12", "Course Name": "جيولوجيا", "Location": "القسم" },
  { "Day": "األحـــد", "Lesson/Type": "حماضرة", "Course Code": "CHEM 262 - E", "Hours": "2", "Time": "1 - 3", "Course Name": "كيمياء عضوية (البرتول والكيمياء والبيئة)", "Location": "مدرج نوح" },
  { "Day": "األحـــد", "Lesson/Type": "عملى", "Course Code": "-", "Hours": "3", "Time": "3 - 6", "Course Name": "جيولوجيا", "Location": "القسم" },
  { "Day": "اإلثنني", "Lesson/Type": "حماضرة", "Course Code": "202GEOL", "Hours": "2", "Time": "8 - 10", "Course Name": "صخور انرية", "Location": "أ.د. سعد السيد" },
  { "Day": "اإلثنني", "Lesson/Type": "حماضرة", "Course Code": "PHYS 268 - E", "Hours": "1", "Time": "10 - 11", "Course Name": "قواعد القياسات اجليومغناطيسة واإلشعاعية", "Location": "فصل (228 أ)" },
  { "Day": "اإلثنني", "Lesson/Type": "عملي", "Course Code": "-", "Hours": "3", "Time": "11 - 2", "Course Name": "جيولوجيا", "Location": "القسم" },
  { "Day": "الثالاثء", "Lesson/Type": "حماضرة", "Course Code": "CHEM 290", "Hours": "2", "Time": "8 - 10", "Course Name": "كيمياء فيزايئية (كيمياء الدينامكيا احلرارية + كهربية 1)", "Location": "مدرج حجازي" },
  { "Day": "اإلثنني", "Lesson/Type": "حماضرة", "Course Code": "MATH 202", "Hours": "3", "Time": "8 - 11", "Course Name": "معادالت تفاضلية عادية", "Location": "مدرج هلال" },
  { "Day": "اإلثنني", "Lesson/Type": "حماضرة", "Course Code": "MATH 226", "Hours": "2", "Time": "11 - 1", "Course Name": "تحليل عددى", "Location": "قاعة (5)" },
  { "Day": "اإلثنني", "Lesson/Type": "حماضرة", "Course Code": "GEOP 202", "Hours": "2", "Time": "1 - 3", "Course Name": "طرق كهربية", "Location": "قاعة (5)" },
  { "Day": "الثالاثء", "Lesson/Type": "حماضرة", "Course Code": "GEOP 212 - E", "Hours": "2", "Time": "8 - 10", "Course Name": "جيوديسيا", "Location": "قاعة (3)" },
  { "Day": "الثالاثء", "Lesson/Type": "حماضرة", "Course Code": "GEOL 210 - E", "Hours": "2", "Time": "10 - 12", "Course Name": "علم الصخور النارية والمتحولة", "Location": "قاعة (3)" },
  { "Day": "الثالاثء", "Lesson/Type": "عملي", "Course Code": "-", "Hours": "3", "Time": "1 - 4", "Course Name": "جيوفيزياء", "Location": "القسم" },
  { "Day": "األربعاء", "Lesson/Type": "حماضرة", "Course Code": "PHYS 274", "Hours": "2", "Time": "8 - 10", "Course Name": "فيزياء حديثة", "Location": "قاعة (3)" },
  { "Day": "األربعاء", "Lesson/Type": "عملي", "Course Code": "-", "Hours": "3", "Time": "11 - 2", "Course Name": "جيوفيزياء", "Location": "القسم" },
  { "Day": "اخلميس", "Lesson/Type": "عملي", "Course Code": "-", "Hours": "3", "Time": "2 - 5", "Course Name": "جيولوجيا", "Location": "القسم" },
  { "Day": "اخلميس", "Lesson/Type": "عملي", "Course Code": "-", "Hours": "3", "Time": "11 - 2", "Course Name": "جيولوجيا", "Location": "القسم" },
  { "Day": "اخلميس", "Lesson/Type": "حماضرة", "Course Code": "GEOL 204", "Hours": "3", "Time": "8 - 11", "Course Name": "ترسيب وصخور رسوبية", "Location": "فصل 7" },
  { "Day": "اخلميس", "Lesson/Type": "متارين", "Course Code": "MATH 202", "Hours": "1", "Time": "3 - 4", "Course Name": "ت رايضيات", "Location": "قاعة (102)" }
];

const batch4 = [
  { "Day": "السبت", "Lesson/Type": "محاضرة", "Course Code": "MATH 302", "Hours": "3", "Time": "12-3", "Course Name": "التوبولوجي العام", "Location": "قاعة ج" },
  { "Day": "الإثنين", "Lesson/Type": "محاضرة", "Course Code": "MATH 304", "Hours": "3", "Time": "11 - 8", "Course Name": "نظرية القياس", "Location": "فصل 9" },
  { "Day": "الإثنين", "Lesson/Type": "محاضرة", "Course Code": "COMP 304", "Hours": "2", "Time": "3 - 1", "Course Name": "تصميم مؤلفات", "Location": "مدرج حجازي" },
  { "Day": "الثلاثاء", "Lesson/Type": "محاضرة", "Course Code": "MATH 306", "Hours": "2", "Time": "10 – 8", "Course Name": "بحوث العمليات", "Location": "فصل أ228" },
  { "Day": "الثلاثاء", "Lesson/Type": "محاضرة", "Course Code": "COMP 302", "Hours": "2", "Time": "1 - 11", "Course Name": "تآلفيات خوارزمية", "Location": "مدرج هلال" },
  { "Day": "الثلاثاء", "Lesson/Type": "تمارين", "Course Code": "COMP 302", "Hours": "1", "Time": "2 - 1", "Course Name": "ت حاسب", "Location": "قاعة 4" },
  { "Day": "الثلاثاء", "Lesson/Type": "محاضرة", "Course Code": "ETHR 302", "Hours": "1", "Time": "4 - 3", "Course Name": "أخلاقيات البحث العلمي", "Location": "مدرج حماد" },
  { "Day": "الإثنين", "Lesson/Type": "معمل - حاسب", "Course Code": "-", "Hours": "3", "Time": "11-8", "Course Name": "معمل - حاسب", "Location": "القسم" },
  { "Day": "الإثنين", "Lesson/Type": "محاضرة", "Course Code": "COMP 310", "Hours": "1", "Time": "12-11", "Course Name": "برمجة ويب متقدمة", "Location": "قاعة (أ)" },
  { "Day": "الإثنين", "Lesson/Type": "معمل - حاسب", "Course Code": "-", "Hours": "2", "Time": "5-3", "Course Name": "معمل - حاسب", "Location": "القسم" },
  { "Day": "الثلاثاء", "Lesson/Type": "تمارين", "Course Code": "COMP 302", "Hours": "1", "Time": "3 - 2", "Course Name": "حاسبت", "Location": "قاعة 4" },
  { "Day": "الأربعاء", "Lesson/Type": "محاضرة", "Course Code": "COMP 314", "Hours": "2", "Time": "2-12", "Course Name": "نظم قواعد البيانات", "Location": "قاعة 102" },
  { "Day": "الأربعاء", "Lesson/Type": "محاضرة", "Course Code": "COMP 306", "Hours": "2", "Time": "5 - 3", "Course Name": "رسومات الحاسب", "Location": "مدرج نوح" },
  { "Day": "الخميس", "Lesson/Type": "محاضرة", "Course Code": "COMP 308", "Hours": "3", "Time": "11 - 8", "Course Name": "تشفير", "Location": "مدرج حجازي" },
  { "Day": "الخميس", "Lesson/Type": "معمل - حاسب", "Course Code": "-", "Hours": "2", "Time": "2-12", "Course Name": "معمل - حاسب", "Location": "القسم" },
  { "Day": "السبت", "Lesson/Type": "محاضرة", "Course Code": "PHYS 304", "Hours": "3", "Time": "12-9", "Course Name": "(1الكترونيات)", "Location": "فصل (أ228)" },
  { "Day": "السبت", "Lesson/Type": "محاضرة", "Course Code": "خ", "Hours": "3", "Time": "3-12", "Course Name": "إختياري للشعب المختلفة", "Location": "القسم" },
  { "Day": "الأحد", "Lesson/Type": "محاضرة", "Course Code": "PHYS 310", "Hours": "3", "Time": "12-9", "Course Name": "(1بصريات)", "Location": "فصل (228ب)" },
  { "Day": "الإثنين", "Lesson/Type": "محاضرة", "Course Code": "خ", "Hours": "3", "Time": "11-8", "Course Name": "إختياري للشعب المختلفة", "Location": "القسم" },
  { "Day": "الإثنين", "Lesson/Type": "محاضرة", "Course Code": "PHYS 308", "Hours": "3", "Time": "3-12", "Course Name": "(2ميكانيكا الكم)", "Location": "فصل أ 228" },
  { "Day": "الإثنين", "Lesson/Type": "تمارين", "Course Code": "-", "Hours": "2", "Time": "5-3", "Course Name": "ت فيزياء", "Location": "فصل أ 228" },
  { "Day": "الثلاثاء", "Lesson/Type": "تمارين", "Course Code": "-", "Hours": "1", "Time": "10-9", "Course Name": "ت. فيزياء (خ)", "Location": "القسم" },
  { "Day": "الثلاثاء", "Lesson/Type": "عملي", "Course Code": "PHYS 306", "Hours": "4", "Time": "2-10", "Course Name": "(6فيزياء تجريبية)", "Location": "القسم" },
  { "Day": "الأربعاء", "Lesson/Type": "محاضرة", "Course Code": "PHYS 302", "Hours": "3", "Time": "11-8", "Course Name": "(1جوامد)", "Location": "فصل ا(225)" },
  { "Day": "الأربعاء", "Lesson/Type": "تمارين", "Course Code": "-", "Hours": "2", "Time": "1-11", "Course Name": "ت فيزياء", "Location": "فصل ا(225)" },
  { "Day": "الأربعاء", "Lesson/Type": "محاضرة", "Course Code": "BIOP 322", "Hours": "2", "Time": "10-8", "Course Name": "تقنيات الفيزياء الحيوية", "Location": "القسم" },
  { "Day": "الأربعاء", "Lesson/Type": "محاضرة", "Course Code": "BIOP 332", "Hours": "2", "Time": "12-10", "Course Name": "تشريح آدمي", "Location": "القسم" },
  { "Day": "الأربعاء", "Lesson/Type": "عملى", "Course Code": "-", "Hours": "3", "Time": "4-1", "Course Name": "فيزياء حيوية", "Location": "القسم" },
  { "Day": "الخميس", "Lesson/Type": "عملي", "Course Code": "-", "Hours": "6", "Time": "5-11", "Course Name": "فيزياء حيوية", "Location": "القسم" },
  { "Day": "السبت", "Lesson/Type": "محاضرة", "Course Code": "PHYS 362", "Hours": "2", "Time": "12-2", "Course Name": "مقدمة في علم الجوامد", "Location": "فصل (7)" },
  { "Day": "الأحد", "Lesson/Type": "محاضرة", "Course Code": "BIOP 342", "Hours": "2", "Time": "10-8", "Course Name": "بيوفيزياء السمع والبصر", "Location": "القسم" },
  { "Day": "الأحد", "Lesson/Type": "تمارين", "Course Code": "-", "Hours": "1", "Time": "12-11", "Course Name": "ت فيزياء", "Location": "القسم" },
  { "Day": "الأحد", "Lesson/Type": "محاضرة", "Course Code": "BIOP 302", "Hours": "2", "Time": "12-2", "Course Name": "أساسيات الفيزياء النووية وبيولوجيا الإشعاع", "Location": "قاعة (5)" },
  { "Day": "الأحد", "Lesson/Type": "محاضرة", "Course Code": "BIOP 312", "Hours": "2", "Time": "3-1", "Course Name": "إلكترونيات حيوية", "Location": "قاعة (5)" },
  { "Day": "الأحد", "Lesson/Type": "محاضرة", "Course Code": "BIOC 324", "Hours": "2", "Time": "5-3", "Course Name": "مناعة", "Location": "قاعة (5)" },
  { "Day": "السبت", "Lesson/Type": "محاضرة", "Course Code": "PHYS 360", "Hours": "2", "Time": "10-8", "Course Name": "ميكانيكا إحصائية", "Location": "فصل (7)" },
  { "Day": "السبت", "Lesson/Type": "تمارين", "Course Code": "-", "Hours": "1", "Time": "11-10", "Course Name": "ت فيزياء", "Location": "فصل (7)" },
  { "Day": "السبت", "Lesson/Type": "محاضرة", "Course Code": "PHYS 364", "Hours": "2", "Time": "3-1", "Course Name": "إلكترونيات", "Location": "قاعة (4)" },
  { "Day": "الأحد", "Lesson/Type": "محاضرة", "Course Code": "PHYS 362", "Hours": "2", "Time": "10-8", "Course Name": "مقدمة في علم الجوامد", "Location": "قاعة 5" },
  { "Day": "الأحد", "Lesson/Type": "تمارين", "Course Code": "-", "Hours": "1", "Time": "12-1", "Course Name": "ت فيزياء", "Location": "قاعة 5" },
  { "Day": "الأحد", "Lesson/Type": "محاضرة", "Course Code": "CHEM 362", "Hours": "2", "Time": "1-11", "Course Name": "كيمياء عضوية (الفيتامينات والكيمياء العلاجية)", "Location": "مدرج حجازى" },
  { "Day": "الأحد", "Lesson/Type": "عملي", "Course Code": "-", "Hours": "3", "Time": "5-2", "Course Name": "عملي - عضوية كيمياء", "Location": "القسم" },
  { "Day": "الثلاثاء", "Lesson/Type": "محاضرة", "Course Code": "PHYS 380", "Hours": "2", "Time": "1-11", "Course Name": "أطياف وجزيئية تطبيقية", "Location": "قاعة (5)" },
  { "Day": "الثلاثاء", "Lesson/Type": "تمارين", "Course Code": "-", "Hours": "1", "Time": "2-1", "Course Name": "ت فيزياء", "Location": "قاعة (5)" },
  { "Day": "الأربعاء", "Lesson/Type": "محاضرة", "Course Code": "CHEM 360", "Hours": "2", "Time": "11-1", "Course Name": "كيمياء عضوية (الأصباغ والأطياف العضوية)", "Location": "مدرج نوح" },
  { "Day": "الإثنين", "Lesson/Type": "محاضرة", "Course Code": "PHYS 382", "Hours": "2", "Time": "11-9", "Course Name": "إتصالات بصرية", "Location": "قاعة (4)" },
  { "Day": "الإثنين", "Lesson/Type": "تمارين", "Course Code": "-", "Hours": "1", "Time": "12-11", "Course Name": "ت فيزياء", "Location": "قاعة (4)" },
  { "Day": "الإثنين", "Lesson/Type": "عملي", "Course Code": "-", "Hours": "2", "Time": "5 - 3", "Course Name": "فيزياء", "Location": "القسم" },
  { "Day": "الأربعاء", "Lesson/Type": "معمل", "Course Code": "-", "Hours": "4", "Time": "12-8", "Course Name": "حاسب", "Location": "القسم" },
  { "Day": "الخميس", "Lesson/Type": "محاضرة", "Course Code": "PHYS 358", "Hours": "2", "Time": "2-12", "Course Name": "فيزياء نووية", "Location": "قاعة (5)" },
  { "Day": "السبت", "Lesson/Type": "محاضرة", "Course Code": "CHEM 312", "Hours": "2", "Time": "11-9", "Course Name": "الكيمياء العضوية الفيزيائية", "Location": "قاعة ج" },
  { "Day": "السبت", "Lesson/Type": "محاضرة", "Course Code": "CHEM 322", "Hours": "1", "Time": "3-2", "Course Name": "(3كيمياء غير عضوية )", "Location": "مدرج حماد" },
  { "Day": "السبت", "Lesson/Type": "محاضرة", "Course Code": "CHEM 324", "Hours": "2", "Time": "5-3", "Course Name": "(4كيمياء غير عضوية)", "Location": "مدرج نوح" },
  { "Day": "الإثنين", "Lesson/Type": "عملي", "Course Code": "CHEM 322", "Hours": "3", "Time": "11-8", "Course Name": "(1)( 3كيمياء غير عضوية )", "Location": "القسم" },
  { "Day": "الإثنين", "Lesson/Type": "عملي", "Course Code": "GEOL 330", "Hours": "4", "Time": "3-11", "Course Name": "جيولوجيا", "Location": "القسم" },
  { "Day": "الإثنين", "Lesson/Type": "عملي", "Course Code": "CHEM-P 344", "Hours": "3", "Time": "6-3", "Course Name": "(1) ( 3كيمياء فيزيائية عملي)", "Location": "القسم" },
  { "Day": "الثلاثاء", "Lesson/Type": "عملي", "Course Code": "CHEM 322", "Hours": "3", "Time": "11-8", "Course Name": "( 2)( 3)كيمياء غير عضوية", "Location": "القسم" },
  { "Day": "الثلاثاء", "Lesson/Type": "عملي", "Course Code": "344CHEM-P", "Hours": "3", "Time": "11-8", "Course Name": "(1) ( 3كيمياء فيزيائية عملي)", "Location": "القسم" },
  { "Day": "الثلاثاء", "Lesson/Type": "عملي", "Course Code": "CHEM-P 344", "Hours": "3", "Time": "2-11", "Course Name": "(2) ( 3كيمياء فيزيائية عملي)", "Location": "القسم" },
  { "Day": "الثلاثاء", "Lesson/Type": "عملي", "Course Code": "316CHEM-P", "Hours": "3", "Time": "2-11", "Course Name": "(1) (3كيمياء عضوية)", "Location": "القسم" },
  { "Day": "الأربعاء", "Lesson/Type": "عملي", "Course Code": "CHEM-P 344", "Hours": "3", "Time": "11-8", "Course Name": "(2) ( 3كيمياء فيزيائية عملي)", "Location": "القسم" },
  { "Day": "السبت", "Lesson/Type": "محاضرة", "Course Code": "BOTA 302", "Hours": "2", "Time": "10- 8", "Course Name": "الخصائص الجزيئية والوظيفية", "Location": "القسم" },
  { "Day": "السبت", "Lesson/Type": "محاضرة", "Course Code": "BOTA 312", "Hours": "2", "Time": "12-10", "Course Name": "المجتمعات النباتية والتكنولوجيا الحيوية البئية", "Location": "القسم" },
  { "Day": "السبت", "Lesson/Type": "محاضرة", "Course Code": "MICR 388", "Hours": "1", "Time": "1-12", "Course Name": "الميكروبيولوجي التطبيقي", "Location": "القسم" },
  { "Day": "الأحد", "Lesson/Type": "محاضرة", "Course Code": "BOTA 304", "Hours": "1", "Time": "9-8", "Course Name": "فصائل مختارة في النباتات الزهرية", "Location": "القسم" },
  { "Day": "الأحد", "Lesson/Type": "محاضرة", "Course Code": "BOTA 306", "Hours": "1", "Time": "10-9", "Course Name": "طحالب المياه العذبة والمالحة في مصر", "Location": "القسم" },
  { "Day": "الأحد", "Lesson/Type": "محاضرة", "Course Code": "BOTA 310", "Hours": "1", "Time": "11-10", "Course Name": "تفاعل البلمرة المتسلسل", "Location": "القسم" },
  { "Day": "الإثنين", "Lesson/Type": "محاضرة", "Course Code": "BOTA 314", "Hours": "1", "Time": "9-8", "Course Name": "خ جغرافيا نباتية", "Location": "القسم" },
  { "Day": "الإثنين", "Lesson/Type": "محاضرة", "Course Code": "BOTA 308", "Hours": "1", "Time": "12-11", "Course Name": "المعلوماتية الحيوية والإحصاء الحيوي", "Location": "القسم" },
  { "Day": "السبت", "Lesson/Type": "محاضرة", "Course Code": "CHEM 370", "Hours": "2", "Time": "12-2", "Course Name": "كيمياء غير عضوية (المركبات الفلزعضوية)", "Location": "مدرج نوح" },
  { "Day": "السبت", "Lesson/Type": "محاضرة", "Course Code": "CHEM 362", "Hours": "2", "Time": "2-4", "Course Name": "كيمياء عضوية (الفيتامينات والكيمياء العلاجية)", "Location": "مدرج هلال" },
  { "Day": "الأحد", "Lesson/Type": "عملي", "Course Code": "-", "Hours": "2", "Time": "12-8", "Course Name": "نبات (ن/ك أ+ب)", "Location": "القسم" },
  { "Day": "الأحد", "Lesson/Type": "محاضرة", "Course Code": "CHEM 380", "Hours": "2", "Time": "2-12", "Course Name": "كيمياء تحليلية (التحليل بالأجهزة)", "Location": "مدرج حماد" },
  { "Day": "الإثنين", "Lesson/Type": "عملي", "Course Code": "CHEM 360", "Hours": "3", "Time": "11-8", "Course Name": "كيمياء عضوية (ن/ك أ)", "Location": "القسم" },
  { "Day": "الإثنين", "Lesson/Type": "عملي", "Course Code": "-", "Hours": "3", "Time": "2-11", "Course Name": "كيمياء غيرعضوية (ن/ك أ)", "Location": "القسم" },
  { "Day": "الثلاثاء", "Lesson/Type": "محاضرة", "Course Code": "BOTA 322", "Hours": "2", "Time": "10-8", "Course Name": "أساسيات علم الأرشيجونيات", "Location": "(7فصل)" },
  { "Day": "الثلاثاء", "Lesson/Type": "محاضرة", "Course Code": "BOTA 326", "Hours": "1", "Time": "11-10", "Course Name": "الحياة البرية والموارد البيئية", "Location": "(7فصل)" },
  { "Day": "الأحد", "Lesson/Type": "محاضرة", "Course Code": "ZOOL 328", "Hours": "2", "Time": "10-8", "Course Name": "اللافقاريات متقدم وعلم الطفيليات", "Location": "قاعة(جـ)" },
  { "Day": "الأحد", "Lesson/Type": "محاضرة", "Course Code": "ZOOL 310", "Hours": "1", "Time": "11-10", "Course Name": "الحيوان الإقتصادي", "Location": "قاعة(جـ)" },
  { "Day": "الأحد", "Lesson/Type": "عملي", "Course Code": "-", "Hours": "3", "Time": "5 - 2", "Course Name": "(2كيمياء تحليلية ) ح/ك", "Location": "القسم" },
  { "Day": "الإثنين", "Lesson/Type": "عملى", "Course Code": "ZOOL 310", "Hours": "2", "Time": "1 – 11", "Course Name": "حيوان", "Location": "القسم" },
  { "Day": "الثلاثاء", "Lesson/Type": "محاضرة", "Course Code": "ZOOL 322", "Hours": "3", "Time": "11-8", "Course Name": "(1علم فزيولوجي)", "Location": "(102قاعة)" },
  { "Day": "السبت", "Lesson/Type": "محاضرة", "Course Code": "ENTM 318", "Hours": "2", "Time": "2-12", "Course Name": "الحشرات النافعة والضارة", "Location": "(9فصل)" },
  { "Day": "الأحد", "Lesson/Type": "محاضرة", "Course Code": "ENTM 320", "Hours": "1", "Time": "9-8", "Course Name": "علم الوراثة وعلاقته بالحشرات", "Location": "(9فصل)" },
  { "Day": "الأحد", "Lesson/Type": "عملي", "Course Code": "-", "Hours": "3", "Time": "3-1", "Course Name": "حشرات", "Location": "القسم" },
  { "Day": "الثلاثاء", "Lesson/Type": "محاضرة", "Course Code": "ENTM 326", "Hours": "1", "Time": "10-9", "Course Name": "أسس علم الاجنة للحشرات", "Location": "(104قاعة )" },
  { "Day": "الثلاثاء", "Lesson/Type": "عملي", "Course Code": "-", "Hours": "3", "Time": "2-11", "Course Name": "كيمياء غير عضوية", "Location": "القسم" },
  { "Day": "الأربعاء", "Lesson/Type": "عملي", "Course Code": "CHEM 360", "Hours": "3", "Time": "11-8", "Course Name": "كيمياء عضوية", "Location": "القسم" },
  { "Day": "السبت", "Lesson/Type": "عملي", "Course Code": "-", "Hours": "5", "Time": "1-8", "Course Name": "كيمياء حيوية", "Location": "القسم" },
  { "Day": "السبت", "Lesson/Type": "محاضرة", "Course Code": "BIOC 314", "Hours": "2", "Time": "3-1", "Course Name": "أساسيات أيض الأحماض النووية", "Location": "قاعة أ" },
  { "Day": "السبت", "Lesson/Type": "محاضرة", "Course Code": "BOTA 334", "Hours": "2", "Time": "5 - 3", "Course Name": "الإجهاد و مضادات الأكسدة فى النباتات", "Location": "قاعة أ" },
  { "Day": "الأحد", "Lesson/Type": "عملي", "Course Code": "-", "Hours": "3", "Time": "11-8", "Course Name": "كيمياء عضوية", "Location": "القسم" },
  { "Day": "الأحد", "Lesson/Type": "محاضرة", "Course Code": "BIOC 306", "Hours": "2", "Time": "1-11", "Course Name": "علم المناعة", "Location": "قاعة 104" },
  { "Day": "الأحد", "Lesson/Type": "محاضرة", "Course Code": "BIOC 312", "Hours": "2", "Time": "3-1", "Course Name": "التغذية", "Location": "قاعة 104" },
  { "Day": "الأربعاء", "Lesson/Type": "محاضرة", "Course Code": "BIOC 304", "Hours": "2", "Time": "10-8", "Course Name": "الكيمياء الحيوية الميكروبية", "Location": "قاعة (104)" },
  { "Day": "الأربعاء", "Lesson/Type": "محاضرة", "Course Code": "CHEM 380", "Hours": "2", "Time": "3-1", "Course Name": "كيمياء تحليلية (التحليل بالأجهزة)", "Location": "مدرج نوح" },
  { "Day": "الخميس", "Lesson/Type": "محاضرة", "Course Code": "CHEM 370", "Hours": "2", "Time": "10-8", "Course Name": "كيمياء غير عضوية (المركبات الفلزعضوية)", "Location": "مدرج هلال" },
  { "Day": "الخميس", "Lesson/Type": "محاضرة", "Course Code": "BIOC 308", "Hours": "2", "Time": "1-11", "Course Name": "هرمونات", "Location": "مدرج حجازى" },
  { "Day": "الخميس", "Lesson/Type": "عملي", "Course Code": "-", "Hours": "3", "Time": "5-2", "Course Name": "كيمياء غير عضوية (كح/ك ب)", "Location": "القسم" },
  { "Day": "السبت", "Lesson/Type": "عملي", "Course Code": "-", "Hours": "4", "Time": "12-8", "Course Name": "ميكروبيولوجي", "Location": "القسم" },
  { "Day": "السبت", "Lesson/Type": "عملي", "Course Code": "-", "Hours": "4", "Time": "5-1", "Course Name": "ميكروبيولوجي", "Location": "القسم" },
  { "Day": "الأحد", "Lesson/Type": "عملي", "Course Code": "-", "Hours": "2", "Time": "10-8", "Course Name": "ميكروبيولوجي", "Location": "القسم" },
  { "Day": "الأحد", "Lesson/Type": "محاضرة", "Course Code": "MICR 374", "Hours": "1", "Time": "11-10", "Course Name": "تحولات ميكروبية", "Location": "7فصل" },
  { "Day": "الأحد", "Lesson/Type": "محاضرة", "Course Code": "MICR 322", "Hours": "1", "Time": "12-11", "Course Name": "أكتينوميسيتات", "Location": "7فصل" },
  { "Day": "الثلاثاء", "Lesson/Type": "محاضرة", "Course Code": "MICR 372", "Hours": "2", "Time": "10-8", "Course Name": "فسيولوجيا وأيض الكائنات الدقيقة", "Location": "(9فصل)" },
  { "Day": "الثلاثاء", "Lesson/Type": "محاضرة", "Course Code": "MICR 352", "Hours": "1", "Time": "11-10", "Course Name": "ميكروبيولوجيا طبقات الأرض", "Location": "(9فصل)" },
  { "Day": "الثلاثاء", "Lesson/Type": "محاضرة", "Course Code": "MICR 384", "Hours": "1", "Time": "12-11", "Course Name": "مضادات حياتية", "Location": "(9فصل)" },
  { "Day": "الأربعاء", "Lesson/Type": "عملي", "Course Code": "-", "Hours": "2", "Time": "10-8", "Course Name": "ميكروبيولوجي", "Location": "القسم" },
  { "Day": "الأربعاء", "Lesson/Type": "محاضرة", "Course Code": "MICR 312", "Hours": "2", "Time": "1-11", "Course Name": "تقسيم فيروسات", "Location": "(9فصل )" },
  { "Day": "الخميس", "Lesson/Type": "محاضرة", "Course Code": "MICR 314", "Hours": "1", "Time": "10-9", "Course Name": "بكتريوفاج", "Location": "(9قاعة)" },
  { "Day": "الخميس", "Lesson/Type": "عملي", "Course Code": "-", "Hours": "2", "Time": "12-10", "Course Name": "ميكروبيولوجي", "Location": "القسم" },
  { "Day": "الخميس", "Lesson/Type": "محاضرة", "Course Code": "MICR 386", "Hours": "1", "Time": "1-12", "Course Name": "تحكم في الكائنات الدقيقة", "Location": "(9فصل)" },
  { "Day": "السبت", "Lesson/Type": "محاضرة", "Course Code": "GEOL 316", "Hours": "2", "Time": "10-8", "Course Name": "استراتجرافيا تتابعية", "Location": "(9فصل )" },
  { "Day": "السبت", "Lesson/Type": "محاضرة", "Course Code": "GEOL 306", "Hours": "1", "Time": "11-10", "Course Name": "جيولوجيا تحت سطحية", "Location": "(9فصل )" },
  { "Day": "السبت", "Lesson/Type": "عملي", "Course Code": "-", "Hours": "3", "Time": "3-12", "Course Name": "جيولوجيا", "Location": "القسم" },
  { "Day": "الأحد", "Lesson/Type": "محاضرة", "Course Code": "GEOL 304", "Hours": "1", "Time": "11-10", "Course Name": "جيوكيمياء", "Location": "(9فصل )" },
  { "Day": "الأحد", "Lesson/Type": "محاضرة", "Course Code": "GEOL 308", "Hours": "2", "Time": "2-12", "Course Name": "جيولوجيا الحقل وتخريط جيولوجي", "Location": "(6قاعة )" },
  { "Day": "الأحد", "Lesson/Type": "عملي", "Course Code": "-", "Hours": "2", "Time": "5-3", "Course Name": "جيولوجيا", "Location": "القسم" },
  { "Day": "الثلاثاء", "Lesson/Type": "محاضرة", "Course Code": "GEOL 314", "Hours": "2", "Time": "11-9", "Course Name": "الإطار التركيبي لمصر", "Location": "101قاعة" },
  { "Day": "السبت", "Lesson/Type": "محاضرة", "Course Code": "GEOL 326", "Hours": "1", "Time": "9-8", "Course Name": "أسس استراجرافيا", "Location": "(3قاعة)" },
  { "Day": "السبت", "Lesson/Type": "محاضرة", "Course Code": "GEOL 328", "Hours": "1", "Time": "10-9", "Course Name": "الوضع التركيبي لمصر", "Location": "(3قاعة)" },
  { "Day": "السبت", "Lesson/Type": "محاضرة", "Course Code": "GEOP 316", "Hours": "2", "Time": "1-11", "Course Name": "أسس علم الزلازل", "Location": "101قاعه" },
  { "Day": "السبت", "Lesson/Type": "عملي", "Course Code": "-", "Hours": "3", "Time": "4-1", "Course Name": "جيولوجيا", "Location": "القسم" },
  { "Day": "الثلاثاء", "Lesson/Type": "عملي", "Course Code": "-", "Hours": "3", "Time": "11-8", "Course Name": "جيوفيزياء", "Location": "القسم" },
  { "Day": "الثلاثاء", "Lesson/Type": "عملي", "Course Code": "-", "Hours": "2", "Time": "1-11", "Course Name": "جيولوجيا", "Location": "القسم" },
  { "Day": "الأربعاء", "Lesson/Type": "عملي", "Course Code": "-", "Hours": "3", "Time": "11-8", "Course Name": "جيولوجيا", "Location": "القسم" },
  { "Day": "الأربعاء", "Lesson/Type": "محاضرة", "Course Code": "GEOP 312", "Hours": "1", "Time": "12-11", "Course Name": "جيوفيزياء مرصدية", "Location": "ب 225فصل" },
  { "Day": "الأربعاء", "Lesson/Type": "عملي", "Course Code": "-", "Hours": "4", "Time": "5-1", "Course Name": "جيوفيزياء", "Location": "القسم" },
  { "Day": "الخميس", "Lesson/Type": "محاضرة", "Course Code": "GEOP 314", "Hours": "2", "Time": "10-8", "Course Name": "تقنيات معالجة البيانات السيزمية", "Location": "أ228فصل" },
  { "Day": "الخميس", "Lesson/Type": "محاضرة", "Course Code": "GEOL 322", "Hours": "1", "Time": "11-10", "Course Name": "جيولوجيا الخامات الإقتصادية", "Location": "ب225" },
  { "Day": "الخميس", "Lesson/Type": "عملي", "Course Code": "-", "Hours": "4", "Time": "4-12", "Course Name": "جيولوجيا", "Location": "القسم" },
  { "Day": "السبت", "Lesson/Type": "عملى", "Course Code": "-", "Hours": "4", "Time": "4-12", "Course Name": "جيولوجيا", "Location": "القسم" },
  { "Day": "الأحد", "Lesson/Type": "عملى", "Course Code": "-", "Hours": "2", "Time": "4-2", "Course Name": "جيولوجيا", "Location": "القسم" },
  { "Day": "الثلاثاء", "Lesson/Type": "عملى", "Course Code": "-", "Hours": "3", "Time": "11-8", "Course Name": "كيمياء", "Location": "القسم" },
  { "Day": "الثلاثاء", "Lesson/Type": "محاضرة", "Course Code": "GEOL 324", "Hours": "1", "Time": "2-1", "Course Name": "جيولوجيا الحقل", "Location": "9فصل" },
  { "Day": "الأحد", "Lesson/Type": "عملي", "Course Code": "-", "Hours": "3", "Time": "11-8", "Course Name": "جيوفيزياء", "Location": "القسم" },
  { "Day": "الأحد", "Lesson/Type": "عملي", "Course Code": "-", "Hours": "3", "Time": "12-3", "Course Name": "جيوفيزياء", "Location": "القسم" },
  { "Day": "الإثنين", "Lesson/Type": "عملي", "Course Code": "-", "Hours": "3", "Time": "11-8", "Course Name": "جيوفيزياء", "Location": "القسم" },
  { "Day": "الإثنين", "Lesson/Type": "عملي", "Course Code": "-", "Hours": "2", "Time": "2-12", "Course Name": "جيولوجيا", "Location": "القسم" },
  { "Day": "الثلاثاء", "Lesson/Type": "عملي", "Course Code": "-", "Hours": "2", "Time": "2-12", "Course Name": "جيوفيزياء", "Location": "القسم" },
  { "Day": "الأربعاء", "Lesson/Type": "عملي", "Course Code": "-", "Hours": "2", "Time": "11-9", "Course Name": "جيوفيزياء", "Location": "القسم" },
  { "Day": "الأربعاء", "Lesson/Type": "محاضرة", "Course Code": "GEOP 308", "Hours": "2", "Time": "2-12", "Course Name": "حفر آبار", "Location": "(3قاعة)" },
  { "Day": "الخميس", "Lesson/Type": "محاضرة", "Course Code": "GEOP 304", "Hours": "1", "Time": "9-8", "Course Name": "طرق إشعاعية", "Location": "(6قاعة)" },
  { "Day": "الخميس", "Lesson/Type": "محاضرة", "Course Code": "GEOP 312", "Hours": "1", "Time": "10-9", "Course Name": "جيوفيزياء مرصدية", "Location": "(6قاعة)" },
  { "Day": "الخميس", "Lesson/Type": "عملي", "Course Code": "GEOL 314", "Hours": "2", "Time": "12-10", "Course Name": "الإطار التركيبي لمصر", "Location": "القسم" }
];

function sanitizeArabic(str) {
  if (!str) return str;
  return str
    .replace(/األحد/g, 'الأحد')
    .replace(/األحـد/g, 'الأحد')
    .replace(/االحد/g, 'الأحد')
    .replace(/اإلثنني/g, 'الاثنين')
    .replace(/اإلثنين/g, 'الاثنين')
    .replace(/الثالاثء/g, 'الثلاثاء')
    .replace(/األربعاء/g, 'الأربعاء')
    .replace(/اخلميس/g, 'الخميس')
    .replace(/حماضرة/g, 'محاضرة')
    .replace(/متارين/g, 'تمارين')
    .trim();
}

const dayMapping = {
  'السبت': 'SATURDAY',
  'الأحد': 'SUNDAY',
  'الاثنين': 'MONDAY',
  'الثلاثاء': 'TUESDAY',
  'الأربعاء': 'WEDNESDAY',
  'الخميس': 'THURSDAY'
};

function parseTime(timeStr) {
  const parts = timeStr.split('-').map(s => s.trim());
  
  function toHHmm(val) {
    let hour, minute = 0;
    if (val.includes('.')) {
      const p = val.split('.');
      hour = Number(p[0]);
      minute = Number(p[1]);
    } else {
      hour = Number(val);
    }
    
    if (hour >= 1 && hour <= 6) hour += 12;
    return hour.toString().padStart(2, '0') + ':' + minute.toString().padStart(2, '0');
  }

  let start = toHHmm(parts[0]);
  let end = toHHmm(parts[1]);

  // Handle reversed ranges like "11-8" (meaning 8:00 to 11:00)
  if (start > end && parts[0] !== '12') {
     [start, end] = [end, start];
  }

  return { startTime: start, endTime: end };
}

async function main() {
  console.log('Starting schedule seeding (All Batches)...');
  
  const existingCourses = await prisma.course.findMany({
    select: { id: true, code: true }
  });
  
  const courseMap = {};
  existingCourses.forEach(c => {
    courseMap[c.code.replace(/\s+/g, '').toUpperCase()] = c.id;
  });

  let createdCount = 0;
  let updatedCount = 0;
  let skippedCount = 0;
  const missingCourses = new Set();

  const allData = [...batch1, ...batch2, ...batch3, ...batch4];

  for (const item of allData) {
    const rawCode = item['Course Code'];
    if (rawCode === '--' || rawCode === '-' || rawCode === 'خ' || !rawCode) {
      skippedCount++;
      continue;
    }

    // Clean Batch 3/4 course codes
    let cleanedCode = rawCode.replace(/\s+/g, '').toUpperCase();
    
    // Handle (خ), (E), (P) suffixes and spaces
    cleanedCode = cleanedCode.split('(')[0].split('-')[0].split('–')[0].trim();

    // Handle inverted format "204MATH" -> "MATH204"
    if (/^\d+[A-Z]+$/.test(cleanedCode)) {
      const match = cleanedCode.match(/^(\d+)([A-Z]+)$/);
      cleanedCode = match[2] + match[1];
    }
    
    const courseId = courseMap[cleanedCode];

    if (!courseId) {
      missingCourses.add(rawCode);
      skippedCount++;
      continue;
    }

    const { startTime, endTime } = parseTime(item.Time);
    const sanitizedDay = sanitizeArabic(item.Day).split('(')[0].trim();
    const dayOfWeek = dayMapping[sanitizedDay];

    if (!dayOfWeek) {
      console.warn(`Unknown day: ${item.Day} (Sanitized: ${sanitizedDay}) for course ${rawCode}`);
      skippedCount++;
      continue;
    }

    const type = sanitizeArabic(item['Lesson/Type']).split('(')[0].trim();

    const existingSlot = await prisma.courseSchedule.findFirst({
      where: {
        courseId,
        dayOfWeek,
        startTime,
        endTime
      }
    });

    if (existingSlot) {
      await prisma.courseSchedule.update({
        where: { id: existingSlot.id },
        data: {
          location: item.Location,
          type: type
        }
      });
      updatedCount++;
    } else {
      await prisma.courseSchedule.create({
        data: {
          courseId,
          dayOfWeek,
          startTime,
          endTime,
          location: item.Location,
          type: type
        }
      });
      createdCount++;
    }
  }

  console.log(`\nSeeding completed!`);
  console.log(`Created: ${createdCount} new slots`);
  console.log(`Updated: ${updatedCount} existing slots`);
  console.log(`Skipped: ${skippedCount}`);
  
  if (missingCourses.size > 0) {
    console.log(`\nMissing courses in DB (Skipped):`);
    console.log(Array.from(missingCourses).sort().join(', '));
  }
}

main()
  .catch(e => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
