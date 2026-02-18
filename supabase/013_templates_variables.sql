-- Поля для ввода пользователя: список переменных шаблона.
-- Каждый шаблон хранит variables: [{ "key": "fullName", "label": "ФИО полностью" }, ...].
-- У пользователя в форме отображаются только эти поля.

alter table templates
  add column if not exists variables jsonb not null default '[]';

comment on column templates.variables is 'Список полей формы: [{ key, label }]. key — подстановка {{key}} в тексте, label — подпись поля.';

-- Для существующего шаблона 402-ФЗ задаём полный набор полей по умолчанию (можно отредактировать в админке)
update templates
set variables = '[
  {"key":"fullName","label":"ФИО полностью"},
  {"key":"address","label":"Адрес регистрации и фактического проживания"},
  {"key":"passportSeries","label":"Паспорт: серия"},
  {"key":"passportNumber","label":"Паспорт: номер"},
  {"key":"passportIssued","label":"Паспорт: кем и когда выдан"},
  {"key":"phone","label":"Контактный телефон"},
  {"key":"ukName","label":"Кому (название УК / ФИО директора)"},
  {"key":"ukAddress","label":"Адрес УК"},
  {"key":"period","label":"Период начислений"},
  {"key":"accountNumber","label":"Номер лицевого счёта (необязательно)"},
  {"key":"emailForReply","label":"Email для ответа"},
  {"key":"extraInfo","label":"Иная информация (необязательно)"}
]'::jsonb
where (variables is null or variables = '[]'::jsonb)
  and body_ru like '%{{fullName}}%';
