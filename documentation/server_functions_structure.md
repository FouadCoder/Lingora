# Database Functions & Triggers

## create_user_defaults

**Trigger:** After insert on `profiles`
**Tables affected:**

- `user_analytics`
- `categories`

**Function purpose:** Set up default data for a new user.

**Actions:**

- Create a `user_analytics` row for the new user
- Insert default categories:

  - Learning
  - Saved
  - Masters

---

## update_stats

**Trigger:** After insert on `translate_history`
**Tables affected:**

- `user_analytics`
- `daily_translation_summary`

**Function purpose:** Update user stats when a translation is made.

**Actions:**

- Increment `xp` and `total_translations` in `user_analytics`
- Update today's `daily_translation_summary` row, or insert a new one if not found

---

## increment_library_words

**Trigger:** After insert on `library_table`
**Tables affected:**

- `user_analytics`

**Function purpose:** Increment total library words for a user.

**Actions:**

- Increment `total_library_words` by 1 in `user_analytics`

- Update `updated_at` timestamp

---

## increment_active_days

**Trigger:** After insert on `daily_translation_summary`
**Tables affected:**

- `user_analytics`

**Function purpose:** Increment active days for a user.

**Actions:**

- Increment `active_days` by 1 in `user_analytics`

- Update `updated_at` timestamp
