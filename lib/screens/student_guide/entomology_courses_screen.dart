import 'package:flutter/material.dart';

const List<Map<String, String>> _courses = [
  // ========== Ø§Ù„Ù…Ø³ØªÙˆÙ‰ Ø§Ù„Ø£ÙˆÙ„ ==========
  {
    "level": "1",
    "type": "mandatory",
    "department": "Ø§Ù„Ø±ÙŠØ§Ø¶ÙŠØ§Øª",
    "course_name": "ØªÙØ§Ø¶Ù„ ÙˆØªÙƒØ§Ù…Ù„ (1)",
    "course_code": "MATH 101",
    "credit_hours": "3",
    "prerequisites": "-"
  },
  {
    "level": "1",
    "type": "mandatory",
    "department": "Ø§Ù„ÙÙŠØ²ÙŠØ§Ø¡",
    "course_name": "ÙÙŠØ²ÙŠØ§Ø¡ Ø¹Ø§Ù…Ø© (1)",
    "course_code": "PHYS 101",
    "credit_hours": "3",
    "prerequisites": "-"
  },
  {
    "level": "1",
    "type": "mandatory",
    "department": "Ø§Ù„ÙƒÙŠÙ…ÙŠØ§Ø¡",
    "course_name": "ÙƒÙŠÙ…ÙŠØ§Ø¡ Ø¹Ø§Ù…Ø© (1)",
    "course_code": "CHEM 101",
    "credit_hours": "3",
    "prerequisites": "-"
  },
  {
    "level": "1",
    "type": "mandatory",
    "department": "Ø§Ù„ÙƒÙŠÙ…ÙŠØ§Ø¡",
    "course_name": "Ø¹Ù…Ù„ÙŠ ÙƒÙŠÙ…ÙŠØ§Ø¡ Ø¹Ø§Ù…Ø© (1)",
    "course_code": "CHEM 103",
    "credit_hours": "1",
    "prerequisites": "-"
  },
  {
    "level": "1",
    "type": "mandatory",
    "department": "Ø¹Ù„Ù… Ø§Ù„Ù†Ø¨Ø§Øª",
    "course_name": "Ø£Ø³Ø§Ø³ÙŠØ§Øª Ø¹Ù„Ù… Ø§Ù„Ù†Ø¨Ø§Øª (1)",
    "course_code": "BOTA 101",
    "credit_hours": "2",
    "prerequisites": "-"
  },
  {
    "level": "1",
    "type": "mandatory",
    "department": "Ø¹Ù„Ù… Ø§Ù„Ø­ÙŠÙˆØ§Ù†",
    "course_name": "Ø¹Ù„Ù… Ø§Ù„Ø­ÙŠÙˆØ§Ù† (1)",
    "course_code": "ZOOL 101",
    "credit_hours": "2",
    "prerequisites": "-"
  },
  {
    "level": "1",
    "type": "mandatory",
    "department": "Ù…ØªØ·Ù„Ø¨ Ø¬Ø§Ù…Ø¹Ø©",
    "course_name": "Ù„ØºØ© Ø¥Ù†Ø¬Ù„ÙŠØ²ÙŠØ© (1)",
    "course_code": "ENGL 102",
    "credit_hours": "2",
    "prerequisites": "-"
  },
  {
    "level": "1",
    "type": "mandatory",
    "department": "Ù…ØªØ·Ù„Ø¨ Ø¬Ø§Ù…Ø¹Ø©",
    "course_name": "Ù…Ø¯Ø®Ù„ ÙÙŠ Ø§Ù„Ø­Ø§Ø³Ø¨ Ø§Ù„Ø¢Ù„ÙŠ",
    "course_code": "INCO 102",
    "credit_hours": "1",
    "prerequisites": "-"
  },
  {
    "level": "1",
    "type": "mandatory",
    "department": "Ø§Ù„ÙƒÙŠÙ…ÙŠØ§Ø¡",
    "course_name": "ÙƒÙŠÙ…ÙŠØ§Ø¡ (2)",
    "course_code": "CHEM 102",
    "credit_hours": "3",
    "prerequisites": "-"
  },
  {
    "level": "1",
    "type": "mandatory",
    "department": "Ø§Ù„ÙƒÙŠÙ…ÙŠØ§Ø¡",
    "course_name": "Ø¹Ù…Ù„ÙŠ ÙƒÙŠÙ…ÙŠØ§Ø¡ Ø¹Ø§Ù…Ø© (2)",
    "course_code": "CHEM 104",
    "credit_hours": "1",
    "prerequisites": "-"
  },
  {
    "level": "1",
    "type": "mandatory",
    "department": "Ø¹Ù„Ù… Ø§Ù„Ù†Ø¨Ø§Øª",
    "course_name": "Ø£Ø³Ø§Ø³ÙŠØ§Øª Ø¹Ù„Ù… Ø§Ù„Ù†Ø¨Ø§Øª (2)",
    "course_code": "BOTA 102",
    "credit_hours": "3",
    "prerequisites": "-"
  },
  {
    "level": "1",
    "type": "mandatory",
    "department": "Ø¹Ù„Ù… Ø§Ù„Ø­ÙŠÙˆØ§Ù†",
    "course_name": "Ø¹Ù„Ù… Ø§Ù„Ø­ÙŠÙˆØ§Ù† (2)",
    "course_code": "ZOOL 102",
    "credit_hours": "3",
    "prerequisites": "-"
  },
  {
    "level": "1",
    "type": "mandatory",
    "department": "Ø§Ù„Ù…ÙŠÙƒØ±ÙˆØ¨ÙŠÙˆÙ„ÙˆØ¬ÙŠØ§",
    "course_name": "Ù…ÙŠÙƒØ±ÙˆØ¨ÙŠÙˆÙ„ÙˆØ¬ÙŠ",
    "course_code": "MICR 102",
    "credit_hours": "2",
    "prerequisites": "-"
  },
  {
    "level": "1",
    "type": "mandatory",
    "department": "Ø¹Ù„Ù… Ø§Ù„Ø­Ø´Ø±Ø§Øª",
    "course_name": "Ø¹Ù„Ù… Ø§Ù„Ø­Ø´Ø±Ø§Øª",
    "course_code": "ENTM 102",
    "credit_hours": "2",
    "prerequisites": "-"
  },

  // ========== Ø§Ù„Ù…Ø³ØªÙˆÙ‰ Ø§Ù„Ø«Ø§Ù†ÙŠ ==========
  {
    "level": "2",
    "type": "mandatory",
    "department": "Ù…ØªØ·Ù„Ø¨ Ø¬Ø§Ù…Ø¹Ø©",
    "course_name": "Ù„ØºØ© Ø¥Ù†Ø¬Ù„ÙŠØ²ÙŠØ© (2)",
    "course_code": "ENGL 201",
    "credit_hours": "2",
    "prerequisites": "-"
  },
  {
    "level": "2",
    "type": "mandatory",
    "department": "Ø¹Ù„Ù… Ø§Ù„Ø­Ø´Ø±Ø§Øª",
    "course_name": "Ø§Ù„Ø´ÙƒÙ„ Ø§Ù„Ø¹Ø§Ù… Ù„Ù„Ø­Ø´Ø±Ø§Øª",
    "course_code": "ENTM 201",
    "credit_hours": "3",
    "prerequisites": "ENTM 102"
  },
  {
    "level": "2",
    "type": "mandatory",
    "department": "Ø¹Ù„Ù… Ø§Ù„Ø­Ø´Ø±Ø§Øª",
    "course_name": "ØªØ´Ø±ÙŠØ­ Ø§Ù„Ø­Ø´Ø±Ø§Øª Ø§Ù„Ù…ØªÙ‚Ø¯Ù…",
    "course_code": "ENTM 203",
    "credit_hours": "2",
    "prerequisites": "ENTM 102"
  },
  {
    "level": "2",
    "type": "mandatory",
    "department": "Ø¹Ù„Ù… Ø§Ù„Ø­Ø´Ø±Ø§Øª",
    "course_name": "Ù…Ù„Ø§Ø¦Ù…Ø© Ø§Ù„Ø­Ø´Ø±Ø§Øª Ù„Ø¨ÙŠØ¦ØªÙ‡Ø§",
    "course_code": "ENTM 205",
    "credit_hours": "1",
    "prerequisites": "ENTM 102"
  },
  {
    "level": "2",
    "type": "mandatory",
    "department": "Ø¹Ù„Ù… Ø§Ù„Ø­Ø´Ø±Ø§Øª",
    "course_name": "Ø§Ù„ØªÙ„ÙˆØ« ÙˆØ­Ù…Ø§ÙŠØ© Ø§Ù„Ø¨ÙŠØ¦Ø©",
    "course_code": "ENTM 207",
    "credit_hours": "1",
    "prerequisites": "ENTM 102"
  },
  {
    "level": "2",
    "type": "mandatory",
    "department": "Ø¹Ù„Ù… Ø§Ù„Ø­Ø´Ø±Ø§Øª",
    "course_name": "ØªØµÙ†ÙŠÙ Ø§Ù„Ø­Ø´Ø±Ø§Øª (1)",
    "course_code": "ENTM 209",
    "credit_hours": "3",
    "prerequisites": "ENTM 102"
  },
  {
    "level": "2",
    "type": "mandatory",
    "department": "Ø§Ù„ÙƒÙŠÙ…ÙŠØ§Ø¡ Ø§Ù„Ø­ÙŠÙˆÙŠØ©",
    "course_name": "Ø§Ù„ÙƒÙŠÙ…ÙŠØ§Ø¡ Ø§Ù„Ø­ÙŠÙˆÙŠ Ù…ØªÙ‚Ø¯Ù…",
    "course_code": "BIOC 205",
    "credit_hours": "3",
    "prerequisites": "-"
  },
  {
    "level": "2",
    "type": "elective",
    "department": "Ø¹Ù„Ù… Ø§Ù„Ø­Ø´Ø±Ø§Øª",
    "course_name": "Ø§Ù„Ø­Ø´Ø±Ø§Øª ÙˆØ¯ÙˆØ±Ù‡Ø§ ÙƒÙ…Ø¤Ø´Ø±Ø§Øª Ø­ÙŠÙˆÙŠØ©",
    "course_code": "ENTM 211",
    "credit_hours": "1",
    "prerequisites": "-"
  },
  {
    "level": "2",
    "type": "elective",
    "department": "Ø¹Ù„Ù… Ø§Ù„Ø­Ø´Ø±Ø§Øª",
    "course_name": "Ø§Ù„Ø­Ø´Ø±Ø§Øª ÙÙŠ Ù…ØµØ± (Ø§Ù„ÙØ±Ø¹ÙˆÙ†ÙŠØ©) Ø§Ù„Ù‚Ø¯ÙŠÙ…Ø©",
    "course_code": "ENTM 213",
    "credit_hours": "1",
    "prerequisites": "-"
  },
  {
    "level": "2",
    "type": "elective",
    "department": "Ø¹Ù„Ù… Ø§Ù„Ø­Ø´Ø±Ø§Øª",
    "course_name": "Ø§Ù„Ø­Ø´Ø±Ø§Øª Ø§Ù„Ù†Ø§ÙØ¹Ø© ÙˆÙ…Ù†ØªØ¬Ø§ØªÙ‡Ø§",
    "course_code": "ENTM 215",
    "credit_hours": "2",
    "prerequisites": "-"
  },
  {
    "level": "2",
    "type": "elective",
    "department": "Ø¹Ù„Ù… Ø§Ù„Ø­Ø´Ø±Ø§Øª",
    "course_name": "Ø¢Ù„ÙŠØ§Øª Ø§Ù„Ø¯ÙØ§Ø¹ ÙÙŠ Ø§Ù„Ø­Ø´Ø±Ø§Øª",
    "course_code": "ENTM 217",
    "credit_hours": "1",
    "prerequisites": "-"
  },
  {
    "level": "2",
    "type": "mandatory",
    "department": "Ø¹Ù„Ù… Ø§Ù„Ø­Ø´Ø±Ø§Øª",
    "course_name": "Ø£Ø³Ø³ Ù…ÙƒØ§ÙØ­Ø© Ø§Ù„Ø¢ÙØ§Øª",
    "course_code": "ENTM 202",
    "credit_hours": "1",
    "prerequisites": "ENTM 102"
  },
  {
    "level": "2",
    "type": "mandatory",
    "department": "Ø¹Ù„Ù… Ø§Ù„Ø­Ø´Ø±Ø§Øª",
    "course_name": "Ø§Ù„Ø­Ø´Ø±Ø§Øª ÙƒÙ†Ø§Ù‚Ù„Ø§Øª Ù„Ù„Ø£Ù…Ø±Ø§Ø¶ Ø§Ù„Ù†Ø¨Ø§ØªÙŠØ©",
    "course_code": "ENTM 204",
    "credit_hours": "2",
    "prerequisites": "ENTM 102"
  },
  {
    "level": "2",
    "type": "mandatory",
    "department": "Ø¹Ù„Ù… Ø§Ù„Ø­Ø´Ø±Ø§Øª",
    "course_name": "Ø§Ù„Ø­Ø´Ø±Ø§Øª Ø§Ù„Ø¥Ø¬ØªÙ…Ø§Ø¹ÙŠØ©",
    "course_code": "ENTM 206",
    "credit_hours": "1",
    "prerequisites": "ENTM 102"
  },
  {
    "level": "2",
    "type": "mandatory",
    "department": "Ø¹Ù„Ù… Ø§Ù„Ø­Ø´Ø±Ø§Øª",
    "course_name": "Ø£Ù…Ø±Ø§Ø¶ Ø­Ø´Ø±Ø§Øª ÙˆÙ…ÙƒØ§ÙØ­Ø© Ø­ÙŠÙˆÙŠØ©",
    "course_code": "ENTM 208",
    "credit_hours": "3",
    "prerequisites": "ENTM 102"
  },
  {
    "level": "2",
    "type": "mandatory",
    "department": "Ø¹Ù„Ù… Ø§Ù„Ø­Ø´Ø±Ø§Øª",
    "course_name": "ØµØ­Ø© Ø§Ù„Ù…Ø¬ØªÙ…Ø¹ ÙˆØ§Ù„Ø­Ø´Ø±Ø§Øª",
    "course_code": "ENTM 210",
    "credit_hours": "1",
    "prerequisites": "ENTM 102"
  },
  {
    "level": "2",
    "type": "mandatory",
    "department": "Ø¹Ù„Ù… Ø§Ù„Ø­Ø´Ø±Ø§Øª",
    "course_name": "Ø§Ù„ØªÙ‚Ù†ÙŠØ© ÙÙŠ Ø§Ù„Ø­Ø´Ø±Ø§Øª",
    "course_code": "ENTM 212",
    "credit_hours": "2",
    "prerequisites": "ENTM 102"
  },
  {
    "level": "2",
    "type": "mandatory",
    "department": "Ø§Ù„Ø¥Ø­ØµØ§Ø¡",
    "course_name": "Ø¥Ø­ØµØ§Ø¡ Ø­ÙŠÙˆÙŠ",
    "course_code": "STAT 212",
    "credit_hours": "3",
    "prerequisites": "-"
  },
  {
    "level": "2",
    "type": "elective",
    "department": "Ø¹Ù„Ù… Ø§Ù„Ø­Ø´Ø±Ø§Øª",
    "course_name": "Ù†Ø­Ù„ Ø§Ù„Ø¹Ø³Ù„",
    "course_code": "ENTM 214",
    "credit_hours": "1",
    "prerequisites": "-"
  },
  {
    "level": "2",
    "type": "elective",
    "department": "Ø¹Ù„Ù… Ø§Ù„Ø­Ø´Ø±Ø§Øª",
    "course_name": "Ø·Ø±Ù‚ Ø§Ù„ÙƒØªØ§Ø¨Ø© ÙˆØ§Ù„Ø¹Ø±Ø¶ Ø§Ù„Ø¹Ù„Ù…ÙŠ",
    "course_code": "ENTM 216",
    "credit_hours": "2",
    "prerequisites": "-"
  },
  {
    "level": "2",
    "type": "elective",
    "department": "Ø¹Ù„Ù… Ø§Ù„Ø­Ø´Ø±Ø§Øª",
    "course_name": "ØªØ¹Ø¯Ø¯ Ø§Ù„Ø£Ø´ÙƒØ§Ù„ ÙÙŠ Ø§Ù„Ø­Ø´Ø±Ø§Øª",
    "course_code": "ENTM 218",
    "credit_hours": "1",
    "prerequisites": "-"
  },
  {
    "level": "2",
    "type": "elective",
    "department": "Ø¹Ù„Ù… Ø§Ù„Ø­Ø´Ø±Ø§Øª",
    "course_name": "Ø¥ØµØ¯Ø§Ø± Ø§Ù„ØµÙˆØª ÙˆØ§Ù„Ø¶ÙˆØ¡ ÙÙŠ Ø§Ù„Ø­Ø´Ø±Ø§Øª",
    "course_code": "ENTM 220",
    "credit_hours": "1",
    "prerequisites": "-"
  },
  {
    "level": "2",
    "type": "elective",
    "department": "Ø¹Ù„Ù… Ø§Ù„Ø­Ø´Ø±Ø§Øª",
    "course_name": "Ø¥Ø¯Ø§Ø±Ø© Ø§Ù„Ø¬ÙˆØ¯Ø© Ø§Ù„Ø´Ø§Ù…Ù„Ø© ÙˆØ§Ù„Ù…Ø¹Ø§ÙŠÙŠØ± Ø§Ù„Ø¹Ø§Ù„Ù…ÙŠØ© Ù„Ø§Ø¹ØªÙ…Ø§Ø¯ Ø§Ù„Ù…Ø¹Ø§Ù…Ù„",
    "course_code": "ENTM 262",
    "credit_hours": "1",
    "prerequisites": "-"
  },

  // ========== Ø§Ù„Ù…Ø³ØªÙˆÙ‰ Ø§Ù„Ø«Ø§Ù„Ø« ==========
  {
    "level": "3",
    "type": "mandatory",
    "department": "Ù…ØªØ·Ù„Ø¨ Ø¬Ø§Ù…Ø¹Ø©",
    "course_name": "Ø§Ù„ØªÙÙƒÙŠØ± Ø§Ù„Ø¹Ù„Ù…ÙŠ",
    "course_code": "SCTH 301",
    "credit_hours": "1",
    "prerequisites": "-"
  },
  {
    "level": "3",
    "type": "mandatory",
    "department": "Ø¹Ù„Ù… Ø§Ù„Ø­Ø´Ø±Ø§Øª",
    "course_name": "Ø¨ÙŠØ¦Ø© Ø§Ù„Ø­Ø´Ø±Ø§Øª Ø§Ù„Ù…ØªÙ‚Ø¯Ù…Ø©",
    "course_code": "ENTM 301",
    "credit_hours": "2",
    "prerequisites": "ENTM 205"
  },
  {
    "level": "3",
    "type": "mandatory",
    "department": "Ø¹Ù„Ù… Ø§Ù„Ø­Ø´Ø±Ø§Øª",
    "course_name": "ØªØµÙ†ÙŠÙ Ø§Ù„Ø­Ø´Ø±Ø§Øª (2)",
    "course_code": "ENTM 303",
    "credit_hours": "3",
    "prerequisites": "ENTM 209"
  },
  {
    "level": "3",
    "type": "mandatory",
    "department": "Ø¹Ù„Ù… Ø§Ù„Ø­Ø´Ø±Ø§Øª",
    "course_name": "Ø­Ø´Ø±Ø§Øª Ø·Ø¨ÙŠØ© ÙˆØ¨ÙŠØ·Ø±ÙŠØ©",
    "course_code": "ENTM 305",
    "credit_hours": "4",
    "prerequisites": "ENTM 210"
  },
  {
    "level": "3",
    "type": "mandatory",
    "department": "Ø¹Ù„Ù… Ø§Ù„Ø­Ø´Ø±Ø§Øª",
    "course_name": "ØªØ·ÙˆØ± ÙˆØªÙƒÙˆÙŠÙ† Ø§Ù„Ø¹Ø´Ø§Ø¦Ø± ÙÙŠ Ø§Ù„Ø­Ø´Ø±Ø§Øª",
    "course_code": "ENTM 317",
    "credit_hours": "1",
    "prerequisites": "ENTM 209"
  },
  {
    "level": "3",
    "type": "mandatory",
    "department": "Ø§Ù„ÙÙŠØ²ÙŠØ§Ø¡ Ø§Ù„Ø­ÙŠÙˆÙŠØ©",
    "course_name": "ÙÙŠØ²ÙŠØ§Ø¡ Ø­ÙŠÙˆÙŠ",
    "course_code": "BIOP 313",
    "credit_hours": "3",
    "prerequisites": "-"
  },
  {
    "level": "3",
    "type": "elective",
    "department": "Ø¹Ù„Ù… Ø§Ù„Ø­Ø´Ø±Ø§Øª",
    "course_name": "Ø§Ù„ØªÙˆØ§ØµÙ„ ÙÙŠ Ø§Ù„Ø­Ø´Ø±Ø§Øª",
    "course_code": "ENTM 307",
    "credit_hours": "1",
    "prerequisites": "-"
  },
  {
    "level": "3",
    "type": "elective",
    "department": "Ø¹Ù„Ù… Ø§Ù„Ø­Ø´Ø±Ø§Øª",
    "course_name": "Ø¢ÙØ§Øª Ø§Ù„Ø­Ø¨ÙˆØ¨ Ø§Ù„Ù…Ø®Ø²Ù†Ø© ÙˆÙ…Ù†ØªØ¬Ø§ØªÙ‡Ø§",
    "course_code": "ENTM 309",
    "credit_hours": "2",
    "prerequisites": "-"
  },
  {
    "level": "3",
    "type": "elective",
    "department": "Ø¹Ù„Ù… Ø§Ù„Ø­Ø´Ø±Ø§Øª",
    "course_name": "Ø¹Ù„Ù… Ø§Ù„Ù‚Ø±Ø§Ø¯ÙŠØ§Øª",
    "course_code": "ENTM 311",
    "credit_hours": "2",
    "prerequisites": "-"
  },
  {
    "level": "3",
    "type": "elective",
    "department": "Ø¹Ù„Ù… Ø§Ù„Ø­Ø´Ø±Ø§Øª",
    "course_name": "Ù…Ø²Ø§Ø±Ø¹ Ø§Ù„Ø®Ù„Ø§ÙŠØ§ Ø§Ù„Ø­Ø´Ø±ÙŠØ©",
    "course_code": "ENTM 313",
    "credit_hours": "1",
    "prerequisites": "-"
  },
  {
    "level": "3",
    "type": "mandatory",
    "department": "Ù…ØªØ·Ù„Ø¨ Ø¬Ø§Ù…Ø¹Ø©",
    "course_name": "Ø£Ø®Ù„Ø§Ù‚ÙŠØ§Øª Ø§Ù„Ø¨Ø­Ø« Ø§Ù„Ø¹Ù„Ù…ÙŠ",
    "course_code": "ETHR 302",
    "credit_hours": "1",
    "prerequisites": "-"
  },
  {
    "level": "3",
    "type": "mandatory",
    "department": "Ø¹Ù„Ù… Ø§Ù„Ø­Ø´Ø±Ø§Øª",
    "course_name": "Ø­Ø´Ø±Ø§Øª Ø¥Ù‚ØªØµØ§Ø¯ÙŠØ©",
    "course_code": "ENTM 302",
    "credit_hours": "3",
    "prerequisites": "ENTM 204"
  },
  {
    "level": "3",
    "type": "mandatory",
    "department": "Ø¹Ù„Ù… Ø§Ù„Ø­Ø´Ø±Ø§Øª",
    "course_name": "Ø§Ù„Ø¬ÙˆØ§Ù†Ø¨ Ø­Ø´Ø±ÙŠØ© Ø§Ù„Ù…Ø¨Ù†ÙŠØ© Ø¹Ù„Ù‰ Ø£Ø³Ø³ ÙˆØ±Ø§Ø«ÙŠØ©",
    "course_code": "ENTM 304",
    "credit_hours": "3",
    "prerequisites": "ENTM 102"
  },
  {
    "level": "3",
    "type": "mandatory",
    "department": "Ø¹Ù„Ù… Ø§Ù„Ø­Ø´Ø±Ø§Øª",
    "course_name": "Ø¹Ù„Ù… Ø§Ù„Ø£Ø¬Ù†Ø© Ø§Ù„Ø­Ø´Ø±ÙŠØ©",
    "course_code": "ENTM 306",
    "credit_hours": "2",
    "prerequisites": "ENTM 203"
  },
  {
    "level": "3",
    "type": "mandatory",
    "department": "Ø§Ù„ÙƒÙŠÙ…ÙŠØ§Ø¡",
    "course_name": "ÙƒÙŠÙ…ÙŠØ§Ø¡ Ø¹Ø¶ÙˆÙŠØ© (Ù…Ø¨ÙŠØ¯Ø§Øª)",
    "course_code": "CHEM 310",
    "credit_hours": "3",
    "prerequisites": "CHEM 102"
  },
  {
    "level": "3",
    "type": "elective",
    "department": "Ø¹Ù„Ù… Ø§Ù„Ø­Ø´Ø±Ø§Øª",
    "course_name": "Ø§Ù„Ø¹Ù„Ø§Ø¬ Ø¨Ø§Ù„Ø­Ø´Ø±Ø§Øª",
    "course_code": "ENTM 308",
    "credit_hours": "2",
    "prerequisites": "-"
  },
  {
    "level": "3",
    "type": "elective",
    "department": "Ø¹Ù„Ù… Ø§Ù„Ø­Ø´Ø±Ø§Øª",
    "course_name": "Ø£Ø³Ø³ Ø¹Ù„Ù… ÙˆØ±Ø§Ø«ÙŠØ© Ø§Ù„Ø®Ù„ÙŠØ© Ø§Ù„Ø­Ø´Ø±ÙŠØ©",
    "course_code": "ENTM 312",
    "credit_hours": "2",
    "prerequisites": "-"
  },
  {
    "level": "3",
    "type": "elective",
    "department": "Ø¹Ù„Ù… Ø§Ù„Ø­Ø´Ø±Ø§Øª",
    "course_name": "Ø§Ù„ØªÙ†ÙˆØ¹ Ø§Ù„Ø­ÙŠÙˆÙŠ ÙˆØ§Ù„Ù…Ø­Ù…ÙŠØ§Øª",
    "course_code": "ENTM 314",
    "credit_hours": "1",
    "prerequisites": "-"
  },
  {
    "level": "3",
    "type": "elective",
    "department": "Ø¹Ù„Ù… Ø§Ù„Ø­Ø´Ø±Ø§Øª",
    "course_name": "Ø£Ø³Ø³ Ø¹Ù„Ù… Ø§Ù„Ø­ÙØ¸ Ø§Ù„Ø¨ÙŠÙˆÙ„ÙˆØ¬ÙŠ",
    "course_code": "ENTM 358",
    "credit_hours": "1",
    "prerequisites": "-"
  },

  // ========== Ø§Ù„Ù…Ø³ØªÙˆÙ‰ Ø§Ù„Ø±Ø§Ø¨Ø¹ ==========
  {
    "level": "4",
    "type": "elective",
    "department": "Ù…ØªØ·Ù„Ø¨ Ø¬Ø§Ù…Ø¹Ø© (Ø§Ø®ØªÙŠØ§Ø±ÙŠ)",
    "course_name": "Ù…Ù‡Ø§Ø±Ø§Øª Ø§Ù„Ø¹Ù…Ù„",
    "course_code": "SKIL 401",
    "credit_hours": "1",
    "prerequisites": "-"
  },
  {
    "level": "4",
    "type": "elective",
    "department": "Ù…ØªØ·Ù„Ø¨ Ø¬Ø§Ù…Ø¹Ø© (Ø§Ø®ØªÙŠØ§Ø±ÙŠ)",
    "course_name": "Ø«Ù‚Ø§ÙØ© Ø¨ÙŠØ¦ÙŠØ©",
    "course_code": "ENCU 401",
    "credit_hours": "1",
    "prerequisites": "-"
  },
  {
    "level": "4",
    "type": "elective",
    "department": "Ù…ØªØ·Ù„Ø¨ Ø¬Ø§Ù…Ø¹Ø© (Ø§Ø®ØªÙŠØ§Ø±ÙŠ)",
    "course_name": "Ù†Ø´Ø£Ø© ÙˆØªØ§Ø±ÙŠØ® ÙˆØªØ·ÙˆØ± Ø§Ù„Ø¹Ù„ÙˆÙ…",
    "course_code": "GHDS 401",
    "credit_hours": "1",
    "prerequisites": "-"
  },
  {
    "level": "4",
    "type": "mandatory",
    "department": "Ø¹Ù„Ù… Ø§Ù„Ø­Ø´Ø±Ø§Øª",
    "course_name": "ÙØ³ÙŠÙˆÙ„ÙˆØ¬ÙŠ Ø§Ù„Ø­Ø´Ø±Ø§Øª Ø§Ù„Ù…ØªÙ‚Ø¯Ù…",
    "course_code": "ENTM 401",
    "credit_hours": "5",
    "prerequisites": "ENTM 203"
  },
  {
    "level": "4",
    "type": "mandatory",
    "department": "Ø¹Ù„Ù… Ø§Ù„Ø­Ø´Ø±Ø§Øª",
    "course_name": "Ø¨ÙŠÙˆÙ„ÙˆØ¬ÙŠØ© Ø§Ù„Ø­Ø´Ø±Ø§Øª Ø§Ù„Ù‡Ù†Ø¯Ø³Ø© Ø§Ù„Ø¬Ø²ÙŠØ¦ÙŠØ© ÙˆØ§Ù„ÙˆØ±Ø§Ø«ÙŠØ©",
    "course_code": "ENTM 403",
    "credit_hours": "3",
    "prerequisites": "ENTM 304"
  },
  {
    "level": "4",
    "type": "mandatory",
    "department": "Ø¹Ù„Ù… Ø§Ù„Ø­Ø´Ø±Ø§Øª",
    "course_name": "Ø³Ù„ÙˆÙƒ Ø§Ù„Ø­Ø´Ø±Ø§Øª Ø§Ù„Ù…ØªÙ‚Ø¯Ù…",
    "course_code": "ENTM 405",
    "credit_hours": "1",
    "prerequisites": "ENTM 303"
  },
  {
    "level": "4",
    "type": "mandatory",
    "department": "Ø§Ù„Ù…ÙŠÙƒØ±ÙˆØ¨ÙŠÙˆÙ„ÙˆØ¬ÙŠØ§",
    "course_name": "Ù…ÙŠÙƒØ±ÙˆØ¨ÙŠÙˆÙ„ÙˆØ¬ÙŠØ§ ØªØ´Ø®ÙŠØµÙŠØ©",
    "course_code": "MICR 485",
    "credit_hours": "3",
    "prerequisites": "-"
  },
  {
    "level": "4",
    "type": "elective",
    "department": "Ø¹Ù„Ù… Ø§Ù„Ø­Ø´Ø±Ø§Øª",
    "course_name": "Ø§Ù„Ø¥Ø³ØªØ®Ø¯Ø§Ù… Ø§Ù„Ø¢Ù…Ù† Ù„Ù„Ù…Ø¨ÙŠØ¯Ø§Øª",
    "course_code": "ENTM 409",
    "credit_hours": "2",
    "prerequisites": "-"
  },
  {
    "level": "4",
    "type": "elective",
    "department": "Ø¹Ù„Ù… Ø§Ù„Ø­Ø´Ø±Ø§Øª",
    "course_name": "Ø§Ù„Ù…Ù†Ø§Ø¹Ø© ÙÙŠ Ø§Ù„Ø­Ø´Ø±Ø§Øª",
    "course_code": "ENTM 411",
    "credit_hours": "1",
    "prerequisites": "-"
  },
  {
    "level": "4",
    "type": "elective",
    "department": "Ø¹Ù„Ù… Ø§Ù„Ø­Ø´Ø±Ø§Øª",
    "course_name": "ÙˆØ±Ø§Ø«Ø© Ø§Ù„Ø¹Ø´Ø§Ø¦Ø±",
    "course_code": "ENTM 413",
    "credit_hours": "1",
    "prerequisites": "-"
  },
  {
    "level": "4",
    "type": "elective",
    "department": "Ø¹Ù„Ù… Ø§Ù„Ø­Ø´Ø±Ø§Øª",
    "course_name": "Ø§Ù„Ø­Ø´Ø±Ø§Øª ÙÙŠ Ø§Ù„Ø·Ø¨ Ø§Ù„Ø´Ø±Ø¹ÙŠ",
    "course_code": "ENTM 459",
    "credit_hours": "2",
    "prerequisites": "-"
  },
  {
    "level": "4",
    "type": "mandatory",
    "department": "Ø¹Ù„Ù… Ø§Ù„Ø­Ø´Ø±Ø§Øª",
    "course_name": "Ù…Ø¨ÙŠØ¯Ø§Øª Ø­Ø´Ø±ÙŠØ© ÙˆÙ…Ù‚Ø§ÙˆÙ…Ø©",
    "course_code": "ENTM 402",
    "credit_hours": "5",
    "prerequisites": "ENTM 202"
  },
  {
    "level": "4",
    "type": "mandatory",
    "department": "Ø¹Ù„Ù… Ø§Ù„Ø­Ø´Ø±Ø§Øª",
    "course_name": "Ø¥Ø¯Ø§Ø±Ø© Ø§Ù„Ù…ÙƒØ§ÙØ­Ø© Ø§Ù„Ù…ØªÙƒØ§Ù…Ù„Ø©",
    "course_code": "ENTM 404",
    "credit_hours": "2",
    "prerequisites": "ENTM 202"
  },
  {
    "level": "4",
    "type": "mandatory",
    "department": "Ø¹Ù„Ù… Ø§Ù„Ø­Ø´Ø±Ø§Øª",
    "course_name": "Ø¯ÙŠÙ†Ø§Ù…ÙŠÙƒØ§ Ø§Ù„Ø¹Ø´Ø§Ø¦Ø± Ø§Ù„Ù…ØªÙ‚Ø¯Ù…",
    "course_code": "ENTM 406",
    "credit_hours": "1",
    "prerequisites": "ENTM 301"
  },
  {
    "level": "4",
    "type": "mandatory",
    "department": "Ø¹Ù„Ù… Ø§Ù„Ø­Ø´Ø±Ø§Øª",
    "course_name": "Ù…Ù‚Ø§Ù„",
    "course_code": "ENTM 408",
    "credit_hours": "2",
    "prerequisites": "-"
  },
  {
    "level": "4",
    "type": "mandatory",
    "department": "Ø¹Ù„Ù… Ø§Ù„Ø­Ø´Ø±Ø§Øª",
    "course_name": "ØªØ®Ø·ÙŠØ· Ø¨Ø±Ø§Ù…Ø¬ Ø¥Ø¯Ø§Ø±Ø© Ø§Ù„Ø¢ÙØ§Øª",
    "course_code": "ENTM 410",
    "credit_hours": "1",
    "prerequisites": "ENTM 202"
  },
  {
    "level": "4",
    "type": "mandatory",
    "department": "Ø§Ù„Ø¥Ø­ØµØ§Ø¡",
    "course_name": "Ø¥Ø­ØµØ§Ø¡ ÙˆØ¨Ø±Ù…Ø¬Ø©",
    "course_code": "STAT 420",
    "credit_hours": "3",
    "prerequisites": "STAT 212"
  },
];

class EntomologyCoursesScreen extends StatefulWidget {
  const EntomologyCoursesScreen({super.key});
  @override
  State<EntomologyCoursesScreen> createState() =>
      _EntomologyCoursesScreenState();
}

class _EntomologyCoursesScreenState extends State<EntomologyCoursesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _filterType = 'all';

  static const _levels = ['1', '2', '3', '4'];
  static const _levelNames = ['Ø§Ù„Ø£ÙˆÙ„Ù‰', 'Ø§Ù„Ø«Ø§Ù†ÙŠØ©', 'Ø§Ù„Ø«Ø§Ù„Ø«Ø©', 'Ø§Ù„Ø±Ø§Ø¨Ø¹Ø©'];
  static const _levelLabels = [
    'Ø§Ù„Ù…Ø³ØªÙˆÙ‰ Ø§Ù„Ø£ÙˆÙ„',
    'Ø§Ù„Ù…Ø³ØªÙˆÙ‰ Ø§Ù„Ø«Ø§Ù†ÙŠ',
    'Ø§Ù„Ù…Ø³ØªÙˆÙ‰ Ø§Ù„Ø«Ø§Ù„Ø«',
    'Ø§Ù„Ù…Ø³ØªÙˆÙ‰ Ø§Ù„Ø±Ø§Ø¨Ø¹',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _levels.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Map<String, String>> _getCourses(String level) => _courses.where((c) {
        if (c['level'] != level) return false;
        if (_filterType != 'all' && c['type'] != _filterType) return false;
        return true;
      }).toList();

  int _totalHours(String level) => _getCourses(level)
      .fold(0, (s, c) => s + (int.tryParse(c['credit_hours'] ?? '0') ?? 0));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        title: const Text('Ø¹Ù„Ù… Ø§Ù„Ø­Ø´Ø±Ø§Øª â€“ Ù…Ù†ÙØ±Ø¯',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
        centerTitle: true,
        backgroundColor: const Color(0xFF1E3A5F),
        foregroundColor: Colors.white,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.amber,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          labelStyle:
              const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          unselectedLabelStyle: const TextStyle(fontSize: 12),
          tabs: List.generate(
              _levels.length, (i) => Tab(text: 'Ø§Ù„Ø³Ù†Ø© ${_levelNames[i]}')),
        ),
      ),
      body: Column(
        children: [
          _buildFilterBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: List.generate(_levels.length,
                  (i) => _buildPage(_levels[i], _levelLabels[i])),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar() {
    return Container(
      color: const Color(0xFF1E3A5F),
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _Chip(
              label: 'Ø§Ù„ÙƒÙ„',
              selected: _filterType == 'all',
              color: const Color(0xFF64748B),
              onTap: () => setState(() => _filterType = 'all')),
          const SizedBox(width: 8),
          _Chip(
              label: 'Ø¥Ø¬Ø¨Ø§Ø±ÙŠ',
              selected: _filterType == 'mandatory',
              color: const Color(0xFF059669),
              onTap: () => setState(() => _filterType = 'mandatory')),
          const SizedBox(width: 8),
          _Chip(
              label: 'Ø§Ø®ØªÙŠØ§Ø±ÙŠ',
              selected: _filterType == 'elective',
              color: const Color(0xFFD97706),
              onTap: () => setState(() => _filterType = 'elective')),
        ],
      ),
    );
  }

  Widget _buildPage(String level, String label) {
    final courses = _getCourses(level);
    final totalHours = _totalHours(level);

    if (courses.isEmpty) {
      return Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(Icons.search_off, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text('Ù„Ø§ ØªÙˆØ¬Ø¯ Ù…Ù‚Ø±Ø±Ø§Øª Ù„Ù‡Ø°Ø§ Ø§Ù„ÙÙ„ØªØ±',
              style: TextStyle(color: Colors.grey[500], fontSize: 16)),
        ]),
      );
    }

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1E3A5F), Color(0xFF2563EB)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                      color: const Color(0xFF1E3A5F).withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4))
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(label,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text('${courses.length} Ù…Ù‚Ø±Ø±',
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 14)),
                      ]),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(children: [
                      Text('$totalHours',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold)),
                      const Text('Ø³Ø§Ø¹Ø©',
                          style:
                              TextStyle(color: Colors.white70, fontSize: 12)),
                    ]),
                  ),
                ],
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _CourseCard(course: courses[index])),
              childCount: courses.length,
            ),
          ),
        ),
      ],
    );
  }
}

class _CourseCard extends StatelessWidget {
  final Map<String, String> course;
  const _CourseCard({required this.course});

  Color get _accentColor {
    final dept = course['department'] ?? '';
    if (dept.contains('Ø§Ù„Ø­Ø´Ø±Ø§Øª') || dept.contains('ENTM')) {
      return const Color(0xFF1E3A5F);
    }
    if (dept.contains('Ø§Ù„Ø­ÙŠÙˆØ§Ù†') || dept.contains('ZOOL')) {
      return const Color(0xFF059669);
    }
    if (dept.contains('Ø§Ù„ÙƒÙŠÙ…ÙŠØ§Ø¡ Ø§Ù„Ø­ÙŠÙˆÙŠØ©') || dept.contains('BIOC')) {
      return const Color(0xFF065F46);
    }
    if (dept.contains('Ø§Ù„ÙƒÙŠÙ…ÙŠØ§Ø¡') || dept.contains('CHEM')) {
      return const Color(0xFF7C3AED);
    }
    if (dept.contains('Ø§Ù„Ù†Ø¨Ø§Øª') || dept.contains('BOTA')) {
      return const Color(0xFF16A34A);
    }
    if (dept.contains('ÙÙŠØ²ÙŠØ§Ø¡') ||
        dept.contains('PHYS') ||
        dept.contains('BIOP')) {
      return const Color(0xFFDC2626);
    }
    if (dept.contains('Ø±ÙŠØ§Ø¶ÙŠØ§Øª') || dept.contains('MATH')) {
      return const Color(0xFF2563EB);
    }
    if (dept.contains('Ø¥Ø­ØµØ§Ø¡') || dept.contains('STAT')) {
      return const Color(0xFF0284C7);
    }
    if (dept.contains('Ù…ÙŠÙƒØ±ÙˆØ¨ÙŠÙˆÙ„ÙˆØ¬ÙŠØ§') || dept.contains('MICR')) {
      return const Color(0xFF6D28D9);
    }
    return const Color(0xFF64748B);
  }

  @override
  Widget build(BuildContext context) {
    final isElective = course['type'] == 'elective';
    final typeColor =
        isElective ? const Color(0xFFD97706) : const Color(0xFF059669);
    final typeLabel = isElective ? 'Ø§Ø®ØªÙŠØ§Ø±ÙŠ' : 'Ø¥Ø¬Ø¨Ø§Ø±ÙŠ';
    final hasPrereq =
        course['prerequisites'] != null && course['prerequisites'] != '-';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border(right: BorderSide(color: _accentColor, width: 4)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2))
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: typeColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(typeLabel,
                  style: TextStyle(
                      color: typeColor,
                      fontSize: 11,
                      fontWeight: FontWeight.bold)),
            ),
            Text(course['course_code'] ?? '',
                style: TextStyle(
                    color: _accentColor,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5)),
          ]),
          const SizedBox(height: 10),
          Text(course['course_name'] ?? '',
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827))),
          const SizedBox(height: 6),
          Text(course['department'] ?? '',
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
          const SizedBox(height: 12),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            if (hasPrereq)
              Flexible(
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                const Icon(Icons.link, size: 14, color: Color(0xFF9CA3AF)),
                const SizedBox(width: 4),
                Flexible(
                    child: Text(course['prerequisites'] ?? '',
                        style: const TextStyle(
                            fontSize: 11, color: Color(0xFF9CA3AF)),
                        overflow: TextOverflow.ellipsis)),
              ]))
            else
              const SizedBox.shrink(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(children: [
                const Icon(Icons.access_time,
                    size: 13, color: Color(0xFF64748B)),
                const SizedBox(width: 4),
                Text('${course['credit_hours']} Ø³Ø§Ø¹Ø©',
                    style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF374151),
                        fontWeight: FontWeight.w600)),
              ]),
            ),
          ]),
        ]),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final bool selected;
  final Color color;
  final VoidCallback onTap;
  const _Chip(
      {required this.label,
      required this.selected,
      required this.color,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
        decoration: BoxDecoration(
          color: selected ? color : Colors.white.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: selected ? color : Colors.white30),
        ),
        child: Text(label,
            style: TextStyle(
                color: selected ? Colors.white : Colors.white70,
                fontWeight: FontWeight.w600,
                fontSize: 13)),
      ),
    );
  }
}
