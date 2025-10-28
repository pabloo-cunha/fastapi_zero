-- ===============================
-- 1. Categorias e subcategorias
-- ===============================

-- Categorias
INSERT INTO categories (name, is_fixed) VALUES
('Gastos Fixos', true),
('Investimentos', false),
('Lazer', false),
('Urgência', false),
('Gastos Variáveis', false);

-- Subcategorias
-- Gastos Fixos
INSERT INTO subcategories (category_id, name, name2)
SELECT id, 'Pagamento de Aluguel', 'Aluguel' FROM categories WHERE name='Gastos Fixos';
INSERT INTO subcategories (category_id, name, name2)
SELECT id, 'Pagamento de Empréstimo', 'Empréstimo' FROM categories WHERE name='Gastos Fixos';
INSERT INTO subcategories (category_id, name, name2)
SELECT id, 'Condomínio', 'Condomínio' FROM categories WHERE name='Gastos Fixos';
INSERT INTO subcategories (category_id, name, name2)
SELECT id, 'Contas de Serviços', 'Serviços' FROM categories WHERE name='Gastos Fixos';

-- Investimentos
INSERT INTO subcategories (category_id, name, name2)
SELECT id, 'Renda Fixa', 'Renda Fixa' FROM categories WHERE name='Investimentos';
INSERT INTO subcategories (category_id, name, name2)
SELECT id, 'Ações', 'Ações' FROM categories WHERE name='Investimentos';
INSERT INTO subcategories (category_id, name, name2)
SELECT id, 'Criptomoedas', 'Criptomoedas' FROM categories WHERE name='Investimentos';

-- Lazer
INSERT INTO subcategories (category_id, name, name2)
SELECT id, 'Cinema', 'Cinema' FROM categories WHERE name='Lazer';
INSERT INTO subcategories (category_id, name, name2)
SELECT id, 'Restaurante', 'Restaurante' FROM categories WHERE name='Lazer';
INSERT INTO subcategories (category_id, name, name2)
SELECT id, 'Viagem', 'Viagem' FROM categories WHERE name='Lazer';
INSERT INTO subcategories (category_id, name, name2)
SELECT id, 'Delivery', 'Delivery' FROM categories WHERE name='Lazer';

-- Urgência
INSERT INTO subcategories (category_id, name, name2)
SELECT id, 'Saúde', 'Saúde' FROM categories WHERE name='Urgência';
INSERT INTO subcategories (category_id, name, name2)
SELECT id, 'Reparo Casa', 'Reparo' FROM categories WHERE name='Urgência';
INSERT INTO subcategories (category_id, name, name2)
SELECT id, 'Reparo Veículo', 'Reparo' FROM categories WHERE name='Urgência';

-- Gastos Variáveis
INSERT INTO subcategories (category_id, name, name2)
SELECT id, 'Supermercado', 'Supermercado' FROM categories WHERE name='Gastos Variáveis';
INSERT INTO subcategories (category_id, name, name2)
SELECT id, 'Transporte', 'Transporte' FROM categories WHERE name='Gastos Variáveis';
INSERT INTO subcategories (category_id, name, name2)
SELECT id, 'Compras Diversas', 'Compras Diversas' FROM categories WHERE name='Gastos Variáveis';
INSERT INTO subcategories (category_id, name, name2)
SELECT id, 'Cartão de Crédito', 'Cartão de Crédito' FROM categories WHERE name='Gastos Variáveis';


-- ===============================
-- 2. Chave de acesso de teste
-- ===============================
INSERT INTO access_keys (key_code, description, expires_at)
VALUES ('TESTE1234', 'Chave inicial para teste do bot', now() + interval '30 days');

-- ===============================
-- 3. Usuário admin
-- ===============================
-- Para criar um admin, primeiro crie o usuário no Supabase Auth.
-- Depois insira o UUID dele nesta tabela (exemplo com UUID fictício):

INSERT INTO public.admins (id)
VALUES ('11111111-2222-3333-4444-555555555555');  -- substitua pelo UUID real do usuário Auth
