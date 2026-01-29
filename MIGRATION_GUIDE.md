# 🚀 Cómo Ejecutar la Migración de Base de Datos

## Opción 1: Supabase Dashboard (Recomendado)

1. Ve a tu proyecto en Supabase: https://supabase.com/dashboard
2. Navega a **SQL Editor** en el menú lateral
3. Haz clic en **New query**
4. Copia el contenido completo de `supabase-migration.sql`
5. Pégalo en el editor
6. Haz clic en **Run** o presiona `Ctrl+Enter`
7. Verifica que todo se ejecutó correctamente (debería decir "Success")

## Opción 2: Supabase CLI

```bash
# Instalar Supabase CLI (si no lo tienes)
npm install -g supabase

# Login
supabase login

# Link a tu proyecto
supabase link --project-ref your-project-ref

# Ejecutar migración
supabase db push

# O ejecutar el archivo SQL directamente
psql postgresql://postgres:[PASSWORD]@db.[PROJECT-REF].supabase.co:5432/postgres < supabase-migration.sql
```

## Opción 3: PostgreSQL Client

```bash
# Conectar a tu base de datos Supabase
psql "postgresql://postgres:[PASSWORD]@db.[PROJECT-REF].supabase.co:5432/postgres"

# Dentro de psql, ejecutar el archivo
\i supabase-migration.sql

# O desde la terminal
psql "postgresql://postgres:[PASSWORD]@db.[PROJECT-REF].supabase.co:5432/postgres" -f supabase-migration.sql
```

---

## ✅ Verificación Post-Migración

Después de ejecutar la migración, verifica que todo se creó correctamente:

### 1. Verificar Tablas

```sql
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public' 
AND table_name IN (
    'user_sessions', 
    'user_coins', 
    'coin_transactions', 
    'shop_items', 
    'shop_purchases'
)
ORDER BY table_name;
```

Deberías ver las 5 tablas nuevas.

### 2. Verificar RLS (Row Level Security)

```sql
SELECT tablename, policyname 
FROM pg_policies 
WHERE tablename IN (
    'user_sessions', 
    'user_coins', 
    'coin_transactions', 
    'shop_items', 
    'shop_purchases'
)
ORDER BY tablename, policyname;
```

Deberías ver al menos 2 políticas por tabla.

### 3. Verificar Seed Data

```sql
-- Ver productos de ejemplo en shop_items
SELECT id, name, coin_price, category, stock 
FROM shop_items 
ORDER BY display_order;
```

Deberías ver 5 productos de ejemplo.

### 4. Verificar Funciones

```sql
-- Listar funciones personalizadas
SELECT routine_name 
FROM information_schema.routines 
WHERE routine_schema = 'public' 
AND routine_name IN ('generate_qr_code', 'add_coins_to_user');
```

Deberías ver las 2 funciones helper.

---

## 🧪 Testing Básico

### Test 1: Crear wallet para un usuario

```sql
-- Asumiendo que tienes un guest con ID conocido
INSERT INTO user_coins (guest_id, balance, total_earned)
VALUES ('tu-guest-uuid-aqui', 100, 100);

-- Verificar
SELECT * FROM user_coins WHERE guest_id = 'tu-guest-uuid-aqui';
```

### Test 2: Crear una transacción

```sql
-- Usar la función helper
SELECT add_coins_to_user(
    'tu-guest-uuid-aqui',
    50,
    'Bonus de bienvenida',
    'admin_grant'::transaction_type
);

-- Verificar balance actualizado
SELECT balance, total_earned FROM user_coins WHERE guest_id = 'tu-guest-uuid-aqui';

-- Ver historial
SELECT * FROM coin_transactions WHERE guest_id = 'tu-guest-uuid-aqui' ORDER BY created_at DESC;
```

### Test 3: Generar código QR

```sql
-- Probar función de generación de QR
SELECT generate_qr_code();
```

Debería retornar un código alfanumérico de 16 caracteres (ej: "A1B2C3D4E5F6G7H8").

---

## 🐛 Troubleshooting

### Error: "relation already exists"

Si ves este error, significa que alguna tabla ya existe. Opciones:

1. **Ignorar el error** - El script usa `IF NOT EXISTS`, así que es seguro
2. **Eliminar tablas existentes** (PELIGRO: perderás datos):
   ```sql
   DROP TABLE IF EXISTS shop_purchases CASCADE;
   DROP TABLE IF EXISTS shop_items CASCADE;
   DROP TABLE IF EXISTS coin_transactions CASCADE;
   DROP TABLE IF EXISTS user_coins CASCADE;
   DROP TABLE IF EXISTS user_sessions CASCADE;
   DROP TYPE IF EXISTS transaction_type CASCADE;
   DROP TYPE IF EXISTS shop_category CASCADE;
   ```

### Error: "permission denied"

Asegúrate de estar usando el usuario `postgres` con permisos de administrador:

```sql
-- Verificar usuario actual
SELECT current_user;

-- Debería ser 'postgres' o 'service_role'
```

### Error: "function auth.uid() does not exist"

Esto puede pasar si RLS está usando `auth.uid()` pero no está en el contexto correcto. Solución:

```sql
-- Reemplazar políticas con verificación de service_role
-- Ya incluido en el script, pero si falla:
DROP POLICY IF EXISTS "Users can read own coins" ON user_coins;
CREATE POLICY "Users can read own coins"
    ON user_coins FOR SELECT
    USING (
        CASE 
            WHEN auth.jwt()->>'role' = 'service_role' THEN true
            ELSE auth.uid()::uuid = guest_id
        END
    );
```

---

## 📊 Estructura Final de la Base de Datos

Después de la migración, tu base de datos tendrá:

### Tablas Existentes (proyecto principal)
- `guests` - Invitados principales
- `passes` - Pases individuales
- `gifts` - Registro de regalos
- `gift_transactions` - Transacciones de regalos
- `configurations` - Configuraciones del sistema

### Tablas Nuevas (gamificación)
- `user_sessions` - Autenticación OTP
- `user_coins` - Wallet de monedas
- `coin_transactions` - Historial de transacciones
- `shop_items` - Productos de la tienda
- `shop_purchases` - Compras realizadas

### Funciones Helper
- `generate_qr_code()` - Genera códigos QR únicos
- `add_coins_to_user()` - Añade/resta monedas con registro

### Row Level Security
- ✅ RLS habilitado en todas las tablas
- ✅ Users solo ven sus propios datos
- ✅ Service role tiene acceso completo
- ✅ Shop items público para lectura

---

## 🎯 Próximos Pasos

1. ✅ Ejecutar migración en Supabase
2. ✅ Verificar que todo se creó correctamente
3. ✅ Ejecutar tests básicos
4. 🔄 Configurar variables de entorno en `.env`
5. 🔄 Implementar API endpoints en Next.js
6. 🔄 Crear componentes de UI
7. 🔄 Testing con usuarios reales

---

**Nota**: Esta migración es **idempotente** - puedes ejecutarla múltiples veces sin problemas gracias a `IF NOT EXISTS` y `ON CONFLICT DO NOTHING`.
