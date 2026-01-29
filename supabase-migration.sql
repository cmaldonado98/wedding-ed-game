-- ============================================================================
-- WEDDING GAMIFICATION MODULE - DATABASE MIGRATION
-- ============================================================================
-- Proyecto: Wedding Game para Esteban & Dany
-- Autor: Carlos Maldonado
-- Fecha: 2026-01-29
-- Descripción: Nuevas tablas para OTP login, wallet, shop y QR codes
-- Base de datos: Supabase (compartida con proyecto principal)
-- ============================================================================

-- Nota: Este script agrega nuevas tablas al schema existente del proyecto
-- principal (guests, passes, gifts ya existen)

BEGIN;

-- ============================================================================
-- 1. USER SESSIONS (OTP Authentication)
-- ============================================================================

CREATE TABLE IF NOT EXISTS user_sessions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    guest_id UUID REFERENCES guests(id) ON DELETE CASCADE,
    email TEXT NOT NULL,
    otp_code TEXT NOT NULL,
    otp_expires_at TIMESTAMPTZ NOT NULL,
    is_verified BOOLEAN NOT NULL DEFAULT FALSE,
    verified_at TIMESTAMPTZ,
    ip_address TEXT,
    user_agent TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Índices para user_sessions
CREATE INDEX IF NOT EXISTS idx_user_sessions_email ON user_sessions(email);
CREATE INDEX IF NOT EXISTS idx_user_sessions_otp ON user_sessions(otp_code);
CREATE INDEX IF NOT EXISTS idx_user_sessions_expires ON user_sessions(otp_expires_at);
CREATE INDEX IF NOT EXISTS idx_user_sessions_guest ON user_sessions(guest_id);

COMMENT ON TABLE user_sessions IS 'Sesiones de autenticación OTP para el módulo de gamificación';
COMMENT ON COLUMN user_sessions.otp_code IS 'Código OTP de 6 dígitos';
COMMENT ON COLUMN user_sessions.otp_expires_at IS 'Timestamp de expiración del OTP (generalmente 10 minutos)';

-- ============================================================================
-- 2. USER COINS (Wallet System)
-- ============================================================================

CREATE TABLE IF NOT EXISTS user_coins (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    guest_id UUID UNIQUE NOT NULL REFERENCES guests(id) ON DELETE CASCADE,
    balance INTEGER NOT NULL DEFAULT 0,
    total_earned INTEGER NOT NULL DEFAULT 0,
    total_spent INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    
    CONSTRAINT balance_non_negative CHECK (balance >= 0),
    CONSTRAINT totals_non_negative CHECK (total_earned >= 0 AND total_spent >= 0)
);

-- Índices para user_coins
CREATE INDEX IF NOT EXISTS idx_user_coins_guest ON user_coins(guest_id);
CREATE INDEX IF NOT EXISTS idx_user_coins_balance ON user_coins(balance);

COMMENT ON TABLE user_coins IS 'Wallet de monedas virtuales por usuario';
COMMENT ON COLUMN user_coins.balance IS 'Saldo actual de monedas';
COMMENT ON COLUMN user_coins.total_earned IS 'Total de monedas ganadas históricamente';
COMMENT ON COLUMN user_coins.total_spent IS 'Total de monedas gastadas históricamente';

-- ============================================================================
-- 3. COIN TRANSACTIONS (Transaction History)
-- ============================================================================

CREATE TYPE IF NOT EXISTS transaction_type AS ENUM ('earn', 'spend', 'admin_grant', 'admin_deduct', 'refund');

CREATE TABLE IF NOT EXISTS coin_transactions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    guest_id UUID NOT NULL REFERENCES guests(id) ON DELETE CASCADE,
    amount INTEGER NOT NULL,
    transaction_type transaction_type NOT NULL,
    description TEXT,
    reference_id UUID, -- ID de compra en shop si aplica
    metadata JSONB, -- Información adicional flexible
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Índices para coin_transactions
CREATE INDEX IF NOT EXISTS idx_coin_transactions_guest ON coin_transactions(guest_id);
CREATE INDEX IF NOT EXISTS idx_coin_transactions_type ON coin_transactions(transaction_type);
CREATE INDEX IF NOT EXISTS idx_coin_transactions_date ON coin_transactions(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_coin_transactions_reference ON coin_transactions(reference_id);

COMMENT ON TABLE coin_transactions IS 'Historial de transacciones de monedas';
COMMENT ON COLUMN coin_transactions.amount IS 'Cantidad de monedas (positivo o negativo)';
COMMENT ON COLUMN coin_transactions.reference_id IS 'UUID de referencia (ej: shop_purchase_id)';

-- ============================================================================
-- 4. SHOP ITEMS (Store Products)
-- ============================================================================

CREATE TYPE IF NOT EXISTS shop_category AS ENUM ('ticket', 'pass', 'vip', 'food', 'drink', 'experience', 'other');

CREATE TABLE IF NOT EXISTS shop_items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    description TEXT,
    image_url TEXT,
    coin_price INTEGER NOT NULL,
    category shop_category NOT NULL DEFAULT 'other',
    stock INTEGER, -- NULL = stock ilimitado
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    metadata JSONB, -- Información adicional flexible
    display_order INTEGER DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    
    CONSTRAINT price_positive CHECK (coin_price > 0),
    CONSTRAINT stock_non_negative CHECK (stock IS NULL OR stock >= 0)
);

-- Índices para shop_items
CREATE INDEX IF NOT EXISTS idx_shop_items_category ON shop_items(category);
CREATE INDEX IF NOT EXISTS idx_shop_items_active ON shop_items(is_active);
CREATE INDEX IF NOT EXISTS idx_shop_items_display_order ON shop_items(display_order);

COMMENT ON TABLE shop_items IS 'Productos disponibles en la tienda virtual';
COMMENT ON COLUMN shop_items.coin_price IS 'Precio en monedas virtuales';
COMMENT ON COLUMN shop_items.stock IS 'Stock disponible (NULL = ilimitado)';
COMMENT ON COLUMN shop_items.display_order IS 'Orden de visualización (menor = primero)';

-- ============================================================================
-- 5. SHOP PURCHASES (Purchase History)
-- ============================================================================

CREATE TABLE IF NOT EXISTS shop_purchases (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    guest_id UUID NOT NULL REFERENCES guests(id) ON DELETE CASCADE,
    shop_item_id UUID NOT NULL REFERENCES shop_items(id),
    quantity INTEGER NOT NULL DEFAULT 1,
    coins_spent INTEGER NOT NULL,
    qr_code TEXT UNIQUE NOT NULL, -- Código QR único para redención
    is_redeemed BOOLEAN NOT NULL DEFAULT FALSE,
    redeemed_at TIMESTAMPTZ,
    redeemed_by TEXT, -- Admin/staff que validó el QR
    notes TEXT, -- Notas adicionales
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    
    CONSTRAINT quantity_positive CHECK (quantity > 0),
    CONSTRAINT coins_spent_positive CHECK (coins_spent > 0)
);

-- Índices para shop_purchases
CREATE INDEX IF NOT EXISTS idx_shop_purchases_guest ON shop_purchases(guest_id);
CREATE INDEX IF NOT EXISTS idx_shop_purchases_item ON shop_purchases(shop_item_id);
CREATE INDEX IF NOT EXISTS idx_shop_purchases_qr ON shop_purchases(qr_code);
CREATE INDEX IF NOT EXISTS idx_shop_purchases_redeemed ON shop_purchases(is_redeemed);
CREATE INDEX IF NOT EXISTS idx_shop_purchases_date ON shop_purchases(created_at DESC);

COMMENT ON TABLE shop_purchases IS 'Historial de compras en la tienda';
COMMENT ON COLUMN shop_purchases.qr_code IS 'Código QR único de 16 caracteres para validación';
COMMENT ON COLUMN shop_purchases.redeemed_by IS 'Usuario admin/staff que validó el QR';

-- ============================================================================
-- 6. TRIGGERS - Auto-update timestamps
-- ============================================================================

-- Reutilizar función existente o crearla si no existe
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Triggers para user_coins
DROP TRIGGER IF EXISTS update_user_coins_updated_at ON user_coins;
CREATE TRIGGER update_user_coins_updated_at 
    BEFORE UPDATE ON user_coins
    FOR EACH ROW 
    EXECUTE FUNCTION update_updated_at_column();

-- Triggers para shop_items
DROP TRIGGER IF EXISTS update_shop_items_updated_at ON shop_items;
CREATE TRIGGER update_shop_items_updated_at 
    BEFORE UPDATE ON shop_items
    FOR EACH ROW 
    EXECUTE FUNCTION update_updated_at_column();

-- ============================================================================
-- 7. ROW LEVEL SECURITY (RLS)
-- ============================================================================

-- Enable RLS en todas las nuevas tablas
ALTER TABLE user_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_coins ENABLE ROW LEVEL SECURITY;
ALTER TABLE coin_transactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE shop_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE shop_purchases ENABLE ROW LEVEL SECURITY;

-- Policies para user_sessions
DROP POLICY IF EXISTS "Users can read own sessions" ON user_sessions;
CREATE POLICY "Users can read own sessions"
    ON user_sessions FOR SELECT
    USING (auth.uid()::uuid = guest_id);

DROP POLICY IF EXISTS "Service role can manage all sessions" ON user_sessions;
CREATE POLICY "Service role can manage all sessions"
    ON user_sessions FOR ALL
    USING (auth.jwt()->>'role' = 'service_role');

-- Policies para user_coins
DROP POLICY IF EXISTS "Users can read own coins" ON user_coins;
CREATE POLICY "Users can read own coins"
    ON user_coins FOR SELECT
    USING (auth.uid()::uuid = guest_id);

DROP POLICY IF EXISTS "Service role can manage all coins" ON user_coins;
CREATE POLICY "Service role can manage all coins"
    ON user_coins FOR ALL
    USING (auth.jwt()->>'role' = 'service_role');

-- Policies para coin_transactions
DROP POLICY IF EXISTS "Users can read own transactions" ON coin_transactions;
CREATE POLICY "Users can read own transactions"
    ON coin_transactions FOR SELECT
    USING (auth.uid()::uuid = guest_id);

DROP POLICY IF EXISTS "Service role can manage all transactions" ON coin_transactions;
CREATE POLICY "Service role can manage all transactions"
    ON coin_transactions FOR ALL
    USING (auth.jwt()->>'role' = 'service_role');

-- Policies para shop_items (público puede ver items activos)
DROP POLICY IF EXISTS "Anyone can read active shop items" ON shop_items;
CREATE POLICY "Anyone can read active shop items"
    ON shop_items FOR SELECT
    USING (is_active = true);

DROP POLICY IF EXISTS "Service role can manage shop items" ON shop_items;
CREATE POLICY "Service role can manage shop items"
    ON shop_items FOR ALL
    USING (auth.jwt()->>'role' = 'service_role');

-- Policies para shop_purchases
DROP POLICY IF EXISTS "Users can read own purchases" ON shop_purchases;
CREATE POLICY "Users can read own purchases"
    ON shop_purchases FOR SELECT
    USING (auth.uid()::uuid = guest_id);

DROP POLICY IF EXISTS "Service role can manage all purchases" ON shop_purchases;
CREATE POLICY "Service role can manage all purchases"
    ON shop_purchases FOR ALL
    USING (auth.jwt()->>'role' = 'service_role');

-- ============================================================================
-- 8. HELPER FUNCTIONS
-- ============================================================================

-- Función para generar código QR único
CREATE OR REPLACE FUNCTION generate_qr_code()
RETURNS TEXT AS $$
BEGIN
    RETURN upper(substring(md5(random()::text || clock_timestamp()::text) from 1 for 16));
END;
$$ LANGUAGE plpgsql;

-- Función para añadir monedas a un usuario
CREATE OR REPLACE FUNCTION add_coins_to_user(
    p_guest_id UUID,
    p_amount INTEGER,
    p_description TEXT,
    p_transaction_type transaction_type DEFAULT 'earn'
)
RETURNS void AS $$
BEGIN
    -- Insertar o actualizar user_coins
    INSERT INTO user_coins (guest_id, balance, total_earned, total_spent)
    VALUES (
        p_guest_id,
        CASE WHEN p_amount > 0 THEN p_amount ELSE 0 END,
        CASE WHEN p_amount > 0 THEN p_amount ELSE 0 END,
        CASE WHEN p_amount < 0 THEN ABS(p_amount) ELSE 0 END
    )
    ON CONFLICT (guest_id) DO UPDATE SET
        balance = user_coins.balance + p_amount,
        total_earned = CASE 
            WHEN p_amount > 0 THEN user_coins.total_earned + p_amount 
            ELSE user_coins.total_earned 
        END,
        total_spent = CASE 
            WHEN p_amount < 0 THEN user_coins.total_spent + ABS(p_amount) 
            ELSE user_coins.total_spent 
        END,
        updated_at = NOW();
    
    -- Registrar transacción
    INSERT INTO coin_transactions (guest_id, amount, transaction_type, description)
    VALUES (p_guest_id, p_amount, p_transaction_type, p_description);
END;
$$ LANGUAGE plpgsql;

-- ============================================================================
-- 9. SEED DATA (opcional para testing)
-- ============================================================================

-- Insertar productos de ejemplo en shop
INSERT INTO shop_items (name, description, coin_price, category, stock, display_order, image_url) VALUES
    ('Ticket VIP Barra Libre', 'Acceso ilimitado a la barra premium durante toda la noche', 500, 'vip', 20, 1, 'https://images.unsplash.com/photo-1514362545857-3bc16c4c7d1b'),
    ('Pass Photo Booth', 'Sesión de 10 fotos en el photo booth con props premium', 150, 'pass', 50, 2, 'https://images.unsplash.com/photo-1511285560929-80b456fea0bc'),
    ('Cocktail Signature', 'Cocktail especial creado para los novios', 100, 'drink', NULL, 3, 'https://images.unsplash.com/photo-1536935338788-846bb9981813'),
    ('Entrada Sorteo Luna de Miel', 'Participa en el sorteo de 1 noche gratis en el hotel', 200, 'ticket', 100, 4, 'https://images.unsplash.com/photo-1520250497591-112f2f40a3f4'),
    ('Pass Fast Track', 'Entrada prioritaria a cualquier actividad o juego', 75, 'pass', NULL, 5, 'https://images.unsplash.com/photo-1492684223066-81342ee5ff30')
ON CONFLICT DO NOTHING;

COMMIT;

-- ============================================================================
-- VERIFICACIÓN POST-MIGRACIÓN
-- ============================================================================

-- Ejecutar estos comandos después de la migración para verificar:

-- Ver todas las tablas nuevas
-- SELECT table_name FROM information_schema.tables 
-- WHERE table_schema = 'public' 
-- AND table_name IN ('user_sessions', 'user_coins', 'coin_transactions', 'shop_items', 'shop_purchases');

-- Ver políticas RLS
-- SELECT schemaname, tablename, policyname, permissive, roles, cmd, qual 
-- FROM pg_policies 
-- WHERE tablename IN ('user_sessions', 'user_coins', 'coin_transactions', 'shop_items', 'shop_purchases');

-- Contar registros en shop_items
-- SELECT COUNT(*) as total_items FROM shop_items;
