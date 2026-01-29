# 🎮 Wedding Gamification Module - Instrucciones Completas

## 📋 RESUMEN DEL PROYECTO

**Nombre**: Wedding Game - Sistema de Gamificación para Boda Esteban & Dany  
**Objetivo**: Módulo independiente con OTP login, wallet de monedas, tienda virtual y códigos QR  
**Usuarios**: ~75 invitados  
**Infraestructura**: AWS EC2 t4g.nano + Docker + GitHub Actions  
**Costo**: $0.03-$0.73 para el día de la boda  
**Base de Datos**: Supabase compartida con proyecto principal

---

## 🎨 DISEÑO Y ESTILO

### Paleta de Colores (heredada del proyecto principal)

```css
/* Colores principales de la boda */
--wedding-rose: #f5cbcc;
--wedding-lavender: #d1c1d9;
--wedding-purple: #9579B4;
--wedding-beige: #F1DBD0;
--wedding-sage: #ADB697;
--wedding-forest: #4D5D53;
--wedding-primary: #C6754D;

/* Colores neutros */
--neutral-bg: #FCF9F7;
--neutral-text: #2B1105;

/* Colores de superficie */
--background-light: #F9F7F2;
--surface-light: #FFFFFF;
--text-main-light: #1C1C1E;
--text-muted-light: #8E8E93;

/* Acentos */
--accent-lavender: #E6E6FA;
--highlight-lavender: #d3c3db;
--lavender-border: #D3CDE6;
--cream-bg: #fbf8f0;
```

### Fuentes

```typescript
// Google Fonts principales
import { Inter, Playfair_Display, Noto_Serif, Noto_Sans } from 'next/font/google'

// También usar Montaga para títulos
@import url('https://fonts.googleapis.com/css2?family=Montaga&display=swap');

// Configuración
const inter = Inter({ subsets: ['latin'], variable: '--font-inter' })
const playfair = Playfair_Display({ subsets: ['latin'], variable: '--font-playfair' })
const notoSerif = Noto_Serif({ subsets: ['latin'], variable: '--font-noto-serif' })
const notoSans = Noto_Sans({ subsets: ['latin'], variable: '--font-noto-sans' })
```

### Tailwind Config (wedding-ed-game)

```typescript
// tailwind.config.ts
import type { Config } from 'tailwindcss'

const config: Config = {
  content: [
    './pages/**/*.{js,ts,jsx,tsx,mdx}',
    './components/**/*.{js,ts,jsx,tsx,mdx}',
    './app/**/*.{js,ts,jsx,tsx,mdx}',
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ['var(--font-inter)'],
        serif: ['var(--font-playfair)'],
        montaga: ['Montaga', 'serif'],
        display: ["Noto Serif", "var(--font-noto-serif)", "Playfair Display", "serif"],
        body: ["Noto Sans", "var(--font-noto-sans)", "Lato", "sans-serif"],
      },
      colors: {
        wedding: {
          primary: '#C6754D',
          rose: '#f5cbcc',
          lavender: '#d1c1d9',
          purple: '#9579B4',
          beige: '#F1DBD0',
          sage: '#ADB697',
          forest: '#4D5D53',
        },
        'neutral-bg': '#FCF9F7',
        'neutral-text': '#2B1105',
        'lavender-border': '#D3CDE6',
        'cream-bg': '#fbf8f0',
        'accent-lavender': '#E6E6FA',
        'highlight-lavender': '#d3c3db',
      },
    },
  },
  plugins: [],
}
export default config
```

### globals.css (wedding-ed-game)

```css
@import url('https://fonts.googleapis.com/css2?family=Montaga&display=swap');
@import url('https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,600;0,700;1,400&family=Lato:wght@300;400;700&display=swap');

@tailwind base;
@tailwind components;
@tailwind utilities;

:root {
  --font-inter: 'Inter', sans-serif;
  --font-playfair: 'Playfair Display', serif;
  --font-montaga: 'Montaga', serif;
  
  /* Wedding Color Palette */
  --wedding-rose: #f5cbcc;
  --wedding-lavender: #d1c1d9;
  --wedding-purple: #9579B4;
  --wedding-beige: #F1DBD0;
  --wedding-sage: #ADB697;
  --wedding-forest: #4D5D53;
  --wedding-primary: #C6754D;
  
  /* Neutral Colors */
  --neutral-bg: #FCF9F7;
  --neutral-text: #2B1105;
}

@layer base {
  body {
    @apply bg-neutral-bg text-neutral-text antialiased;
  }
  
  h1, h2, h3, h4, h5, h6 {
    @apply font-montaga;
  }
  
  p {
    @apply font-body;
  }
}

@layer utilities {
  .text-balance {
    text-wrap: balance;
  }
}
```

---

## 🗄️ ESTRUCTURA DE BASE DE DATOS SUPABASE

### Tablas Existentes (del proyecto principal)

```sql
-- Guests: Invitados principales
CREATE TABLE guests (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    email TEXT,
    phone TEXT,
    access_token TEXT UNIQUE NOT NULL,
    notified_whatsapp BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Passes: Pases individuales por invitado
CREATE TABLE passes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    guest_id UUID REFERENCES guests(id) ON DELETE CASCADE,
    attendee_name TEXT NOT NULL,
    confirmation_status TEXT DEFAULT 'pending', -- 'pending', 'confirmed', 'declined'
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Gifts: Registro de regalos
CREATE TABLE gifts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    description TEXT,
    image_url TEXT,
    price NUMERIC(10,2),
    category TEXT,
    is_purchased BOOLEAN DEFAULT FALSE,
    purchased_by UUID REFERENCES guests(id),
    purchased_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT NOW()
);
```

### Nuevas Tablas (para el módulo de gamificación)

```sql
-- User Sessions: Sesiones OTP
CREATE TABLE user_sessions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    guest_id UUID REFERENCES guests(id) ON DELETE CASCADE,
    email TEXT NOT NULL,
    otp_code TEXT NOT NULL,
    otp_expires_at TIMESTAMPTZ NOT NULL,
    is_verified BOOLEAN DEFAULT FALSE,
    verified_at TIMESTAMPTZ,
    ip_address TEXT,
    user_agent TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_user_sessions_email ON user_sessions(email);
CREATE INDEX idx_user_sessions_otp ON user_sessions(otp_code);
CREATE INDEX idx_user_sessions_expires ON user_sessions(otp_expires_at);

-- User Coins: Wallet de monedas
CREATE TABLE user_coins (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    guest_id UUID UNIQUE REFERENCES guests(id) ON DELETE CASCADE,
    balance INTEGER NOT NULL DEFAULT 0,
    total_earned INTEGER NOT NULL DEFAULT 0,
    total_spent INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_user_coins_guest ON user_coins(guest_id);

-- Coin Transactions: Historial de transacciones
CREATE TABLE coin_transactions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    guest_id UUID REFERENCES guests(id) ON DELETE CASCADE,
    amount INTEGER NOT NULL,
    transaction_type TEXT NOT NULL, -- 'earn', 'spend', 'admin_grant'
    description TEXT,
    reference_id UUID, -- ID de compra en shop si aplica
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_coin_transactions_guest ON coin_transactions(guest_id);
CREATE INDEX idx_coin_transactions_type ON coin_transactions(transaction_type);

-- Shop Items: Artículos de la tienda
CREATE TABLE shop_items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    description TEXT,
    image_url TEXT,
    coin_price INTEGER NOT NULL,
    category TEXT, -- 'ticket', 'pass', 'vip', 'other'
    stock INTEGER, -- NULL = ilimitado
    is_active BOOLEAN DEFAULT TRUE,
    metadata JSONB, -- info adicional flexible
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_shop_items_category ON shop_items(category);
CREATE INDEX idx_shop_items_active ON shop_items(is_active);

-- Shop Purchases: Compras realizadas
CREATE TABLE shop_purchases (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    guest_id UUID REFERENCES guests(id) ON DELETE CASCADE,
    shop_item_id UUID REFERENCES shop_items(id),
    quantity INTEGER NOT NULL DEFAULT 1,
    coins_spent INTEGER NOT NULL,
    qr_code TEXT UNIQUE, -- Código QR único para redención
    is_redeemed BOOLEAN DEFAULT FALSE,
    redeemed_at TIMESTAMPTZ,
    redeemed_by TEXT, -- Admin/staff que validó
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_shop_purchases_guest ON shop_purchases(guest_id);
CREATE INDEX idx_shop_purchases_qr ON shop_purchases(qr_code);
CREATE INDEX idx_shop_purchases_redeemed ON shop_purchases(is_redeemed);

-- Triggers para actualizar updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_user_coins_updated_at 
    BEFORE UPDATE ON user_coins
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_shop_items_updated_at 
    BEFORE UPDATE ON shop_items
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
```

### Row Level Security (RLS)

```sql
-- Enable RLS
ALTER TABLE user_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_coins ENABLE ROW LEVEL SECURITY;
ALTER TABLE coin_transactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE shop_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE shop_purchases ENABLE ROW LEVEL SECURITY;

-- Policies: Users can only see their own data
CREATE POLICY "Users can read own sessions"
    ON user_sessions FOR SELECT
    USING (guest_id = auth.uid()::uuid);

CREATE POLICY "Users can read own coins"
    ON user_coins FOR SELECT
    USING (guest_id = auth.uid()::uuid);

CREATE POLICY "Users can read own transactions"
    ON coin_transactions FOR SELECT
    USING (guest_id = auth.uid()::uuid);

-- Shop items: public read
CREATE POLICY "Anyone can read active shop items"
    ON shop_items FOR SELECT
    USING (is_active = true);

-- Shop purchases: users can read own purchases
CREATE POLICY "Users can read own purchases"
    ON shop_purchases FOR SELECT
    USING (guest_id = auth.uid()::uuid);
```

---

## 🏗️ ESTRUCTURA DEL PROYECTO

```
wedding-ed-game/
├── app/                          # Next.js 16 App Router
│   ├── layout.tsx               # Layout principal con fuentes
│   ├── page.tsx                 # Landing page
│   ├── globals.css              # Estilos globales con paleta
│   ├── login/
│   │   └── page.tsx            # Login con OTP
│   ├── dashboard/
│   │   ├── page.tsx            # Dashboard principal
│   │   └── layout.tsx          # Layout autenticado
│   ├── wallet/
│   │   └── page.tsx            # Wallet de monedas
│   ├── shop/
│   │   ├── page.tsx            # Tienda
│   │   └── [id]/
│   │       └── page.tsx        # Detalle de producto
│   ├── purchases/
│   │   └── page.tsx            # Mis compras
│   ├── qr/
│   │   └── [code]/
│   │       └── page.tsx        # Ver QR individual
│   └── api/
│       ├── auth/
│       │   ├── send-otp/
│       │   │   └── route.ts   # Enviar código OTP
│       │   ├── verify-otp/
│       │   │   └── route.ts   # Verificar OTP
│       │   └── logout/
│       │       └── route.ts   # Cerrar sesión
│       ├── wallet/
│       │   ├── balance/
│       │   │   └── route.ts   # Ver saldo
│       │   └── transactions/
│       │       └── route.ts   # Historial
│       ├── shop/
│       │   ├── items/
│       │   │   └── route.ts   # Listar productos
│       │   └── purchase/
│       │       └── route.ts   # Comprar producto
│       └── qr/
│           ├── generate/
│           │   └── route.ts   # Generar QR
│           └── validate/
│               └── route.ts   # Validar QR
├── components/                   # Componentes reutilizables
│   ├── OTPInput.tsx
│   ├── WalletCard.tsx
│   ├── CoinBalance.tsx
│   ├── ShopItemCard.tsx
│   ├── PurchaseCard.tsx
│   ├── QRCodeDisplay.tsx
│   └── LoadingSpinner.tsx
├── lib/
│   ├── supabase/
│   │   ├── client.ts           # Cliente Supabase
│   │   └── server.ts           # Server actions
│   ├── auth.ts                  # Helpers de autenticación
│   ├── ses.ts                   # Amazon SES para OTP emails
│   └── qr.ts                    # Generación de QR codes
├── types/
│   └── database.types.ts        # Types de Supabase
├── middleware.ts                # Auth middleware
├── .env.example
├── .env
├── package.json
├── next.config.js
├── tailwind.config.ts
├── tsconfig.json
├── Dockerfile                   # Para deployment
├── docker-compose.yml
├── .github/
│   └── workflows/
│       └── deploy.yml          # CI/CD GitHub Actions
└── README.md
```

---

## 🔐 VARIABLES DE ENTORNO

### .env.example

```bash
# Supabase (compartido con proyecto principal)
NEXT_PUBLIC_SUPABASE_URL=https://your-project.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=your_anon_key
SUPABASE_SERVICE_ROLE_KEY=your_service_role_key

# AWS SES para OTP emails
AWS_REGION=us-east-1
AWS_SES_FROM_EMAIL=noreply@yourdomain.com
AWS_ACCESS_KEY_ID=your_aws_access_key
AWS_SECRET_ACCESS_KEY=your_aws_secret_key

# JWT para sesiones
JWT_SECRET=generate_with_openssl_rand_base64_32

# App Configuration
NEXT_PUBLIC_APP_URL=http://54.208.89.87
NODE_ENV=production

# Feature Flags
NEXT_PUBLIC_WALLET_ENABLED=true
NEXT_PUBLIC_SHOP_ENABLED=true
NEXT_PUBLIC_QR_ENABLED=true
NEXT_PUBLIC_COINS_PER_LOGIN=10
NEXT_PUBLIC_COINS_PER_REFERRAL=50
```

---

## 🚀 CI/CD CON GITHUB ACTIONS

### .github/workflows/deploy.yml

```yaml
name: Deploy to EC2

on:
  push:
    branches:
      - main
  workflow_dispatch:

env:
  EC2_HOST: 54.208.89.87
  EC2_USER: ubuntu
  APP_DIR: /home/ubuntu/wedding-game

jobs:
  deploy:
    name: Deploy to Production
    runs-on: ubuntu-latest
    
    steps:
      - name: Checkout Code
        uses: actions/checkout@v4
        
      - name: Setup SSH Key
        run: |
          mkdir -p ~/.ssh
          echo "${{ secrets.EC2_SSH_KEY }}" > ~/.ssh/id_rsa
          chmod 600 ~/.ssh/id_rsa
          ssh-keyscan -H ${{ env.EC2_HOST }} >> ~/.ssh/known_hosts
          
      - name: Create .env file
        run: |
          cat > .env << EOF
          NEXT_PUBLIC_SUPABASE_URL=${{ secrets.SUPABASE_URL }}
          NEXT_PUBLIC_SUPABASE_ANON_KEY=${{ secrets.SUPABASE_ANON_KEY }}
          SUPABASE_SERVICE_ROLE_KEY=${{ secrets.SUPABASE_SERVICE_ROLE_KEY }}
          JWT_SECRET=${{ secrets.JWT_SECRET }}
          AWS_REGION=${{ secrets.AWS_REGION }}
          AWS_SES_FROM_EMAIL=${{ secrets.AWS_SES_FROM_EMAIL }}
          AWS_ACCESS_KEY_ID=${{ secrets.AWS_ACCESS_KEY_ID }}
          AWS_SECRET_ACCESS_KEY=${{ secrets.AWS_SECRET_ACCESS_KEY }}
          NEXT_PUBLIC_APP_URL=http://${{ env.EC2_HOST }}
          NODE_ENV=production
          NEXT_PUBLIC_WALLET_ENABLED=true
          NEXT_PUBLIC_SHOP_ENABLED=true
          NEXT_PUBLIC_QR_ENABLED=true
          EOF
          
      - name: Deploy to EC2
        run: |
          # Copy files to EC2
          scp -r -o StrictHostKeyChecking=no ./* ${{ env.EC2_USER }}@${{ env.EC2_HOST }}:${{ env.APP_DIR }}/
          
          # Execute deployment commands on EC2
          ssh -o StrictHostKeyChecking=no ${{ env.EC2_USER }}@${{ env.EC2_HOST }} << 'ENDSSH'
            cd ${{ env.APP_DIR }}
            
            # Pull latest changes (if git repo)
            if [ -d .git ]; then
              git pull origin main
            fi
            
            # Stop existing containers
            docker-compose down
            
            # Build new image
            docker-compose build --no-cache
            
            # Start containers
            docker-compose up -d
            
            # Wait for health check
            sleep 30
            
            # Cleanup old images
            docker system prune -af
            
            echo "✅ Deployment complete!"
          ENDSSH
          
      - name: Health Check
        run: |
          MAX_ATTEMPTS=10
          ATTEMPT=0
          
          while [ $ATTEMPT -lt $MAX_ATTEMPTS ]; do
            if curl -f http://${{ env.EC2_HOST }}; then
              echo "✅ Health check passed!"
              exit 0
            fi
            
            ATTEMPT=$((ATTEMPT+1))
            echo "Attempt $ATTEMPT/$MAX_ATTEMPTS failed, retrying in 10s..."
            sleep 10
          done
          
          echo "❌ Health check failed after $MAX_ATTEMPTS attempts"
          exit 1
          
      - name: Notify Success
        if: success()
        run: |
          echo "🎉 Deployment successful!"
          echo "App URL: http://${{ env.EC2_HOST }}"
          
      - name: Notify Failure
        if: failure()
        run: |
          echo "❌ Deployment failed!"
          echo "Check logs: ssh ${{ env.EC2_USER }}@${{ env.EC2_HOST }} 'docker logs wedding-game'"
```

### GitHub Secrets Requeridos

Configurar en: https://github.com/cmaldonado98/wedding-ed-game/settings/secrets/actions

```
EC2_SSH_KEY              = [contenido de wedding-game-key.pem]
SUPABASE_URL             = https://your-project.supabase.co
SUPABASE_ANON_KEY        = eyJhbGc...
SUPABASE_SERVICE_ROLE_KEY = eyJhbGc...
JWT_SECRET               = [generar: openssl rand -base64 32]
AWS_REGION               = us-east-1
AWS_SES_FROM_EMAIL       = noreply@yourdomain.com
AWS_ACCESS_KEY_ID        = AKIA...
AWS_SECRET_ACCESS_KEY    = wJalr...
```

---

## 📦 DOCKER CONFIGURATION

### Dockerfile

```dockerfile
FROM node:20-alpine AS base

# Dependencies
FROM base AS deps
RUN apk add --no-cache libc6-compat
WORKDIR /app

COPY package.json package-lock.json* ./
RUN npm ci

# Builder
FROM base AS builder
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .

ENV NEXT_TELEMETRY_DISABLED=1

RUN npm run build

# Runner
FROM base AS runner
WORKDIR /app

ENV NODE_ENV=production
ENV NEXT_TELEMETRY_DISABLED=1

RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nextjs

COPY --from=builder /app/public ./public

RUN mkdir .next
RUN chown nextjs:nodejs .next

COPY --from=builder --chown=nextjs:nodejs /app/.next/standalone ./
COPY --from=builder --chown=nextjs:nodejs /app/.next/static ./.next/static

USER nextjs

EXPOSE 3000

ENV PORT=3000
ENV HOSTNAME="0.0.0.0"

CMD ["node", "server.js"]
```

### docker-compose.yml

```yaml
version: '3.8'

services:
  app:
    build:
      context: .
      dockerfile: Dockerfile
    container_name: wedding-game
    restart: unless-stopped
    ports:
      - "3000:3000"
    env_file:
      - .env
    environment:
      - NODE_ENV=production
    healthcheck:
      test: ["CMD", "wget", "--quiet", "--tries=1", "--spider", "http://localhost:3000"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 40s
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
        max-file: "3"
```

---

## 🛠️ COMANDOS DE DESARROLLO

### Setup Inicial

```bash
# Clonar repo
git clone https://github.com/cmaldonado98/wedding-ed-game.git
cd wedding-ed-game

# Instalar dependencias
npm install

# Configurar .env
cp .env.example .env
# Editar .env con tus valores

# Generar types de Supabase (opcional)
npx supabase gen types typescript --project-id your-project-id > types/database.types.ts

# Desarrollo local
npm run dev
# Abrir http://localhost:3000
```

### Comandos Útiles

```bash
# Build para producción
npm run build

# Iniciar producción local
npm start

# Linting
npm run lint

# Type checking
npx tsc --noEmit

# Build Docker local
docker-compose build
docker-compose up

# Ver logs Docker
docker logs wedding-game -f

# Restart app
docker-compose restart
```

---

## 🚀 DEPLOYMENT

### Deploy Manual (primera vez)

```bash
# 1. SSH al servidor
ssh -i wedding-game-key.pem ubuntu@54.208.89.87

# 2. Clonar repo en /home/ubuntu/wedding-game
cd /home/ubuntu
git clone https://github.com/cmaldonado98/wedding-ed-game.git wedding-game
cd wedding-game

# 3. Crear .env con valores reales
nano .env

# 4. Build y start
docker-compose build
docker-compose up -d

# 5. Verificar
docker logs wedding-game -f
curl http://localhost:3000
```

### Deploy Automático (GitHub Actions)

```bash
# Simplemente push a main
git add .
git commit -m "feat: Add new feature"
git push origin main

# GitHub Actions se encarga del resto
```

### Verificar Deployment

```bash
# Desde tu máquina
curl -I http://54.208.89.87

# SSH y ver logs
ssh -i wedding-game-key.pem ubuntu@54.208.89.87 'docker logs wedding-game --tail 50'

# Ver estado del container
ssh -i wedding-game-key.pem ubuntu@54.208.89.87 'docker ps'
```

---

## 🎯 FEATURES A IMPLEMENTAR

### Fase 1: Authentication (Semana 1)
- [ ] Login page con input de email
- [ ] API `/api/auth/send-otp` (Amazon SES)
- [ ] OTP verification page
- [ ] API `/api/auth/verify-otp`
- [ ] JWT token generation
- [ ] Middleware para rutas protegidas
- [ ] Logout functionality

### Fase 2: Wallet System (Semana 2)
- [ ] Dashboard con balance de monedas
- [ ] API `/api/wallet/balance`
- [ ] Historial de transacciones
- [ ] API `/api/wallet/transactions`
- [ ] Admin panel para otorgar monedas
- [ ] Sistema de recompensas (login diario, referidos)

### Fase 3: Shop (Semana 3)
- [ ] Catálogo de productos
- [ ] API `/api/shop/items`
- [ ] Detalle de producto
- [ ] Compra con monedas
- [ ] API `/api/shop/purchase`
- [ ] Confirmación de compra
- [ ] Mis compras page

### Fase 4: QR Codes (Semana 4)
- [ ] Generación de QR después de compra
- [ ] API `/api/qr/generate`
- [ ] Display QR en app
- [ ] QR validation endpoint
- [ ] Admin scanner para validar QRs
- [ ] Marcar como redimido

### Fase 5: Testing & Polish (Semana 5)
- [ ] Testing con 10-20 usuarios
- [ ] Optimización de performance
- [ ] Error handling robusto
- [ ] Loading states
- [ ] Responsive design
- [ ] Accessibility

---

## 🐛 TROUBLESHOOTING

### Error: No se puede conectar a Supabase

```bash
# Verificar .env
cat .env | grep SUPABASE

# Test connection
curl https://your-project.supabase.co/rest/v1/ \
  -H "apikey: your_anon_key"
```

### Error: EC2 no responde

```bash
# Ver estado de la instancia
aws ec2 describe-instances --instance-ids i-083bcc1b409c1ecb6 \
  --query 'Reservations[0].Instances[0].State.Name'

# Ver logs de user-data
ssh -i wedding-game-key.pem ubuntu@54.208.89.87 \
  'sudo cat /var/log/user-data.log'

# Ver logs de Nginx
ssh -i wedding-game-key.pem ubuntu@54.208.89.87 \
  'sudo tail -50 /var/log/nginx/error.log'
```

### Error: Docker build falla

```bash
# Ver logs completos
docker-compose build --progress=plain

# Limpiar y rebuild
docker system prune -af
docker-compose build --no-cache
```

### Error: GitHub Actions falla

```bash
# Ver logs en GitHub
# https://github.com/cmaldonado98/wedding-ed-game/actions

# SSH manual para debug
ssh -i wedding-game-key.pem ubuntu@54.208.89.87
cd /home/ubuntu/wedding-game
docker logs wedding-game
```

---

## 📊 MONITOREO Y COSTOS

### Ver Costos AWS

```bash
# Costos del mes actual
aws ce get-cost-and-usage \
  --time-period Start=2026-01-01,End=2026-01-31 \
  --granularity MONTHLY \
  --metrics "UnblendedCost" \
  --output table

# Instancias corriendo
aws ec2 describe-instances \
  --filters "Name=instance-state-name,Values=running" \
  --query 'Reservations[*].Instances[*].[InstanceId,InstanceType,PublicIpAddress]' \
  --output table
```

### Detener EC2 (ahorro de costos)

```bash
# Detener (mantiene EBS, $0.08/mes)
aws ec2 stop-instances --instance-ids i-083bcc1b409c1ecb6

# Iniciar nuevamente
aws ec2 start-instances --instance-ids i-083bcc1b409c1ecb6

# Obtener nueva IP pública
aws ec2 describe-instances --instance-ids i-083bcc1b409c1ecb6 \
  --query 'Reservations[0].Instances[0].PublicIpAddress' \
  --output text
```

---

## 📚 RECURSOS ADICIONALES

### Documentación del Proyecto
- [AWS_RESOURCES.md](./AWS_RESOURCES.md) - Recursos AWS creados
- [QUICK_REFERENCE.md](./QUICK_REFERENCE.md) - Comandos rápidos
- [SETUP_COMPLETE.md](./SETUP_COMPLETE.md) - Setup inicial

### Enlaces Útiles
- **App**: http://54.208.89.87
- **GitHub**: https://github.com/cmaldonado98/wedding-ed-game
- **AWS Console**: https://console.aws.amazon.com/ec2
- **Supabase**: https://supabase.com/dashboard
- **Proyecto Principal**: https://github.com/cmaldonado98/wedding-esteban-dany

### Stack Técnico
- Next.js 16 (App Router, Server Components)
- React 19
- TypeScript
- Tailwind CSS
- Supabase (PostgreSQL)
- Amazon SES
- Docker
- GitHub Actions
- AWS EC2 (t4g.nano ARM64)

---

## ✅ CHECKLIST PRE-BODA

### 1 Semana Antes
- [ ] Verificar que EC2 está corriendo
- [ ] Hacer deploy final
- [ ] Testing completo con usuarios reales
- [ ] Verificar emails OTP funcionan
- [ ] Cargar productos en shop
- [ ] Configurar saldos iniciales de coins
- [ ] Backup de base de datos

### Día de la Boda
- [ ] EC2 running y monitoreado
- [ ] Números de contacto de soporte listos
- [ ] Acceso SSH desde móvil (Termius)
- [ ] Dashboard de Supabase abierto
- [ ] Logs en tiempo real

### Después de la Boda
- [ ] Detener EC2 (stop, no terminate)
- [ ] Descargar logs y analytics
- [ ] Backup final de base de datos
- [ ] Review de costos finales
- [ ] Después de 1 semana: cleanup completo

---

**Creado**: 2026-01-29  
**Autor**: Carlos Maldonado  
**Para**: Boda Esteban & Dany - 11 de Abril 2026  
**Versión**: 1.0
