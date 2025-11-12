-- Create database
CREATE DATABASE IF NOT EXISTS cratercode_applications;

USE cratercode_applications;

-- Create course_applications table
CREATE TABLE IF NOT EXISTS course_applications (
    id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    course VARCHAR(255) NOT NULL,
    message TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_email (email),
    INDEX idx_course (course),
    INDEX idx_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Users table for authentication
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(100) NOT NULL,
    full_name VARCHAR(100),
    is_active TINYINT(1) DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    last_login TIMESTAMP NULL DEFAULT NULL,
    INDEX idx_users_active (is_active),
    INDEX idx_users_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Seed admin user (login with username 'admin' and password 'Admin@123')
INSERT INTO users (username, email, password_hash, full_name, is_active)
VALUES (
    'admin',
    'admin@cratercode.com',
    '$2y$10$ITjGJvLC9OtJk9gDC11FXOO0JRtKzs/ufADG7n2AFDzy83H8XTurG',
    'Administrator',
    1
)
ON DUPLICATE KEY UPDATE
    email = VALUES(email),
    full_name = VALUES(full_name),
    is_active = VALUES(is_active),
    updated_at = CURRENT_TIMESTAMP;

-- Master course catalog table
CREATE TABLE IF NOT EXISTS courses (
    id INT AUTO_INCREMENT PRIMARY KEY,
    slug VARCHAR(100) NOT NULL UNIQUE,
    name VARCHAR(255) NOT NULL,
    duration_weeks TINYINT UNSIGNED NOT NULL,
    difficulty_level ENUM('Beginner', 'Intermediate', 'Advanced', 'All Levels') NOT NULL DEFAULT 'All Levels',
    category VARCHAR(100) NOT NULL,
    delivery_mode VARCHAR(100) NOT NULL DEFAULT 'Hybrid',
    technology_stack TEXT NOT NULL,
    summary TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_courses_category (category),
    INDEX idx_courses_difficulty (difficulty_level)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Detailed technology narratives per course
CREATE TABLE IF NOT EXISTS course_technology_details (
    id INT AUTO_INCREMENT PRIMARY KEY,
    course_id INT NOT NULL,
    tech_name VARCHAR(100) NOT NULL,
    headline VARCHAR(150) NOT NULL,
    tech_stacks VARCHAR(255) NOT NULL,
    long_description TEXT NOT NULL,
    display_order TINYINT UNSIGNED NOT NULL DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_course_technology_course FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE,
    UNIQUE KEY uq_course_technology (course_id, tech_name),
    INDEX idx_course_technology_order (course_id, display_order)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Seed canonical full-stack course definition
INSERT INTO courses (slug, name, duration_weeks, difficulty_level, category, delivery_mode, technology_stack, summary)
VALUES (
    'fullstack-js',
    'Full-Stack JavaScript Accelerator',
    12,
    'All Levels',
    'Web Development',
    'Hybrid',
    'React, Node.js, Express.js, MongoDB',
    'A 12-week sprint that takes learners from fundamentals to production-ready full-stack JavaScript skills with guided projects and professional mentorship.'
)
ON DUPLICATE KEY UPDATE
    name = VALUES(name),
    duration_weeks = VALUES(duration_weeks),
    difficulty_level = VALUES(difficulty_level),
    category = VALUES(category),
    delivery_mode = VALUES(delivery_mode),
    technology_stack = VALUES(technology_stack),
    summary = VALUES(summary),
    updated_at = CURRENT_TIMESTAMP;

SET @fullstack_course_id = (SELECT id FROM courses WHERE slug = 'fullstack-js' LIMIT 1);

INSERT INTO course_technology_details (course_id, tech_name, headline, tech_stacks, long_description, display_order)
SELECT @fullstack_course_id, 'React', 'Dynamic Frontend Experiences', 'Hooks · Context API · Component-driven UI · Testing Library',
       'We are offering immersive React mastery from day one.\nWe are teaching how to architect reusable component systems at scale.\nWe show how to manage state cleanly with hooks, context, and reducers.\nWe guide you through performance tuning with memoization and suspense.\nWe connect REST and GraphQL data sources with resilient networking patterns.\nWe bake in accessibility and testing using Jest and Testing Library.\nWe finish with deployment pipelines that keep shipping frictionless.',
       1
WHERE @fullstack_course_id IS NOT NULL
  AND NOT EXISTS (
      SELECT 1 FROM course_technology_details WHERE course_id = @fullstack_course_id AND tech_name = 'React'
  );

INSERT INTO course_technology_details (course_id, tech_name, headline, tech_stacks, long_description, display_order)
SELECT @fullstack_course_id, 'Node.js', 'Backends Built for Speed', 'Event Loop · Streams · Worker Threads · NPM Tooling',
       'We are offering deep dives into asynchronous patterns that keep APIs responsive.\nWe are teaching how to structure layered Node services with maintainable modules.\nWe harden authentication, authorization, and input validation across every route.\nWe instrument logging, tracing, and profiling for observable services.\nWe automate integration and contract testing for dependable releases.\nWe run zero-downtime deployments across modern cloud providers.\nWe keep iterating with feedback loops tuned for production workloads.',
       2
WHERE @fullstack_course_id IS NOT NULL
  AND NOT EXISTS (
      SELECT 1 FROM course_technology_details WHERE course_id = @fullstack_course_id AND tech_name = 'Node.js'
  );

INSERT INTO course_technology_details (course_id, tech_name, headline, tech_stacks, long_description, display_order)
SELECT @fullstack_course_id, 'Express.js', 'API Craftsmanship', 'Routing · Middleware · REST Conventions · Error Handling',
       'We are offering expressive API design that keeps services flexible and fast.\nWe are teaching middleware composition to handle security, caching, and serialization.\nWe codify DTOs so contracts stay predictable for every consumer.\nWe implement rate limiting, sanitization, and graceful fallbacks by default.\nWe generate OpenAPI documentation that reflects live behavior automatically.\nWe mirror production traffic with integration tests that never drift.\nWe deliver CI/CD pipelines that promote APIs safely and repeatedly.',
       3
WHERE @fullstack_course_id IS NOT NULL
  AND NOT EXISTS (
      SELECT 1 FROM course_technology_details WHERE course_id = @fullstack_course_id AND tech_name = 'Express.js'
  );

INSERT INTO course_technology_details (course_id, tech_name, headline, tech_stacks, long_description, display_order)
SELECT @fullstack_course_id, 'MongoDB', 'Data for Modern Products', 'Schema Design · Aggregations · Indexing · Replication',
       'We are offering practical MongoDB schema design for evolving products.\nWe are teaching aggregation pipelines that unlock real-time insights.\nWe optimize indexes and sharding to keep reads and writes lightning fast.\nWe automate backup, failover, and recovery for enterprise resilience.\nWe lock down data with encryption, auditing, and role-based access.\nWe monitor clusters with proactive alerting and health dashboards.\nWe blend transactional data with analytics so features stay data-informed.',
       4
WHERE @fullstack_course_id IS NOT NULL
  AND NOT EXISTS (
      SELECT 1 FROM course_technology_details WHERE course_id = @fullstack_course_id AND tech_name = 'MongoDB'
  );