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
    "department": "Ø§Ù„Ø±ÙŠØ§Ø¶ÙŠØ§Øª (Ù…ØªØ·Ù„Ø¨Ø§Øª ÙƒÙ„ÙŠØ©)",
    "course_name": "ØªÙØ§Ø¶Ù„ ÙˆØªÙƒØ§Ù…Ù„ (1)",
    "course_code": "MATH 101",
    "credit_hours": "4",
    "prerequisites": "-"
  },
  {
    "level": "1",
    "type": "mandatory",
    "spec": "both",
    "department": "Ø§Ù„ÙÙŠØ²ÙŠØ§Ø¡ (Ù…ØªØ·Ù„Ø¨Ø§Øª ÙƒÙ„ÙŠØ©)",
    "course_name": "ÙÙŠØ²ÙŠØ§Ø¡ Ø¹Ø§Ù…Ø© (1)",
    "course_code": "PHYS 101",
    "credit_hours": "4",
    "prerequisites": "-"
  },
  {
    "level": "1",
    "type": "mandatory",
    "spec": "chem",
    "department": "Ø§Ù„ÙƒÙŠÙ…ÙŠØ§Ø¡ (Ù…ØªØ·Ù„Ø¨Ø§Øª ÙƒÙ„ÙŠØ©)",
    "course_name": "ÙƒÙŠÙ…ÙŠØ§Ø¡ Ø¹Ø§Ù…Ø© (1)",
    "course_code": "CHEM 101",
    "credit_hours": "3",
    "prerequisites": "-"
  },
  {
    "level": "1",
    "type": "mandatory",
    "spec": "chem",
    "department": "Ø§Ù„ÙƒÙŠÙ…ÙŠØ§Ø¡ (Ù…ØªØ·Ù„Ø¨Ø§Øª ÙƒÙ„ÙŠØ©)",
    "course_name": "Ø¹Ù…Ù„ÙŠ ÙƒÙŠÙ…ÙŠØ§Ø¡ Ø¹Ø§Ù…Ø© (1)",
    "course_code": "CHEM 103",
    "credit_hours": "1",
    "prerequisites": "-"
  },
  {
    "level": "1",
    "type": "mandatory",
    "spec": "bota",
    "department": "Ø§Ù„Ù†Ø¨Ø§Øª (Ù…ØªØ·Ù„Ø¨Ø§Øª ÙƒÙ„ÙŠØ©)",
    "course_name": "Ø£Ø³Ø§Ø³ÙŠØ§Øª Ø¹Ù„Ù… Ø§Ù„Ù†Ø¨Ø§Øª (1)",
    "course_code": "BOTA 101",
    "credit_hours": "2",
    "prerequisites": "-"
  },
  {
    "level": "1",
    "type": "mandatory",
    "spec": "both",
    "department": "Ø¹Ù„Ù… Ø§Ù„Ø­ÙŠÙˆØ§Ù† (Ù…ØªØ·Ù„Ø¨Ø§Øª ÙƒÙ„ÙŠØ©)",
    "course_name": "Ø¹Ù„Ù… Ø§Ù„Ø­ÙŠÙˆØ§Ù† (1)",
    "course_code": "ZOOL 101",
    "credit_hours": "2",
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
    "spec": "chem",
    "department": "Ø§Ù„ÙƒÙŠÙ…ÙŠØ§Ø¡ (Ù…ØªØ·Ù„Ø¨Ø§Øª ÙƒÙ„ÙŠØ©)",
    "course_name": "ÙƒÙŠÙ…ÙŠØ§Ø¡ (2)",
    "course_code": "CHEM 102",
    "credit_hours": "3",
    "prerequisites": "-"
  },
  {
    "level": "1",
    "type": "mandatory",
    "spec": "chem",
    "department": "Ø§Ù„ÙƒÙŠÙ…ÙŠØ§Ø¡ (Ù…ØªØ·Ù„Ø¨Ø§Øª ÙƒÙ„ÙŠØ©)",
    "course_name": "Ø¹Ù…Ù„ÙŠ ÙƒÙŠÙ…ÙŠØ§Ø¡ Ø¹Ø§Ù…Ø© (2)",
    "course_code": "CHEM 104",
    "credit_hours": "1",
    "prerequisites": "-"
  },
  {
    "level": "1",
    "type": "mandatory",
    "spec": "bota",
    "department": "Ø§Ù„Ù†Ø¨Ø§Øª (Ù…ØªØ·Ù„Ø¨Ø§Øª ÙƒÙ„ÙŠØ©)",
    "course_name": "Ø£Ø³Ø§Ø³ÙŠØ§Øª Ø¹Ù„Ù… Ø§Ù„Ù†Ø¨Ø§Øª (2)",
    "course_code": "BOTA 102",
    "credit_hours": "3",
    "prerequisites": "-"
  },
  {
    "level": "1",
    "type": "mandatory",
    "spec": "both",
    "department": "Ø¹Ù„Ù… Ø§Ù„Ø­ÙŠÙˆØ§Ù† (Ù…ØªØ·Ù„Ø¨Ø§Øª ÙƒÙ„ÙŠØ©)",
    "course_name": "Ø¹Ù„Ù… Ø§Ù„Ø­ÙŠÙˆØ§Ù† (2)",
    "course_code": "ZOOL 102",
    "credit_hours": "3",
    "prerequisites": "-"
  },
  {
    "level": "1",
    "type": "mandatory",
    "spec": "both",
    "department": "Ø§Ù„Ù…ÙŠÙƒØ±ÙˆØ¨ÙŠÙˆÙ„ÙˆØ¬ÙŠ (Ù…ØªØ·Ù„Ø¨Ø§Øª ÙƒÙ„ÙŠØ©)",
    "course_name": "Ù…ÙŠÙƒØ±ÙˆØ¨ÙŠÙˆÙ„ÙˆØ¬ÙŠ",
    "course_code": "MICR 102",
    "credit_hours": "2",
    "prerequisites": "-"
  },
  {
    "level": "1",
    "type": "mandatory",
    "spec": "both",
    "department": "Ø¹Ù„Ù… Ø§Ù„Ø­Ø´Ø±Ø§Øª (Ù…ØªØ·Ù„Ø¨Ø§Øª ÙƒÙ„ÙŠØ©)",
    "course_name": "Ø¹Ù„Ù… Ø§Ù„Ø­Ø´Ø±Ø§Øª",
    "course_code": "ENTM 102",
    "credit_hours": "2",
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
    "spec": "bota",
    "department": "Ø§Ù„Ù†Ø¨Ø§Øª (ØªØ®ØµØµ Ø£ÙˆÙ„)",
    "course_name": "ØªØ´Ø±ÙŠØ­ Ù†Ø¨Ø§Øª",
    "course_code": "BOTA 201",
    "credit_hours": "2",
    "prerequisites": "BOTA 101"
  },
  {
    "level": "2",
    "type": "mandatory",
    "spec": "bota",
    "department": "Ø§Ù„Ù†Ø¨Ø§Øª (ØªØ®ØµØµ Ø£ÙˆÙ„)",
    "course_name": "Ø£Ø³Ø§Ø³ÙŠØ§Øª Ø¹Ù„Ù… Ø§Ù„Ø·Ø­Ø§Ù„Ø¨",
    "course_code": "BOTA 213",
    "credit_hours": "2",
    "prerequisites": "BOTA 102"
  },
  {
    "level": "2",
    "type": "mandatory",
    "spec": "bota",
    "department": "Ø§Ù„Ù†Ø¨Ø§Øª (ØªØ®ØµØµ Ø£ÙˆÙ„)",
    "course_name": "Ø£Ø³Ø§Ø³ÙŠØ§Øª Ø§Ù„Ù†Ø¸Ù… Ø§Ù„Ø¨ÙŠØ¦ÙŠØ©",
    "course_code": "BOTA 215",
    "credit_hours": "1",
    "prerequisites": "BOTA 102"
  },
  {
    "level": "2",
    "type": "mandatory",
    "spec": "bota",
    "department": "Ø§Ù„Ù†Ø¨Ø§Øª (ØªØ®ØµØµ Ø£ÙˆÙ„)",
    "course_name": "Ø£Ø³Ø§Ø³ÙŠØ§Øª ÙˆØ£Ø¯ÙˆØ§Øª ØªÙƒÙ†ÙˆÙ„ÙˆØ¬ÙŠØ§ Ø§Ù„Ø¯Ù†Ø§ â€“ Ø§Ù„Ø¨Ø±ÙˆØªÙŠÙˆÙ…Ø§Øª",
    "course_code": "BOTA 217",
    "credit_hours": "2",
    "prerequisites": "BOTA 102"
  },
  {
    "level": "2",
    "type": "mandatory",
    "spec": "chem",
    "department": "Ø§Ù„ÙƒÙŠÙ…ÙŠØ§Ø¡ (ØªØ®ØµØµ Ø«Ø§Ù†ÙŠ)",
    "course_name": "ÙƒÙŠÙ…ÙŠØ§Ø¡ Ø¹Ø¶ÙˆÙŠØ© Ø£Ù„ÙŠÙØ§ØªÙŠØ© Ø£Ø­Ø§Ø¯ÙŠØ© ÙˆØ¹Ø¯ÙŠØ¯Ø© Ø§Ù„Ù…Ø¬Ù…ÙˆØ¹Ø©",
    "course_code": "CHEM 261",
    "credit_hours": "3",
    "prerequisites": "-"
  },
  {
    "level": "2",
    "type": "mandatory",
    "spec": "chem",
    "department": "Ø§Ù„ÙƒÙŠÙ…ÙŠØ§Ø¡ (ØªØ®ØµØµ Ø«Ø§Ù†ÙŠ)",
    "course_name": "ÙƒÙŠÙ…ÙŠØ§Ø¡ ØºÙŠØ± Ø¹Ø¶ÙˆÙŠØ© â€“ Ù†Ø¸Ø±ÙŠØ§Øª ÙˆØ¹Ù†Ø§ØµØ± s,p",
    "course_code": "CHEM 271",
    "credit_hours": "2",
    "prerequisites": "-"
  },
  {
    "level": "2",
    "type": "mandatory",
    "spec": "chem",
    "department": "Ø§Ù„ÙƒÙŠÙ…ÙŠØ§Ø¡ (ØªØ®ØµØµ Ø«Ø§Ù†ÙŠ)",
    "course_name": "Ø£Ø³Ø§Ø³ÙŠØ§Øª Ø§Ù„ÙƒÙŠÙ…ÙŠØ§Ø¡ Ø§Ù„ØªØ­Ù„ÙŠÙ„ÙŠØ©",
    "course_code": "CHEM 281",
    "credit_hours": "2",
    "prerequisites": "-"
  },
  {
    "level": "2",
    "type": "mandatory",
    "spec": "bota",
    "department": "Ø§Ù„Ù†Ø¨Ø§Øª (ØªØ®ØµØµ Ø£ÙˆÙ„)",
    "course_name": "Ø§Ù„Ø®Ù„ÙŠØ© ÙˆØ§Ù„Ø¬ÙŠÙ†ÙˆÙ… Ø§Ù„Ù†Ø¨Ø§ØªÙŠ â€“ Ø§Ù„Ø§ØªØ¬Ø§Ù‡ Ø§Ù„ØªØ·ÙˆØ±ÙŠ",
    "course_code": "BOTA 220",
    "credit_hours": "1",
    "prerequisites": "-"
  },
  {
    "level": "2",
    "type": "mandatory",
    "spec": "chem",
    "department": "Ø§Ù„ÙƒÙŠÙ…ÙŠØ§Ø¡ (ØªØ®ØµØµ Ø«Ø§Ù†ÙŠ)",
    "course_name": "ÙƒÙŠÙ…ÙŠØ§Ø¡ Ø¹Ø¶ÙˆÙŠØ© Ø£Ø±ÙˆÙ…Ø§ØªÙŠØ© Ø£Ø­Ø§Ø¯ÙŠØ© ÙˆØ¹Ø¯ÙŠØ¯Ø© Ø§Ù„Ù…Ø¬Ù…ÙˆØ¹Ø©",
    "course_code": "CHEM 260",
    "credit_hours": "3",
    "prerequisites": "-"
  },
  {
    "level": "2",
    "type": "mandatory",
    "spec": "chem",
    "department": "Ø§Ù„ÙƒÙŠÙ…ÙŠØ§Ø¡ (ØªØ®ØµØµ Ø«Ø§Ù†ÙŠ)",
    "course_name": "ÙƒÙŠÙ…ÙŠØ§Ø¡ ÙÙŠØ²ÙŠØ§Ø¦ÙŠØ© â€“ Ø¯ÙŠÙ†Ø§Ù…ÙŠÙƒØ§ Ø­Ø±Ø§Ø±ÙŠØ© ÙˆÙƒÙŠÙ…ÙŠØ§Ø¡ ÙƒÙ‡Ø±Ø¨ÙŠØ©",
    "course_code": "CHEM 290",
    "credit_hours": "2",
    "prerequisites": "-"
  },
  {
    "level": "2",
    "type": "mandatory",
    "spec": "chem",
    "department": "Ø§Ù„ÙƒÙŠÙ…ÙŠØ§Ø¡ (ØªØ®ØµØµ Ø«Ø§Ù†ÙŠ)",
    "course_name": "ÙƒÙŠÙ…ÙŠØ§Ø¡ ÙÙŠØ²ÙŠØ§Ø¦ÙŠØ© â€“ ÙƒÙŠÙ…ÙŠØ§Ø¡ Ø­Ø±ÙƒÙŠØ©",
    "course_code": "CHEM 294",
    "credit_hours": "1",
    "prerequisites": "-"
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
    "course_code": "ETHR 302",
    "credit_hours": "1",
    "prerequisites": "-"
  },
  {
    "level": "3",
    "type": "mandatory",
    "spec": "bota",
    "department": "Ø§Ù„Ù†Ø¨Ø§Øª (ØªØ®ØµØµ Ø£ÙˆÙ„)",
    "course_name": "ÙØ³ÙŠÙˆÙ„ÙˆØ¬ÙŠØ§ Ø§Ù„Ù†Ù…Ùˆ ÙˆØ§Ù„Ù‡Ø±Ù…ÙˆÙ†Ø§Øª Ø§Ù„Ù†Ø¨Ø§ØªÙŠØ© â€“ Ø²Ø±Ø§Ø¹Ø© Ø£Ù†Ø³Ø¬Ø© Ù†Ø¨Ø§ØªÙŠØ©",
    "course_code": "BOTA 321",
    "credit_hours": "3",
    "prerequisites": "-"
  },
  {
    "level": "3",
    "type": "mandatory",
    "spec": "bota",
    "department": "Ø§Ù„Ù†Ø¨Ø§Øª (ØªØ®ØµØµ Ø£ÙˆÙ„)",
    "course_name": "Ø§Ù„Ø¢Ù„ÙŠØ§Øª Ø§Ù„Ø£Ø³Ø§Ø³ÙŠØ© Ù„Ù„ÙˆØ±Ø§Ø«Ø©",
    "course_code": "BOTA 323",
    "credit_hours": "2",
    "prerequisites": "BOTA 217"
  },
  {
    "level": "3",
    "type": "mandatory",
    "spec": "bota",
    "department": "Ø§Ù„Ù†Ø¨Ø§Øª (ØªØ®ØµØµ Ø£ÙˆÙ„)",
    "course_name": "Ø·Ø­Ø§Ù„Ø¨ Ø§Ù„Ø¨ÙŠØ¦Ø§Øª Ø§Ù„Ù…Ø®ØªÙ„ÙØ© ÙÙŠ Ù…ØµØ±",
    "course_code": "BOTA 325",
    "credit_hours": "2",
    "prerequisites": "BOTA 213"
  },
  {
    "level": "3",
    "type": "mandatory",
    "spec": "chem",
    "department": "Ø§Ù„ÙƒÙŠÙ…ÙŠØ§Ø¡ (ØªØ®ØµØµ Ø«Ø§Ù†ÙŠ)",
    "course_name": "ÙƒÙŠÙ…ÙŠØ§Ø¡ Ø¹Ø¶ÙˆÙŠØ© â€“ Ø§Ù„ÙƒÙŠÙ…ÙŠØ§Ø¡ Ø§Ù„ÙØ±Ø§ØºÙŠØ© ÙˆØ§Ù„Ø³ÙƒØ±ÙŠØ§Øª",
    "course_code": "CHEM 361",
    "credit_hours": "2",
    "prerequisites": "-"
  },
  {
    "level": "3",
    "type": "mandatory",
    "spec": "chem",
    "department": "Ø§Ù„ÙƒÙŠÙ…ÙŠØ§Ø¡ (ØªØ®ØµØµ Ø«Ø§Ù†ÙŠ)",
    "course_name": "ÙƒÙŠÙ…ÙŠØ§Ø¡ ØºÙŠØ± Ø¹Ø¶ÙˆÙŠØ© â€“ ÙƒÙŠÙ…ÙŠØ§Ø¡ ØªÙ†Ø§Ø³Ù‚ÙŠØ©",
    "course_code": "CHEM 371",
    "credit_hours": "2",
    "prerequisites": "-"
  },
  {
    "level": "3",
    "type": "mandatory",
    "spec": "chem",
    "department": "Ø§Ù„ÙƒÙŠÙ…ÙŠØ§Ø¡ (ØªØ®ØµØµ Ø«Ø§Ù†ÙŠ)",
    "course_name": "ÙƒÙŠÙ…ÙŠØ§Ø¡ ÙÙŠØ²ÙŠØ§Ø¦ÙŠØ© â€“ ÙƒÙŠÙ…ÙŠØ§Ø¡ Ø§Ù„Ø³Ø·ÙˆØ­ ÙˆØ§Ù„Ø­ÙØ² ÙˆØ§Ù„Ø¨Ù„Ù…Ø±Ø§Øª",
    "course_code": "CHEM 391",
    "credit_hours": "3",
    "prerequisites": "-"
  },
  {
    "level": "3",
    "type": "mandatory",
    "spec": "bota",
    "department": "Ø§Ù„Ù†Ø¨Ø§Øª (ØªØ®ØµØµ Ø£ÙˆÙ„)",
    "course_name": "Ø£Ø³Ø§Ø³ÙŠØ§Øª Ø¹Ù„Ù… Ø§Ù„Ø£Ø±Ø´ÙŠØ¬ÙˆÙ†ÙŠØ§Øª",
    "course_code": "BOTA 322",
    "credit_hours": "3",
    "prerequisites": "-"
  },
  {
    "level": "3",
    "type": "mandatory",
    "spec": "bota",
    "department": "Ø§Ù„Ù†Ø¨Ø§Øª (ØªØ®ØµØµ Ø£ÙˆÙ„)",
    "course_name": "Ù…Ù† ØªÙ…ÙŠØ² Ø§Ù„Ø¨Ø±ÙˆØªÙŠÙ†Ø§Øª Ø¥Ù„Ù‰ Ù‡Ù†Ø¯Ø³Ø© Ø§Ù„Ø¨Ø±ÙˆØªÙŠÙ†Ø§Øª",
    "course_code": "BOTA 324",
    "credit_hours": "1",
    "prerequisites": "BOTA 217"
  },
  {
    "level": "3",
    "type": "mandatory",
    "spec": "bota",
    "department": "Ø§Ù„Ù†Ø¨Ø§Øª (ØªØ®ØµØµ Ø£ÙˆÙ„)",
    "course_name": "Ø§Ù„Ø­ÙŠØ§Ø© Ø§Ù„Ø¨Ø±ÙŠØ© ÙˆØ§Ù„Ù…ÙˆØ§Ø±Ø¯ Ø§Ù„Ø¨ÙŠØ¦ÙŠØ© Ø§Ù„Ø·Ø¨ÙŠØ¹ÙŠØ©",
    "course_code": "BOTA 326",
    "credit_hours": "1",
    "prerequisites": "BOTA 215"
  },
  {
    "level": "3",
    "type": "mandatory",
    "spec": "chem",
    "department": "Ø§Ù„ÙƒÙŠÙ…ÙŠØ§Ø¡ (ØªØ®ØµØµ Ø«Ø§Ù†ÙŠ)",
    "course_name": "ÙƒÙŠÙ…ÙŠØ§Ø¡ Ø¹Ø¶ÙˆÙŠØ© â€“ Ø§Ù„Ø£ØµØ¨Ø§Øº ÙˆØ§Ù„Ø£Ø·ÙŠØ§Ù Ø§Ù„Ø¹Ø¶ÙˆÙŠØ©",
    "course_code": "CHEM 360",
    "credit_hours": "3",
    "prerequisites": "-"
  },
  {
    "level": "3",
    "type": "mandatory",
    "spec": "chem",
    "department": "Ø§Ù„ÙƒÙŠÙ…ÙŠØ§Ø¡ (ØªØ®ØµØµ Ø«Ø§Ù†ÙŠ)",
    "course_name": "ÙƒÙŠÙ…ÙŠØ§Ø¡ ØªØ­Ù„ÙŠÙ„ÙŠØ© â€“ Ø§Ù„ØªØ­Ù„ÙŠÙ„ Ø¨Ø§Ù„Ø£Ø¬Ù‡Ø²Ø©",
    "course_code": "CHEM 380",
    "credit_hours": "3",
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
    "type": "mandatory",
    "spec": "bota",
    "department": "Ø§Ù„Ù†Ø¨Ø§Øª (ØªØ®ØµØµ Ø£ÙˆÙ„)",
    "course_name": "ÙØ³ÙŠÙˆÙ„ÙˆØ¬ÙŠØ§ Ø§Ù„Ø¥Ù†Ø¨Ø§Øª ÙˆØ§Ù„Ø¥ÙƒØ«Ø§Ø±",
    "course_code": "BOTA 427",
    "credit_hours": "2",
    "prerequisites": "BOTA 321"
  },
  {
    "level": "4",
    "type": "mandatory",
    "spec": "bota",
    "department": "Ø§Ù„Ù†Ø¨Ø§Øª (ØªØ®ØµØµ Ø£ÙˆÙ„)",
    "course_name": "Ø§Ù„Ù†ÙˆØ§Ø­ÙŠ Ø§Ù„ØªØ·Ø¨ÙŠÙ‚ÙŠØ© Ù„Ù„Ø£Ø±Ø´ÙŠØ¬ÙˆÙ†ÙŠØ§Øª ÙˆØ§Ù„Ø­ÙØ±ÙŠØ§Øª",
    "course_code": "BOTA 429",
    "credit_hours": "2",
    "prerequisites": "BOTA 322"
  },
  {
    "level": "4",
    "type": "mandatory",
    "spec": "bota",
    "department": "Ø§Ù„Ù†Ø¨Ø§Øª (ØªØ®ØµØµ Ø£ÙˆÙ„)",
    "course_name": "Ù…Ù‚Ø¯Ù…Ø© ÙÙŠ Ø¹Ù„Ù… Ø§Ù„Ø£Ø¬Ù†Ø©",
    "course_code": "BOTA 431",
    "credit_hours": "2",
    "prerequisites": "-"
  },
  {
    "level": "4",
    "type": "mandatory",
    "spec": "chem",
    "department": "Ø§Ù„ÙƒÙŠÙ…ÙŠØ§Ø¡ (ØªØ®ØµØµ Ø«Ø§Ù†ÙŠ)",
    "course_name": "ÙƒÙŠÙ…ÙŠØ§Ø¡ Ø¹Ø¶ÙˆÙŠØ© â€“ Ù…ÙŠÙƒØ§Ù†ÙŠÙƒÙŠØ© ØªÙØ§Ø¹Ù„Ø§Øª ÙˆØªØ±Ø¨ÙŠÙ†Ø§Øª",
    "course_code": "CHEM 461",
    "credit_hours": "4",
    "prerequisites": "-"
  },
  {
    "level": "4",
    "type": "mandatory",
    "spec": "chem",
    "department": "Ø§Ù„ÙƒÙŠÙ…ÙŠØ§Ø¡ (ØªØ®ØµØµ Ø«Ø§Ù†ÙŠ)",
    "course_name": "Ø§Ù„ÙƒÙŠÙ…ÙŠØ§Ø¡ Ø§Ù„Ø­ÙŠÙˆÙŠØ© ØºÙŠØ± Ø¹Ø¶ÙˆÙŠØ© ÙˆØ§Ù„Ø·ÙŠÙÙŠØ© Ø§Ù„ÙƒÙŠÙ…ÙŠØ§Ø¦ÙŠØ©",
    "course_code": "CHEM 471",
    "credit_hours": "2",
    "prerequisites": "-"
  },
  {
    "level": "4",
    "type": "mandatory",
    "spec": "chem",
    "department": "Ø§Ù„ÙƒÙŠÙ…ÙŠØ§Ø¡ (ØªØ®ØµØµ Ø«Ø§Ù†ÙŠ)",
    "course_name":
        "ÙƒÙŠÙ…ÙŠØ§Ø¡ ÙÙŠØ²ÙŠØ§Ø¦ÙŠØ© â€“ Ø§Ù„Ø¯ÙŠÙ†Ø§Ù…ÙŠÙƒØ§ Ø§Ù„Ø­Ø±Ø§Ø±ÙŠØ© Ù„Ù„Ù…Ø­Ø§Ù„ÙŠÙ„ Ø§Ù„Ø¥Ù„ÙƒØªØ±ÙˆÙ„ÙŠØªÙŠØ©",
    "course_code": "CHEM 491",
    "credit_hours": "1",
    "prerequisites": "-"
  },
  {
    "level": "4",
    "type": "mandatory",
    "spec": "bota",
    "department": "Ø§Ù„Ù†Ø¨Ø§Øª (ØªØ®ØµØµ Ø£ÙˆÙ„)",
    "course_name": "Ø£ÙŠØ¶ Ø§Ù„Ù†Ø¨Ø§Øª",
    "course_code": "BOTA 422",
    "credit_hours": "3",
    "prerequisites": "-"
  },
  {
    "level": "4",
    "type": "mandatory",
    "spec": "bota",
    "department": "Ø§Ù„Ù†Ø¨Ø§Øª (ØªØ®ØµØµ Ø£ÙˆÙ„)",
    "course_name": "Ù†Ø¨Ø§ØªØ§Øª Ø¹Ù‚Ø§Ù‚ÙŠØ± Ø·Ø¨ÙŠØ© â€“ ØªØµÙ†ÙŠÙ ÙˆÙÙ„ÙˆØ±Ø§ ÙƒÙŠÙ…ÙŠØ§Ø¦ÙŠ",
    "course_code": "BOTA 424",
    "credit_hours": "3",
    "prerequisites": "BOTA 216"
  },
  {
    "level": "4",
    "type": "mandatory",
    "spec": "bota",
    "department": "Ø§Ù„Ù†Ø¨Ø§Øª (ØªØ®ØµØµ Ø£ÙˆÙ„)",
    "course_name":
        "ØªÙ‚Ù†ÙŠØ§Øª ØªØ¶Ø§Ø¹Ù Ø§Ù„Ø­Ù…Ø¶ Ø§Ù„Ù†ÙˆÙˆÙŠ DNA Ø¨Ø¥Ø³ØªØ®Ø¯Ø§Ù… ØªÙØ§Ø¹Ù„ Ø§Ù„Ø¨Ù„Ù…Ø±Ø© Ø§Ù„Ù…ØªØ³Ù„Ø³Ù„",
    "course_code": "BOTA 426",
    "credit_hours": "2",
    "prerequisites": "BOTA 323"
  },
  {
    "level": "4",
    "type": "mandatory",
    "spec": "chem",
    "department": "Ø§Ù„ÙƒÙŠÙ…ÙŠØ§Ø¡ (ØªØ®ØµØµ Ø«Ø§Ù†ÙŠ)",
    "course_name": "ÙƒÙŠÙ…ÙŠØ§Ø¡ Ø¹Ø¶ÙˆÙŠØ© â€“ ØºÙŠØ± Ù…ØªØ¬Ø§Ù†Ø³Ø© ÙˆÙ‚Ù„ÙˆÙŠØ¯Ø§Øª",
    "course_code": "CHEM 460",
    "credit_hours": "4",
    "prerequisites": "-"
  },
  {
    "level": "4",
    "type": "mandatory",
    "spec": "chem",
    "department": "Ø§Ù„ÙƒÙŠÙ…ÙŠØ§Ø¡ (ØªØ®ØµØµ Ø«Ø§Ù†ÙŠ)",
    "course_name": "ÙƒÙŠÙ…ÙŠØ§Ø¡ ÙÙŠØ²ÙŠØ§Ø¦ÙŠØ© â€“ ÙƒÙŠÙ…ÙŠØ§Ø¡ Ø¶ÙˆØ¦ÙŠØ©",
    "course_code": "CHEM 490",
    "credit_hours": "2",
    "prerequisites": "-"
  },
  {
    "level": "4",
    "type": "mandatory",
    "spec": "chem",
    "department": "Ø§Ù„ÙƒÙŠÙ…ÙŠØ§Ø¡ (ØªØ®ØµØµ Ø«Ø§Ù†ÙŠ)",
    "course_name": "ÙƒÙŠÙ…ÙŠØ§Ø¡ ØºÙŠØ± Ø¹Ø¶ÙˆÙŠØ© â€“ Ø³Ù„Ø§Ø³Ù„ ÙˆØ§Ù„Ù…ØªØ±Ø§ÙƒØ¨Ø§Øª Ø§Ù„Ø¹Ù†Ù‚ÙˆØ¯ÙŠØ©",
    "course_code": "CHEM 470",
    "credit_hours": "1",
    "prerequisites": "-"
  },
];

class BotanyChemCoursesScreen extends StatefulWidget {
  const BotanyChemCoursesScreen({super.key});
  @override
  State<BotanyChemCoursesScreen> createState() =>
      _BotanyChemCoursesScreenState();
}

class _BotanyChemCoursesScreenState extends State<BotanyChemCoursesScreen>
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
      if (_filterSpec == 'bota') {
        return c['spec'] == 'bota' || c['spec'] == 'both';
      }
      if (_filterSpec == 'chem') {
        return c['spec'] == 'chem' || c['spec'] == 'both';
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
        title: const Text('Ø§Ù„Ù†Ø¨Ø§Øª â€“ ÙƒÙŠÙ…ÙŠØ§Ø¡ (Ù…Ø²Ø¯ÙˆØ¬)',
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
      color: const Color(0xFF14532D),
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
                  color: const Color(0xFF14532D),
                  onTap: () => setState(() => _filterSpec = 'all')),
              const SizedBox(width: 8),
              _Chip(
                  label: 'Ø§Ù„Ù†Ø¨Ø§Øª',
                  selected: _filterSpec == 'bota',
                  color: const Color(0xFF16A34A),
                  onTap: () => setState(() => _filterSpec = 'bota')),
              const SizedBox(width: 8),
              _Chip(
                  label: 'Ø§Ù„ÙƒÙŠÙ…ÙŠØ§Ø¡',
                  selected: _filterSpec == 'chem',
                  color: const Color(0xFF7C3AED),
                  onTap: () => setState(() => _filterSpec = 'chem')),
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
    final spec = course['spec'] ?? '';
    final dept = course['department'] ?? '';
    if (spec == 'bota' || dept.contains('Ø§Ù„Ù†Ø¨Ø§Øª') || dept.contains('BOTA')) {
      return const Color(0xFF16A34A);
    }
    if (spec == 'chem' || dept.contains('Ø§Ù„ÙƒÙŠÙ…ÙŠØ§Ø¡') || dept.contains('CHEM')) {
      return const Color(0xFF7C3AED);
    }
    if (dept.contains('ÙÙŠØ²ÙŠØ§Ø¡') || dept.contains('PHYS')) {
      return const Color(0xFFDC2626);
    }
    if (dept.contains('Ø±ÙŠØ§Ø¶ÙŠØ§Øª')) return const Color(0xFF2563EB);
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
