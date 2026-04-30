import 'package:flutter/material.dart';

const List<Map<String, String>> _courses = [
  // ========== Ø§Ù„Ù…Ø³ØªÙˆÙ‰ Ø§Ù„Ø£ÙˆÙ„ ==========
  {
    "level": "1",
    "type": "mandatory",
    "department": "Ù…ØªØ·Ù„Ø¨Ø§Øª Ø¬Ø§Ù…Ø¹Ø©",
    "course_name": "Ø§Ù„Ø£Ù…Ù† ÙˆØ§Ù„Ø³Ù„Ø§Ù…Ø©",
    "course_code": "SAFS 101",
    "credit_hours": "1",
    "prerequisites": "-"
  },
  {
    "level": "1",
    "type": "mandatory",
    "department": "Ù…ØªØ·Ù„Ø¨Ø§Øª Ø¬Ø§Ù…Ø¹Ø©",
    "course_name": "Ø­Ù‚ÙˆÙ‚ Ø§Ù„Ø¥Ù†Ø³Ø§Ù†",
    "course_code": "HURI 101",
    "credit_hours": "1",
    "prerequisites": "-"
  },
  {
    "level": "1",
    "type": "mandatory",
    "department": "Ø§Ù„Ø±ÙŠØ§Ø¶ÙŠØ§Øª (Ù…ØªØ·Ù„Ø¨Ø§Øª ÙƒÙ„ÙŠØ©)",
    "course_name": "ØªÙØ§Ø¶Ù„ ÙˆØªÙƒØ§Ù…Ù„ (1)",
    "course_code": "MATH 101",
    "credit_hours": "4",
    "prerequisites": "-"
  },
  {
    "level": "1",
    "type": "mandatory",
    "department": "Ø§Ù„ÙÙŠØ²ÙŠØ§Ø¡ (Ù…ØªØ·Ù„Ø¨Ø§Øª ÙƒÙ„ÙŠØ©)",
    "course_name": "ÙÙŠØ²ÙŠØ§Ø¡ Ø¹Ø§Ù…Ø© (1)",
    "course_code": "PHYS 101",
    "credit_hours": "4",
    "prerequisites": "-"
  },
  {
    "level": "1",
    "type": "mandatory",
    "department": "Ø§Ù„ÙƒÙŠÙ…ÙŠØ§Ø¡ (Ù…ØªØ·Ù„Ø¨Ø§Øª ÙƒÙ„ÙŠØ©)",
    "course_name": "ÙƒÙŠÙ…ÙŠØ§Ø¡ Ø¹Ø§Ù…Ø© (1)",
    "course_code": "CHEM 101",
    "credit_hours": "3",
    "prerequisites": "-"
  },
  {
    "level": "1",
    "type": "mandatory",
    "department": "Ø§Ù„ÙƒÙŠÙ…ÙŠØ§Ø¡ (Ù…ØªØ·Ù„Ø¨Ø§Øª ÙƒÙ„ÙŠØ©)",
    "course_name": "Ø¹Ù…Ù„ÙŠ ÙƒÙŠÙ…ÙŠØ§Ø¡ Ø¹Ø§Ù…Ø© (1)",
    "course_code": "CHEM 103",
    "credit_hours": "1",
    "prerequisites": "-"
  },
  {
    "level": "1",
    "type": "mandatory",
    "department": "Ø§Ù„Ù†Ø¨Ø§Øª",
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
    "department": "Ù…ØªØ·Ù„Ø¨Ø§Øª Ø¬Ø§Ù…Ø¹Ø©",
    "course_name": "Ù„ØºØ© Ø¥Ù†Ø¬Ù„ÙŠØ²ÙŠØ© (1)",
    "course_code": "ENGL 102",
    "credit_hours": "2",
    "prerequisites": "-"
  },
  {
    "level": "1",
    "type": "mandatory",
    "department": "Ù…ØªØ·Ù„Ø¨Ø§Øª Ø¬Ø§Ù…Ø¹Ø©",
    "course_name": "Ù…Ø¯Ø®Ù„ ÙÙŠ Ø§Ù„Ø­Ø§Ø³Ø¨ Ø§Ù„Ø¢Ù„ÙŠ",
    "course_code": "INCO 102",
    "credit_hours": "1",
    "prerequisites": "-"
  },
  {
    "level": "1",
    "type": "mandatory",
    "department": "Ø§Ù„ÙƒÙŠÙ…ÙŠØ§Ø¡ (Ù…ØªØ·Ù„Ø¨Ø§Øª ÙƒÙ„ÙŠØ©)",
    "course_name": "ÙƒÙŠÙ…ÙŠØ§Ø¡ (2)",
    "course_code": "CHEM 102",
    "credit_hours": "3",
    "prerequisites": "-"
  },
  {
    "level": "1",
    "type": "mandatory",
    "department": "Ø§Ù„ÙƒÙŠÙ…ÙŠØ§Ø¡ (Ù…ØªØ·Ù„Ø¨Ø§Øª ÙƒÙ„ÙŠØ©)",
    "course_name": "Ø¹Ù…Ù„ÙŠ ÙƒÙŠÙ…ÙŠØ§Ø¡ Ø¹Ø§Ù…Ø© (2)",
    "course_code": "CHEM 104",
    "credit_hours": "1",
    "prerequisites": "-"
  },
  {
    "level": "1",
    "type": "mandatory",
    "department": "Ø§Ù„Ù†Ø¨Ø§Øª",
    "course_name": "Ø£Ø³Ø§Ø³ÙŠØ§Øª Ø¹Ù„Ù… Ø§Ù„Ù†Ø¨Ø§Øª (2)",
    "course_code": "BOTA 102",
    "credit_hours": "3",
    "prerequisites": "-"
  },
  // ========== Ø§Ù„Ù…Ø³ØªÙˆÙ‰ Ø§Ù„Ø«Ø§Ù†ÙŠ ==========
  {
    "level": "2",
    "type": "mandatory",
    "department": "Ù…ØªØ·Ù„Ø¨Ø§Øª Ø¬Ø§Ù…Ø¹Ø©",
    "course_name": "Ù„ØºØ© Ø¥Ù†Ø¬Ù„ÙŠØ²ÙŠØ© (2)",
    "course_code": "ENGL 201",
    "credit_hours": "2",
    "prerequisites": "ENGL 102"
  },
  {
    "level": "2",
    "type": "mandatory",
    "department": "Ø§Ù„Ù†Ø¨Ø§Øª",
    "course_name": "ØªØ´Ø±ÙŠØ­ Ù†Ø¨Ø§Øª",
    "course_code": "BOTA 201",
    "credit_hours": "2",
    "prerequisites": "BOTA 101"
  },
  {
    "level": "2",
    "type": "mandatory",
    "department": "Ø§Ù„Ù†Ø¨Ø§Øª",
    "course_name": "ÙØ³ÙŠÙˆÙ„ÙˆØ¬ÙŠØ§ Ø§Ù„Ø¹Ù„Ø§Ù‚Ø§Øª Ø§Ù„Ù…Ø§Ø¦ÙŠØ© ÙÙŠ Ø§Ù„Ù†Ø¨Ø§Øª",
    "course_code": "BOTA 203",
    "credit_hours": "2",
    "prerequisites": "BOTA 102"
  },
  {
    "level": "2",
    "type": "mandatory",
    "department": "Ø§Ù„Ù†Ø¨Ø§Øª",
    "course_name": "Ø§Ù„Ù†Ø¸Ù… Ø§Ù„Ø¨ÙŠØ¦ÙŠØ©",
    "course_code": "BOTA 205",
    "credit_hours": "2",
    "prerequisites": "BOTA 102"
  },
  {
    "level": "2",
    "type": "mandatory",
    "department": "Ø§Ù„ÙÙŠØ²ÙŠØ§Ø¡ Ø§Ù„Ø­ÙŠÙˆÙŠØ©",
    "course_name": "Ø£Ø³Ø§Ø³ÙŠØ§Øª Ø§Ù„ÙÙŠØ²ÙŠØ§Ø¡ Ø§Ù„Ø­ÙŠÙˆÙŠØ©",
    "course_code": "BIOP 213",
    "credit_hours": "2",
    "prerequisites": "PHYS 101"
  },
  {
    "level": "2",
    "type": "mandatory",
    "department": "Ø§Ù„Ø¬ÙŠÙˆÙ„ÙˆØ¬ÙŠØ§",
    "course_name": "Ù…Ù‚Ø¯Ù…Ø© ÙÙŠ Ø§Ù„Ø¬ÙŠÙˆÙ„ÙˆØ¬ÙŠØ§",
    "course_code": "GEOL 255",
    "credit_hours": "2",
    "prerequisites": "-"
  },
  {
    "level": "2",
    "type": "mandatory",
    "department": "Ø§Ù„Ù†Ø¨Ø§Øª",
    "course_name": "Ø£Ø³Ø§Ø³ÙŠØ§Øª Ø¹Ù„Ù… Ø§Ù„ØªØµÙ†ÙŠÙ",
    "course_code": "BOTA 202",
    "credit_hours": "2",
    "prerequisites": "-"
  },
  {
    "level": "2",
    "type": "mandatory",
    "department": "Ø§Ù„Ù†Ø¨Ø§Øª",
    "course_name": "Ø£Ø±Ø´ÙŠØ¬ÙˆÙ†ÙŠØ§Øª",
    "course_code": "BOTA 204",
    "credit_hours": "3",
    "prerequisites": "-"
  },
  {
    "level": "2",
    "type": "mandatory",
    "department": "Ø§Ù„Ù†Ø¨Ø§Øª",
    "course_name": "Ø·Ø­Ø§Ù„Ø¨",
    "course_code": "BOTA 206",
    "credit_hours": "2",
    "prerequisites": "-"
  },
  {
    "level": "2",
    "type": "mandatory",
    "department": "Ø§Ù„Ù†Ø¨Ø§Øª",
    "course_name": "Ø¹Ù„Ù… Ø­Ø¨ÙˆØ¨ Ø§Ù„Ù„Ù‚Ø§Ø­ Ø§Ù„ØªØ·Ø¨ÙŠÙ‚ÙŠ",
    "course_code": "BOTA 208",
    "credit_hours": "2",
    "prerequisites": "-"
  },
  {
    "level": "2",
    "type": "mandatory",
    "department": "Ø§Ù„Ù…ÙŠÙƒØ±ÙˆØ¨ÙŠÙˆÙ„ÙˆØ¬ÙŠ",
    "course_name": "Ù…ÙŠÙƒØ±ÙˆØ¨ÙŠÙˆÙ„ÙˆØ¬ÙŠ (2)",
    "course_code": "MICR 202",
    "credit_hours": "3",
    "prerequisites": "MICR 102"
  },
  {
    "level": "2",
    "type": "mandatory",
    "department": "Ø§Ù„ÙƒÙŠÙ…ÙŠØ§Ø¡",
    "course_name": "ÙƒÙŠÙ…ÙŠØ§Ø¡ ÙÙŠØ²ÙŠØ§Ø¦ÙŠØ©",
    "course_code": "CHEM 204",
    "credit_hours": "2",
    "prerequisites": "CHEM 102"
  },
  // ========== Ø§Ù„Ù…Ø³ØªÙˆÙ‰ Ø§Ù„Ø«Ø§Ù„Ø« ==========
  {
    "level": "3",
    "type": "mandatory",
    "department": "Ù…ØªØ·Ù„Ø¨Ø§Øª Ø¬Ø§Ù…Ø¹Ø©",
    "course_name": "Ø§Ù„ØªÙÙƒÙŠØ± Ø§Ù„Ø¹Ù„Ù…ÙŠ",
    "course_code": "SCTH 301",
    "credit_hours": "1",
    "prerequisites": "-"
  },
  {
    "level": "3",
    "type": "mandatory",
    "department": "Ù…ØªØ·Ù„Ø¨Ø§Øª Ø¬Ø§Ù…Ø¹Ø©",
    "course_name": "Ø£Ø®Ù„Ø§Ù‚ÙŠØ§Øª Ø§Ù„Ø¨Ø­Ø« Ø§Ù„Ø¹Ù„Ù…ÙŠ",
    "course_code": "ETHR 302",
    "credit_hours": "1",
    "prerequisites": "-"
  },
  {
    "level": "3",
    "type": "mandatory",
    "department": "Ø§Ù„Ù†Ø¨Ø§Øª",
    "course_name": "ÙØ³ÙŠÙˆÙ„ÙˆØ¬ÙŠØ§ Ø§Ù„Ù†Ù…Ùˆ ÙˆØ§Ù„Ù‡Ø±Ù…ÙˆÙ†Ø§Øª Ø§Ù„Ù†Ø¨Ø§ØªÙŠØ© ÙˆØªØ·Ø¨ÙŠÙ‚Ø§ØªÙ‡Ø§ Ø§Ù„ØªÙƒÙ†ÙˆÙ„ÙˆØ¬ÙŠØ©",
    "course_code": "BOTA 301",
    "credit_hours": "3",
    "prerequisites": "-"
  },
  {
    "level": "3",
    "type": "mandatory",
    "department": "Ø§Ù„Ù†Ø¨Ø§Øª",
    "course_name": "Ø­ÙØ±ÙŠØ§Øª Ù†Ø¨Ø§ØªÙŠØ©",
    "course_code": "BOTA 303",
    "credit_hours": "2",
    "prerequisites": "BOTA 204"
  },
  {
    "level": "3",
    "type": "mandatory",
    "department": "Ø§Ù„Ù†Ø¨Ø§Øª",
    "course_name": "ÙˆØ±Ø§Ø«Ø© Ø¬Ø²ÙŠØ¦ÙŠØ©",
    "course_code": "BOTA 305",
    "credit_hours": "2",
    "prerequisites": "BOTA 207"
  },
  {
    "level": "3",
    "type": "mandatory",
    "department": "Ø§Ù„Ù†Ø¨Ø§Øª",
    "course_name": "Ø²Ø±Ø§Ø¹Ø© Ø§Ù„Ø£Ù†Ø³Ø¬Ø© Ø§Ù„Ù†Ø¨Ø§ØªÙŠØ© ÙˆØªØ·Ø¨ÙŠÙ‚Ø§ØªÙ‡Ø§ Ø§Ù„ØªÙƒÙ†ÙˆÙ„ÙˆØ¬ÙŠØ©",
    "course_code": "BOTA 307",
    "credit_hours": "3",
    "prerequisites": "-"
  },
  {
    "level": "3",
    "type": "mandatory",
    "department": "Ø§Ù„Ø¥Ø­ØµØ§Ø¡",
    "course_name": "Ø¥Ø­ØµØ§Ø¡ Ø­ÙŠÙˆÙŠ",
    "course_code": "STAT 321",
    "credit_hours": "2",
    "prerequisites": "STAT 209"
  },
  {
    "level": "3",
    "type": "mandatory",
    "department": "Ø§Ù„Ù†Ø¨Ø§Øª",
    "course_name":
        "Ø§Ù„Ø®ØµØ§Ø¦Øµ Ø§Ù„Ø¬Ø²ÙŠØ¦ÙŠØ© ÙˆØ§Ù„ÙˆØ¸ÙŠÙÙŠØ© Ù„Ù„Ø§Ù†ØªÙ‚Ø§Ù„ ÙÙŠ Ø§Ù„Ù†Ø¨Ø§Øª â€“ ØªØºØ°ÙŠØ© Ù…Ø¹Ø¯Ù†ÙŠØ©",
    "course_code": "BOTA 302",
    "credit_hours": "3",
    "prerequisites": "BOTA 203"
  },
  {
    "level": "3",
    "type": "mandatory",
    "department": "Ø§Ù„Ù†Ø¨Ø§Øª",
    "course_name": "Ø§Ù„Ù…Ø¬ØªÙ…Ø¹Ø§Øª Ø§Ù„Ù†Ø¨Ø§ØªÙŠØ© â€“ Ø§Ù„ØªÙƒÙ†ÙˆÙ„ÙˆØ¬ÙŠØ§ Ø§Ù„Ø­ÙŠÙˆÙŠØ© Ø§Ù„Ø¨ÙŠØ¦ÙŠØ©",
    "course_code": "BOTA 312",
    "credit_hours": "2",
    "prerequisites": "BOTA 205"
  },
  {
    "level": "3",
    "type": "mandatory",
    "department": "Ø§Ù„Ù†Ø¨Ø§Øª",
    "course_name": "Ø·Ø­Ø§Ù„Ø¨ Ø§Ù„Ù…ÙŠØ§Ù‡ Ø§Ù„Ø¹Ø°Ø¨Ø© ÙˆØ§Ù„Ù…Ø§Ù„Ø­Ø© ÙÙŠ Ù…ØµØ±",
    "course_code": "BOTA 306",
    "credit_hours": "2",
    "prerequisites": "BOTA 206"
  },
  {
    "level": "3",
    "type": "mandatory",
    "department": "Ø§Ù„Ù†Ø¨Ø§Øª",
    "course_name": "Ø§Ù„Ù…Ø¹Ù„ÙˆÙ…Ø§ØªÙŠØ© Ø§Ù„Ø­ÙŠÙˆÙŠØ© ÙˆØ§Ù„Ø¥Ø­ØµØ§Ø¡ Ø§Ù„Ø­ÙŠÙˆÙŠ Ù„ØªØ­Ù„ÙŠÙ„ Ø§Ù„Ø¯Ù†Ø§ ÙˆØ§Ù„Ø¨Ø±ÙˆØªÙŠÙ†",
    "course_code": "BOTA 308",
    "credit_hours": "2",
    "prerequisites": "BOTA 209"
  },
  {
    "level": "3",
    "type": "mandatory",
    "department": "Ø§Ù„Ù†Ø¨Ø§Øª",
    "course_name": "ØªÙØ§Ø¹Ù„ Ø§Ù„Ø¨Ù„Ù…Ø±Ø© Ø§Ù„Ù…ØªØ³Ù„Ø³Ù„ â€“ Ø§Ù„Ø£Ø³Ø§Ø³ÙŠØ§Øª ÙˆØ§Ù„ØªØ·Ø¨ÙŠÙ‚Ø§Øª",
    "course_code": "BOTA 310",
    "credit_hours": "2",
    "prerequisites": "BOTA 209"
  },
  {
    "level": "3",
    "type": "mandatory",
    "department": "Ø§Ù„Ù…ÙŠÙƒØ±ÙˆØ¨ÙŠÙˆÙ„ÙˆØ¬ÙŠ",
    "course_name": "Ø§Ù„Ù…ÙŠÙƒØ±ÙˆØ¨ÙŠÙˆÙ„ÙˆØ¬ÙŠ Ø§Ù„ØªØ·Ø¨ÙŠÙ‚ÙŠ",
    "course_code": "MICR 388",
    "credit_hours": "2",
    "prerequisites": "MICR 101"
  },
  // ========== Ø§Ù„Ù…Ø³ØªÙˆÙ‰ Ø§Ù„Ø±Ø§Ø¨Ø¹ ==========
  {
    "level": "4",
    "type": "elective",
    "department": "Ù…ØªØ·Ù„Ø¨Ø§Øª Ø¬Ø§Ù…Ø¹Ø© (Ø§Ø®ØªÙŠØ§Ø±ÙŠ)",
    "course_name": "Ù…Ù‡Ø§Ø±Ø§Øª Ø§Ù„Ø¹Ù…Ù„ / Ø«Ù‚Ø§ÙØ© Ø¨ÙŠØ¦ÙŠØ© / ØªØ§Ø±ÙŠØ® Ø§Ù„Ø¹Ù„ÙˆÙ…",
    "course_code": "SKIL 401",
    "credit_hours": "1",
    "prerequisites": "-"
  },
  {
    "level": "4",
    "type": "mandatory",
    "department": "Ø§Ù„Ù†Ø¨Ø§Øª",
    "course_name": "Ø£Ø³Ø³ Ø¹Ù„Ù… Ø§Ù„Ø¥Ù†Ø²ÙŠÙ…Ø§Øª ÙˆØªØ·Ø¨ÙŠÙ‚Ø§ØªÙ‡Ø§ Ø§Ù„ØªÙƒÙ†ÙˆÙ„ÙˆØ¬ÙŠØ©",
    "course_code": "BOTA 401",
    "credit_hours": "3",
    "prerequisites": "-"
  },
  {
    "level": "4",
    "type": "mandatory",
    "department": "Ø§Ù„Ù†Ø¨Ø§Øª",
    "course_name": "Ù‡Ù†Ø¯Ø³Ø© Ø§Ù„Ø¨Ø±ÙˆØªÙŠÙ† â€“ Ø§Ù„Ù…Ø³Ø§Ø±Ø§Øª ÙˆØ§Ù„ØªÙØ§Ø¹Ù„Ø§Øª",
    "course_code": "BOTA 403",
    "credit_hours": "2",
    "prerequisites": "BOTA 207"
  },
  {
    "level": "4",
    "type": "mandatory",
    "department": "Ø§Ù„Ù†Ø¨Ø§Øª",
    "course_name": "ØªÙƒÙ†ÙˆÙ„ÙˆØ¬ÙŠØ§ Ø§Ù„Ø·Ø­Ø§Ù„Ø¨",
    "course_code": "BOTA 405",
    "credit_hours": "2",
    "prerequisites": "BOTA 306"
  },
  {
    "level": "4",
    "type": "mandatory",
    "department": "Ø§Ù„Ù†Ø¨Ø§Øª",
    "course_name": "Ø§Ù„ØªØµÙ†ÙŠÙØ§Øª Ø§Ù„Ø­Ø¯ÙŠØ«Ø© Ù„Ù„Ù†Ø¨Ø§ØªØ§Øª Ø§Ù„Ø²Ù‡Ø±ÙŠØ© â€“ Ù†Ø¨Ø§ØªØ§Øª Ø·Ø¨ÙŠØ© ÙˆØ¹Ø·Ø±ÙŠØ©",
    "course_code": "BOTA 407",
    "credit_hours": "3",
    "prerequisites": "BOTA 304"
  },
  {
    "level": "4",
    "type": "mandatory",
    "department": "Ø§Ù„Ù…ÙŠÙƒØ±ÙˆØ¨ÙŠÙˆÙ„ÙˆØ¬ÙŠ",
    "course_name": "Ø£Ù…Ø±Ø§Ø¶ Ù†Ø¨Ø§Øª (1)",
    "course_code": "MICR 481",
    "credit_hours": "2",
    "prerequisites": "MICR 202"
  },
  {
    "level": "4",
    "type": "mandatory",
    "department": "Ø§Ù„Ù†Ø¨Ø§Øª",
    "course_name": "Ø£ÙŠØ¶ ÙˆØ·Ø§Ù‚Ø© Ø¥Ø­ÙŠØ§Ø¦ÙŠØ©",
    "course_code": "BOTA 402",
    "credit_hours": "3",
    "prerequisites": "-"
  },
  {
    "level": "4",
    "type": "mandatory",
    "department": "Ø§Ù„Ù†Ø¨Ø§Øª",
    "course_name": "ÙÙ„ÙˆØ±Ø© Ø§Ù„Ù†Ø¨Ø§ØªØ§Øª Ø§Ù„Ø²Ù‡Ø±ÙŠØ© â€“ ÙÙ„ÙˆØ±Ø© Ø­Ø²Ø§Ø²ÙŠØ©",
    "course_code": "BOTA 404",
    "credit_hours": "3",
    "prerequisites": "BOTA 304"
  },
  {
    "level": "4",
    "type": "mandatory",
    "department": "Ø§Ù„Ù†Ø¨Ø§Øª",
    "course_name": "ØªØ·Ø¨ÙŠÙ‚Ø§Øª Ø¹Ù„Ù… Ø§Ù„Ø¨ÙŠØ¦Ø©",
    "course_code": "BOTA 406",
    "credit_hours": "2",
    "prerequisites": "BOTA 312"
  },
  {
    "level": "4",
    "type": "mandatory",
    "department": "Ø§Ù„Ù†Ø¨Ø§Øª",
    "course_name": "Ù‡Ù†Ø¯Ø³Ø© ÙˆØ±Ø§Ø«ÙŠØ©",
    "course_code": "BOTA 408",
    "credit_hours": "2",
    "prerequisites": "BOTA 305"
  },
  {
    "level": "4",
    "type": "mandatory",
    "department": "Ø§Ù„Ù†Ø¨Ø§Øª",
    "course_name": "Ù…Ø´Ø±ÙˆØ¹ Ø¨Ø­Ø«ÙŠ",
    "course_code": "BOTA 410",
    "credit_hours": "1",
    "prerequisites": "-"
  },
  {
    "level": "4",
    "type": "mandatory",
    "department": "Ø§Ù„Ù†Ø¨Ø§Øª",
    "course_name": "Ø¹Ù„Ù… Ø§Ù„Ø£Ø¬Ù†Ø©",
    "course_code": "BOTA 412",
    "credit_hours": "1",
    "prerequisites": "-"
  },
];

class BotanyCoursesScreen extends StatefulWidget {
  const BotanyCoursesScreen({super.key});
  @override
  State<BotanyCoursesScreen> createState() => _BotanyCoursesScreenState();
}

class _BotanyCoursesScreenState extends State<BotanyCoursesScreen>
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
        title: const Text('Ø§Ù„Ù†Ø¨Ø§Øª â€“ ØªØ®ØµØµ Ù…Ù†ÙØ±Ø¯',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
        centerTitle: true,
        backgroundColor: const Color(0xFF14532D),
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
      color: const Color(0xFF14532D),
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
                  colors: [Color(0xFF14532D), Color(0xFF16A34A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                      color: const Color(0xFF14532D).withValues(alpha: 0.3),
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
    if (dept.contains('Ø§Ù„Ù†Ø¨Ø§Øª') || dept.contains('BOTA')) {
      return const Color(0xFF16A34A);
    }
    if (dept.contains('Ø§Ù„Ù…ÙŠÙƒØ±ÙˆØ¨ÙŠÙˆÙ„ÙˆØ¬ÙŠ') || dept.contains('MICR')) {
      return const Color(0xFF0891B2);
    }
    if (dept.contains('Ø§Ù„ÙƒÙŠÙ…ÙŠØ§Ø¡') || dept.contains('CHEM')) {
      return const Color(0xFF7C3AED);
    }
    if (dept.contains('Ø§Ù„ÙÙŠØ²ÙŠØ§Ø¡') ||
        dept.contains('BIOP') ||
        dept.contains('PHYS')) {
      return const Color(0xFFDC2626);
    }
    if (dept.contains('Ø§Ù„Ø¬ÙŠÙˆÙ„ÙˆØ¬ÙŠØ§')) return const Color(0xFF92400E);
    if (dept.contains('Ø§Ù„Ø¥Ø­ØµØ§Ø¡') || dept.contains('STAT')) {
      return const Color(0xFF0284C7);
    }
    if (dept.contains('Ø§Ù„Ø­ÙŠÙˆØ§Ù†') || dept.contains('ZOOL')) {
      return const Color(0xFFD97706);
    }
    if (dept.contains('Ø§Ù„Ø±ÙŠØ§Ø¶ÙŠØ§Øª')) return const Color(0xFF2563EB);
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
