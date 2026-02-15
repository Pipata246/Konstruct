-- Платёжные намерения: заказ создаётся только после успешной оплаты (webhook payment.succeeded)
create table if not exists payment_intents (
  id uuid default gen_random_uuid() primary key,
  user_id uuid not null references users(id) on delete cascade,
  order_data jsonb not null default '{}',
  with_expert boolean not null default false,
  amount_kop integer not null,
  yookassa_payment_id text,
  status text not null default 'pending',
  created_at timestamptz default now()
);

create index if not exists payment_intents_user_id_idx on payment_intents(user_id);
create index if not exists payment_intents_yookassa_id_idx on payment_intents(yookassa_payment_id);
create index if not exists payment_intents_status_idx on payment_intents(status);

alter table payment_intents enable row level security;

create policy "Allow all for now" on payment_intents
  for all using (true) with check (true);
