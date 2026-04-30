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
    "department": "Ø§Ù„Ø±ÙŠØ§Ø¶ÙŠØ§Øª (Ù…ØªØ·Ù„Ø¨Ø§Øª Ø§Ù„ÙƒÙ„ÙŠØ©)",
    "course_name": "ØªÙØ§Ø¶Ù„ ÙˆØªÙƒØ§Ù…Ù„ (1)",
    "course_code": "MATH 101",
    "credit_hours": "4",
    "prerequisites": "-"
  },
  {
    "level": "1",
    "type": "mandatory",
    "department": "Ø§Ù„ÙÙŠØ²ÙŠØ§Ø¡ (Ù…ØªØ·Ù„Ø¨Ø§Øª Ø§Ù„ÙƒÙ„ÙŠØ©)",
    "course_name": "ÙÙŠØ²ÙŠØ§Ø¡ Ø¹Ø§Ù…Ø© (1)",
    "course_code": "PHYS 101",
    "credit_hours": "4",
    "prerequisites": "-"
  },
  {
    "level": "1",
    "type": "mandatory",
    "department": "Ø§Ù„ÙƒÙŠÙ…ÙŠØ§Ø¡ (Ù…ØªØ·Ù„Ø¨Ø§Øª Ø§Ù„ÙƒÙ„ÙŠØ©)",
    "course_name": "ÙƒÙŠÙ…ÙŠØ§Ø¡ Ø¹Ø§Ù…Ø© (1)",
    "course_code": "CHEM 101",
    "credit_hours": "3",
    "prerequisites": "-"
  },
  {
    "level": "1",
    "type": "mandatory",
    "department": "Ø§Ù„ÙƒÙŠÙ…ÙŠØ§Ø¡ (Ù…ØªØ·Ù„Ø¨Ø§Øª Ø§Ù„ÙƒÙ„ÙŠØ©)",
    "course_name": "Ø¹Ù…Ù„ÙŠ ÙƒÙŠÙ…ÙŠØ§Ø¡ Ø¹Ø§Ù…Ø© (1)",
    "course_code": "CHEM 103",
    "credit_hours": "1",
    "prerequisites": "-"
  },
  {
    "level": "1",
    "type": "mandatory",
    "department": "Ø§Ù„Ø¥Ø­ØµØ§Ø¡ (Ù…ØªØ·Ù„Ø¨Ø§Øª Ø§Ù„ÙƒÙ„ÙŠØ©)",
    "course_name": "Ù…Ù‚Ø¯Ù…Ø© ÙÙŠ Ø§Ù„Ø¥Ø­ØµØ§Ø¡",
    "course_code": "STAT 101",
    "credit_hours": "3",
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
    "department": "Ø§Ù„Ø±ÙŠØ§Ø¶ÙŠØ§Øª (Ù…ØªØ·Ù„Ø¨Ø§Øª Ø§Ù„ÙƒÙ„ÙŠØ©)",
    "course_name": "ØªÙØ§Ø¶Ù„ ÙˆØªÙƒØ§Ù…Ù„ (2)",
    "course_code": "MATH 102",
    "credit_hours": "3",
    "prerequisites": "-"
  },
  {
    "level": "1",
    "type": "mandatory",
    "department": "Ø§Ù„Ø±ÙŠØ§Ø¶ÙŠØ§Øª (Ù…ØªØ·Ù„Ø¨Ø§Øª Ø§Ù„ÙƒÙ„ÙŠØ©)",
    "course_name": "Ù…ÙØ§Ù‡ÙŠÙ… Ø£Ø³Ø§Ø³ÙŠØ© ÙÙŠ Ø§Ù„Ø±ÙŠØ§Ø¶ÙŠØ§Øª",
    "course_code": "MATH 104",
    "credit_hours": "3",
    "prerequisites": "-"
  },
  {
    "level": "1",
    "type": "mandatory",
    "department": "Ø§Ù„Ø¥Ø­ØµØ§Ø¡ (Ù…ØªØ·Ù„Ø¨Ø§Øª Ø§Ù„ÙƒÙ„ÙŠØ©)",
    "course_name": "Ù†Ø¸Ø±ÙŠØ© Ø§Ù„Ø§Ø­ØªÙ…Ø§Ù„Ø§Øª (1)",
    "course_code": "STAT 102",
    "credit_hours": "3",
    "prerequisites": "-"
  },
  {
    "level": "1",
    "type": "mandatory",
    "department": "Ø¹Ù„ÙˆÙ… Ø§Ù„Ø­Ø§Ø³Ø¨ (Ù…ØªØ·Ù„Ø¨Ø§Øª Ø§Ù„ÙƒÙ„ÙŠØ©)",
    "course_name": "Ù…Ù‚Ø¯Ù…Ø© ÙÙŠ Ø§Ù„Ø­Ø§Ø³Ø¨ Ø§Ù„Ø¢Ù„ÙŠ",
    "course_code": "COMP 102",
    "credit_hours": "3",
    "prerequisites": "-"
  },
  {
    "level": "1",
    "type": "mandatory",
    "department": "Ø¹Ù„ÙˆÙ… Ø§Ù„Ø­Ø§Ø³Ø¨ (Ù…ØªØ·Ù„Ø¨Ø§Øª Ø§Ù„ÙƒÙ„ÙŠØ©)",
    "course_name": "Ø¨Ø±Ù…Ø¬Ø© Ø­Ø§Ø³Ø¨ (1)",
    "course_code": "COMP 104",
    "credit_hours": "3",
    "prerequisites": "-"
  },
  {
    "level": "1",
    "type": "mandatory",
    "department": "Ù…ØªØ·Ù„Ø¨Ø§Øª Ø¬Ø§Ù…Ø¹Ø©",
    "course_name": "Ù„ØºØ© Ø¥Ù†Ø¬Ù„ÙŠØ²ÙŠØ© (2)",
    "course_code": "ENGL 201",
    "credit_hours": "2",
    "prerequisites": "ENGL 102"
  },
  // ========== Ø§Ù„Ù…Ø³ØªÙˆÙ‰ Ø§Ù„Ø«Ø§Ù†ÙŠ ==========
  {
    "level": "2",
    "type": "mandatory",
    "department": "Ø§Ù„Ø¥Ø­ØµØ§Ø¡ Ø§Ù„Ø±ÙŠØ§Ø¶ÙŠ (ØªØ®ØµØµ Ø£ÙˆÙ„)",
    "course_name": "Ù†Ø¸Ø±ÙŠØ© Ø§Ù„Ø¥Ø­ØµØ§Ø¡ (1)",
    "course_code": "STAT 201",
    "credit_hours": "3",
    "prerequisites": "STAT 102"
  },
  {
    "level": "2",
    "type": "mandatory",
    "department": "Ø§Ù„Ø¥Ø­ØµØ§Ø¡ Ø§Ù„Ø±ÙŠØ§Ø¶ÙŠ (ØªØ®ØµØµ Ø£ÙˆÙ„)",
    "course_name": "Ø·Ø±Ù‚ Ø¥Ø­ØµØ§Ø¦ÙŠØ© (1)",
    "course_code": "STAT 203",
    "credit_hours": "3",
    "prerequisites": "STAT 101"
  },
  {
    "level": "2",
    "type": "mandatory",
    "department": "Ø§Ù„Ø¥Ø­ØµØ§Ø¡ Ø§Ù„Ø±ÙŠØ§Ø¶ÙŠ (ØªØ®ØµØµ Ø£ÙˆÙ„)",
    "course_name": "Ø±ÙŠØ§Ø¶ÙŠØ§Øª Ø¥Ø­ØµØ§Ø¦ÙŠØ©",
    "course_code": "STAT 205",
    "credit_hours": "3",
    "prerequisites": "-"
  },
  {
    "level": "2",
    "type": "mandatory",
    "department": "Ø¹Ù„ÙˆÙ… Ø§Ù„Ø­Ø§Ø³Ø¨ (ØªØ®ØµØµ Ø«Ø§Ù†ÙŠ)",
    "course_name": "ØªØµÙ…ÙŠÙ… ÙˆØªØ­Ù„ÙŠÙ„ Ø§Ù„Ø®ÙˆØ§Ø±Ø²Ù…ÙŠØ§Øª",
    "course_code": "COMP 201",
    "credit_hours": "3",
    "prerequisites": "-"
  },
  {
    "level": "2",
    "type": "mandatory",
    "department": "Ø¹Ù„ÙˆÙ… Ø§Ù„Ø­Ø§Ø³Ø¨ (ØªØ®ØµØµ Ø«Ø§Ù†ÙŠ)",
    "course_name": "Ù†Ø¸Ù… Ù‚ÙˆØ§Ø¹Ø¯ Ø¨ÙŠØ§Ù†Ø§Øª",
    "course_code": "COMP 207",
    "credit_hours": "4",
    "prerequisites": "-"
  },
  {
    "level": "2",
    "type": "mandatory",
    "department": "Ø§Ù„Ø¥Ø­ØµØ§Ø¡ Ø§Ù„Ø±ÙŠØ§Ø¶ÙŠ (ØªØ®ØµØµ Ø£ÙˆÙ„)",
    "course_name": "Ù†Ø¸Ø±ÙŠØ© Ø§Ù„Ø¥Ø­ØµØ§Ø¡ (2)",
    "course_code": "STAT 202",
    "credit_hours": "3",
    "prerequisites": "STAT 102"
  },
  {
    "level": "2",
    "type": "mandatory",
    "department": "Ø§Ù„Ø¥Ø­ØµØ§Ø¡ Ø§Ù„Ø±ÙŠØ§Ø¶ÙŠ (ØªØ®ØµØµ Ø£ÙˆÙ„)",
    "course_name": "Ø·Ø±Ù‚ Ø§Ø­ØªÙ…Ø§Ù„ÙŠØ© Ù„Ø¨Ø­ÙˆØ« Ø§Ù„Ø¹Ù…Ù„ÙŠØ§Øª (1)",
    "course_code": "STAT 204",
    "credit_hours": "3",
    "prerequisites": "-"
  },
  {
    "level": "2",
    "type": "mandatory",
    "department": "Ø¹Ù„ÙˆÙ… Ø§Ù„Ø­Ø§Ø³Ø¨ (ØªØ®ØµØµ Ø«Ø§Ù†ÙŠ)",
    "course_name": "ØªØ±Ø§ÙƒÙŠØ¨ Ø§Ù„Ø¨ÙŠØ§Ù†Ø§Øª",
    "course_code": "COMP 202",
    "credit_hours": "3",
    "prerequisites": "COMP 104"
  },
  {
    "level": "2",
    "type": "mandatory",
    "department": "Ø¹Ù„ÙˆÙ… Ø§Ù„Ø­Ø§Ø³Ø¨ (ØªØ®ØµØµ Ø«Ø§Ù†ÙŠ)",
    "course_name": "Ø¨Ø±Ù…Ø¬Ø© Ø­Ø§Ø³Ø¨ Ù…ØªÙ‚Ø¯Ù…",
    "course_code": "COMP 212",
    "credit_hours": "3",
    "prerequisites": "COMP 104"
  },
  {
    "level": "2",
    "type": "elective",
    "department": "Ø§Ù„Ø¥Ø­ØµØ§Ø¡ Ø§Ù„Ø±ÙŠØ§Ø¶ÙŠ (Ø§Ø®ØªÙŠØ§Ø±ÙŠ)",
    "course_name": "Ø·Ø±Ù‚ Ø¥Ø­ØµØ§Ø¦ÙŠØ© (2)",
    "course_code": "STAT 206",
    "credit_hours": "3",
    "prerequisites": "-"
  },
  {
    "level": "2",
    "type": "elective",
    "department": "Ø§Ù„Ø¥Ø­ØµØ§Ø¡ Ø§Ù„Ø±ÙŠØ§Ø¶ÙŠ (Ø§Ø®ØªÙŠØ§Ø±ÙŠ)",
    "course_name": "Ù…Ø¨Ø§Ø¯Ø¦ ØªØ­Ù„ÙŠÙ„ Ø§Ù„Ø§Ù†Ø­Ø¯Ø§Ø±",
    "course_code": "STAT 208",
    "credit_hours": "3",
    "prerequisites": "-"
  },
  {
    "level": "2",
    "type": "elective",
    "department": "Ø¹Ù„ÙˆÙ… Ø§Ù„Ø­Ø§Ø³Ø¨ (Ø§Ø®ØªÙŠØ§Ø±ÙŠ)",
    "course_name": "Ø´Ø¨ÙƒØ§Øª Ø§Ù„Ø­Ø§Ø³Ø¨",
    "course_code": "COMP 204",
    "credit_hours": "3",
    "prerequisites": "-"
  },
  {
    "level": "2",
    "type": "elective",
    "department": "Ø¹Ù„ÙˆÙ… Ø§Ù„Ø­Ø§Ø³Ø¨ (Ø§Ø®ØªÙŠØ§Ø±ÙŠ)",
    "course_name": "Ø¨Ø±Ù…Ø¬Ø© Ø§Ù„ÙˆÙŠØ¨",
    "course_code": "COMP 206",
    "credit_hours": "3",
    "prerequisites": "COMP 104"
  },
  {
    "level": "2",
    "type": "elective",
    "department": "Ø¹Ù„ÙˆÙ… Ø§Ù„Ø­Ø§Ø³Ø¨ (Ø§Ø®ØªÙŠØ§Ø±ÙŠ)",
    "course_name": "Ù†Ø¸Ø±ÙŠØ© Ø§Ù„Ø¢Ù„ÙŠØ§Øª Ø§Ù„Ø°Ø§ØªÙŠØ©",
    "course_code": "COMP 208",
    "credit_hours": "3",
    "prerequisites": "-"
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
    "department": "Ø§Ù„Ø¥Ø­ØµØ§Ø¡ Ø§Ù„Ø±ÙŠØ§Ø¶ÙŠ (ØªØ®ØµØµ Ø£ÙˆÙ„)",
    "course_name": "Ø§Ø³ØªØ¯Ù„Ø§Ù„ Ø¥Ø­ØµØ§Ø¦ÙŠ (1)",
    "course_code": "STAT 301",
    "credit_hours": "3",
    "prerequisites": "STAT 202"
  },
  {
    "level": "3",
    "type": "mandatory",
    "department": "Ø§Ù„Ø¥Ø­ØµØ§Ø¡ Ø§Ù„Ø±ÙŠØ§Ø¶ÙŠ (ØªØ®ØµØµ Ø£ÙˆÙ„)",
    "course_name": "Ø¹Ù…Ù„ÙŠØ§Øª Ø¹Ø´ÙˆØ§Ø¦ÙŠØ© (1)",
    "course_code": "STAT 303",
    "credit_hours": "3",
    "prerequisites": "STAT 205"
  },
  {
    "level": "3",
    "type": "mandatory",
    "department": "Ø¹Ù„ÙˆÙ… Ø§Ù„Ø­Ø§Ø³Ø¨ (ØªØ®ØµØµ Ø«Ø§Ù†ÙŠ)",
    "course_name": "Ù†Ø¸Ø±ÙŠØ© Ø§Ù„ØªØ¹Ù‚Ø¯",
    "course_code": "COMP 305",
    "credit_hours": "3",
    "prerequisites": "-"
  },
  {
    "level": "3",
    "type": "mandatory",
    "department": "Ø¹Ù„ÙˆÙ… Ø§Ù„Ø­Ø§Ø³Ø¨ (ØªØ®ØµØµ Ø«Ø§Ù†ÙŠ)",
    "course_name": "Ù†Ø¸Ù… ØªØ´ØºÙŠÙ„",
    "course_code": "COMP 307",
    "credit_hours": "3",
    "prerequisites": "-"
  },
  {
    "level": "3",
    "type": "mandatory",
    "department": "Ø§Ù„Ø¥Ø­ØµØ§Ø¡ Ø§Ù„Ø±ÙŠØ§Ø¶ÙŠ (ØªØ®ØµØµ Ø£ÙˆÙ„)",
    "course_name": "Ø§Ø³ØªØ¯Ù„Ø§Ù„ Ø¥Ø­ØµØ§Ø¦ÙŠ (2)",
    "course_code": "STAT 302",
    "credit_hours": "3",
    "prerequisites": "STAT 202"
  },
  {
    "level": "3",
    "type": "mandatory",
    "department": "Ø§Ù„Ø¥Ø­ØµØ§Ø¡ Ø§Ù„Ø±ÙŠØ§Ø¶ÙŠ (ØªØ®ØµØµ Ø£ÙˆÙ„)",
    "course_name": "Ø·Ø±Ù‚ Ø§Ù„Ù…Ø¹Ø§ÙŠÙ†Ø©",
    "course_code": "STAT 304",
    "credit_hours": "3",
    "prerequisites": "-"
  },
  {
    "level": "3",
    "type": "mandatory",
    "department": "Ø§Ù„Ø¥Ø­ØµØ§Ø¡ Ø§Ù„Ø±ÙŠØ§Ø¶ÙŠ (ØªØ®ØµØµ Ø£ÙˆÙ„)",
    "course_name": "Ù†Ø¸Ø±ÙŠØ© Ø§Ù„ØµÙ„Ø§Ø­ÙŠØ©",
    "course_code": "STAT 314",
    "credit_hours": "2",
    "prerequisites": "-"
  },
  {
    "level": "3",
    "type": "mandatory",
    "department": "Ø¹Ù„ÙˆÙ… Ø§Ù„Ø­Ø§Ø³Ø¨ (ØªØ®ØµØµ Ø«Ø§Ù†ÙŠ)",
    "course_name": "ØªØ¢Ù„ÙÙŠØ§Øª Ø®ÙˆØ§Ø±Ø²Ù…ÙŠØ©",
    "course_code": "COMP 302",
    "credit_hours": "2",
    "prerequisites": "-"
  },
  {
    "level": "3",
    "type": "mandatory",
    "department": "Ø¹Ù„ÙˆÙ… Ø§Ù„Ø­Ø§Ø³Ø¨ (ØªØ®ØµØµ Ø«Ø§Ù†ÙŠ)",
    "course_name": "ØªØ´ÙÙŠØ±",
    "course_code": "COMP 308",
    "credit_hours": "3",
    "prerequisites": "-"
  },
  {
    "level": "3",
    "type": "elective",
    "department": "Ø§Ù„Ø¥Ø­ØµØ§Ø¡ Ø§Ù„Ø±ÙŠØ§Ø¶ÙŠ (Ø§Ø®ØªÙŠØ§Ø±ÙŠ)",
    "course_name": "Ø¥Ø­ØµØ§Ø¡Ø§Øª Ù…Ø±ØªØ¨Ø©",
    "course_code": "STAT 305",
    "credit_hours": "3",
    "prerequisites": "STAT 202"
  },
  {
    "level": "3",
    "type": "elective",
    "department": "Ø§Ù„Ø¥Ø­ØµØ§Ø¡ Ø§Ù„Ø±ÙŠØ§Ø¶ÙŠ (Ø§Ø®ØªÙŠØ§Ø±ÙŠ)",
    "course_name": "Ù…Ø­Ø§ÙƒØ§Ø© ÙˆÙ†Ù…Ø°Ø¬Ø©",
    "course_code": "STAT 311",
    "credit_hours": "3",
    "prerequisites": "STAT 202"
  },
  {
    "level": "3",
    "type": "elective",
    "department": "Ø§Ù„Ø¥Ø­ØµØ§Ø¡ Ø§Ù„Ø±ÙŠØ§Ø¶ÙŠ (Ø§Ø®ØªÙŠØ§Ø±ÙŠ)",
    "course_name": "Ø·Ø±Ù‚ Ø§Ø­ØªÙ…Ø§Ù„ÙŠØ© ÙÙŠ Ø¨Ø­ÙˆØ« Ø§Ù„Ø¹Ù…Ù„ÙŠØ§Øª (2)",
    "course_code": "STAT 315",
    "credit_hours": "3",
    "prerequisites": "STAT 204"
  },
  {
    "level": "3",
    "type": "elective",
    "department": "Ø¹Ù„ÙˆÙ… Ø§Ù„Ø­Ø§Ø³Ø¨ (Ø§Ø®ØªÙŠØ§Ø±ÙŠ)",
    "course_name": "Ù‚ÙˆØ§Ø¹Ø¯ ÙˆØ¯Ù„Ø§Ù„Ø§Øª Ù„ØºØ§Øª Ø§Ù„Ø¨Ø±Ù…Ø¬Ø©",
    "course_code": "COMP 303",
    "credit_hours": "2",
    "prerequisites": "-"
  },
  {
    "level": "3",
    "type": "elective",
    "department": "Ø¹Ù„ÙˆÙ… Ø§Ù„Ø­Ø§Ø³Ø¨ (Ø§Ø®ØªÙŠØ§Ø±ÙŠ)",
    "course_name": "Ù†Ø¸Ù… Ø§Ù„ÙˆØ³Ø§Ø¦Ø· Ø§Ù„Ù…ØªØ¹Ø¯Ø¯Ø©",
    "course_code": "COMP 309",
    "credit_hours": "2",
    "prerequisites": "-"
  },
  {
    "level": "3",
    "type": "elective",
    "department": "Ø¹Ù„ÙˆÙ… Ø§Ù„Ø­Ø§Ø³Ø¨ (Ø§Ø®ØªÙŠØ§Ø±ÙŠ)",
    "course_name": "Ø§Ù„Ù„ØºØ§Øª Ø§Ù„ØªØµØ±ÙŠØ­ÙŠØ©",
    "course_code": "COMP 311",
    "credit_hours": "2",
    "prerequisites": "-"
  },
  {
    "level": "3",
    "type": "elective",
    "department": "Ø¹Ù„ÙˆÙ… Ø§Ù„Ø­Ø§Ø³Ø¨ (Ø§Ø®ØªÙŠØ§Ø±ÙŠ)",
    "course_name": "ØªØµÙ…ÙŠÙ… Ù…Ø¤Ù„ÙØ§Øª",
    "course_code": "COMP 304",
    "credit_hours": "3",
    "prerequisites": "COMP 208, 212"
  },
  {
    "level": "3",
    "type": "elective",
    "department": "Ø¹Ù„ÙˆÙ… Ø§Ù„Ø­Ø§Ø³Ø¨ (Ø§Ø®ØªÙŠØ§Ø±ÙŠ)",
    "course_name": "Ø±Ø³ÙˆÙ…Ø§Øª Ø§Ù„Ø­Ø§Ø³Ø¨",
    "course_code": "COMP 306",
    "credit_hours": "3",
    "prerequisites": "COMP 212"
  },
  // ========== Ø§Ù„Ù…Ø³ØªÙˆÙ‰ Ø§Ù„Ø±Ø§Ø¨Ø¹ ==========
  {
    "level": "4",
    "type": "elective",
    "department": "Ù…ØªØ·Ù„Ø¨Ø§Øª Ø¬Ø§Ù…Ø¹Ø© (Ø§Ø®ØªÙŠØ§Ø±ÙŠ)",
    "course_name": "Ù…Ù‡Ø§Ø±Ø§Øª Ø§Ù„Ø¹Ù…Ù„",
    "course_code": "SKIL 401",
    "credit_hours": "1",
    "prerequisites": "-"
  },
  {
    "level": "4",
    "type": "elective",
    "department": "Ù…ØªØ·Ù„Ø¨Ø§Øª Ø¬Ø§Ù…Ø¹Ø© (Ø§Ø®ØªÙŠØ§Ø±ÙŠ)",
    "course_name": "Ø«Ù‚Ø§ÙØ© Ø¨ÙŠØ¦ÙŠØ©",
    "course_code": "ENCU 401",
    "credit_hours": "1",
    "prerequisites": "-"
  },
  {
    "level": "4",
    "type": "elective",
    "department": "Ù…ØªØ·Ù„Ø¨Ø§Øª Ø¬Ø§Ù…Ø¹Ø© (Ø§Ø®ØªÙŠØ§Ø±ÙŠ)",
    "course_name": "Ù†Ø´Ø£Ø© ÙˆØªØ§Ø±ÙŠØ® ÙˆØªØ·ÙˆØ± Ø§Ù„Ø¹Ù„ÙˆÙ…",
    "course_code": "GHDS 401",
    "credit_hours": "1",
    "prerequisites": "-"
  },
  {
    "level": "4",
    "type": "mandatory",
    "department": "Ø§Ù„Ø¥Ø­ØµØ§Ø¡ Ø§Ù„Ø±ÙŠØ§Ø¶ÙŠ (ØªØ®ØµØµ Ø£ÙˆÙ„)",
    "course_name": "ØªØµÙ…ÙŠÙ… ÙˆØªØ­Ù„ÙŠÙ„ Ø§Ù„ØªØ¬Ø§Ø±Ø¨",
    "course_code": "STAT 405",
    "credit_hours": "4",
    "prerequisites": "STAT 302"
  },
  {
    "level": "4",
    "type": "mandatory",
    "department": "Ø§Ù„Ø¥Ø­ØµØ§Ø¡ Ø§Ù„Ø±ÙŠØ§Ø¶ÙŠ (ØªØ®ØµØµ Ø£ÙˆÙ„)",
    "course_name": "ØªØ­Ù„ÙŠÙ„ Ø¥Ø­ØµØ§Ø¦ÙŠ Ù…ØªØ¹Ø¯Ø¯",
    "course_code": "STAT 415",
    "credit_hours": "2",
    "prerequisites": "STAT 205"
  },
  {
    "level": "4",
    "type": "mandatory",
    "department": "Ø¹Ù„ÙˆÙ… Ø§Ù„Ø­Ø§Ø³Ø¨ (ØªØ®ØµØµ Ø«Ø§Ù†ÙŠ)",
    "course_name": "Ø°ÙƒØ§Ø¡ Ø§ØµØ·Ù†Ø§Ø¹ÙŠ",
    "course_code": "COMP 401",
    "credit_hours": "3",
    "prerequisites": "-"
  },
  {
    "level": "4",
    "type": "mandatory",
    "department": "Ø¹Ù„ÙˆÙ… Ø§Ù„Ø­Ø§Ø³Ø¨ (ØªØ®ØµØµ Ø«Ø§Ù†ÙŠ)",
    "course_name": "Ø§Ù„Ù…Ø¹Ø§Ù„Ø¬Ø© Ø§Ù„Ù…ØªÙˆØ§Ø²ÙŠØ© ÙˆØ§Ù„Ù…ÙˆØ²Ø¹Ø©",
    "course_code": "COMP 403",
    "credit_hours": "3",
    "prerequisites": "-"
  },
  {
    "level": "4",
    "type": "mandatory",
    "department": "Ø§Ù„Ø¥Ø­ØµØ§Ø¡ Ø§Ù„Ø±ÙŠØ§Ø¶ÙŠ (ØªØ®ØµØµ Ø£ÙˆÙ„)",
    "course_name": "Ø³Ù„Ø§Ø³Ù„ Ø²Ù…Ù†ÙŠØ©",
    "course_code": "STAT 408",
    "credit_hours": "3",
    "prerequisites": "STAT 302"
  },
  {
    "level": "4",
    "type": "mandatory",
    "department": "Ø§Ù„Ø¥Ø­ØµØ§Ø¡ Ø§Ù„Ø±ÙŠØ§Ø¶ÙŠ (ØªØ®ØµØµ Ø£ÙˆÙ„)",
    "course_name": "Ø¹Ù…Ù„ÙŠØ§Øª Ø¹Ø´ÙˆØ§Ø¦ÙŠØ© (2)",
    "course_code": "STAT 418",
    "credit_hours": "2",
    "prerequisites": "STAT 303"
  },
  {
    "level": "4",
    "type": "mandatory",
    "department": "Ø§Ù„Ø¥Ø­ØµØ§Ø¡ Ø§Ù„Ø±ÙŠØ§Ø¶ÙŠ (ØªØ®ØµØµ Ø£ÙˆÙ„)",
    "course_name": "Ù…Ø´Ø±ÙˆØ¹ Ø¨Ø­Ø«ÙŠ ÙÙŠ Ø§Ù„Ø¥Ø­ØµØ§Ø¡",
    "course_code": "STAT 424",
    "credit_hours": "2",
    "prerequisites": "-"
  },
  {
    "level": "4",
    "type": "mandatory",
    "department": "Ø¹Ù„ÙˆÙ… Ø§Ù„Ø­Ø§Ø³Ø¨ (ØªØ®ØµØµ Ø«Ø§Ù†ÙŠ)",
    "course_name": "Ø§Ù„Ù…Ø¹Ù„ÙˆÙ…Ø§ØªÙŠØ© Ø§Ù„Ø­ÙŠÙˆÙŠØ©",
    "course_code": "COMP 402",
    "credit_hours": "3",
    "prerequisites": "COMP 201, 212"
  },
  {
    "level": "4",
    "type": "mandatory",
    "department": "Ø¹Ù„ÙˆÙ… Ø§Ù„Ø­Ø§Ø³Ø¨ (ØªØ®ØµØµ Ø«Ø§Ù†ÙŠ)",
    "course_name": "Ù…Ø´Ø±ÙˆØ¹ Ø­Ø§Ø³Ø¨ (Ù…Ø²Ø¯ÙˆØ¬)",
    "course_code": "COMP 418",
    "credit_hours": "3",
    "prerequisites": "-"
  },
  {
    "level": "4",
    "type": "elective",
    "department": "Ø§Ù„Ø¥Ø­ØµØ§Ø¡ Ø§Ù„Ø±ÙŠØ§Ø¶ÙŠ (Ø§Ø®ØªÙŠØ§Ø±ÙŠ)",
    "course_name": "Ø§Ù„ØªØ­Ù„ÙŠÙ„ Ø§Ù„ØªØªØ§Ø¨Ø¹ÙŠ",
    "course_code": "STAT 411",
    "credit_hours": "2",
    "prerequisites": "STAT 302"
  },
  {
    "level": "4",
    "type": "elective",
    "department": "Ø§Ù„Ø¥Ø­ØµØ§Ø¡ Ø§Ù„Ø±ÙŠØ§Ø¶ÙŠ (Ø§Ø®ØªÙŠØ§Ø±ÙŠ)",
    "course_name": "Ù†Ø¸Ø±ÙŠØ© Ø§ØªØ®Ø§Ø° Ø§Ù„Ù‚Ø±Ø§Ø±",
    "course_code": "STAT 417",
    "credit_hours": "2",
    "prerequisites": "STAT 301"
  },
  {
    "level": "4",
    "type": "elective",
    "department": "Ø§Ù„Ø¥Ø­ØµØ§Ø¡ Ø§Ù„Ø±ÙŠØ§Ø¶ÙŠ (Ø§Ø®ØªÙŠØ§Ø±ÙŠ)",
    "course_name": "Ù†Ø¸Ø±ÙŠØ© Ø§Ù„Ø·ÙˆØ§Ø¨ÙŠØ±",
    "course_code": "STAT 412",
    "credit_hours": "2",
    "prerequisites": "STAT 303"
  },
  {
    "level": "4",
    "type": "elective",
    "department": "Ø§Ù„Ø¥Ø­ØµØ§Ø¡ Ø§Ù„Ø±ÙŠØ§Ø¶ÙŠ (Ø§Ø®ØªÙŠØ§Ø±ÙŠ)",
    "course_name": "Ù†Ø¸Ø±ÙŠØ© Ø§Ù„ØªØ¬Ø¯ÙŠØ¯",
    "course_code": "STAT 416",
    "credit_hours": "2",
    "prerequisites": "STAT 205"
  },
  {
    "level": "4",
    "type": "elective",
    "department": "Ø¹Ù„ÙˆÙ… Ø§Ù„Ø­Ø§Ø³Ø¨ (Ø§Ø®ØªÙŠØ§Ø±ÙŠ)",
    "course_name": "Ù…Ø¹Ø§Ù„Ø¬Ø© Ø§Ù„ØµÙˆØ±",
    "course_code": "COMP 407",
    "credit_hours": "3",
    "prerequisites": "COMP 212"
  },
  {
    "level": "4",
    "type": "elective",
    "department": "Ø¹Ù„ÙˆÙ… Ø§Ù„Ø­Ø§Ø³Ø¨ (Ø§Ø®ØªÙŠØ§Ø±ÙŠ)",
    "course_name": "Ø§Ù„Ù‡Ù†Ø¯Ø³Ø© Ø§Ù„Ø­Ø³Ø§Ø¨ÙŠØ©",
    "course_code": "COMP 411",
    "credit_hours": "3",
    "prerequisites": "COMP 201, 212"
  },
  {
    "level": "4",
    "type": "elective",
    "department": "Ø¹Ù„ÙˆÙ… Ø§Ù„Ø­Ø§Ø³Ø¨ (Ø§Ø®ØªÙŠØ§Ø±ÙŠ)",
    "course_name": "Ù…ÙˆØ¶ÙˆØ¹Ø§Øª Ù…Ø®ØªØ§Ø±Ø© ÙÙŠ Ø§Ù„Ø®ÙˆØ§Ø±Ø²Ù…ÙŠØ§Øª",
    "course_code": "COMP 413",
    "credit_hours": "3",
    "prerequisites": "COMP 201"
  },
  {
    "level": "4",
    "type": "elective",
    "department": "Ø¹Ù„ÙˆÙ… Ø§Ù„Ø­Ø§Ø³Ø¨ (Ø§Ø®ØªÙŠØ§Ø±ÙŠ)",
    "course_name": "Ù‡Ù†Ø¯Ø³Ø© Ø§Ù„Ø¨Ø±Ù…Ø¬ÙŠØ§Øª",
    "course_code": "COMP 404",
    "credit_hours": "3",
    "prerequisites": "COMP 212"
  },
  {
    "level": "4",
    "type": "elective",
    "department": "Ø¹Ù„ÙˆÙ… Ø§Ù„Ø­Ø§Ø³Ø¨ (Ø§Ø®ØªÙŠØ§Ø±ÙŠ)",
    "course_name": "Ù…ÙˆØ¶ÙˆØ¹Ø§Øª Ù…Ø®ØªØ§Ø±Ø© ÙÙŠ Ø§Ù„Ø­ÙˆØ³Ø¨Ø©",
    "course_code": "COMP 414",
    "credit_hours": "3",
    "prerequisites": "COMP 212"
  },
  {
    "level": "4",
    "type": "elective",
    "department": "Ø¹Ù„ÙˆÙ… Ø§Ù„Ø­Ø§Ø³Ø¨ (Ø§Ø®ØªÙŠØ§Ø±ÙŠ)",
    "course_name": "Ø§Ø³ØªØ®Ù„Ø§Øµ Ø§Ù„Ø¨ÙŠØ§Ù†Ø§Øª ÙˆØ§Ù„ÙˆÙŠØ¨",
    "course_code": "COMP 416",
    "credit_hours": "3",
    "prerequisites": "COMP 207"
  },
];

class StatsCSCoursesScreen extends StatefulWidget {
  const StatsCSCoursesScreen({super.key});

  @override
  State<StatsCSCoursesScreen> createState() => _StatsCSCoursesScreenState();
}

class _StatsCSCoursesScreenState extends State<StatsCSCoursesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _filterType = 'all';
  String _filterSpec = 'all';

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

  List<Map<String, String>> _getCourses(String level) {
    return _courses.where((c) {
      if (c['level'] != level) return false;
      if (_filterType != 'all' && c['type'] != _filterType) return false;
      if (_filterSpec == 'stats') {
        return c['department']!.contains('Ø¥Ø­ØµØ§Ø¡') ||
            c['department']!.contains('Ù…ØªØ·Ù„Ø¨Ø§Øª');
      }
      if (_filterSpec == 'cs') {
        return c['department']!.contains('Ø­Ø§Ø³Ø¨') ||
            c['department']!.contains('Ù…ØªØ·Ù„Ø¨Ø§Øª');
      }
      return true;
    }).toList();
  }

  int _totalHours(String level) => _getCourses(level)
      .fold(0, (s, c) => s + (int.tryParse(c['credit_hours'] ?? '0') ?? 0));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        title: const Text(
          'Ø¥Ø­ØµØ§Ø¡ Ø±ÙŠØ§Ø¶ÙŠ â€“ Ø¹Ù„ÙˆÙ… Ø§Ù„Ø­Ø§Ø³Ø¨ (Ù…Ø²Ø¯ÙˆØ¬)',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
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
          _buildFilters(),
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

  Widget _buildFilters() {
    return Container(
      color: const Color(0xFF1E3A5F),
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      child: Column(
        children: [
          Row(
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
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _Chip(
                  label: 'Ø§Ù„ÙƒÙ„',
                  selected: _filterSpec == 'all',
                  color: const Color(0xFF1E3A5F),
                  onTap: () => setState(() => _filterSpec = 'all')),
              const SizedBox(width: 8),
              _Chip(
                  label: 'Ø¥Ø­ØµØ§Ø¡ Ø±ÙŠØ§Ø¶ÙŠ',
                  selected: _filterSpec == 'stats',
                  color: const Color(0xFF0284C7),
                  onTap: () => setState(() => _filterSpec = 'stats')),
              const SizedBox(width: 8),
              _Chip(
                  label: 'Ø¹Ù„ÙˆÙ… Ø§Ù„Ø­Ø§Ø³Ø¨',
                  selected: _filterSpec == 'cs',
                  color: const Color(0xFF7C3AED),
                  onTap: () => setState(() => _filterSpec = 'cs')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPage(String level, String label) {
    final courses = _getCourses(level);
    final totalHours = _totalHours(level);

    if (courses.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text('Ù„Ø§ ØªÙˆØ¬Ø¯ Ù…Ù‚Ø±Ø±Ø§Øª Ù„Ù‡Ø°Ø§ Ø§Ù„ÙÙ„ØªØ±',
                style: TextStyle(color: Colors.grey[500], fontSize: 16)),
          ],
        ),
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
                      Text(label,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text('${courses.length} Ù…Ù‚Ø±Ø±',
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 14)),
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
                        Text('$totalHours',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold)),
                        const Text('Ø³Ø§Ø¹Ø©',
                            style:
                                TextStyle(color: Colors.white70, fontSize: 12)),
                      ],
                    ),
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
                child: _CourseCard(course: courses[index]),
              ),
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

  Color get _specColor {
    final dept = course['department'] ?? '';
    if (dept.contains('Ø­Ø§Ø³Ø¨')) return const Color(0xFF7C3AED);
    if (dept.contains('Ø¥Ø­ØµØ§Ø¡')) return const Color(0xFF0284C7);
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
        border: Border(right: BorderSide(color: _specColor, width: 4)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
                        color: _specColor,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5)),
              ],
            ),
            const SizedBox(height: 10),
            Text(course['course_name'] ?? '',
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.right,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111827))),
            const SizedBox(height: 6),
            Text(course['department'] ?? '',
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.right,
                style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (hasPrereq)
                  Flexible(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.link,
                            size: 14, color: Color(0xFF9CA3AF)),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(course['prerequisites'] ?? '',
                              style: const TextStyle(
                                  fontSize: 11, color: Color(0xFF9CA3AF)),
                              overflow: TextOverflow.ellipsis),
                        ),
                      ],
                    ),
                  )
                else
                  const SizedBox.shrink(),
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
                      Text('${course['credit_hours']} Ø³Ø§Ø¹Ø©',
                          style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF374151),
                              fontWeight: FontWeight.w600)),
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
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? color : Colors.white.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: selected ? color : Colors.white30),
        ),
        child: Text(label,
            style: TextStyle(
                color: selected ? Colors.white : Colors.white70,
                fontWeight: FontWeight.w600,
                fontSize: 12)),
      ),
    );
  }
}
