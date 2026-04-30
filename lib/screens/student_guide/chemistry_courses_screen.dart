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
    "department": "Ù…ØªØ·Ù„Ø¨Ø§Øª Ø§Ù„ÙƒÙ„ÙŠØ©",
    "course_name": "ØªÙØ§Ø¶Ù„ ÙˆØªÙƒØ§Ù…Ù„ (1)",
    "course_code": "MATH 101",
    "credit_hours": "4",
    "prerequisites": "-"
  },
  {
    "level": "1",
    "type": "mandatory",
    "department": "Ù…ØªØ·Ù„Ø¨Ø§Øª Ø§Ù„ÙƒÙ„ÙŠØ©",
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
    "department": "Ù…ØªØ·Ù„Ø¨Ø§Øª Ø§Ù„ÙƒÙ„ÙŠØ©",
    "course_name": "ØªÙØ§Ø¶Ù„ ÙˆØªÙƒØ§Ù…Ù„ (2)",
    "course_code": "MATH 102",
    "credit_hours": "3",
    "prerequisites": "-"
  },
  {
    "level": "1",
    "type": "mandatory",
    "department": "Ø§Ù„ÙƒÙŠÙ…ÙŠØ§Ø¡ (Ù…ØªØ·Ù„Ø¨Ø§Øª Ø§Ù„ÙƒÙ„ÙŠØ©)",
    "course_name": "ÙƒÙŠÙ…ÙŠØ§Ø¡ Ø¹Ø§Ù…Ø© (2)",
    "course_code": "CHEM 102",
    "credit_hours": "3",
    "prerequisites": "-"
  },
  {
    "level": "1",
    "type": "mandatory",
    "department": "Ø§Ù„ÙƒÙŠÙ…ÙŠØ§Ø¡ (Ù…ØªØ·Ù„Ø¨Ø§Øª Ø§Ù„ÙƒÙ„ÙŠØ©)",
    "course_name": "Ø¹Ù…Ù„ÙŠ ÙƒÙŠÙ…ÙŠØ§Ø¡ Ø¹Ø§Ù…Ø© (2)",
    "course_code": "CHEM 104",
    "credit_hours": "1",
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
    "department": "Ø§Ù„ÙƒÙŠÙ…ÙŠØ§Ø¡ Ø§Ù„Ø¹Ø¶ÙˆÙŠØ©",
    "course_name": "ÙƒÙŠÙ…ÙŠØ§Ø¡ Ø¹Ø¶ÙˆÙŠØ© (1)",
    "course_code": "CHEM 211",
    "credit_hours": "2",
    "prerequisites": "CHEM 101 Ø£Ùˆ 102"
  },
  {
    "level": "2",
    "type": "mandatory",
    "department": "Ø§Ù„ÙƒÙŠÙ…ÙŠØ§Ø¡ Ø§Ù„Ø¹Ø¶ÙˆÙŠØ©",
    "course_name": "Ø¨ØªØ±ÙˆÙƒÙŠÙ…Ø§ÙˆÙŠØ§Øª",
    "course_code": "CHEM 213",
    "credit_hours": "1",
    "prerequisites": "CHEM 101 Ø£Ùˆ 102"
  },
  {
    "level": "2",
    "type": "mandatory",
    "department": "Ø§Ù„ÙƒÙŠÙ…ÙŠØ§Ø¡ Ø§Ù„Ø¹Ø¶ÙˆÙŠØ©",
    "course_name": "ÙƒÙŠÙ…ÙŠØ§Ø¡ Ø¹Ø¶ÙˆÙŠØ© Ø¹Ù…Ù„ÙŠ (1)",
    "course_code": "CHEM 215",
    "credit_hours": "1",
    "prerequisites": "CHEM 101 Ø£Ùˆ 102"
  },
  {
    "level": "2",
    "type": "mandatory",
    "department": "Ø§Ù„ÙƒÙŠÙ…ÙŠØ§Ø¡ Ø§Ù„ÙÙŠØ²ÙŠØ§Ø¦ÙŠØ©",
    "course_name": "ÙƒÙŠÙ…ÙŠØ§Ø¡ ÙÙŠØ²ÙŠØ§Ø¦ÙŠØ© (1) â€“ Ø¯ÙŠÙ†Ø§Ù…ÙŠÙƒØ§ Ø­Ø±Ø§Ø±ÙŠØ© ÙˆÙƒÙŠÙ…ÙŠØ§Ø¡ ÙƒÙ‡Ø±Ø¨ÙŠØ©",
    "course_code": "CHEM 241",
    "credit_hours": "2",
    "prerequisites": "CHEM 101 Ø£Ùˆ 102"
  },
  {
    "level": "2",
    "type": "mandatory",
    "department": "Ø§Ù„ÙƒÙŠÙ…ÙŠØ§Ø¡ Ø§Ù„ÙÙŠØ²ÙŠØ§Ø¦ÙŠØ©",
    "course_name": "ÙƒÙŠÙ…ÙŠØ§Ø¡ ÙÙŠØ²ÙŠØ§Ø¦ÙŠØ© (2) â€“ ÙƒÙŠÙ…ÙŠØ§Ø¡ Ø­Ø±ÙƒÙŠØ© ÙˆÙ‚Ø§Ø¹Ø¯Ø© Ø§Ù„ØµÙ†Ù",
    "course_code": "CHEM 243",
    "credit_hours": "2",
    "prerequisites": "CHEM 101 Ø£Ùˆ 102"
  },
  {
    "level": "2",
    "type": "mandatory",
    "department": "Ø§Ù„ÙƒÙŠÙ…ÙŠØ§Ø¡ Ø§Ù„ØªØ­Ù„ÙŠÙ„ÙŠØ©",
    "course_name": "ÙƒÙŠÙ…ÙŠØ§Ø¡ ØªØ­Ù„ÙŠÙ„ÙŠØ© (1)",
    "course_code": "CHEM 231",
    "credit_hours": "2",
    "prerequisites": "CHEM 101 Ø£Ùˆ 102"
  },
  {
    "level": "2",
    "type": "mandatory",
    "department": "Ø§Ù„ÙƒÙŠÙ…ÙŠØ§Ø¡ Ø§Ù„ØªØ­Ù„ÙŠÙ„ÙŠØ©",
    "course_name": "ÙƒÙŠÙ…ÙŠØ§Ø¡ ØªØ­Ù„ÙŠÙ„ÙŠØ© Ø¹Ù…Ù„ÙŠ (1)",
    "course_code": "CHEM 233",
    "credit_hours": "1",
    "prerequisites": "CHEM 101 Ø£Ùˆ 102"
  },
  {
    "level": "2",
    "type": "mandatory",
    "department": "Ø§Ù„ÙÙŠØ²ÙŠØ§Ø¡",
    "course_name": "Ø£Ø³Ø§Ø³ÙŠØ§Øª Ø§Ù„ÙÙŠØ²ÙŠØ§Ø¡ Ø§Ù„Ø­ÙŠÙˆÙŠØ©",
    "course_code": "BIOP 213",
    "credit_hours": "2",
    "prerequisites": "PHYS 101"
  },
  {
    "level": "2",
    "type": "mandatory",
    "department": "Ø§Ù„ÙƒÙŠÙ…ÙŠØ§Ø¡ Ø§Ù„Ø¹Ø¶ÙˆÙŠØ©",
    "course_name": "ÙƒÙŠÙ…ÙŠØ§Ø¡ Ø¹Ø¶ÙˆÙŠØ© (2)",
    "course_code": "CHEM 212",
    "credit_hours": "2",
    "prerequisites": "CHEM 101 Ø£Ùˆ 102"
  },
  {
    "level": "2",
    "type": "mandatory",
    "department": "Ø§Ù„ÙƒÙŠÙ…ÙŠØ§Ø¡ Ø§Ù„Ø¹Ø¶ÙˆÙŠØ©",
    "course_name": "ÙƒÙŠÙ…ÙŠØ§Ø¡ Ø¹Ø¶ÙˆÙŠØ© ÙØ±Ø§ØºÙŠØ©",
    "course_code": "CHEM 214",
    "credit_hours": "1",
    "prerequisites": "CHEM 101 Ø£Ùˆ 102"
  },
  {
    "level": "2",
    "type": "mandatory",
    "department": "Ø§Ù„ÙƒÙŠÙ…ÙŠØ§Ø¡ Ø§Ù„Ø¹Ø¶ÙˆÙŠØ©",
    "course_name": "ÙƒÙŠÙ…ÙŠØ§Ø¡ Ø¹Ø¶ÙˆÙŠØ© Ø¹Ù…Ù„ÙŠ (2)",
    "course_code": "CHEM 216",
    "credit_hours": "1",
    "prerequisites": "CHEM 101 Ø£Ùˆ 102"
  },
  {
    "level": "2",
    "type": "mandatory",
    "department": "Ø§Ù„ÙƒÙŠÙ…ÙŠØ§Ø¡ ØºÙŠØ± Ø§Ù„Ø¹Ø¶ÙˆÙŠØ©",
    "course_name": "ÙƒÙŠÙ…ÙŠØ§Ø¡ ØºÙŠØ± Ø¹Ø¶ÙˆÙŠØ© (1)",
    "course_code": "CHEM 222",
    "credit_hours": "2",
    "prerequisites": "CHEM 102"
  },
  {
    "level": "2",
    "type": "mandatory",
    "department": "Ø§Ù„ÙƒÙŠÙ…ÙŠØ§Ø¡ Ø§Ù„ÙÙŠØ²ÙŠØ§Ø¦ÙŠØ©",
    "course_name": "ÙƒÙŠÙ…ÙŠØ§Ø¡ ÙÙŠØ²ÙŠØ§Ø¦ÙŠØ© (3) â€“ Ø¯ÙŠÙ†Ø§Ù…ÙŠÙƒØ§ Ø­Ø±Ø§Ø±ÙŠØ© ÙˆÙƒÙŠÙ…ÙŠØ§Ø¡ Ø§Ù„Ø³Ø·ÙˆØ­",
    "course_code": "CHEM 242",
    "credit_hours": "2",
    "prerequisites": "CHEM 101 Ø£Ùˆ 102"
  },
  {
    "level": "2",
    "type": "mandatory",
    "department": "Ø§Ù„ÙƒÙŠÙ…ÙŠØ§Ø¡ Ø§Ù„ÙÙŠØ²ÙŠØ§Ø¦ÙŠØ©",
    "course_name": "ÙƒÙŠÙ…ÙŠØ§Ø¡ ÙÙŠØ²ÙŠØ§Ø¦ÙŠØ© Ø¹Ù…Ù„ÙŠ (1)",
    "course_code": "CHEM 244",
    "credit_hours": "1",
    "prerequisites": "CHEM 101 Ø£Ùˆ 102"
  },
  {
    "level": "2",
    "type": "mandatory",
    "department": "Ø§Ù„Ø±ÙŠØ§Ø¶ÙŠØ§Øª",
    "course_name": "Ø¬Ø¨Ø± Ø®Ø·ÙŠ ÙˆØªØ·Ø¨ÙŠÙ‚Ø§ØªÙ‡ ÙÙŠ Ø§Ù„ÙƒÙŠÙ…ÙŠØ§Ø¡",
    "course_code": "MATH 210",
    "credit_hours": "2",
    "prerequisites": "-"
  },
  {
    "level": "2",
    "type": "mandatory",
    "department": "Ø§Ù„ÙÙŠØ²ÙŠØ§Ø¡",
    "course_name": "ÙÙŠØ²ÙŠØ§Ø¡ â€“ Ø¯ÙˆØ§Ø¦Ø± ÙƒÙ‡Ø±Ø¨ÙŠØ©",
    "course_code": "PHYS 226",
    "credit_hours": "2",
    "prerequisites": "-"
  },
  {
    "level": "2",
    "type": "elective",
    "department": "Ø§Ù„ÙƒÙŠÙ…ÙŠØ§Ø¡ (Ø§Ø®ØªÙŠØ§Ø±ÙŠ)",
    "course_name": "ÙƒÙŠÙ…ÙŠØ§Ø¡ Ø§Ù„Ø£ØµØ¨Ø§Øº ÙˆØ§Ù„ÙƒÙŠÙ…ÙŠØ§Ø¡ Ø§Ù„Ø¨ÙŠØ¦ÙŠØ©",
    "course_code": "CHEM 217",
    "credit_hours": "2",
    "prerequisites": "CHEM 101 Ø£Ùˆ 102"
  },
  {
    "level": "2",
    "type": "elective",
    "department": "Ø§Ù„ÙƒÙŠÙ…ÙŠØ§Ø¡ Ø§Ù„ÙÙŠØ²ÙŠØ§Ø¦ÙŠØ© (Ø§Ø®ØªÙŠØ§Ø±ÙŠ)",
    "course_name":
        "ÙƒÙŠÙ…ÙŠØ§Ø¡ ÙÙŠØ²ÙŠØ§Ø¦ÙŠØ© Ø£ â€“ Ø§Ù„Ù†Ø¸Ø±ÙŠØ© Ø§Ù„Ø­Ø±ÙƒÙŠØ© Ù„Ù„ØºØ§Ø²Ø§Øª ÙˆØ§Ù„ØªØ±ÙƒÙŠØ¨ Ø§Ù„Ø¬Ø²ÙŠØ¦ÙŠ",
    "course_code": "CHEM 245",
    "credit_hours": "2",
    "prerequisites": "CHEM 101 Ø£Ùˆ 102"
  },
  // ========== Ø§Ù„Ù…Ø³ØªÙˆÙ‰ Ø§Ù„Ø«Ø§Ù„Ø« ==========
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
    "department": "Ø§Ù„ÙƒÙŠÙ…ÙŠØ§Ø¡ Ø§Ù„Ø¹Ø¶ÙˆÙŠØ©",
    "course_name": "ÙƒÙŠÙ…ÙŠØ§Ø¡ Ø¹Ø¶ÙˆÙŠØ© Ø¹Ù…Ù„ÙŠ (3)",
    "course_code": "CHEM 315",
    "credit_hours": "1",
    "prerequisites": "-"
  },
  {
    "level": "3",
    "type": "mandatory",
    "department": "Ø§Ù„ÙƒÙŠÙ…ÙŠØ§Ø¡ ØºÙŠØ± Ø§Ù„Ø¹Ø¶ÙˆÙŠØ©",
    "course_name": "ÙƒÙŠÙ…ÙŠØ§Ø¡ ØºÙŠØ± Ø¹Ø¶ÙˆÙŠØ© (2) â€“ ØªÙ†Ø§Ø³Ù‚ÙŠØ© ÙˆØ§Ù†ØªÙ‚Ø§Ù„ÙŠØ©",
    "course_code": "CHEM 321",
    "credit_hours": "2",
    "prerequisites": "CHEM 222"
  },
  {
    "level": "3",
    "type": "mandatory",
    "department": "Ø§Ù„ÙƒÙŠÙ…ÙŠØ§Ø¡ Ø§Ù„ØªØ­Ù„ÙŠÙ„ÙŠØ©",
    "course_name": "ÙƒÙŠÙ…ÙŠØ§Ø¡ ØªØ­Ù„ÙŠÙ„ÙŠØ© (2)",
    "course_code": "CHEM 331",
    "credit_hours": "2",
    "prerequisites": "CHEM 231"
  },
  {
    "level": "3",
    "type": "mandatory",
    "department": "Ø§Ù„ÙƒÙŠÙ…ÙŠØ§Ø¡ Ø§Ù„ØªØ­Ù„ÙŠÙ„ÙŠØ©",
    "course_name": "ÙƒÙŠÙ…ÙŠØ§Ø¡ ØªØ­Ù„ÙŠÙ„ÙŠØ© Ø¹Ù…Ù„ÙŠ (2)",
    "course_code": "CHEM 333",
    "credit_hours": "1",
    "prerequisites": "CHEM 231"
  },
  {
    "level": "3",
    "type": "mandatory",
    "department": "Ø§Ù„ÙƒÙŠÙ…ÙŠØ§Ø¡ Ø§Ù„ÙÙŠØ²ÙŠØ§Ø¦ÙŠØ©",
    "course_name": "ÙƒÙŠÙ…ÙŠØ§Ø¡ ÙÙŠØ²ÙŠØ§Ø¦ÙŠØ© (4) â€“ ÙƒÙŠÙ…ÙŠØ§Ø¡ Ø§Ù„Ø³Ø·ÙˆØ­ ÙˆØ§Ù„Ø­ÙØ²",
    "course_code": "CHEM 341",
    "credit_hours": "2",
    "prerequisites": "CHEM 242"
  },
  {
    "level": "3",
    "type": "mandatory",
    "department": "Ø§Ù„ÙƒÙŠÙ…ÙŠØ§Ø¡ Ø§Ù„ÙÙŠØ²ÙŠØ§Ø¦ÙŠØ©",
    "course_name": "ÙƒÙŠÙ…ÙŠØ§Ø¡ ÙÙŠØ²ÙŠØ§Ø¦ÙŠØ© Ø¹Ù…Ù„ÙŠ (2)",
    "course_code": "CHEM 343",
    "credit_hours": "1",
    "prerequisites": "CHEM 243"
  },
  {
    "level": "3",
    "type": "mandatory",
    "department": "Ø§Ù„ÙƒÙŠÙ…ÙŠØ§Ø¡ Ø§Ù„Ø¹Ø¶ÙˆÙŠØ©",
    "course_name": "Ø§Ù„ÙƒÙŠÙ…ÙŠØ§Ø¡ Ø§Ù„Ø¹Ø¶ÙˆÙŠØ© Ø§Ù„ÙÙŠØ²ÙŠØ§Ø¦ÙŠØ© (1)",
    "course_code": "CHEM 312",
    "credit_hours": "2",
    "prerequisites": "CHEM 211 Ø£Ùˆ 212"
  },
  {
    "level": "3",
    "type": "mandatory",
    "department": "Ø§Ù„ÙƒÙŠÙ…ÙŠØ§Ø¡ Ø§Ù„Ø¹Ø¶ÙˆÙŠØ©",
    "course_name": "ÙƒÙŠÙ…ÙŠØ§Ø¡ Ø¹Ø¶ÙˆÙŠØ© â€“ Ø·ÙŠÙ",
    "course_code": "CHEM 314",
    "credit_hours": "2",
    "prerequisites": "CHEM 212"
  },
  {
    "level": "3",
    "type": "mandatory",
    "department": "Ø§Ù„ÙƒÙŠÙ…ÙŠØ§Ø¡ Ø§Ù„Ø¹Ø¶ÙˆÙŠØ©",
    "course_name": "ÙƒÙŠÙ…ÙŠØ§Ø¡ Ø¹Ø¶ÙˆÙŠØ© Ø¹Ù…Ù„ÙŠ (4)",
    "course_code": "CHEM 316",
    "credit_hours": "1",
    "prerequisites": "-"
  },
  {
    "level": "3",
    "type": "mandatory",
    "department": "Ø§Ù„ÙƒÙŠÙ…ÙŠØ§Ø¡ ØºÙŠØ± Ø§Ù„Ø¹Ø¶ÙˆÙŠØ©",
    "course_name": "ÙƒÙŠÙ…ÙŠØ§Ø¡ ØºÙŠØ± Ø¹Ø¶ÙˆÙŠØ© (3)",
    "course_code": "CHEM 322",
    "credit_hours": "2",
    "prerequisites": "CHEM 222"
  },
  {
    "level": "3",
    "type": "mandatory",
    "department": "Ø§Ù„ÙƒÙŠÙ…ÙŠØ§Ø¡ Ø§Ù„ÙÙŠØ²ÙŠØ§Ø¦ÙŠØ©",
    "course_name": "ÙƒÙŠÙ…ÙŠØ§Ø¡ ÙÙŠØ²ÙŠØ§Ø¦ÙŠØ© (5) â€“ ÙƒÙŠÙ…ÙŠØ§Ø¡ ÙƒÙ‡Ø±Ø¨Ø§Ø¦ÙŠØ© ÙˆÙƒÙŠÙ…ÙŠØ§Ø¡ Ø¶ÙˆØ¦ÙŠØ©",
    "course_code": "CHEM 342",
    "credit_hours": "2",
    "prerequisites": "CHEM 241"
  },
  {
    "level": "3",
    "type": "mandatory",
    "department": "Ø§Ù„ÙƒÙŠÙ…ÙŠØ§Ø¡ Ø§Ù„ÙÙŠØ²ÙŠØ§Ø¦ÙŠØ©",
    "course_name": "ÙƒÙŠÙ…ÙŠØ§Ø¡ ÙÙŠØ²ÙŠØ§Ø¦ÙŠØ© Ø¹Ù…Ù„ÙŠ (3)",
    "course_code": "CHEM 344",
    "credit_hours": "1",
    "prerequisites": "CHEM 243"
  },
  {
    "level": "3",
    "type": "mandatory",
    "department": "Ø§Ù„Ø¬ÙŠÙˆÙ„ÙˆØ¬ÙŠØ§",
    "course_name": "Ø¨Ù„ÙˆØ±Ø§Øª ÙˆÙ…Ø¹Ø§Ø¯Ù† ÙˆØµØ®ÙˆØ±",
    "course_code": "GEOL 320",
    "credit_hours": "2",
    "prerequisites": "-"
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
    "department": "Ø§Ù„ÙƒÙŠÙ…ÙŠØ§Ø¡",
    "course_name": "Ù…Ø´Ø±ÙˆØ¹ Ø¨Ø­Ø« (1)",
    "course_code": "CHEM 451",
    "credit_hours": "1",
    "prerequisites": "-"
  },
  {
    "level": "4",
    "type": "mandatory",
    "department": "Ø§Ù„ÙƒÙŠÙ…ÙŠØ§Ø¡ Ø§Ù„Ø¹Ø¶ÙˆÙŠØ©",
    "course_name": "ÙƒÙŠÙ…ÙŠØ§Ø¡ Ø¹Ø¶ÙˆÙŠØ© ÙÙŠØ²ÙŠØ§Ø¦ÙŠØ© (2)",
    "course_code": "CHEM 411",
    "credit_hours": "2",
    "prerequisites": "CHEM 312"
  },
  {
    "level": "4",
    "type": "mandatory",
    "department": "Ø§Ù„ÙƒÙŠÙ…ÙŠØ§Ø¡ Ø§Ù„Ø¹Ø¶ÙˆÙŠØ©",
    "course_name": "ÙƒØ±Ø¨ÙˆÙ‡ÙŠØ¯Ø±Ø§Øª",
    "course_code": "CHEM 413",
    "credit_hours": "1",
    "prerequisites": "CHEM 211"
  },
  {
    "level": "4",
    "type": "mandatory",
    "department": "Ø§Ù„ÙƒÙŠÙ…ÙŠØ§Ø¡ ØºÙŠØ± Ø§Ù„Ø¹Ø¶ÙˆÙŠØ©",
    "course_name": "ÙƒÙŠÙ…ÙŠØ§Ø¡ ØºÙŠØ± Ø¹Ø¶ÙˆÙŠØ© (5) â€“ Ù†ÙˆÙˆÙŠØ© ÙˆÙÙ„Ø² Ø¹Ø¶ÙˆÙŠØ©",
    "course_code": "CHEM 421",
    "credit_hours": "2",
    "prerequisites": "CHEM 321"
  },
  {
    "level": "4",
    "type": "mandatory",
    "department": "Ø§Ù„ÙƒÙŠÙ…ÙŠØ§Ø¡ Ø§Ù„ØªØ­Ù„ÙŠÙ„ÙŠØ©",
    "course_name": "ÙƒÙŠÙ…ÙŠØ§Ø¡ ØªØ­Ù„ÙŠÙ„ÙŠØ© (3) â€“ Ø§Ù„ØªØ­Ù„ÙŠÙ„ Ø§Ù„ÙƒÙ‡Ø±Ø¨ÙŠ",
    "course_code": "CHEM 431",
    "credit_hours": "2",
    "prerequisites": "CHEM 331"
  },
  {
    "level": "4",
    "type": "mandatory",
    "department": "Ø§Ù„ÙƒÙŠÙ…ÙŠØ§Ø¡ Ø§Ù„ÙÙŠØ²ÙŠØ§Ø¦ÙŠØ©",
    "course_name": "ÙƒÙŠÙ…ÙŠØ§Ø¡ ÙÙŠØ²ÙŠØ§Ø¦ÙŠØ© (6) â€“ ÙƒÙ‡Ø±Ø¨ÙŠØ© ÙˆØ£Ø³Ù…Ù†Øª",
    "course_code": "CHEM 441",
    "credit_hours": "2",
    "prerequisites": "CHEM 342"
  },
  {
    "level": "4",
    "type": "mandatory",
    "department": "Ø§Ù„ÙÙŠØ²ÙŠØ§Ø¡",
    "course_name": "Ø£Ø³Ø§Ø³ÙŠØ§Øª Ø§Ù„Ø¥Ù„ÙƒØªØ±ÙˆÙ†ÙŠØ§Øª",
    "course_code": "PHYS 403",
    "credit_hours": "2",
    "prerequisites": "PHYS 102"
  },
  {
    "level": "4",
    "type": "mandatory",
    "department": "Ø§Ù„ÙƒÙŠÙ…ÙŠØ§Ø¡",
    "course_name": "Ù…Ø´Ø±ÙˆØ¹ Ø¨Ø­Ø« (2)",
    "course_code": "CHEM 452",
    "credit_hours": "1",
    "prerequisites": "-"
  },
  {
    "level": "4",
    "type": "mandatory",
    "department": "Ø§Ù„ÙƒÙŠÙ…ÙŠØ§Ø¡ Ø§Ù„Ø¹Ø¶ÙˆÙŠØ©",
    "course_name": "Ù…Ù†ØªØ¬Ø§Øª Ø·Ø¨ÙŠØ¹ÙŠØ©",
    "course_code": "CHEM 412",
    "credit_hours": "2",
    "prerequisites": "CHEM 314"
  },
  {
    "level": "4",
    "type": "mandatory",
    "department": "Ø§Ù„ÙƒÙŠÙ…ÙŠØ§Ø¡ Ø§Ù„Ø¹Ø¶ÙˆÙŠØ©",
    "course_name": "ÙƒÙŠÙ…ÙŠØ§Ø¡ Ø¹Ø¶ÙˆÙŠØ© Ø¹Ù…Ù„ÙŠ (5)",
    "course_code": "CHEM 414",
    "credit_hours": "1",
    "prerequisites": "CHEM 316"
  },
  {
    "level": "4",
    "type": "mandatory",
    "department": "Ø§Ù„ÙƒÙŠÙ…ÙŠØ§Ø¡ ØºÙŠØ± Ø§Ù„Ø¹Ø¶ÙˆÙŠØ©",
    "course_name": "ÙƒÙŠÙ…ÙŠØ§Ø¡ ØºÙŠØ± Ø¹Ø¶ÙˆÙŠØ© (5) â€“ Ù†Ø¸Ø±ÙŠØ© Ø§Ù„Ù…Ø¬Ù…ÙˆØ¹Ø§Øª ÙˆØ·ÙŠÙÙŠØ©",
    "course_code": "CHEM 422",
    "credit_hours": "2",
    "prerequisites": "CHEM 322"
  },
  {
    "level": "4",
    "type": "mandatory",
    "department": "Ø§Ù„ÙƒÙŠÙ…ÙŠØ§Ø¡ Ø§Ù„ØªØ­Ù„ÙŠÙ„ÙŠØ©",
    "course_name": "ÙƒÙŠÙ…ÙŠØ§Ø¡ ØªØ­Ù„ÙŠÙ„ÙŠØ© (4) â€“ Ø·Ø±Ù‚ Ø§Ù„ÙØµÙ„",
    "course_code": "CHEM 432",
    "credit_hours": "1",
    "prerequisites": "CHEM 331"
  },
  {
    "level": "4",
    "type": "mandatory",
    "department": "Ø§Ù„ÙƒÙŠÙ…ÙŠØ§Ø¡ Ø§Ù„ÙÙŠØ²ÙŠØ§Ø¦ÙŠØ©",
    "course_name":
        "ÙƒÙŠÙ…ÙŠØ§Ø¡ ÙÙŠØ²ÙŠØ§Ø¦ÙŠØ© (7) â€“ Ø¨ÙˆÙ„ÙŠÙ…Ø±Ø§Øª ÙˆÙ…ÙŠÙƒØ§Ù†ÙŠÙƒØ§ Ø§Ù„ÙƒÙ… ÙˆØªØ¢ÙƒÙ„ Ø§Ù„Ù…Ø¹Ø§Ø¯Ù†",
    "course_code": "CHEM 442",
    "credit_hours": "3",
    "prerequisites": "CHEM 241"
  },
  {
    "level": "4",
    "type": "mandatory",
    "department": "Ø§Ù„ÙƒÙŠÙ…ÙŠØ§Ø¡ Ø§Ù„ÙÙŠØ²ÙŠØ§Ø¦ÙŠØ©",
    "course_name": "ÙƒÙŠÙ…ÙŠØ§Ø¡ ÙÙŠØ²ÙŠØ§Ø¦ÙŠØ© Ø¹Ù…Ù„ÙŠ Ù…ØªÙ‚Ø¯Ù…",
    "course_code": "CHEM 444",
    "credit_hours": "1",
    "prerequisites": "CHEM 344"
  },
  {
    "level": "4",
    "type": "mandatory",
    "department": "Ø¹Ù„ÙˆÙ… Ø§Ù„Ø­Ø§Ø³Ø¨",
    "course_name": "ØªØ·Ø¨ÙŠÙ‚Ø§Øª Ø§Ù„Ø­Ø§Ø³Ø¨ ÙÙŠ Ø§Ù„ÙƒÙŠÙ…ÙŠØ§Ø¡",
    "course_code": "COMP 420",
    "credit_hours": "2",
    "prerequisites": "-"
  },
];

class ChemistryCoursesScreen extends StatefulWidget {
  const ChemistryCoursesScreen({super.key});
  @override
  State<ChemistryCoursesScreen> createState() => _ChemistryCoursesScreenState();
}

class _ChemistryCoursesScreenState extends State<ChemistryCoursesScreen>
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
        title: const Text('Ø§Ù„ÙƒÙŠÙ…ÙŠØ§Ø¡ â€“ ØªØ®ØµØµ Ù…Ù†ÙØ±Ø¯',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
        centerTitle: true,
        backgroundColor: const Color(0xFF4C1D95),
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
      color: const Color(0xFF4C1D95),
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
                  colors: [Color(0xFF4C1D95), Color(0xFF7C3AED)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                      color: const Color(0xFF4C1D95).withValues(alpha: 0.3),
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
    if (dept.contains('Ø§Ù„Ø¹Ø¶ÙˆÙŠØ©')) return const Color(0xFF7C3AED);
    if (dept.contains('ØºÙŠØ± Ø§Ù„Ø¹Ø¶ÙˆÙŠØ©')) return const Color(0xFF4C1D95);
    if (dept.contains('Ø§Ù„ÙÙŠØ²ÙŠØ§Ø¦ÙŠØ©')) return const Color(0xFF0284C7);
    if (dept.contains('Ø§Ù„ØªØ­Ù„ÙŠÙ„ÙŠØ©')) return const Color(0xFF059669);
    if (dept.contains('ÙÙŠØ²ÙŠØ§Ø¡') ||
        dept.contains('PHYS') ||
        dept.contains('BIOP')) {
      return const Color(0xFFDC2626);
    }
    if (dept.contains('Ø±ÙŠØ§Ø¶ÙŠØ§Øª')) return const Color(0xFF2563EB);
    if (dept.contains('Ø¬ÙŠÙˆÙ„ÙˆØ¬ÙŠØ§')) return const Color(0xFF92400E);
    if (dept.contains('Ø­Ø§Ø³Ø¨')) return const Color(0xFF6D28D9);
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
