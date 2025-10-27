# 📚 Database Structure

This document describes the core database schema for the application.  
Each table has relational links and thoughtfully chosen constraints to ensure data integrity and a smooth developer experience.

## Tables Overview

### 1. 🗂️ `categories`

| Field         | Type                       | Description                          |
| ------------- | -------------------------- | ------------------------------------ |
| `id`          | `uuid` (PK)                | Unique category ID                   |
| `user_id`     | `uuid` (FK → profiles.id)  | Owner of the category                |
| `name`        | `text`                     | Name of the category                 |
| `description` | `text`                     | Extra info about the category        |
| `created_at`  | `timestamp with time zone` | Timestamp of creation (default: now) |
| `word_count`  | `integer`                  | Number of words (default: 0)         |
| `deleted_at`  | `timestamp with time zone` | Soft delete timestamp                |

---

### 2. 📝 `notes`

| Field        | Type                              | Description                           |
| ------------ | --------------------------------- | ------------------------------------- |
| `id`         | `uuid` (PK)                       | Unique note ID                        |
| `word_id`    | `uuid` (FK → translated_words.id) | Associated word                       |
| `user_id`    | `uuid` (FK → profiles.id)         | Note owner                            |
| `content`    | `text`                            | Note content                          |
| `created_at` | `timestamp with time zone`        | Created timestamp (default: now)      |
| `updated_at` | `timestamp with time zone`        | Last updated timestamp (default: now) |
| `deleted_at` | `timestamp with time zone`        | Soft delete timestamp                 |

---

### 3. 🙍 `profiles`

| Field        | Type                            | Description                      |
| ------------ | ------------------------------- | -------------------------------- |
| `id`         | `uuid` (PK, FK → auth.users.id) | User profile ID                  |
| `username`   | `text` (UNIQUE)                 | Public username                  |
| `full_name`  | `text`                          | User's full name                 |
| `avatar_url` | `text`                          | URL to user's avatar             |
| `bio`        | `text`                          | Short user bio                   |
| `created_at` | `timestamp with time zone`      | Created timestamp (default: now) |
| `deleted_at` | `timestamp with time zone`      | Soft delete timestamp            |

---

### 4. ⏰ `reminders`

| Field        | Type                              | Description                      |
| ------------ | --------------------------------- | -------------------------------- |
| `id`         | `uuid` (PK)                       | Unique reminder ID               |
| `user_id`    | `uuid` (FK → profiles.id)         | Reminder owner                   |
| `word_id`    | `uuid` (FK → translated_words.id) | Word to be reminded of           |
| `remind_at`  | `timestamp with time zone`        | When to remind the user          |
| `is_active`  | `boolean`                         | Active status (default: true)    |
| `created_at` | `timestamp with time zone`        | Created timestamp (default: now) |
| `updated_at` | `timestamp with time zone`        | Last updated (default: now)      |
| `deleted_at` | `timestamp with time zone`        | Soft delete timestamp            |

---

### 5. 🌍 `translated_words`

| Field            | Type                        | Description                  |
| ---------------- | --------------------------- | ---------------------------- |
| `id`             | `uuid` (PK)                 | Unique word ID               |
| `user_id`        | `uuid` (FK → profiles.id)   | Word added by user           |
| `category_id`    | `uuid` (FK → categories.id) | Linked category              |
| `original`       | `text`                      | The original word/text       |
| `translated`     | `text`                      | The translated word/text     |
| `pos`            | `text`                      | Part of speech               |
| `pronunciation`  | `text`                      | Pronunciation guide          |
| `meaning`        | `text`                      | Meaning explanation          |
| `examples`       | `array` (type unspecified)  | Example usages               |
| `synonyms`       | `array` (type unspecified)  | Synonyms                     |
| `translate_from` | `text`                      | Source language              |
| `translate_to`   | `text`                      | Target language              |
| `created_at`     | `timestamp with time zone`  | When added (default: now)    |
| `updated_at`     | `timestamp with time zone`  | Last modified (default: now) |
| `deleted_at`     | `timestamp with time zone`  | Soft delete timestamp        |

---

## ⚡️ Relations Diagram (Text Overview)

- **profiles.id** = user id, referenced throughout all tables
- **categories.user_id → profiles.id**
- **notes.user_id → profiles.id**
- **notes.word_id → translated_words.id**
- **reminders.user_id → profiles.id**
- **reminders.word_id → translated_words.id**
- **translated_words.user_id → profiles.id**
- **translated_words.category_id → categories.id**

---

**Happy Coding! ✨**
