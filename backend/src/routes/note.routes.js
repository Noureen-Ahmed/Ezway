const express = require('express');
const { body, param } = require('express-validator');
const router = express.Router();
const { prisma } = require('../utils/database');
const { validate } = require('../middleware/validate');
const { authenticate } = require('../middleware/auth');
const logger = require('../utils/logger');
const { ApiError } = require('../middleware/errorHandler');

// GET all notes for the authenticated user
router.get('/', authenticate, async (req, res, next) => {
  try {
    const notes = await prisma.note.findMany({
      where: { userId: req.user.id },
      orderBy: { createdAt: 'desc' }
    });

    res.json({
      success: true,
      notes: notes.map(n => ({
        id: n.id,
        title: n.title,
        content: n.content,
        createdAt: n.createdAt,
        updatedAt: n.updatedAt
      }))
    });
  } catch (error) {
    next(error);
  }
});

// GET single note
router.get('/:id', authenticate, async (req, res, next) => {
  try {
    const note = await prisma.note.findUnique({
      where: { id: req.params.id }
    });

    if (!note || note.userId !== req.user.id) {
      throw new ApiError(404, 'Note not found');
    }

    res.json({
      success: true,
      note: {
        id: note.id,
        title: note.title,
        content: note.content,
        createdAt: note.createdAt,
        updatedAt: note.updatedAt
      }
    });
  } catch (error) {
    next(error);
  }
});

// POST create a new note
router.post('/', authenticate, [
  body('title').trim().notEmpty().withMessage('Title is required'),
  body('content').optional({ nullable: true }).isString(),
  validate
], async (req, res, next) => {
  try {
    const { title, content } = req.body;

    const note = await prisma.note.create({
      data: {
        title,
        content,
        userId: req.user.id
      }
    });

    logger.info(`✅ Note created by ${req.user.email}`);

    res.status(201).json({
      success: true,
      note: {
        id: note.id,
        title: note.title,
        content: note.content,
        createdAt: note.createdAt,
        updatedAt: note.updatedAt
      }
    });
  } catch (error) {
    next(error);
  }
});

// PUT update note
router.put('/:id', authenticate, [
  param('id').notEmpty(),
  body('title').optional().trim().notEmpty(),
  body('content').optional({ nullable: true }).isString(),
  validate
], async (req, res, next) => {
  try {
    const { id } = req.params;
    const { title, content } = req.body;

    const existingNote = await prisma.note.findUnique({ where: { id } });
    if (!existingNote || existingNote.userId !== req.user.id) {
      throw new ApiError(404, 'Note not found');
    }

    const note = await prisma.note.update({
      where: { id },
      data: {
        ...(title !== undefined && { title }),
        ...(content !== undefined && { content })
      }
    });

    res.json({
      success: true,
      note: {
        id: note.id,
        title: note.title,
        content: note.content,
        createdAt: note.createdAt,
        updatedAt: note.updatedAt
      }
    });
  } catch (error) {
    next(error);
  }
});

// DELETE a note
router.delete('/:id', authenticate, async (req, res, next) => {
  try {
    const { id } = req.params;

    const existingNote = await prisma.note.findUnique({ where: { id } });
    if (!existingNote || existingNote.userId !== req.user.id) {
      throw new ApiError(404, 'Note not found');
    }

    await prisma.note.delete({ where: { id } });

    res.json({
      success: true,
      message: 'Note deleted successfully'
    });
  } catch (error) {
    next(error);
  }
});

module.exports = router;
