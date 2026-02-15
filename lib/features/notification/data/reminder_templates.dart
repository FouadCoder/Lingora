// data/reminder_templates.dart

const Map<String, List<String>> reminderTitles = {
  'ar': [
    'هل تتذكر معنى {word}؟',
    'تذكير: ماذا يعني {word}؟',
    'تحدي سريع: {word} ما معناها؟',
    'مراجعة سريعة: ما معنى {word}؟',
    'تذكير صغير: {word} يعني؟'
  ],
  'en': [
    'Do you remember what {word} means?',
    'Quick reminder: {word} means...',
    'Time to recall: {word}',
    'Pop quiz: what does {word} mean?',
    'Reminder: do you know {word}?'
  ],
  'ru': [
    'Помнишь, что значит {word}?',
    'Напоминание: значение слова {word}',
    'Быстрый тест: что значит {word}?',
    'Проверка: значение слова {word}',
    'Напоминание: знаешь ли ты {word}?'
  ]
};

const Map<String, List<String>> reminderMessages = {
  'ar': [
    '{word} يعني {meaning}. مثال: {example}',
    'المعنى: {meaning}. مرادفات: {synonyms}',
    'استخدام {word} في جملة: {example}',
    '{word} = {meaning}. يمكن أن تقول أيضًا: {synonyms}',
    'تذكير: {word} يعني {meaning}'
  ],
  'en': [
    '{word} means {meaning}. Example: {example}',
    'Meaning: {meaning}. Synonyms: {synonyms}',
    'Here’s how you use {word}: {example}',
    '{word} = {meaning}. You can also say: {synonyms}',
    'Reminder: {word} means {meaning}'
  ],
  'ru': [
    '{word} означает {meaning}. Пример: {example}',
    'Значение: {meaning}. Синонимы: {synonyms}',
    'Использование {word} в предложении: {example}',
    '{word} = {meaning}. Можно также сказать: {synonyms}',
    'Напоминание: {word} означает {meaning}'
  ]
};
