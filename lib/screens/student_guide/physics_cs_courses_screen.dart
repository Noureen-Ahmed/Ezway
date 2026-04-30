import 'package:flutter/material.dart';

const List<Map<String, String>> _courses = [
  // ========== Ø§Ù„Ù…Ø³ØªÙˆÙ‰ Ø§Ù„Ø£ÙˆÙ„ ==========
  {
    "level": "1",
    "type": "mandatory",
    "spec": "both",
    "department": "Ù…ØªØ·Ù„Ø¨Ø§Øª Ø¬Ø§Ù…Ø¹Ø©",
    "course_name": "Ø§Ù„Ø£Ù…Ù† ÙˆØ§Ù„Ø³Ù„Ø§Ù…Ø©",
    "course_code": "SAFS 101",
    "credit_hours": "1",
    "prerequisites": "-"
  },
  {
    "level": "1",
    "type": "mandatory",
    "spec": "both",
    "department": "Ù…ØªØ·Ù„Ø¨Ø§Øª Ø¬Ø§Ù…Ø¹Ø©",
    "course_name": "Ø­Ù‚ÙˆÙ‚ Ø§Ù„Ø¥Ù†Ø³Ø§Ù†",
    "course_code": "HURI 101",
    "credit_hours": "1",
    "prerequisites": "-"
  },
  {
    "level": "1",
    "type": "mandatory",
    "spec": "both",
    "department": "Ø§Ù„Ø±ÙŠØ§Ø¶ÙŠØ§Øª (Ù…ØªØ·Ù„Ø¨Ø§Øª Ø§Ù„ÙƒÙ„ÙŠØ©)",
    "course_name": "ØªÙØ§Ø¶Ù„ ÙˆØªÙƒØ§Ù…Ù„ (1)",
    "course_code": "MATH 101",
    "credit_hours": "4",
    "prerequisites": "-"
  },
  {
    "level": "1",
    "type": "mandatory",
    "spec": "phys",
    "department": "Ø§Ù„ÙÙŠØ²ÙŠØ§Ø¡ (ØªØ®ØµØµ Ø£ÙˆÙ„)",
    "course_name": "ÙÙŠØ²ÙŠØ§Ø¡ Ø¹Ø§Ù…Ø© (1)",
    "course_code": "PHYS 101",
    "credit_hours": "4",
    "prerequisites": "-"
  },
  {
    "level": "1",
    "type": "mandatory",
    "spec": "both",
    "department": "Ø§Ù„ÙƒÙŠÙ…ÙŠØ§Ø¡ (Ù…ØªØ·Ù„Ø¨Ø§Øª Ø§Ù„ÙƒÙ„ÙŠØ©)",
    "course_name": "ÙƒÙŠÙ…ÙŠØ§Ø¡ Ø¹Ø§Ù…Ø© (2)",
    "course_code": "CHEM 101",
    "credit_hours": "3",
    "prerequisites": "-"
  },
  {
    "level": "1",
    "type": "mandatory",
    "spec": "both",
    "department": "Ø§Ù„ÙƒÙŠÙ…ÙŠØ§Ø¡ (Ù…ØªØ·Ù„Ø¨Ø§Øª Ø§Ù„ÙƒÙ„ÙŠØ©)",
    "course_name": "Ø¹Ù…Ù„ÙŠ ÙƒÙŠÙ…ÙŠØ§Ø¡ Ø¹Ø§Ù…Ø© (2)",
    "course_code": "CHEM 103",
    "credit_hours": "1",
    "prerequisites": "-"
  },
  {
    "level": "1",
    "type": "mandatory",
    "spec": "phys",
    "department": "Ø§Ù„ÙÙŠØ²ÙŠØ§Ø¡ (ØªØ®ØµØµ Ø£ÙˆÙ„)",
    "course_name": "ÙÙŠØ²ÙŠØ§Ø¡ Ø¹Ø§Ù…Ø© (2)",
    "course_code": "PHYS 103",
    "credit_hours": "3",
    "prerequisites": "-"
  },
  {
    "level": "1",
    "type": "mandatory",
    "spec": "both",
    "department": "Ù…ØªØ·Ù„Ø¨Ø§Øª Ø¬Ø§Ù…Ø¹Ø©",
    "course_name": "Ù„ØºØ© Ø¥Ù†Ø¬Ù„ÙŠØ²ÙŠØ© (1)",
    "course_code": "ENGL 102",
    "credit_hours": "2",
    "prerequisites": "-"
  },
  {
    "level": "1",
    "type": "mandatory",
    "spec": "both",
    "department": "Ù…ØªØ·Ù„Ø¨Ø§Øª Ø¬Ø§Ù…Ø¹Ø©",
    "course_name": "Ù…Ø¯Ø®Ù„ ÙÙŠ Ø§Ù„Ø­Ø§Ø³Ø¨ Ø§Ù„Ø¢Ù„ÙŠ",
    "course_code": "INCO 102",
    "credit_hours": "1",
    "prerequisites": "-"
  },
  {
    "level": "1",
    "type": "mandatory",
    "spec": "both",
    "department": "Ø§Ù„Ø±ÙŠØ§Ø¶ÙŠØ§Øª (Ù…ØªØ·Ù„Ø¨Ø§Øª Ø§Ù„ÙƒÙ„ÙŠØ©)",
    "course_name": "ØªÙØ§Ø¶Ù„ ÙˆØªÙƒØ§Ù…Ù„ (2)",
    "course_code": "MATH 102",
    "credit_hours": "3",
    "prerequisites": "-"
  },
  {
    "level": "1",
    "type": "mandatory",
    "spec": "both",
    "department": "Ø§Ù„Ø±ÙŠØ§Ø¶ÙŠØ§Øª (Ù…ØªØ·Ù„Ø¨Ø§Øª Ø§Ù„ÙƒÙ„ÙŠØ©)",
    "course_name": "Ù…ÙØ§Ù‡ÙŠÙ… Ø£Ø³Ø§Ø³ÙŠØ© ÙÙŠ Ø§Ù„Ø±ÙŠØ§Ø¶ÙŠØ§Øª",
    "course_code": "MATH 104",
    "credit_hours": "3",
    "prerequisites": "-"
  },
  {
    "level": "1",
    "type": "mandatory",
    "spec": "phys",
    "department": "Ø§Ù„ÙÙŠØ²ÙŠØ§Ø¡ (ØªØ®ØµØµ Ø£ÙˆÙ„)",
    "course_name": "ÙÙŠØ²ÙŠØ§Ø¡ Ø¹Ø§Ù…Ø© (3)",
    "course_code": "PHYS 102",
    "credit_hours": "3",
    "prerequisites": "-"
  },
  {
    "level": "1",
    "type": "mandatory",
    "spec": "phys",
    "department": "Ø§Ù„ÙÙŠØ²ÙŠØ§Ø¡ (ØªØ®ØµØµ Ø£ÙˆÙ„)",
    "course_name": "ÙÙŠØ²ÙŠØ§Ø¡ Ø¹Ø§Ù…Ø© (4)",
    "course_code": "PHYS 104",
    "credit_hours": "3",
    "prerequisites": "-"
  },
  {
    "level": "1",
    "type": "mandatory",
    "spec": "cs",
    "department": "Ø¹Ù„ÙˆÙ… Ø§Ù„Ø­Ø§Ø³Ø¨ (ØªØ®ØµØµ Ø«Ø§Ù†ÙŠ)",
    "course_name": "Ù…Ù‚Ø¯Ù…Ø© ÙÙŠ Ø§Ù„Ø­Ø§Ø³Ø¨ Ø§Ù„Ø¢Ù„ÙŠ",
    "course_code": "COMP 102",
    "credit_hours": "3",
    "prerequisites": "-"
  },
  {
    "level": "1",
    "type": "mandatory",
    "spec": "cs",
    "department": "Ø¹Ù„ÙˆÙ… Ø§Ù„Ø­Ø§Ø³Ø¨ (ØªØ®ØµØµ Ø«Ø§Ù†ÙŠ)",
    "course_name": "Ø¨Ø±Ù…Ø¬Ø© Ø­Ø§Ø³Ø¨ (1)",
    "course_code": "COMP 104",
    "credit_hours": "3",
    "prerequisites": "-"
  },
  // ========== Ø§Ù„Ù…Ø³ØªÙˆÙ‰ Ø§Ù„Ø«Ø§Ù†ÙŠ ==========
  {
    "level": "2",
    "type": "mandatory",
    "spec": "both",
    "department": "Ù…ØªØ·Ù„Ø¨Ø§Øª Ø¬Ø§Ù…Ø¹Ø©",
    "course_name": "Ù„ØºØ© Ø¥Ù†Ø¬Ù„ÙŠØ²ÙŠØ© (2)",
    "course_code": "ENGL 201",
    "credit_hours": "2",
    "prerequisites": "ENGL 102"
  },
  {
    "level": "2",
    "type": "mandatory",
    "spec": "phys",
    "department": "Ø§Ù„ÙÙŠØ²ÙŠØ§Ø¡ (ØªØ®ØµØµ Ø£ÙˆÙ„)",
    "course_name": "ÙÙŠØ²ÙŠØ§Ø¡ Ø­Ø¯ÙŠØ«Ø© (1)",
    "course_code": "PHYS 201",
    "credit_hours": "2",
    "prerequisites": "PHYS 102"
  },
  {
    "level": "2",
    "type": "mandatory",
    "spec": "phys",
    "department": "Ø§Ù„ÙÙŠØ²ÙŠØ§Ø¡ (ØªØ®ØµØµ Ø£ÙˆÙ„)",
    "course_name": "ÙƒÙ‡Ø±ÙˆÙ…ØºÙ†Ø§Ø·ÙŠØ³ÙŠØ©",
    "course_code": "PHYS 203",
    "credit_hours": "2",
    "prerequisites": "PHYS 101"
  },
  {
    "level": "2",
    "type": "mandatory",
    "spec": "phys",
    "department": "Ø§Ù„ÙÙŠØ²ÙŠØ§Ø¡ (ØªØ®ØµØµ Ø£ÙˆÙ„)",
    "course_name": "Ø¯ÙŠÙ†Ø§Ù…ÙŠÙƒØ§ Ø­Ø±Ø§Ø±ÙŠØ©",
    "course_code": "PHYS 205",
    "credit_hours": "2",
    "prerequisites": "PHYS 104"
  },
  {
    "level": "2",
    "type": "mandatory",
    "spec": "both",
    "department": "Ø§Ù„Ø±ÙŠØ§Ø¶ÙŠØ§Øª",
    "course_name": "ØªØ­Ù„ÙŠÙ„ Ù…ØªØ¬Ù‡Ø§Øª ÙˆØ­Ø³Ø§Ø¨ Ù…Ù…ØªØ¯Ø§Øª ÙˆÙ…ØµÙÙˆÙØ§Øª",
    "course_code": "MATH 225",
    "credit_hours": "3",
    "prerequisites": "MATH 102"
  },
  {
    "level": "2",
    "type": "mandatory",
    "spec": "cs",
    "department": "Ø¹Ù„ÙˆÙ… Ø§Ù„Ø­Ø§Ø³Ø¨ (ØªØ®ØµØµ Ø«Ø§Ù†ÙŠ)",
    "course_name": "ØªØµÙ…ÙŠÙ… ÙˆØªØ­Ù„ÙŠÙ„ Ø§Ù„Ø®ÙˆØ§Ø±Ø²Ù…ÙŠØ§Øª",
    "course_code": "COMP 201",
    "credit_hours": "3",
    "prerequisites": "-"
  },
  {
    "level": "2",
    "type": "mandatory",
    "spec": "cs",
    "department": "Ø¹Ù„ÙˆÙ… Ø§Ù„Ø­Ø§Ø³Ø¨ (ØªØ®ØµØµ Ø«Ø§Ù†ÙŠ)",
    "course_name": "Ù†Ø¸Ù… Ù‚ÙˆØ§Ø¹Ø¯ Ø¨ÙŠØ§Ù†Ø§Øª",
    "course_code": "COMP 207",
    "credit_hours": "4",
    "prerequisites": "-"
  },
  {
    "level": "2",
    "type": "mandatory",
    "spec": "phys",
    "department": "Ø§Ù„ÙÙŠØ²ÙŠØ§Ø¡ (ØªØ®ØµØµ Ø£ÙˆÙ„)",
    "course_name": "Ø¨ØµØ±ÙŠØ§Øª ÙÙŠØ²ÙŠØ§Ø¦ÙŠØ©",
    "course_code": "PHYS 204",
    "credit_hours": "2",
    "prerequisites": "PHYS 102"
  },
  {
    "level": "2",
    "type": "mandatory",
    "spec": "phys",
    "department": "Ø§Ù„ÙÙŠØ²ÙŠØ§Ø¡ (ØªØ®ØµØµ Ø£ÙˆÙ„)",
    "course_name": "Ù…Ù‚Ø¯Ù…Ø© ÙÙŠ Ø§Ù„Ø¯ÙˆØ§Ø¦Ø± Ø§Ù„ÙƒÙ‡Ø±Ø¨ÙŠØ©",
    "course_code": "PHYS 216",
    "credit_hours": "2",
    "prerequisites": "PHYS 101"
  },
  {
    "level": "2",
    "type": "mandatory",
    "spec": "both",
    "department": "Ø§Ù„Ø¥Ø­ØµØ§Ø¡",
    "course_name": "Ø§Ù„Ø¥Ø­ØµØ§Ø¡ ÙˆØ§Ù„Ø§Ø­ØªÙ…Ø§Ù„Ø§Øª",
    "course_code": "STAT 232",
    "credit_hours": "2",
    "prerequisites": "MATH 102"
  },
  {
    "level": "2",
    "type": "mandatory",
    "spec": "cs",
    "department": "Ø¹Ù„ÙˆÙ… Ø§Ù„Ø­Ø§Ø³Ø¨ (ØªØ®ØµØµ Ø«Ø§Ù†ÙŠ)",
    "course_name": "ØªØ±Ø§ÙƒÙŠØ¨ Ø§Ù„Ø¨ÙŠØ§Ù†Ø§Øª",
    "course_code": "COMP 202",
    "credit_hours": "3",
    "prerequisites": "COMP 104"
  },
  {
    "level": "2",
    "type": "mandatory",
    "spec": "cs",
    "department": "Ø¹Ù„ÙˆÙ… Ø§Ù„Ø­Ø§Ø³Ø¨ (ØªØ®ØµØµ Ø«Ø§Ù†ÙŠ)",
    "course_name": "Ø¨Ø±Ù…Ø¬Ø© Ø­Ø§Ø³Ø¨ Ù…ØªÙ‚Ø¯Ù…Ø©",
    "course_code": "COMP 212",
    "credit_hours": "3",
    "prerequisites": "COMP 104"
  },
  {
    "level": "2",
    "type": "elective",
    "spec": "both",
    "department": "Ø§Ù„Ø±ÙŠØ§Ø¶ÙŠØ§Øª (Ø§Ø®ØªÙŠØ§Ø±ÙŠ)",
    "course_name": "Ù…Ø¹Ø§Ø¯Ù„Ø§Øª ØªÙØ§Ø¶Ù„ÙŠØ© Ø¹Ø§Ø¯ÙŠØ©",
    "course_code": "MATH 202",
    "credit_hours": "3",
    "prerequisites": "MATH 101 Ø£Ùˆ 102"
  },
  {
    "level": "2",
    "type": "elective",
    "spec": "phys",
    "department": "Ø§Ù„ÙÙŠØ²ÙŠØ§Ø¡ (Ø§Ø®ØªÙŠØ§Ø±ÙŠ)",
    "course_name": "ÙÙŠØ²ÙŠØ§Ø¡ Ø­Ø³Ø§Ø¨ÙŠØ©",
    "course_code": "PHYS 210",
    "credit_hours": "3",
    "prerequisites": "MATH 102"
  },
  // ========== Ø§Ù„Ù…Ø³ØªÙˆÙ‰ Ø§Ù„Ø«Ø§Ù„Ø« ==========
  {
    "level": "3",
    "type": "mandatory",
    "spec": "both",
    "department": "Ù…ØªØ·Ù„Ø¨Ø§Øª Ø¬Ø§Ù…Ø¹Ø©",
    "course_name": "Ø§Ù„ØªÙÙƒÙŠØ± Ø§Ù„Ø¹Ù„Ù…ÙŠ",
    "course_code": "SCTH 301",
    "credit_hours": "1",
    "prerequisites": "-"
  },
  {
    "level": "3",
    "type": "mandatory",
    "spec": "both",
    "department": "Ù…ØªØ·Ù„Ø¨Ø§Øª Ø¬Ø§Ù…Ø¹Ø©",
    "course_name": "Ø£Ø®Ù„Ø§Ù‚ÙŠØ§Øª Ø§Ù„Ø¨Ø­Ø« Ø§Ù„Ø¹Ù„Ù…ÙŠ",
    "course_code": "ETHR 303",
    "credit_hours": "1",
    "prerequisites": "-"
  },
  {
    "level": "3",
    "type": "mandatory",
    "spec": "cs",
    "department": "Ø¹Ù„ÙˆÙ… Ø§Ù„Ø­Ø§Ø³Ø¨ (ØªØ®ØµØµ Ø«Ø§Ù†ÙŠ)",
    "course_name": "Ù†Ø¸Ø±ÙŠØ© Ø§Ù„ØªØ¹Ù‚Ø¯",
    "course_code": "COMP 305",
    "credit_hours": "3",
    "prerequisites": "-"
  },
  {
    "level": "3",
    "type": "mandatory",
    "spec": "cs",
    "department": "Ø¹Ù„ÙˆÙ… Ø§Ù„Ø­Ø§Ø³Ø¨ (ØªØ®ØµØµ Ø«Ø§Ù†ÙŠ)",
    "course_name": "Ù†Ø¸Ù… Ø§Ù„ØªØ´ØºÙŠÙ„",
    "course_code": "COMP 307",
    "credit_hours": "3",
    "prerequisites": "-"
  },
  {
    "level": "3",
    "type": "mandatory",
    "spec": "phys",
    "department": "Ø§Ù„ÙÙŠØ²ÙŠØ§Ø¡ (ØªØ®ØµØµ Ø£ÙˆÙ„)",
    "course_name": "Ø§ØªØµØ§Ù„Ø§Øª Ø¨ØµØ±ÙŠØ©",
    "course_code": "PHYS 382",
    "credit_hours": "2",
    "prerequisites": "PHYS 204"
  },
  {
    "level": "3",
    "type": "mandatory",
    "spec": "phys",
    "department": "Ø§Ù„ÙÙŠØ²ÙŠØ§Ø¡ (ØªØ®ØµØµ Ø£ÙˆÙ„)",
    "course_name": "Ù…ÙŠÙƒØ§Ù†ÙŠÙƒØ§ Ø¥Ø­ØµØ§Ø¦ÙŠØ©",
    "course_code": "PHYS 360",
    "credit_hours": "2",
    "prerequisites": "PHYS 205, STAT 232"
  },
  {
    "level": "3",
    "type": "mandatory",
    "spec": "phys",
    "department": "Ø§Ù„ÙÙŠØ²ÙŠØ§Ø¡ (ØªØ®ØµØµ Ø£ÙˆÙ„)",
    "course_name": "Ø¥Ù„ÙƒØªØ±ÙˆÙ†ÙŠØ§Øª",
    "course_code": "PHYS 364",
    "credit_hours": "2",
    "prerequisites": "PHYS 206"
  },
  {
    "level": "3",
    "type": "mandatory",
    "spec": "phys",
    "department": "Ø§Ù„ÙÙŠØ²ÙŠØ§Ø¡ (ØªØ®ØµØµ Ø£ÙˆÙ„)",
    "course_name": "ÙÙŠØ²ÙŠØ§Ø¡ Ù†ÙˆÙˆÙŠØ©",
    "course_code": "PHYS 358",
    "credit_hours": "2",
    "prerequisites": "PHYS 201"
  },
  {
    "level": "3",
    "type": "elective",
    "spec": "cs",
    "department": "Ø¹Ù„ÙˆÙ… Ø§Ù„Ø­Ø§Ø³Ø¨ (Ø§Ø®ØªÙŠØ§Ø±ÙŠ)",
    "course_name": "Ù‚ÙˆØ§Ø¹Ø¯ ÙˆØ¯Ù„Ø§Ù„Ø§Øª Ù„ØºØ§Øª Ø§Ù„Ø¨Ø±Ù…Ø¬Ø©",
    "course_code": "COMP 303",
    "credit_hours": "2",
    "prerequisites": "-"
  },
  {
    "level": "3",
    "type": "elective",
    "spec": "cs",
    "department": "Ø¹Ù„ÙˆÙ… Ø§Ù„Ø­Ø§Ø³Ø¨ (Ø§Ø®ØªÙŠØ§Ø±ÙŠ)",
    "course_name": "Ù†Ø¸Ù… Ø§Ù„ÙˆØ³Ø§Ø¦Ø· Ø§Ù„Ù…ØªØ¹Ø¯Ø¯Ø©",
    "course_code": "COMP 309",
    "credit_hours": "2",
    "prerequisites": "-"
  },
  {
    "level": "3",
    "type": "elective",
    "spec": "cs",
    "department": "Ø¹Ù„ÙˆÙ… Ø§Ù„Ø­Ø§Ø³Ø¨ (Ø§Ø®ØªÙŠØ§Ø±ÙŠ)",
    "course_name": "Ø§Ù„Ù„ØºØ§Øª Ø§Ù„ØªØµØ±ÙŠØ­ÙŠØ©",
    "course_code": "COMP 311",
    "credit_hours": "2",
    "prerequisites": "-"
  },
  // ========== Ø§Ù„Ù…Ø³ØªÙˆÙ‰ Ø§Ù„Ø±Ø§Ø¨Ø¹ ==========
  {
    "level": "4",
    "type": "elective",
    "spec": "both",
    "department": "Ù…ØªØ·Ù„Ø¨Ø§Øª Ø¬Ø§Ù…Ø¹Ø© (Ø§Ø®ØªÙŠØ§Ø±ÙŠ)",
    "course_name": "Ù…Ù‡Ø§Ø±Ø§Øª Ø§Ù„Ø¹Ù…Ù„",
    "course_code": "SKIL 401",
    "credit_hours": "1",
    "prerequisites": "-"
  },
  {
    "level": "4",
    "type": "elective",
    "spec": "both",
    "department": "Ù…ØªØ·Ù„Ø¨Ø§Øª Ø¬Ø§Ù…Ø¹Ø© (Ø§Ø®ØªÙŠØ§Ø±ÙŠ)",
    "course_name": "Ø«Ù‚Ø§ÙØ© Ø¨ÙŠØ¦ÙŠØ©",
    "course_code": "ENCU 401",
    "credit_hours": "1",
    "prerequisites": "-"
  },
  {
    "level": "4",
    "type": "elective",
    "spec": "both",
    "department": "Ù…ØªØ·Ù„Ø¨Ø§Øª Ø¬Ø§Ù…Ø¹Ø© (Ø§Ø®ØªÙŠØ§Ø±ÙŠ)",
    "course_name": "Ù†Ø´Ø£Ø© ÙˆØªØ§Ø±ÙŠØ® ÙˆØªØ·ÙˆØ± Ø§Ù„Ø¹Ù„ÙˆÙ…",
    "course_code": "GHDS 401",
    "credit_hours": "1",
    "prerequisites": "-"
  },
  {
    "level": "4",
    "type": "mandatory",
    "spec": "phys",
    "department": "Ø§Ù„ÙÙŠØ²ÙŠØ§Ø¡ (ØªØ®ØµØµ Ø£ÙˆÙ„)",
    "course_name": "Ø¥Ù„ÙƒØªØ±ÙˆÙ†ÙŠØ§Øª Ø±Ù‚Ù…ÙŠØ©",
    "course_code": "PHYS 449",
    "credit_hours": "2",
    "prerequisites": "PHYS 364"
  },
  {
    "level": "4",
    "type": "mandatory",
    "spec": "phys",
    "department": "Ø§Ù„ÙÙŠØ²ÙŠØ§Ø¡ (ØªØ®ØµØµ Ø£ÙˆÙ„)",
    "course_name": "ÙÙŠØ²ÙŠØ§Ø¡ Ù†Ø§Ù†ÙˆÙŠØ© ÙˆØªÙ‚Ù†ÙŠØ© Ø§Ù„Ù†Ø§Ù†Ùˆ",
    "course_code": "PHYS 461",
    "credit_hours": "2",
    "prerequisites": "PHYS 362"
  },
  {
    "level": "4",
    "type": "mandatory",
    "spec": "phys",
    "department": "Ø§Ù„ÙÙŠØ²ÙŠØ§Ø¡ (ØªØ®ØµØµ Ø£ÙˆÙ„)",
    "course_name": "Ù…Ù‚Ø¯Ù…Ø© ÙÙŠ Ø§Ù„Ù…ÙˆØ§Ø¯ Ø§Ù„ÙÙˆØªÙˆÙ†ÙŠØ©",
    "course_code": "PHYS 471",
    "credit_hours": "2",
    "prerequisites": "PHYS 362"
  },
  {
    "level": "4",
    "type": "mandatory",
    "spec": "phys",
    "department": "Ø§Ù„ÙÙŠØ²ÙŠØ§Ø¡ (ØªØ®ØµØµ Ø£ÙˆÙ„)",
    "course_name": "ÙÙŠØ²ÙŠØ§Ø¡ Ø­Ø³Ø§Ø¨ÙŠØ© Ù…ØªÙ‚Ø¯Ù…Ø©",
    "course_code": "PHYS 476",
    "credit_hours": "3",
    "prerequisites": "PHYS 315"
  },
  {
    "level": "4",
    "type": "mandatory",
    "spec": "phys",
    "department": "Ø§Ù„ÙÙŠØ²ÙŠØ§Ø¡ (ØªØ®ØµØµ Ø£ÙˆÙ„)",
    "course_name": "ÙÙŠØ²ÙŠØ§Ø¡ ØªØ¬Ø±ÙŠØ¨ÙŠØ©",
    "course_code": "PHYS 438",
    "credit_hours": "2",
    "prerequisites": "-"
  },
  {
    "level": "4",
    "type": "mandatory",
    "spec": "phys",
    "department": "Ø§Ù„ÙÙŠØ²ÙŠØ§Ø¡ (ØªØ®ØµØµ Ø£ÙˆÙ„)",
    "course_name": "Ù†Ø¨Ø§Ø¦Ø· Ø£Ø´Ø¨Ø§Ù‡ Ù…ÙˆØµÙ„Ø§Øª ÙˆØªØ·Ø¨ÙŠÙ‚Ø§ØªÙ‡Ø§",
    "course_code": "PHYS 470",
    "credit_hours": "2",
    "prerequisites": "PHYS 362"
  },
  {
    "level": "4",
    "type": "mandatory",
    "spec": "cs",
    "department": "Ø¹Ù„ÙˆÙ… Ø§Ù„Ø­Ø§Ø³Ø¨ (ØªØ®ØµØµ Ø«Ø§Ù†ÙŠ)",
    "course_name": "Ø°ÙƒØ§Ø¡ Ø§ØµØ·Ù†Ø§Ø¹ÙŠ",
    "course_code": "COMP 401",
    "credit_hours": "3",
    "prerequisites": "-"
  },
  {
    "level": "4",
    "type": "mandatory",
    "spec": "cs",
    "department": "Ø¹Ù„ÙˆÙ… Ø§Ù„Ø­Ø§Ø³Ø¨ (ØªØ®ØµØµ Ø«Ø§Ù†ÙŠ)",
    "course_name": "Ø§Ù„Ù…Ø¹Ø§Ù„Ø¬Ø© Ø§Ù„Ù…ØªÙˆØ§Ø²ÙŠØ© ÙˆØ§Ù„Ù…ÙˆØ²Ø¹Ø©",
    "course_code": "COMP 403",
    "credit_hours": "3",
    "prerequisites": "-"
  },
  {
    "level": "4",
    "type": "mandatory",
    "spec": "cs",
    "department": "Ø¹Ù„ÙˆÙ… Ø§Ù„Ø­Ø§Ø³Ø¨ (ØªØ®ØµØµ Ø«Ø§Ù†ÙŠ)",
    "course_name": "Ø§Ù„Ù…Ø¹Ù„ÙˆÙ…Ø§ØªÙŠØ© Ø§Ù„Ø­ÙŠÙˆÙŠØ©",
    "course_code": "COMP 402",
    "credit_hours": "3",
    "prerequisites": "COMP 201, 212"
  },
  {
    "level": "4",
    "type": "mandatory",
    "spec": "cs",
    "department": "Ø¹Ù„ÙˆÙ… Ø§Ù„Ø­Ø§Ø³Ø¨ (ØªØ®ØµØµ Ø«Ø§Ù†ÙŠ)",
    "course_name": "Ù…Ø´Ø±ÙˆØ¹ Ø­Ø§Ø³Ø¨ (Ù…Ø²Ø¯ÙˆØ¬)",
    "course_code": "COMP 418",
    "credit_hours": "3",
    "prerequisites": "-"
  },
  {
    "level": "4",
    "type": "elective",
    "spec": "phys",
    "department": "Ø§Ù„ÙÙŠØ²ÙŠØ§Ø¡ (Ø§Ø®ØªÙŠØ§Ø±ÙŠ)",
    "course_name": "Ø¥Ù„ÙƒØªØ±ÙˆÙ†ÙŠØ§Øª ÙƒÙ…ÙŠØ©",
    "course_code": "PHYS 469",
    "credit_hours": "2",
    "prerequisites": "PHYS 315"
  },
  {
    "level": "4",
    "type": "elective",
    "spec": "phys",
    "department": "Ø§Ù„ÙÙŠØ²ÙŠØ§Ø¡ (Ø§Ø®ØªÙŠØ§Ø±ÙŠ)",
    "course_name": "Ø£Ø·ÙŠØ§Ù Ø§Ù„Ù„ÙŠØ²Ø±",
    "course_code": "PHYS 465",
    "credit_hours": "2",
    "prerequisites": "PHYS 371"
  },
  {
    "level": "4",
    "type": "elective",
    "spec": "phys",
    "department": "Ø§Ù„ÙÙŠØ²ÙŠØ§Ø¡ (Ø§Ø®ØªÙŠØ§Ø±ÙŠ)",
    "course_name": "Ø®ÙˆØ§Øµ ÙƒÙ‡Ø±Ø¨Ø§Ø¦ÙŠØ© ÙˆØ¶ÙˆØ¦ÙŠØ© ÙˆÙ…ØºÙ†Ø§Ø·ÙŠØ³ÙŠØ© Ù„Ù„Ù…ÙˆØ§Ø¯",
    "course_code": "PHYS 468",
    "credit_hours": "2",
    "prerequisites": "PHYS 362"
  },
  {
    "level": "4",
    "type": "elective",
    "spec": "phys",
    "department": "Ø§Ù„ÙÙŠØ²ÙŠØ§Ø¡ (Ø§Ø®ØªÙŠØ§Ø±ÙŠ)",
    "course_name": "Ù…ÙˆØ§Ø¯ Ø§Ù„Ø¥Ù„ÙƒØªØ±ÙˆÙ†ÙŠØ§Øª",
    "course_code": "PHYS 472",
    "credit_hours": "2",
    "prerequisites": "PHYS 362"
  },
  {
    "level": "4",
    "type": "elective",
    "spec": "cs",
    "department": "Ø¹Ù„ÙˆÙ… Ø§Ù„Ø­Ø§Ø³Ø¨ (Ø§Ø®ØªÙŠØ§Ø±ÙŠ)",
    "course_name": "Ù…Ø¹Ø§Ù„Ø¬Ø© Ø§Ù„ØµÙˆØ±",
    "course_code": "COMP 407",
    "credit_hours": "3",
    "prerequisites": "COMP 212"
  },
  {
    "level": "4",
    "type": "elective",
    "spec": "cs",
    "department": "Ø¹Ù„ÙˆÙ… Ø§Ù„Ø­Ø§Ø³Ø¨ (Ø§Ø®ØªÙŠØ§Ø±ÙŠ)",
    "course_name": "Ø§Ù„Ù‡Ù†Ø¯Ø³Ø© Ø§Ù„Ø­Ø³Ø§Ø¨ÙŠØ©",
    "course_code": "COMP 411",
    "credit_hours": "3",
    "prerequisites": "COMP 201, 212"
  },
  {
    "level": "4",
    "type": "elective",
    "spec": "cs",
    "department": "Ø¹Ù„ÙˆÙ… Ø§Ù„Ø­Ø§Ø³Ø¨ (Ø§Ø®ØªÙŠØ§Ø±ÙŠ)",
    "course_name": "Ù…ÙˆØ¶ÙˆØ¹Ø§Øª Ù…Ø®ØªØ§Ø±Ø© ÙÙŠ Ø§Ù„Ø®ÙˆØ§Ø±Ø²Ù…ÙŠØ§Øª",
    "course_code": "COMP 413",
    "credit_hours": "3",
    "prerequisites": "COMP 201"
  },
];

class PhysicsCSCoursesScreen extends StatefulWidget {
  const PhysicsCSCoursesScreen({super.key});
  @override
  State<PhysicsCSCoursesScreen> createState() => _PhysicsCSCoursesScreenState();
}

class _PhysicsCSCoursesScreenState extends State<PhysicsCSCoursesScreen>
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
      if (_filterSpec == 'phys') {
        return c['spec'] == 'phys' || c['spec'] == 'both';
      }
      if (_filterSpec == 'cs') return c['spec'] == 'cs' || c['spec'] == 'both';
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
        title: const Text('ÙÙŠØ²ÙŠØ§Ø¡ â€“ Ø¹Ù„ÙˆÙ… Ø§Ù„Ø­Ø§Ø³Ø¨ (Ù…Ø²Ø¯ÙˆØ¬)',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        centerTitle: true,
        backgroundColor: const Color(0xFF7C2D12),
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
      color: const Color(0xFF7C2D12),
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
                  color: const Color(0xFF7C2D12),
                  onTap: () => setState(() => _filterSpec = 'all')),
              const SizedBox(width: 8),
              _Chip(
                  label: 'Ø§Ù„ÙÙŠØ²ÙŠØ§Ø¡',
                  selected: _filterSpec == 'phys',
                  color: const Color(0xFFDC2626),
                  onTap: () => setState(() => _filterSpec = 'phys')),
              const SizedBox(width: 8),
              _Chip(
                  label: 'Ø¹Ù„ÙˆÙ… Ø§Ù„Ø­Ø§Ø³Ø¨',
                  selected: _filterSpec == 'cs',
                  color: const Color(0xFF6D28D9),
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
                  colors: [Color(0xFF7C2D12), Color(0xFFDC2626)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                      color: const Color(0xFF7C2D12).withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4)),
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

  Color get _accentColor {
    final spec = course['spec'] ?? '';
    final dept = course['department'] ?? '';
    if (spec == 'phys' || dept.contains('ÙÙŠØ²ÙŠØ§Ø¡')) {
      return const Color(0xFFDC2626);
    }
    if (spec == 'cs' || dept.contains('Ø­Ø§Ø³Ø¨')) return const Color(0xFF6D28D9);
    if (dept.contains('Ø±ÙŠØ§Ø¶ÙŠØ§Øª')) return const Color(0xFF2563EB);
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
        border: Border(right: BorderSide(color: _accentColor, width: 4)),
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
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
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
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
