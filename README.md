# 🎮 Wedding Gamification Module

Sistema de gamificación para la boda de Esteban y Dany con login OTP, wallet de monedas, tienda y códigos QR.

## 🚀 Infraestructura

- **Servidor**: AWS EC2 t4g.nano (ARM64, 512MB RAM)
- **Costo**: $0.0042/hora = $0.10/día = $0.73/semana
- **IP Pública**: 54.208.89.87
- **Región**: us-east-1
- **Stack**: Next.js 16 + Docker + Nginx + GitHub Actions

## 📋 Features

- **OTP Login**: Amazon SES (62K emails gratis desde EC2)
- **Wallet**: Sistema de monedas virtuales
- **Shop**: Compra de tickets, passes y VIP access
- **QR Codes**: Generación y validación de códigos
- **Supabase**: Base de datos compartida con app principal

## 🔗 Enlaces

- **GitHub Repo**: https://github.com/cmaldonado98/wedding-ed-game
- **Main App**: https://github.com/cmaldonado98/wedding-esteban-dany
- **Docs AWS**: [AWS_RESOURCES.md](./AWS_RESOURCES.md)

## 💻 Deployment

Automático via GitHub Actions al hacer push a `main`:

```bash
git push origin main
```

## 🛠️ Setup Local

```bash
# Instalar dependencias
npm install

# Copiar env
cp .env.example .env.local

# Correr dev
npm run dev
```

## 🔐 SSH al Servidor

```bash
ssh -i wedding-game-key.pem ubuntu@54.208.89.87
```

## 📊 Comandos Útiles

```bash
# Ver logs del container
ssh -i wedding-game-key.pem ubuntu@54.208.89.87 'docker logs wedding-game'

# Restart app
ssh -i wedding-game-key.pem ubuntu@54.208.89.87 'cd wedding-game && docker-compose restart'

# Ver costos AWS
aws ce get-cost-and-usage --time-period Start=2026-01-01,End=2026-01-31 --granularity MONTHLY --metrics "UnblendedCost"
```

## ⚠️ IMPORTANTE - Control de Costos

1. **Detener EC2** cuando no uses: `aws ec2 stop-instances --instance-ids i-083bcc1b409c1ecb6`
2. **Ver [AWS_RESOURCES.md](./AWS_RESOURCES.md)** para comandos de limpieza
3. EBS cobra $0.08/mes incluso si EC2 está stopped
4. Para costo $0: TERMINAR la instancia completamente

## 📅 Timeline de la Boda

- 1 semana antes: Iniciar EC2 y hacer pruebas
- Día de la boda: Monitorear EC2
- Después: Detener o terminar EC2

---

**Developed by**: Carlos Maldonado  
**For**: Esteban & Dany's Wedding 💍
