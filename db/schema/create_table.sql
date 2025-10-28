-- EXTENSÕES (necessário no Supabase para gen_random_uuid)
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- =======================================
-- TABELA: access_keys
-- =======================================
CREATE TABLE IF NOT EXISTS access_keys (
    id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    key_code text UNIQUE NOT NULL,              
    description text,                           
    is_active boolean DEFAULT true,             
    used_by uuid REFERENCES auth.users(id),     
    id_telegram_user bigint,                    
    used_at timestamptz,                        
    expires_at timestamptz,                     
    created_at timestamptz DEFAULT now()
);

ALTER TABLE access_keys ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Admin can manage access keys"
ON access_keys
FOR ALL
USING (auth.uid() IN (SELECT id FROM public.admins));

-- =======================================
-- TABELA: profiles
-- =======================================
CREATE TABLE IF NOT EXISTS profiles(
    id uuid PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    id_telegram_user bigint UNIQUE NOT NULL,    
    full_name text,                             
    timezone text DEFAULT 'America/Sao_Paulo',  
    created_at timestamptz DEFAULT now(),
    updated_at timestamptz DEFAULT now()
);

ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can manage own profiles"
ON profiles
FOR ALL
USING (id = auth.uid())
WITH CHECK (id = auth.uid());

CREATE INDEX idx_profiles_created_at ON profiles (created_at);

-- =======================================
-- TABELA: accounts
-- =======================================
CREATE TABLE IF NOT EXISTS accounts (
    id bigserial PRIMARY KEY,
    user_id uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    name text NOT NULL,                             
    currency varchar(3) NOT NULL DEFAULT 'BRL',     
    balance numeric(14,2) NOT NULL DEFAULT 0,       
    created_at timestamptz DEFAULT now(),
    updated_at timestamptz DEFAULT now(),
    UNIQUE (user_id, name)
);

ALTER TABLE accounts ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can manage own accounts"
ON accounts
FOR ALL
USING (user_id = auth.uid())
WITH CHECK (user_id = auth.uid());

CREATE INDEX idx_accounts_user_id ON accounts (user_id);

-- =======================================
-- TABELA: categories
-- =======================================
CREATE TABLE IF NOT EXISTS categories (
    id smallserial PRIMARY KEY,
    name text NOT NULL,
    is_fixed boolean DEFAULT false,
    created_at timestamptz DEFAULT now()
);

-- =======================================
-- TABELA: subcategories
-- =======================================
CREATE TABLE IF NOT EXISTS subcategories (
    id smallserial PRIMARY KEY,
    category_id smallint REFERENCES categories(id) ON DELETE CASCADE,
    name text NOT NULL,
    name2 varchar(20) not null,
    created_at timestamptz DEFAULT now(),
    UNIQUE(category_id, name)
);

-- =======================================
-- TABELA: transactions
-- =======================================
CREATE TABLE IF NOT EXISTS transactions (
    id bigserial PRIMARY KEY,
    user_id uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    account_id bigint NOT NULL REFERENCES accounts(id) ON DELETE CASCADE,
    type varchar(10) NOT NULL CHECK (type IN ('debit', 'credit')),
    amount numeric(14,2) NOT NULL CHECK (amount > 0),
    category_id smallint REFERENCES categories(id),
    subcategory_id smallint REFERENCES subcategories(id), -- corrigido nome
    description text,
    reference_date date NOT NULL,
    posted_at timestamptz DEFAULT now(),
    origin varchar(30) DEFAULT 'telegram',
    status varchar(15) DEFAULT 'confirmed',
    created_at timestamptz DEFAULT now()
);

ALTER TABLE transactions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can manage own transactions"
ON transactions
FOR ALL
USING (user_id = auth.uid())
WITH CHECK (user_id = auth.uid());

CREATE INDEX idx_transactions_user_account_refdate 
ON transactions (user_id, account_id, reference_date);

CREATE INDEX idx_transactions_account_posted_at 
ON transactions (account_id, posted_at);

-- =======================================
-- TABELA: recurring_transactions
-- =======================================
CREATE TABLE IF NOT EXISTS recurring_transactions (
    id bigserial PRIMARY KEY,
    user_id uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    account_id bigint REFERENCES accounts(id),
    name text NOT NULL,
    amount numeric(14,2) NOT NULL CHECK (amount > 0),
    frequency varchar(15) NOT NULL CHECK (frequency IN ('daily', 'weekly', 'monthly', 'yearly')),
    next_due date,
    is_active boolean DEFAULT true,
    created_at timestamptz DEFAULT now()
);

ALTER TABLE recurring_transactions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can manage own recurring transactions"
ON recurring_transactions
FOR ALL
USING (user_id = auth.uid())
WITH CHECK (user_id = auth.uid());

-- =======================================
-- TABELA: telegram_sessions
-- =======================================
CREATE TABLE IF NOT EXISTS telegram_sessions (
    id bigserial PRIMARY KEY,
    id_telegram_user bigint UNIQUE NOT NULL,    
    user_chat_id bigint NOT NULL,               
    user_id uuid REFERENCES profiles(id) ON DELETE CASCADE,
    state jsonb NOT NULL,                       
    updated_at timestamptz DEFAULT now()
);

