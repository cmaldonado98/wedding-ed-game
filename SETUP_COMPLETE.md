# 🎉 Setup Completo - Wedding Gamification Module

## ✅ RECURSOS CREADOS

### 1. AWS Infrastructure
- ✅ **IAM User**: `github-actions-wedding` (AKIA6GBMDMUS4SELRE77)
- ✅ **EC2 Key Pair**: `wedding-game-key` (saved in `wedding-game-key.pem`)
- ✅ **Security Group**: `sg-0db7137e55b7bb3d9` (ports 22, 80, 443)
- ✅ **EC2 Instance**: `i-083bcc1b409c1ecb6` 
  - Type: t4g.nano (ARM64, 512MB RAM)
  - Public IP: **54.208.89.87**
  - Region: us-east-1b
  - Status: Running (iniciando servicios...)

### 2. GitHub Repository
- ✅ **Repo**: https://github.com/cmaldonado98/wedding-ed-game
- ✅ **Initial Commit**: 17 files pushed
- ✅ **CI/CD**: GitHub Actions workflow configured

### 3. Project Structure
```
wedding-ed-game/
├── app/                    # Next.js 16 App Router
│   ├── layout.tsx
│   ├── page.tsx
│   └── globals.css
├── .github/workflows/
│   └── deploy.yml         # Auto-deploy on push to main
├── Dockerfile             # Production build
├── docker-compose.yml     # Container orchestration
├── next.config.js         # Next.js standalone output
├── package.json           # Dependencies
├── AWS_RESOURCES.md       # AWS resource documentation
├── QUICK_REFERENCE.md     # Commands cheat sheet
└── README.md              # Project overview
```

---

## 🚀 PRÓXIMOS PASOS

### 1. Esperar Setup de EC2 (5-10 minutos)
El user-data script está instalando:
- Docker & Docker Compose
- Nginx (reverse proxy)
- Node.js 20
- Configurando /home/ubuntu/wedding-game

**Verificar cuando esté listo:**
```bash
ssh -i wedding-game-key.pem ubuntu@54.208.89.87 'docker --version && nginx -v'
```

### 2. Configurar GitHub Secrets
Ve a: https://github.com/cmaldonado98/wedding-ed-game/settings/secrets/actions

Agregar:
```
EC2_SSH_KEY              = [contenido de wedding-game-key.pem]
SUPABASE_URL             = [tu Supabase URL]
SUPABASE_ANON_KEY        = [tu Supabase anon key]
SUPABASE_SERVICE_ROLE_KEY = [tu Supabase service role key]
JWT_SECRET               = [generar: openssl rand -base64 32]
```

### 3. Instalar Dependencias y Desarrollar
```bash
cd /Users/carlosmaldonado/Documents/Projects/wedding-ed-game

# Instalar packages
npm install

# Crear .env.local
cp .env.example .env.local
# Editar .env.local con tus valores

# Desarrollo local
npm run dev
# Abrir http://localhost:3000
```

### 4. Primer Deploy
Cuando hagas push a `main`, GitHub Actions auto-desplegará:
```bash
git add .
git commit -m "feat: Add OTP login"
git push origin main
```

---

## 💰 CONTROL DE COSTOS

### Costos Actuales
```
EC2 t4g.nano:  $0.0042/hora = $0.10/día
EBS 10 GB:     $0.08/mes
Total día:     ~$0.11
Total semana:  ~$0.78
Total mes:     ~$3.15
```

### Detener Cuando No Uses
```bash
# Detener (conserva todo, no cobra EC2)
aws ec2 stop-instances --instance-ids i-083bcc1b409c1ecb6

# Iniciar nuevamente
aws ec2 start-instances --instance-ids i-083bcc1b409c1ecb6

# Ver nueva IP pública después de reiniciar
aws ec2 describe-instances --instance-ids i-083bcc1b409c1ecb6 \
  --query 'Reservations[0].Instances[0].PublicIpAddress' --output text
```

### Cleanup Completo (después de la boda)
```bash
# Ver QUICK_REFERENCE.md para script completo
./cleanup-wedding-game.sh
```

---

## 📊 MONITOREO

### Health Checks
```bash
# HTTP Response
curl -I http://54.208.89.87

# SSH Status
ssh -i wedding-game-key.pem ubuntu@54.208.89.87 'uptime'

# Ver logs
ssh -i wedding-game-key.pem ubuntu@54.208.89.87 'docker logs wedding-game'

# Costos AWS
aws ce get-cost-and-usage \
  --time-period Start=2026-01-01,End=2026-01-31 \
  --granularity MONTHLY \
  --metrics "UnblendedCost" \
  --output table
```

---

## 🎯 FEATURES A DESARROLLAR

### Fase 1: Authentication
- [ ] OTP Login system con Amazon SES
- [ ] JWT token management
- [ ] Protected routes middleware
- [ ] User session management

### Fase 2: Wallet System
- [ ] Supabase `user_coins` table
- [ ] Coins balance API
- [ ] Transaction history
- [ ] Admin coin grants

### Fase 3: Shop Module
- [ ] Supabase `shop_items` table
- [ ] Purchase flow
- [ ] Inventory management
- [ ] Purchase confirmations

### Fase 4: QR Codes
- [ ] QR generation (qrcode library)
- [ ] QR validation endpoint
- [ ] Redemption tracking
- [ ] Admin QR scanner

### Fase 5: Testing & Optimization
- [ ] Load testing (75 users)
- [ ] Performance optimization
- [ ] Error handling
- [ ] Monitoring setup

---

## 📚 DOCUMENTACIÓN

- **AWS Resources**: [AWS_RESOURCES.md](./AWS_RESOURCES.md)
- **Quick Reference**: [QUICK_REFERENCE.md](./QUICK_REFERENCE.md)
- **Project README**: [README.md](./README.md)
- **GitHub Repo**: https://github.com/cmaldonado98/wedding-ed-game

---

## 🔗 LINKS ÚTILES

- **App URL**: http://54.208.89.87
- **GitHub Repo**: https://github.com/cmaldonado98/wedding-ed-game
- **AWS Console**: https://console.aws.amazon.com/ec2
- **Supabase Dashboard**: https://supabase.com/dashboard

---

## ⚡ COMANDOS MÁS USADOS

```bash
# SSH al servidor
ssh -i wedding-game-key.pem ubuntu@54.208.89.87

# Ver logs
ssh -i wedding-game-key.pem ubuntu@54.208.89.87 'docker logs wedding-game -f'

# Detener EC2
aws ec2 stop-instances --instance-ids i-083bcc1b409c1ecb6

# Ver costos
aws ce get-cost-and-usage --time-period Start=2026-01-01,End=2026-01-31 --granularity MONTHLY --metrics "UnblendedCost"

# Push y deploy
git push origin main  # Auto-deploys via GitHub Actions
```

---

**🎮 Ready to build the wedding gamification experience!**

**Costo objetivo**: $0.03-$0.73 para el día de la boda ✅  
**Infraestructura**: AWS EC2 + Docker + GitHub Actions ✅  
**Base de datos**: Supabase (compartida) ✅

**Created**: 2026-01-29  
**By**: Carlos Maldonado
