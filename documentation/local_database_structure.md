# 💾 Local Database Structure

This document describes the local (Hive) storage schema used to cache user data on the device.  
Each box mirrors key server tables but is optimized for offline access and fast lookups.

## Boxes Overview

---

### 1. 🗂️ `collections`

| Field  | Type     | Description                   |
| ------ | -------- | ----------------------------- |
| `id`   | `string` | Category UUID from the server |
| `name` | `string` | Category name                 |

> **Purpose:**  
> Stores only minimal category data (`id`, `name`) locally for quick lookup when translating or browsing collections.

---

### 2. 🕒 `lastUpdatedTimeCollections`

| Field                        | Type       | Description                    | Section     |
| ---------------------------- | ---------- | ------------------------------ | ----------- |
| `lastUpdatedTimeCollections` | `datetime` | Last update time of categories | collections |

> **Purpose:**  
> Tracks the last time each section of cached data was refreshed.

---
