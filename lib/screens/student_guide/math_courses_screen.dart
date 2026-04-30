import 'package:flutter/material.dart';

// ===== Ø¨ÙŠØ§Ù†Ø§Øª Ø§Ù„ÙƒÙˆØ±Ø³Ø§Øª =====
const List<Map<String, String>> _mathCourses = [
  // ---- Ø§Ù„Ù…Ø³ØªÙˆÙ‰ Ø§Ù„Ø£ÙˆÙ„ ----
  {
    "level": "1",
    "department": "Ø§Ù„Ø±ÙŠØ§Ø¶ÙŠØ§Øª (Ù…ØªØ·Ù„Ø¨Ø§Øª Ø§Ù„ÙƒÙ„ÙŠØ©)",
    "course_name": "ØªÙØ§Ø¶Ù„ ÙˆØªÙƒØ§Ù…Ù„ (1)",
    "course_code": "MATH 101",
    "credit_hours": "4",
    "prerequisites": "-",
    "type": "mandatory",
  },
  {
    "level": "1",
    "department": "Ø§Ù„ÙÙŠØ²ÙŠØ§Ø¡ (Ù…ØªØ·Ù„Ø¨Ø§Øª Ø§Ù„ÙƒÙ„ÙŠØ©)",
    "course_name": "ÙÙŠØ²ÙŠØ§Ø¡ Ø¹Ø§Ù…Ø© (1)",
    "course_code": "PHYS 101",
    "credit_hours": "4",
    "prerequisites": "-",
    "type": "mandatory",
  },
  {
    "level": "1",
    "department": "Ø§Ù„ÙƒÙŠÙ…ÙŠØ§Ø¡ (Ù…ØªØ·Ù„Ø¨Ø§Øª Ø§Ù„ÙƒÙ„ÙŠØ©)",
    "course_name": "ÙƒÙŠÙ…ÙŠØ§Ø¡ Ø¹Ø§Ù…Ø© (1)",
    "course_code": "CHEM 101",
    "credit_hours": "3",
    "prerequisites": "-",
    "type": "mandatory",
  },
  {
    "level": "1",
    "department": "Ø§Ù„ÙƒÙŠÙ…ÙŠØ§Ø¡ (Ù…ØªØ·Ù„Ø¨Ø§Øª Ø§Ù„ÙƒÙ„ÙŠØ©)",
    "course_name": "Ø¹Ù…Ù„ÙŠ ÙƒÙŠÙ…ÙŠØ§Ø¡ Ø¹Ø§Ù…Ø© (1)",
    "course_code": "CHEM 103",
    "credit_hours": "1",
    "prerequisites": "-",
    "type": "mandatory",
  },
  {
    "level": "1",
    "department": "Ø§Ù„Ø¥Ø­ØµØ§Ø¡ (Ù…ØªØ·Ù„Ø¨Ø§Øª Ø§Ù„ÙƒÙ„ÙŠØ©)",
    "course_name": "Ù…Ù‚Ø¯Ù…Ø© ÙÙŠ Ø§Ù„Ø¥Ø­ØµØ§Ø¡",
    "course_code": "STAT 101",
    "credit_hours": "3",
    "prerequisites": "-",
    "type": "mandatory",
  },
  {
    "level": "1",
    "department": "Ù…ØªØ·Ù„Ø¨Ø§Øª Ø¬Ø§Ù…Ø¹Ø©",
    "course_name": "Ù„ØºØ© Ø¥Ù†Ø¬Ù„ÙŠØ²ÙŠØ© (1)",
    "course_code": "ENGL 102",
    "credit_hours": "2",
    "prerequisites": "-",
    "type": "mandatory",
  },
  {
    "level": "1",
    "department": "Ù…ØªØ·Ù„Ø¨Ø§Øª Ø¬Ø§Ù…Ø¹Ø©",
    "course_name": "Ù…Ø¯Ø®Ù„ ÙÙŠ Ø§Ù„Ø­Ø§Ø³Ø¨ Ø§Ù„Ø¢Ù„ÙŠ",
    "course_code": "INCO 102",
    "credit_hours": "1",
    "prerequisites": "-",
    "type": "mandatory",
  },
  {
    "level": "1",
    "department": "Ø§Ù„Ø±ÙŠØ§Ø¶ÙŠØ§Øª (Ù…ØªØ·Ù„Ø¨Ø§Øª Ø§Ù„ÙƒÙ„ÙŠØ©)",
    "course_name": "ØªÙØ§Ø¶Ù„ ÙˆØªÙƒØ§Ù…Ù„ (2)",
    "course_code": "MATH 102",
    "credit_hours": "3",
    "prerequisites": "-",
    "type": "mandatory",
  },
  {
    "level": "1",
    "department": "Ø§Ù„Ø±ÙŠØ§Ø¶ÙŠØ§Øª (Ù…ØªØ·Ù„Ø¨Ø§Øª Ø§Ù„ÙƒÙ„ÙŠØ©)",
    "course_name": "Ù…ÙØ§Ù‡ÙŠÙ… Ø£Ø³Ø§Ø³ÙŠØ© ÙÙŠ Ø§Ù„Ø±ÙŠØ§Ø¶ÙŠØ§Øª",
    "course_code": "MATH 104",
    "credit_hours": "3",
    "prerequisites": "-",
    "type": "mandatory",
  },
  {
    "level": "1",
    "department": "Ø§Ù„Ø±ÙŠØ§Ø¶ÙŠØ§Øª (Ù…ØªØ·Ù„Ø¨Ø§Øª Ø§Ù„ÙƒÙ„ÙŠØ©)",
    "course_name": "Ù…ÙŠÙƒØ§Ù†ÙŠÙƒØ§ (1)",
    "course_code": "MATH 112",
    "credit_hours": "3",
    "prerequisites": "-",
    "type": "mandatory",
  },
  {
    "level": "1",
    "department": "Ø§Ù„ÙÙŠØ²ÙŠØ§Ø¡ (Ù…ØªØ·Ù„Ø¨Ø§Øª Ø§Ù„ÙƒÙ„ÙŠØ©)",
    "course_name": "ÙÙŠØ²ÙŠØ§Ø¡ Ø¹Ø§Ù…Ø© (3)",
    "course_code": "PHYS 102",
    "credit_hours": "3",
    "prerequisites": "-",
    "type": "mandatory",
  },
  {
    "level": "1",
    "department": "Ø¹Ù„ÙˆÙ… Ø§Ù„Ø­Ø§Ø³Ø¨ (Ù…ØªØ·Ù„Ø¨Ø§Øª Ø§Ù„ÙƒÙ„ÙŠØ©)",
    "course_name": "Ø¹Ù„ÙˆÙ… Ø­Ø§Ø³Ø¨ Ø¢Ù„ÙŠ Ù„Ù„Ø±ÙŠØ§Ø¶ÙŠØ§Øª (Ø­Ø²Ù… + Ø¨Ø±Ù…Ø¬Ø©)",
    "course_code": "COMP 108",
    "credit_hours": "3",
    "prerequisites": "-",
    "type": "mandatory",
  },
  {
    "level": "1",
    "department": "Ù…ØªØ·Ù„Ø¨Ø§Øª Ø¬Ø§Ù…Ø¹Ø©",
    "course_name": "Ù„ØºØ© Ø¥Ù†Ø¬Ù„ÙŠØ²ÙŠØ© (2)",
    "course_code": "ENGL 201",
    "credit_hours": "2",
    "prerequisites": "ENGL 102",
    "type": "mandatory",
  },
  // ---- Ø§Ù„Ù…Ø³ØªÙˆÙ‰ Ø§Ù„Ø«Ø§Ù†ÙŠ ----
  {
    "level": "2",
    "department": "Ø§Ù„Ø±ÙŠØ§Ø¶ÙŠØ§Øª",
    "course_name": "Ø§Ù„ØªØ­Ù„ÙŠÙ„ Ø§Ù„Ø±ÙŠØ§Ø¶ÙŠ",
    "course_code": "MATH 201",
    "credit_hours": "3",
    "prerequisites": "-",
    "type": "mandatory",
  },
  {
    "level": "2",
    "department": "Ø§Ù„Ø±ÙŠØ§Ø¶ÙŠØ§Øª",
    "course_name": "Ø¬Ø¨Ø± Ø®Ø·ÙŠ",
    "course_code": "MATH 203",
    "credit_hours": "3",
    "prerequisites": "-",
    "type": "mandatory",
  },
  {
    "level": "2",
    "department": "Ø§Ù„Ø±ÙŠØ§Ø¶ÙŠØ§Øª",
    "course_name": "Ø§Ù„ØªØ­Ù„ÙŠÙ„ Ø§Ù„Ø§ØªØ¬Ø§Ù‡ÙŠ ÙˆØ­Ø³Ø§Ø¨ Ø§Ù„Ù…Ù…ØªØ¯Ø§Øª",
    "course_code": "MATH 211",
    "credit_hours": "3",
    "prerequisites": "-",
    "type": "mandatory",
  },
  {
    "level": "2",
    "department": "Ø§Ù„Ø±ÙŠØ§Ø¶ÙŠØ§Øª",
    "course_name": "Ù…ÙŠÙƒØ§Ù†ÙŠÙƒØ§ (2)",
    "course_code": "MATH 213",
    "credit_hours": "3",
    "prerequisites": "-",
    "type": "mandatory",
  },
  {
    "level": "2",
    "department": "Ø§Ù„Ø±ÙŠØ§Ø¶ÙŠØ§Øª",
    "course_name": "ØªØ§Ø±ÙŠØ® Ø§Ù„Ø±ÙŠØ§Ø¶ÙŠØ§Øª",
    "course_code": "MATH 207",
    "credit_hours": "1",
    "prerequisites": "-",
    "type": "mandatory",
  },
  {
    "level": "2",
    "department": "Ø§Ù„Ø±ÙŠØ§Ø¶ÙŠØ§Øª (Ø§Ø®ØªÙŠØ§Ø±ÙŠ)",
    "course_name": "Ù†Ø¸Ø±ÙŠØ© Ø§Ù„Ø£Ø¹Ø¯Ø§Ø¯",
    "course_code": "MATH 205",
    "credit_hours": "3",
    "prerequisites": "-",
    "type": "elective",
  },
  {
    "level": "2",
    "department": "Ø§Ù„Ø±ÙŠØ§Ø¶ÙŠØ§Øª",
    "course_name": "Ù…Ø¹Ø§Ø¯Ù„Ø§Øª ØªÙØ§Ø¶Ù„ÙŠØ© Ø¹Ø§Ø¯ÙŠØ©",
    "course_code": "MATH 202",
    "credit_hours": "3",
    "prerequisites": "MATH 101 Ø£Ùˆ 102",
    "type": "mandatory",
  },
  {
    "level": "2",
    "department": "Ø§Ù„Ø±ÙŠØ§Ø¶ÙŠØ§Øª",
    "course_name": "ØªØ­Ù„ÙŠÙ„ Ø­Ù‚ÙŠÙ‚ÙŠ",
    "course_code": "MATH 204",
    "credit_hours": "3",
    "prerequisites": "-",
    "type": "mandatory",
  },
  {
    "level": "2",
    "department": "Ø§Ù„Ø±ÙŠØ§Ø¶ÙŠØ§Øª",
    "course_name": "Ø§Ù„Ù†Ø¸Ø±ÙŠØ© Ø§Ù„ÙƒÙ‡Ø±ÙˆÙ…ØºÙ†Ø§Ø·ÙŠØ³ÙŠØ©",
    "course_code": "MATH 212",
    "credit_hours": "3",
    "prerequisites": "-",
    "type": "mandatory",
  },
  {
    "level": "2",
    "department": "Ø§Ù„Ø±ÙŠØ§Ø¶ÙŠØ§Øª",
    "course_name": "Ù…ÙŠÙƒØ§Ù†ÙŠÙƒØ§ (3)",
    "course_code": "MATH 214",
    "credit_hours": "3",
    "prerequisites": "-",
    "type": "mandatory",
  },
  {
    "level": "2",
    "department": "Ø§Ù„Ø±ÙŠØ§Ø¶ÙŠØ§Øª (Ø§Ø®ØªÙŠØ§Ø±ÙŠ)",
    "course_name": "Ù†Ø¸Ø±ÙŠØ© Ø§Ù„Ø£Ù„Ø¹Ø§Ø¨",
    "course_code": "MATH 206",
    "credit_hours": "2",
    "prerequisites": "-",
    "type": "elective",
  },
  {
    "level": "2",
    "department": "Ø§Ù„Ø±ÙŠØ§Ø¶ÙŠØ§Øª (Ø§Ø®ØªÙŠØ§Ø±ÙŠ)",
    "course_name": "Ø§Ù„Ø¨Ø±Ù…Ø¬Ø© Ø§Ù„Ø®Ø·ÙŠØ©",
    "course_code": "MATH 208",
    "credit_hours": "2",
    "prerequisites": "-",
    "type": "elective",
  },
  {
    "level": "2",
    "department": "Ø§Ù„Ø±ÙŠØ§Ø¶ÙŠØ§Øª (Ø§Ø®ØªÙŠØ§Ø±ÙŠ)",
    "course_name": "Ø§Ù„Ù…Ù†Ø·Ù‚ Ø§Ù„Ø±ÙŠØ§Ø¶ÙŠ",
    "course_code": "MATH 222",
    "credit_hours": "2",
    "prerequisites": "-",
    "type": "elective",
  },
  {
    "level": "2",
    "department": "Ø§Ù„Ø¥Ø­ØµØ§Ø¡ (Ø§Ø®ØªÙŠØ§Ø±ÙŠ)",
    "course_name": "Ù…Ø¨Ø§Ø¯Ø¦ Ù†Ø¸Ø±ÙŠØ© Ø§Ù„Ø§Ø­ØªÙ…Ø§Ù„Ø§Øª",
    "course_code": "STAT 228",
    "credit_hours": "2",
    "prerequisites": "-",
    "type": "elective",
  },
  // ---- Ø§Ù„Ù…Ø³ØªÙˆÙ‰ Ø§Ù„Ø«Ø§Ù„Ø« ----
  {
    "level": "3",
    "department": "Ù…ØªØ·Ù„Ø¨Ø§Øª Ø¬Ø§Ù…Ø¹Ø©",
    "course_name": "Ø§Ù„ØªÙÙƒÙŠØ± Ø§Ù„Ø¹Ù„Ù…ÙŠ",
    "course_code": "SCTH 301",
    "credit_hours": "1",
    "prerequisites": "-",
    "type": "mandatory",
  },
  {
    "level": "3",
    "department": "Ø§Ù„Ø±ÙŠØ§Ø¶ÙŠØ§Øª",
    "course_name": "Ø§Ù„Ø¬Ø¨Ø± Ø§Ù„Ù…Ø¬Ø±Ø¯ (1) â€“ Ù†Ø¸Ø±ÙŠØ© Ø§Ù„Ø²Ù…Ø±",
    "course_code": "MATH 301",
    "credit_hours": "3",
    "prerequisites": "-",
    "type": "mandatory",
  },
  {
    "level": "3",
    "department": "Ø§Ù„Ø±ÙŠØ§Ø¶ÙŠØ§Øª",
    "course_name": "Ø§Ù„ØªØ­Ù„ÙŠÙ„ Ø§Ù„Ø¹Ø¯Ø¯ÙŠ",
    "course_code": "MATH 303",
    "credit_hours": "3",
    "prerequisites": "-",
    "type": "mandatory",
  },
  {
    "level": "3",
    "department": "Ø§Ù„Ø±ÙŠØ§Ø¶ÙŠØ§Øª",
    "course_name": "Ù…ÙŠÙƒØ§Ù†ÙŠÙƒØ§ Ø§Ù„Ø£ÙˆØ³Ø§Ø· Ø§Ù„Ù…ØªØµÙ„Ø©",
    "course_code": "MATH 311",
    "credit_hours": "3",
    "prerequisites": "-",
    "type": "mandatory",
  },
  {
    "level": "3",
    "department": "Ø§Ù„Ø±ÙŠØ§Ø¶ÙŠØ§Øª",
    "course_name": "Ù…ÙŠÙƒØ§Ù†ÙŠÙƒØ§ Ø§Ù„ÙƒÙ… (1)",
    "course_code": "MATH 313",
    "credit_hours": "3",
    "prerequisites": "-",
    "type": "mandatory",
  },
  {
    "level": "3",
    "department": "Ø§Ù„Ø±ÙŠØ§Ø¶ÙŠØ§Øª (Ø§Ø®ØªÙŠØ§Ø±ÙŠ)",
    "course_name": "Ø§Ù„Ù‡Ù†Ø¯Ø³Ø© Ø§Ù„ØªÙØ§Ø¶Ù„ÙŠØ©",
    "course_code": "MATH 305",
    "credit_hours": "2",
    "prerequisites": "-",
    "type": "elective",
  },
  {
    "level": "3",
    "department": "Ø§Ù„Ø±ÙŠØ§Ø¶ÙŠØ§Øª (Ø§Ø®ØªÙŠØ§Ø±ÙŠ)",
    "course_name": "Ù†Ø¸Ø±ÙŠØ© Ø§Ù„Ø®ÙˆØ§Ø±Ø²Ù…ÙŠØ§Øª",
    "course_code": "MATH 307",
    "credit_hours": "2",
    "prerequisites": "-",
    "type": "elective",
  },
  {
    "level": "3",
    "department": "Ø§Ù„Ø±ÙŠØ§Ø¶ÙŠØ§Øª (Ø§Ø®ØªÙŠØ§Ø±ÙŠ)",
    "course_name": "Ù…Ø¨Ø§Ø¯Ø¦ Ø­Ø³Ø§Ø¨ Ø§Ù„ØªØºÙŠØ±Ø§Øª",
    "course_code": "MATH 331",
    "credit_hours": "2",
    "prerequisites": "-",
    "type": "elective",
  },
  {
    "level": "3",
    "department": "Ø§Ù„Ø±ÙŠØ§Ø¶ÙŠØ§Øª (Ø§Ø®ØªÙŠØ§Ø±ÙŠ)",
    "course_name": "Ø§Ù„Ø¯ÙˆØ§Ù„ Ø§Ù„Ø®Ø§ØµØ©",
    "course_code": "MATH 317",
    "credit_hours": "2",
    "prerequisites": "-",
    "type": "elective",
  },
  {
    "level": "3",
    "department": "Ø§Ù„Ø±ÙŠØ§Ø¶ÙŠØ§Øª (Ø§Ø®ØªÙŠØ§Ø±ÙŠ)",
    "course_name": "Ù…Ø¨Ø§Ø¯Ø¦ Ø§Ù„Ù†Ù…Ø°Ø¬Ø© Ø§Ù„Ø±ÙŠØ§Ø¶ÙŠØ©",
    "course_code": "MATH 319",
    "credit_hours": "2",
    "prerequisites": "-",
    "type": "elective",
  },
  {
    "level": "3",
    "department": "Ù…ØªØ·Ù„Ø¨Ø§Øª Ø¬Ø§Ù…Ø¹Ø©",
    "course_name": "Ø£Ø®Ù„Ø§Ù‚ÙŠØ§Øª Ø§Ù„Ø¨Ø­Ø« Ø§Ù„Ø¹Ù„Ù…ÙŠ",
    "course_code": "ETHR 302",
    "credit_hours": "1",
    "prerequisites": "-",
    "type": "mandatory",
  },
  {
    "level": "3",
    "department": "Ø§Ù„Ø±ÙŠØ§Ø¶ÙŠØ§Øª",
    "course_name": "Ø§Ù„ØªÙˆØ¨ÙˆÙ„ÙˆØ¬ÙŠ Ø§Ù„Ø¹Ø§Ù…",
    "course_code": "MATH 302",
    "credit_hours": "3",
    "prerequisites": "-",
    "type": "mandatory",
  },
  {
    "level": "3",
    "department": "Ø§Ù„Ø±ÙŠØ§Ø¶ÙŠØ§Øª",
    "course_name": "Ù†Ø¸Ø±ÙŠØ© Ø§Ù„Ù‚ÙŠØ§Ø³",
    "course_code": "MATH 304",
    "credit_hours": "3",
    "prerequisites": "MATH 204",
    "type": "mandatory",
  },
  {
    "level": "3",
    "department": "Ø§Ù„Ø±ÙŠØ§Ø¶ÙŠØ§Øª",
    "course_name": "Ø§Ù„Ø¥Ù„ÙƒØªØ±ÙˆØ¯ÙŠÙ†Ø§Ù…ÙŠÙƒØ§",
    "course_code": "MATH 312",
    "credit_hours": "3",
    "prerequisites": "MATH 212",
    "type": "mandatory",
  },
  {
    "level": "3",
    "department": "Ø§Ù„Ø±ÙŠØ§Ø¶ÙŠØ§Øª",
    "course_name": "Ù…ÙŠÙƒØ§Ù†ÙŠÙƒØ§ Ø§Ù„ÙƒÙ… (2)",
    "course_code": "MATH 314",
    "credit_hours": "3",
    "prerequisites": "-",
    "type": "mandatory",
  },
  {
    "level": "3",
    "department": "Ø§Ù„Ø±ÙŠØ§Ø¶ÙŠØ§Øª (Ø§Ø®ØªÙŠØ§Ø±ÙŠ)",
    "course_name": "Ø¨Ø­ÙˆØ« Ø§Ù„Ø¹Ù…Ù„ÙŠØ§Øª",
    "course_code": "MATH 306",
    "credit_hours": "2",
    "prerequisites": "-",
    "type": "elective",
  },
  {
    "level": "3",
    "department": "Ø§Ù„Ø±ÙŠØ§Ø¶ÙŠØ§Øª (Ø§Ø®ØªÙŠØ§Ø±ÙŠ)",
    "course_name": "Ø§Ù„ØªØ´ÙÙŠØ± Ø§Ù„Ø±ÙŠØ§Ø¶ÙŠ",
    "course_code": "MATH 308",
    "credit_hours": "2",
    "prerequisites": "-",
    "type": "elective",
  },
  {
    "level": "3",
    "department": "Ø§Ù„Ø±ÙŠØ§Ø¶ÙŠØ§Øª (Ø§Ø®ØªÙŠØ§Ø±ÙŠ)",
    "course_name": "ØªØ¢Ù„ÙÙŠØ§Øª (Combinatorics)",
    "course_code": "MATH 322",
    "credit_hours": "2",
    "prerequisites": "-",
    "type": "elective",
  },
  {
    "level": "3",
    "department": "Ø§Ù„Ø±ÙŠØ§Ø¶ÙŠØ§Øª (Ø§Ø®ØªÙŠØ§Ø±ÙŠ)",
    "course_name": "Ù…ÙŠÙƒØ§Ù†ÙŠÙƒØ§ Ø§Ù„Ù…ÙˆØ§Ø¦Ø¹",
    "course_code": "MATH 316",
    "credit_hours": "2",
    "prerequisites": "-",
    "type": "elective",
  },
  {
    "level": "3",
    "department": "Ø§Ù„Ø±ÙŠØ§Ø¶ÙŠØ§Øª (Ø§Ø®ØªÙŠØ§Ø±ÙŠ)",
    "course_name": "Ù†Ø¸Ø±ÙŠØ© Ø§Ù„Ù…Ø±ÙˆÙ†Ø©",
    "course_code": "MATH 318",
    "credit_hours": "2",
    "prerequisites": "-",
    "type": "elective",
  },
  {
    "level": "3",
    "department": "Ø§Ù„Ø±ÙŠØ§Ø¶ÙŠØ§Øª (Ø§Ø®ØªÙŠØ§Ø±ÙŠ)",
    "course_name": "Ø¯ÙŠÙ†Ø§Ù…ÙŠÙƒØ§ Ø§Ù„ØºØ§Ø²Ø§Øª",
    "course_code": "MATH 332",
    "credit_hours": "2",
    "prerequisites": "-",
    "type": "elective",
  },
  // ---- Ø§Ù„Ù…Ø³ØªÙˆÙ‰ Ø§Ù„Ø±Ø§Ø¨Ø¹ ----
  {
    "level": "4",
    "department": "Ù…ØªØ·Ù„Ø¨Ø§Øª Ø¬Ø§Ù…Ø¹Ø© (Ø§Ø®ØªÙŠØ§Ø±ÙŠ)",
    "course_name": "Ù…Ù‡Ø§Ø±Ø§Øª Ø§Ù„Ø¹Ù…Ù„",
    "course_code": "SKIL 401",
    "credit_hours": "1",
    "prerequisites": "-",
    "type": "elective",
  },
  {
    "level": "4",
    "department": "Ù…ØªØ·Ù„Ø¨Ø§Øª Ø¬Ø§Ù…Ø¹Ø© (Ø§Ø®ØªÙŠØ§Ø±ÙŠ)",
    "course_name": "Ø«Ù‚Ø§ÙØ© Ø¨ÙŠØ¦ÙŠØ©",
    "course_code": "ENCU 401",
    "credit_hours": "1",
    "prerequisites": "-",
    "type": "elective",
  },
  {
    "level": "4",
    "department": "Ù…ØªØ·Ù„Ø¨Ø§Øª Ø¬Ø§Ù…Ø¹Ø© (Ø§Ø®ØªÙŠØ§Ø±ÙŠ)",
    "course_name": "Ù†Ø´Ø£Ø© ÙˆØªØ§Ø±ÙŠØ® ÙˆØªØ·ÙˆØ± Ø§Ù„Ø¹Ù„ÙˆÙ…",
    "course_code": "GHDS 401",
    "credit_hours": "1",
    "prerequisites": "-",
    "type": "elective",
  },
  {
    "level": "4",
    "department": "Ø§Ù„Ø±ÙŠØ§Ø¶ÙŠØ§Øª",
    "course_name": "Ø§Ù„ØªØ­Ù„ÙŠÙ„ Ø§Ù„Ø¯Ø§Ù„ÙŠ",
    "course_code": "MATH 401",
    "credit_hours": "3",
    "prerequisites": "-",
    "type": "mandatory",
  },
  {
    "level": "4",
    "department": "Ø§Ù„Ø±ÙŠØ§Ø¶ÙŠØ§Øª",
    "course_name": "Ø§Ù„ØªØ­Ù„ÙŠÙ„ Ø§Ù„Ù…Ø±ÙƒØ¨",
    "course_code": "MATH 403",
    "credit_hours": "3",
    "prerequisites": "MATH 204",
    "type": "mandatory",
  },
  {
    "level": "4",
    "department": "Ø§Ù„Ø±ÙŠØ§Ø¶ÙŠØ§Øª",
    "course_name": "Ù†Ø¸Ø±ÙŠØ© Ø§Ù„Ø¬ÙˆØ§Ù…Ø¯",
    "course_code": "MATH 411",
    "credit_hours": "3",
    "prerequisites": "-",
    "type": "mandatory",
  },
  {
    "level": "4",
    "department": "Ø§Ù„Ø±ÙŠØ§Ø¶ÙŠØ§Øª",
    "course_name": "Ø§Ù„Ù†Ø¸Ø±ÙŠØ© Ø§Ù„Ù†Ø³Ø¨ÙŠØ©",
    "course_code": "MATH 413",
    "credit_hours": "3",
    "prerequisites": "-",
    "type": "mandatory",
  },
  {
    "level": "4",
    "department": "Ø§Ù„Ø±ÙŠØ§Ø¶ÙŠØ§Øª",
    "course_name": "Ù…Ø´Ø±ÙˆØ¹ Ø¨Ø­Ø«ÙŠ Ø±ÙŠØ§Ø¶ÙŠØ§Øª Ø¨Ø­ØªØ©",
    "course_code": "MATH 405",
    "credit_hours": "4",
    "prerequisites": "-",
    "type": "mandatory",
  },
  {
    "level": "4",
    "department": "Ø§Ù„Ø±ÙŠØ§Ø¶ÙŠØ§Øª (Ø§Ø®ØªÙŠØ§Ø±ÙŠ)",
    "course_name": "Ø§Ù„Ù‡Ù†Ø¯Ø³Ø© Ø§Ù„Ø¬Ø¨Ø±ÙŠØ©",
    "course_code": "MATH 407",
    "credit_hours": "2",
    "prerequisites": "-",
    "type": "elective",
  },
  {
    "level": "4",
    "department": "Ø§Ù„Ø±ÙŠØ§Ø¶ÙŠØ§Øª (Ø§Ø®ØªÙŠØ§Ø±ÙŠ)",
    "course_name": "Ù†Ø¸Ø±ÙŠØ© Ø§Ù„Ø±Ø³ÙˆÙ…",
    "course_code": "MATH 409",
    "credit_hours": "2",
    "prerequisites": "-",
    "type": "elective",
  },
  {
    "level": "4",
    "department": "Ø§Ù„Ø±ÙŠØ§Ø¶ÙŠØ§Øª (Ø§Ø®ØªÙŠØ§Ø±ÙŠ)",
    "course_name": "Ø¬Ø¨Ø± Ø®Ø·ÙŠ Ø¹Ø¯Ø¯ÙŠ",
    "course_code": "MATH 421",
    "credit_hours": "2",
    "prerequisites": "MATH 203",
    "type": "elective",
  },
  {
    "level": "4",
    "department": "Ø§Ù„Ø±ÙŠØ§Ø¶ÙŠØ§Øª (Ø§Ø®ØªÙŠØ§Ø±ÙŠ)",
    "course_name": "Ø§Ù„Ø±ÙŠØ§Ø¶ÙŠØ§Øª Ø§Ù„Ø¨ÙŠÙˆÙ„ÙˆØ¬ÙŠØ© (Ø§Ù„Ø¹Ù…Ù„ÙŠØ§Øª Ø§Ù„Ù…ØªÙ‚Ø·Ø¹Ø©)",
    "course_code": "MATH 415",
    "credit_hours": "2",
    "prerequisites": "-",
    "type": "elective",
  },
  {
    "level": "4",
    "department": "Ø§Ù„Ø±ÙŠØ§Ø¶ÙŠØ§Øª",
    "course_name": "Ø§Ù„Ø¬Ø¨Ø± Ø§Ù„Ù…Ø¬Ø±Ø¯ (2) â€“ Ø§Ù„Ø­Ù„Ù‚Ø§Øª ÙˆØ§Ù„Ø­Ù‚ÙˆÙ„",
    "course_code": "MATH 402",
    "credit_hours": "3",
    "prerequisites": "MATH 301",
    "type": "mandatory",
  },
  {
    "level": "4",
    "department": "Ø§Ù„Ø±ÙŠØ§Ø¶ÙŠØ§Øª",
    "course_name": "Ø§Ù„Ù…Ø¹Ø§Ø¯Ù„Ø§Øª Ø§Ù„ØªÙØ§Ø¶Ù„ÙŠØ© Ø§Ù„Ø¬Ø²Ø¦ÙŠØ©",
    "course_code": "MATH 404",
    "credit_hours": "3",
    "prerequisites": "MATH 202",
    "type": "mandatory",
  },
  {
    "level": "4",
    "department": "Ø§Ù„Ø±ÙŠØ§Ø¶ÙŠØ§Øª",
    "course_name": "Ø§Ù„Ù…ÙŠÙƒØ§Ù†ÙŠÙƒØ§ Ø§Ù„Ø¥Ø­ØµØ§Ø¦ÙŠØ©",
    "course_code": "MATH 412",
    "credit_hours": "3",
    "prerequisites": "-",
    "type": "mandatory",
  },
  {
    "level": "4",
    "department": "Ø§Ù„Ø±ÙŠØ§Ø¶ÙŠØ§Øª",
    "course_name": "Ø§Ù„Ù…ÙŠÙƒØ§Ù†ÙŠÙƒØ§ Ø§Ù„ÙØ¶Ø§Ø¦ÙŠØ©",
    "course_code": "MATH 414",
    "credit_hours": "3",
    "prerequisites": "-",
    "type": "mandatory",
  },
  {
    "level": "4",
    "department": "Ø§Ù„Ø±ÙŠØ§Ø¶ÙŠØ§Øª",
    "course_name": "Ù…Ø´Ø±ÙˆØ¹ Ø¨Ø­Ø«ÙŠ Ø±ÙŠØ§Ø¶ÙŠØ§Øª ØªØ·Ø¨ÙŠÙ‚ÙŠØ©",
    "course_code": "MATH 416",
    "credit_hours": "4",
    "prerequisites": "-",
    "type": "mandatory",
  },
  {
    "level": "4",
    "department": "Ø§Ù„Ø±ÙŠØ§Ø¶ÙŠØ§Øª (Ø§Ø®ØªÙŠØ§Ø±ÙŠ)",
    "course_name": "ÙƒÙˆØ²Ù…ÙˆÙ„ÙˆØ¬ÙŠ",
    "course_code": "MATH 418",
    "credit_hours": "2",
    "prerequisites": "-",
    "type": "elective",
  },
  {
    "level": "4",
    "department": "Ø§Ù„Ø±ÙŠØ§Ø¶ÙŠØ§Øª (Ø§Ø®ØªÙŠØ§Ø±ÙŠ)",
    "course_name": "Ø§Ù„Ø¶ÙˆØ¡ Ø§Ù„ÙƒÙ…ÙŠ",
    "course_code": "MATH 432",
    "credit_hours": "2",
    "prerequisites": "-",
    "type": "elective",
  },
  {
    "level": "4",
    "department": "Ø§Ù„Ø±ÙŠØ§Ø¶ÙŠØ§Øª (Ø§Ø®ØªÙŠØ§Ø±ÙŠ)",
    "course_name": "Ù…ÙŠÙƒØ§Ù†ÙŠÙƒØ§ Ø§Ù„ÙƒÙ… Ø§Ù„Ù†Ø³Ø¨ÙŠØ©",
    "course_code": "MATH 434",
    "credit_hours": "2",
    "prerequisites": "-",
    "type": "elective",
  },
];

// ===== Ø§Ù„Ø´Ø§Ø´Ø© Ø§Ù„Ø±Ø¦ÙŠØ³ÙŠØ© =====
class MathCoursesScreen extends StatefulWidget {
  const MathCoursesScreen({super.key});

  @override
  State<MathCoursesScreen> createState() => _MathCoursesScreenState();
}

class _MathCoursesScreenState extends State<MathCoursesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _filterType = 'all'; // all, mandatory, elective

  static const List<String> _levels = ['1', '2', '3', '4'];
  static const List<String> _levelLabels = [
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

  List<Map<String, String>> _getCoursesForLevel(String level) {
    return _mathCourses.where((c) {
      final matchLevel = c['level'] == level;
      if (_filterType == 'all') return matchLevel;
      return matchLevel && c['type'] == _filterType;
    }).toList();
  }

  int _totalHoursForLevel(String level) {
    return _getCoursesForLevel(level).fold(
        0, (sum, c) => sum + (int.tryParse(c['credit_hours'] ?? '0') ?? 0));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        title: const Text(
          'Ø±ÙŠØ§Ø¶ÙŠØ§Øª â€“ ØªØ®ØµØµ Ù…Ù†ÙØ±Ø¯',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF1E3A5F),
        foregroundColor: Colors.white,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: false,
          indicatorColor: Colors.amber,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          labelStyle:
              const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          unselectedLabelStyle: const TextStyle(fontSize: 12),
          tabs: List.generate(
            _levels.length,
            (i) => Tab(text: 'Ø§Ù„Ø³Ù†Ø© ${_levelNames[i]}'),
          ),
        ),
      ),
      body: Column(
        children: [
          // ---- Ø´Ø±ÙŠØ· Ø§Ù„ÙÙ„ØªØ± ----
          _buildFilterBar(),
          // ---- Ù…Ø­ØªÙˆÙ‰ Ø§Ù„ØªØ§Ø¨Ø² ----
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: List.generate(
                _levels.length,
                (i) => _buildLevelPage(_levels[i], _levelLabels[i]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static const List<String> _levelNames = [
    'Ø§Ù„Ø£ÙˆÙ„Ù‰',
    'Ø§Ù„Ø«Ø§Ù†ÙŠØ©',
    'Ø§Ù„Ø«Ø§Ù„Ø«Ø©',
    'Ø§Ù„Ø±Ø§Ø¨Ø¹Ø©'
  ];

  Widget _buildFilterBar() {
    return Container(
      color: const Color(0xFF1E3A5F),
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _FilterChip(
            label: 'Ø§Ù„ÙƒÙ„',
            isSelected: _filterType == 'all',
            color: const Color(0xFF64748B),
            onTap: () => setState(() => _filterType = 'all'),
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: 'Ø¥Ø¬Ø¨Ø§Ø±ÙŠ',
            isSelected: _filterType == 'mandatory',
            color: const Color(0xFF059669),
            onTap: () => setState(() => _filterType = 'mandatory'),
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: 'Ø§Ø®ØªÙŠØ§Ø±ÙŠ',
            isSelected: _filterType == 'elective',
            color: const Color(0xFFD97706),
            onTap: () => setState(() => _filterType = 'elective'),
          ),
        ],
      ),
    );
  }

  Widget _buildLevelPage(String level, String label) {
    final courses = _getCoursesForLevel(level);
    final totalHours = _totalHoursForLevel(level);

    if (courses.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              'Ù„Ø§ ØªÙˆØ¬Ø¯ Ù…Ù‚Ø±Ø±Ø§Øª Ù„Ù‡Ø°Ø§ Ø§Ù„ÙÙ„ØªØ±',
              style: TextStyle(color: Colors.grey[500], fontSize: 16),
            ),
          ],
        ),
      );
    }

    return CustomScrollView(
      slivers: [
        // ---- Ø¨Ø·Ø§Ù‚Ø© Ù…Ù„Ø®Øµ Ø§Ù„Ù…Ø³ØªÙˆÙ‰ ----
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
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${courses.length} Ù…Ù‚Ø±Ø±',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Text(
                          '$totalHours',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          'Ø³Ø§Ø¹Ø©',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        // ---- Ù‚Ø§Ø¦Ù…Ø© Ø§Ù„ÙƒÙˆØ±Ø³Ø§Øª ----
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _CourseCard(course: courses[index]),
                );
              },
              childCount: courses.length,
            ),
          ),
        ),
      ],
    );
  }
}

// ===== Ø¨Ø·Ø§Ù‚Ø© Ø§Ù„ÙƒÙˆØ±Ø³ =====
class _CourseCard extends StatelessWidget {
  final Map<String, String> course;

  const _CourseCard({required this.course});

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
        border: Border(
          right: BorderSide(color: typeColor, width: 4),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // ---- Ø§Ù„ØµÙ Ø§Ù„Ø£ÙˆÙ„: Ø§Ù„ÙƒÙˆØ¯ + Ø§Ù„Ù†ÙˆØ¹ ----
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Ù†ÙˆØ¹ Ø§Ù„Ù…Ù‚Ø±Ø±
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: typeColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    typeLabel,
                    style: TextStyle(
                      color: typeColor,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // ÙƒÙˆØ¯ Ø§Ù„Ù…Ø§Ø¯Ø©
                Text(
                  course['course_code'] ?? '',
                  style: const TextStyle(
                    color: Color(0xFF2563EB),
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // ---- Ø§Ø³Ù… Ø§Ù„Ù…Ø§Ø¯Ø© ----
            Text(
              course['course_name'] ?? '',
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF111827),
              ),
            ),
            const SizedBox(height: 6),
            // ---- Ø§Ù„Ù‚Ø³Ù… ----
            Text(
              course['department'] ?? '',
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF6B7280),
              ),
            ),
            const SizedBox(height: 12),
            // ---- Ø§Ù„Ø³Ø§Ø¹Ø§Øª ÙˆØ§Ù„Ù…ØªØ·Ù„Ø¨Ø§Øª ----
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Ø§Ù„Ù…ØªØ·Ù„Ø¨ Ø§Ù„Ø³Ø§Ø¨Ù‚
                if (hasPrereq)
                  Flexible(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.link,
                            size: 14, color: Color(0xFF9CA3AF)),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            course['prerequisites'] ?? '',
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF9CA3AF),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  const SizedBox.shrink(),
                // Ø§Ù„Ø³Ø§Ø¹Ø§Øª Ø§Ù„Ù…Ø¹ØªÙ…Ø¯Ø©
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.access_time,
                          size: 13, color: Color(0xFF64748B)),
                      const SizedBox(width: 4),
                      Text(
                        '${course['credit_hours']} Ø³Ø§Ø¹Ø©',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF374151),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ===== Ø²Ø± Ø§Ù„ÙÙ„ØªØ± =====
class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Color color;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.white.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? color : Colors.white30,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white70,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
