-- CreateTable
CREATE TABLE `faculties` (
    `id` VARCHAR(191) NOT NULL,
    `name` VARCHAR(191) NOT NULL,
    `name_ar` VARCHAR(191) NULL,
    `code` VARCHAR(191) NOT NULL,
    `description` LONGTEXT NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_at` DATETIME(3) NOT NULL,

    UNIQUE INDEX `faculties_name_key`(`name`),
    UNIQUE INDEX `faculties_code_key`(`code`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `departments` (
    `id` VARCHAR(191) NOT NULL,
    `name` VARCHAR(191) NOT NULL,
    `name_ar` VARCHAR(191) NULL,
    `code` VARCHAR(191) NOT NULL,
    `description` LONGTEXT NULL,
    `faculty_id` VARCHAR(191) NOT NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_at` DATETIME(3) NOT NULL,

    UNIQUE INDEX `departments_code_key`(`code`),
    UNIQUE INDEX `departments_faculty_id_name_key`(`faculty_id`, `name`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `programs` (
    `id` VARCHAR(191) NOT NULL,
    `name` VARCHAR(191) NOT NULL,
    `name_ar` VARCHAR(191) NULL,
    `code` VARCHAR(191) NOT NULL,
    `description` LONGTEXT NULL,
    `credit_hours` INTEGER NOT NULL DEFAULT 132,
    `department_id` VARCHAR(191) NOT NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_at` DATETIME(3) NOT NULL,

    UNIQUE INDEX `programs_code_key`(`code`),
    UNIQUE INDEX `programs_department_id_name_key`(`department_id`, `name`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `program_instructors` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `assigned_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `professor_id` VARCHAR(191) NOT NULL,
    `program_id` VARCHAR(191) NOT NULL,

    UNIQUE INDEX `program_instructors_professor_id_program_id_key`(`professor_id`, `program_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `users` (
    `id` VARCHAR(191) NOT NULL,
    `email` VARCHAR(191) NOT NULL,
    `password` VARCHAR(191) NOT NULL,
    `name` VARCHAR(191) NOT NULL,
    `name_ar` VARCHAR(191) NULL,
    `avatar` VARCHAR(191) NULL,
    `phone` VARCHAR(191) NULL,
    `role` ENUM('STUDENT', 'PROFESSOR', 'ADMIN') NOT NULL DEFAULT 'STUDENT',
    `student_id` VARCHAR(191) NULL,
    `gpa` DOUBLE NULL,
    `level` INTEGER NULL,
    `program_id` VARCHAR(191) NULL,
    `department_id` VARCHAR(191) NULL,
    `is_verified` BOOLEAN NOT NULL DEFAULT false,
    `is_onboarding_complete` BOOLEAN NOT NULL DEFAULT false,
    `is_active` BOOLEAN NOT NULL DEFAULT true,
    `faculty` VARCHAR(191) NULL,
    `department_name` VARCHAR(191) NULL,
    `major` VARCHAR(191) NULL,
    `semester` VARCHAR(191) NULL,
    `academic_year` VARCHAR(191) NULL,
    `advisor_name` VARCHAR(191) NULL,
    `advisor_email` VARCHAR(191) NULL,
    `address` TEXT NULL,
    `fcm_token` VARCHAR(191) NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_at` DATETIME(3) NOT NULL,
    `last_login_at` DATETIME(3) NULL,

    UNIQUE INDEX `users_email_key`(`email`),
    UNIQUE INDEX `users_student_id_key`(`student_id`),
    INDEX `users_program_id_idx`(`program_id`),
    INDEX `users_department_id_idx`(`department_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `verification_codes` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `code` VARCHAR(191) NOT NULL,
    `type` ENUM('REGISTRATION', 'PASSWORD_RESET', 'EMAIL_CHANGE') NOT NULL,
    `expires_at` DATETIME(3) NOT NULL,
    `used` BOOLEAN NOT NULL DEFAULT false,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `user_id` VARCHAR(191) NOT NULL,

    INDEX `verification_codes_code_idx`(`code`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `courses` (
    `id` VARCHAR(191) NOT NULL,
    `code` VARCHAR(191) NOT NULL,
    `name` VARCHAR(191) NOT NULL,
    `name_ar` VARCHAR(191) NULL,
    `description` LONGTEXT NULL,
    `category` ENUM('COMP', 'MATH', 'CHEM', 'PHYS', 'BIO', 'GENERAL', 'ELECTIVE') NOT NULL DEFAULT 'GENERAL',
    `credit_hours` INTEGER NOT NULL DEFAULT 3,
    `semester` VARCHAR(191) NULL,
    `academic_year` VARCHAR(191) NULL,
    `is_active` BOOLEAN NOT NULL DEFAULT true,
    `department_id` VARCHAR(191) NULL,
    `program_id` VARCHAR(191) NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_at` DATETIME(3) NOT NULL,

    UNIQUE INDEX `courses_code_key`(`code`),
    INDEX `courses_department_id_idx`(`department_id`),
    INDEX `courses_program_id_idx`(`program_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `course_instructors` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `is_primary` BOOLEAN NOT NULL DEFAULT false,
    `assigned_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `user_id` VARCHAR(191) NOT NULL,
    `course_id` VARCHAR(191) NOT NULL,

    UNIQUE INDEX `course_instructors_user_id_course_id_key`(`user_id`, `course_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `enrollments` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `status` ENUM('ENROLLED', 'COMPLETED', 'DROPPED', 'WITHDRAWN', 'FAILED') NOT NULL DEFAULT 'ENROLLED',
    `enrolled_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `completed_at` DATETIME(3) NULL,
    `grade` VARCHAR(191) NULL,
    `grade_points` DOUBLE NULL,
    `user_id` VARCHAR(191) NOT NULL,
    `course_id` VARCHAR(191) NOT NULL,

    INDEX `enrollments_user_id_idx`(`user_id`),
    INDEX `enrollments_course_id_idx`(`course_id`),
    INDEX `enrollments_status_idx`(`status`),
    UNIQUE INDEX `enrollments_user_id_course_id_key`(`user_id`, `course_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `course_content` (
    `id` VARCHAR(191) NOT NULL,
    `title` VARCHAR(191) NOT NULL,
    `description` LONGTEXT NULL,
    `contentType` ENUM('LECTURE', 'MATERIAL', 'VIDEO', 'DOCUMENT', 'LINK') NOT NULL,
    `file_url` VARCHAR(191) NULL,
    `attachments` JSON NULL,
    `week_number` INTEGER NULL,
    `order_index` INTEGER NOT NULL DEFAULT 0,
    `is_published` BOOLEAN NOT NULL DEFAULT true,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_at` DATETIME(3) NOT NULL,
    `course_id` VARCHAR(191) NOT NULL,
    `created_by_id` VARCHAR(191) NOT NULL,

    INDEX `course_content_course_id_week_number_idx`(`course_id`, `week_number`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `course_schedules` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `dayOfWeek` ENUM('SUNDAY', 'MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY', 'SATURDAY') NOT NULL,
    `start_time` VARCHAR(191) NOT NULL,
    `end_time` VARCHAR(191) NOT NULL,
    `location` VARCHAR(191) NULL,
    `room` VARCHAR(191) NULL,
    `course_id` VARCHAR(191) NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `tasks` (
    `id` VARCHAR(191) NOT NULL,
    `title` VARCHAR(191) NOT NULL,
    `description` LONGTEXT NULL,
    `task_type` ENUM('ASSIGNMENT', 'EXAM', 'QUIZ', 'PROJECT', 'LAB', 'PERSONAL') NOT NULL DEFAULT 'ASSIGNMENT',
    `priority` ENUM('LOW', 'MEDIUM', 'HIGH', 'URGENT') NOT NULL DEFAULT 'MEDIUM',
    `due_date` DATETIME(3) NULL,
    `start_date` DATETIME(3) NULL,
    `max_points` INTEGER NOT NULL DEFAULT 100,
    `attachments` JSON NULL,
    `questions` JSON NULL,
    `settings` JSON NULL,
    `published` BOOLEAN NOT NULL DEFAULT true,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_at` DATETIME(3) NOT NULL,
    `status` VARCHAR(191) NOT NULL DEFAULT 'PENDING',
    `completed_at` DATETIME(3) NULL,
    `course_id` VARCHAR(191) NULL,
    `created_by_id` VARCHAR(191) NOT NULL,

    INDEX `tasks_due_date_idx`(`due_date`),
    INDEX `tasks_course_id_idx`(`course_id`),
    INDEX `tasks_created_by_id_idx`(`created_by_id`),
    INDEX `tasks_status_idx`(`status`),
    INDEX `tasks_created_by_id_status_idx`(`created_by_id`, `status`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `task_submissions` (
    `id` VARCHAR(191) NOT NULL,
    `status` ENUM('PENDING', 'SUBMITTED', 'LATE', 'GRADED', 'RETURNED') NOT NULL DEFAULT 'PENDING',
    `submitted_at` DATETIME(3) NULL,
    `file_url` VARCHAR(191) NULL,
    `notes` LONGTEXT NULL,
    `answers` JSON NULL,
    `started_at` DATETIME(3) NULL,
    `snapshots` JSON NULL,
    `points` DOUBLE NULL,
    `grade` VARCHAR(191) NULL,
    `feedback` LONGTEXT NULL,
    `graded_at` DATETIME(3) NULL,
    `task_id` VARCHAR(191) NOT NULL,
    `student_id` VARCHAR(191) NOT NULL,

    UNIQUE INDEX `task_submissions_task_id_student_id_key`(`task_id`, `student_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `announcements` (
    `id` VARCHAR(191) NOT NULL,
    `title` VARCHAR(191) NOT NULL,
    `message` LONGTEXT NOT NULL,
    `type` ENUM('GENERAL', 'ASSIGNMENT', 'EXAM', 'LECTURE', 'URGENT', 'MAINTENANCE') NOT NULL DEFAULT 'GENERAL',
    `is_pinned` BOOLEAN NOT NULL DEFAULT false,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `expires_at` DATETIME(3) NULL,
    `course_id` VARCHAR(191) NULL,
    `created_by_id` VARCHAR(191) NOT NULL,

    INDEX `announcements_created_at_idx`(`created_at`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `notifications` (
    `id` VARCHAR(191) NOT NULL,
    `title` VARCHAR(191) NOT NULL,
    `message` LONGTEXT NOT NULL,
    `type` ENUM('GENERAL', 'ANNOUNCEMENT', 'ASSIGNMENT', 'EXAM', 'GRADE', 'REMINDER', 'SYSTEM') NOT NULL DEFAULT 'GENERAL',
    `reference_type` ENUM('ANNOUNCEMENT', 'TASK', 'COURSE', 'CONTENT') NULL,
    `reference_id` VARCHAR(191) NULL,
    `is_read` BOOLEAN NOT NULL DEFAULT false,
    `is_pushed` BOOLEAN NOT NULL DEFAULT false,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `read_at` DATETIME(3) NULL,
    `user_id` VARCHAR(191) NOT NULL,

    INDEX `notifications_user_id_is_read_idx`(`user_id`, `is_read`),
    INDEX `notifications_created_at_idx`(`created_at`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `schedule_events` (
    `id` VARCHAR(191) NOT NULL,
    `title` VARCHAR(191) NOT NULL,
    `description` LONGTEXT NULL,
    `eventType` ENUM('LECTURE', 'EXAM', 'ASSIGNMENT_DUE', 'MEETING', 'OFFICE_HOURS', 'PERSONAL') NOT NULL DEFAULT 'PERSONAL',
    `start_time` DATETIME(3) NOT NULL,
    `end_time` DATETIME(3) NOT NULL,
    `is_all_day` BOOLEAN NOT NULL DEFAULT false,
    `location` VARCHAR(191) NULL,
    `is_recurring` BOOLEAN NOT NULL DEFAULT false,
    `recurrence_rule` VARCHAR(191) NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_at` DATETIME(3) NOT NULL,
    `user_id` VARCHAR(191) NOT NULL,

    INDEX `schedule_events_start_time_idx`(`start_time`),
    INDEX `schedule_events_user_id_idx`(`user_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `ums_sessions` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `cookies` JSON NOT NULL,
    `last_sync_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `expires_at` DATETIME(3) NULL,
    `is_active` BOOLEAN NOT NULL DEFAULT true,
    `user_id` VARCHAR(191) NOT NULL,

    UNIQUE INDEX `ums_sessions_user_id_key`(`user_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `ums_courses` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `course_code` VARCHAR(191) NOT NULL,
    `course_name` VARCHAR(191) NOT NULL,
    `course_name_ar` VARCHAR(191) NULL,
    `credit_hours` INTEGER NULL,
    `section` VARCHAR(191) NULL,
    `semester` VARCHAR(191) NULL,
    `academic_year` VARCHAR(191) NULL,
    `instructor_name` VARCHAR(191) NULL,
    `raw_data` JSON NULL,
    `synced_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `user_id` VARCHAR(191) NOT NULL,

    INDEX `ums_courses_user_id_idx`(`user_id`),
    UNIQUE INDEX `ums_courses_user_id_course_code_semester_academic_year_key`(`user_id`, `course_code`, `semester`, `academic_year`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `ums_grades` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `course_code` VARCHAR(191) NOT NULL,
    `course_name` VARCHAR(191) NOT NULL,
    `grade` VARCHAR(191) NULL,
    `grade_points` DOUBLE NULL,
    `credit_hours` INTEGER NULL,
    `semester` VARCHAR(191) NULL,
    `academic_year` VARCHAR(191) NULL,
    `raw_data` JSON NULL,
    `synced_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `user_id` VARCHAR(191) NOT NULL,

    INDEX `ums_grades_user_id_idx`(`user_id`),
    UNIQUE INDEX `ums_grades_user_id_course_code_semester_academic_year_key`(`user_id`, `course_code`, `semester`, `academic_year`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- AddForeignKey
ALTER TABLE `departments` ADD CONSTRAINT `departments_faculty_id_fkey` FOREIGN KEY (`faculty_id`) REFERENCES `faculties`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `programs` ADD CONSTRAINT `programs_department_id_fkey` FOREIGN KEY (`department_id`) REFERENCES `departments`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `program_instructors` ADD CONSTRAINT `program_instructors_professor_id_fkey` FOREIGN KEY (`professor_id`) REFERENCES `users`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `program_instructors` ADD CONSTRAINT `program_instructors_program_id_fkey` FOREIGN KEY (`program_id`) REFERENCES `programs`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `users` ADD CONSTRAINT `users_program_id_fkey` FOREIGN KEY (`program_id`) REFERENCES `programs`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `users` ADD CONSTRAINT `users_department_id_fkey` FOREIGN KEY (`department_id`) REFERENCES `departments`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `verification_codes` ADD CONSTRAINT `verification_codes_user_id_fkey` FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `courses` ADD CONSTRAINT `courses_department_id_fkey` FOREIGN KEY (`department_id`) REFERENCES `departments`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `courses` ADD CONSTRAINT `courses_program_id_fkey` FOREIGN KEY (`program_id`) REFERENCES `programs`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `course_instructors` ADD CONSTRAINT `course_instructors_user_id_fkey` FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `course_instructors` ADD CONSTRAINT `course_instructors_course_id_fkey` FOREIGN KEY (`course_id`) REFERENCES `courses`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `enrollments` ADD CONSTRAINT `enrollments_user_id_fkey` FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `enrollments` ADD CONSTRAINT `enrollments_course_id_fkey` FOREIGN KEY (`course_id`) REFERENCES `courses`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `course_content` ADD CONSTRAINT `course_content_course_id_fkey` FOREIGN KEY (`course_id`) REFERENCES `courses`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `course_content` ADD CONSTRAINT `course_content_created_by_id_fkey` FOREIGN KEY (`created_by_id`) REFERENCES `users`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `course_schedules` ADD CONSTRAINT `course_schedules_course_id_fkey` FOREIGN KEY (`course_id`) REFERENCES `courses`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `tasks` ADD CONSTRAINT `tasks_course_id_fkey` FOREIGN KEY (`course_id`) REFERENCES `courses`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `tasks` ADD CONSTRAINT `tasks_created_by_id_fkey` FOREIGN KEY (`created_by_id`) REFERENCES `users`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `task_submissions` ADD CONSTRAINT `task_submissions_task_id_fkey` FOREIGN KEY (`task_id`) REFERENCES `tasks`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `task_submissions` ADD CONSTRAINT `task_submissions_student_id_fkey` FOREIGN KEY (`student_id`) REFERENCES `users`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `announcements` ADD CONSTRAINT `announcements_course_id_fkey` FOREIGN KEY (`course_id`) REFERENCES `courses`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `announcements` ADD CONSTRAINT `announcements_created_by_id_fkey` FOREIGN KEY (`created_by_id`) REFERENCES `users`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `notifications` ADD CONSTRAINT `notifications_user_id_fkey` FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `schedule_events` ADD CONSTRAINT `schedule_events_user_id_fkey` FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `ums_sessions` ADD CONSTRAINT `ums_sessions_user_id_fkey` FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `ums_courses` ADD CONSTRAINT `ums_courses_user_id_fkey` FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `ums_grades` ADD CONSTRAINT `ums_grades_user_id_fkey` FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;
