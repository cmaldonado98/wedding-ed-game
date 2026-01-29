# 🔧 QUICK REFERENCE - Wedding Game Infrastructure

## 🆔 IDs y Claves

### AWS Resources
```
Account ID:          975050073381
Region:              us-east-1
IAM User:            github-actions-wedding
Access Key:          AKIA6GBMDMUS4SELRE77
Secret Key:          (saved in AWS_RESOURCES.md)

Key Pair:            wedding-game-key
Key File:            wedding-game-key.pem

Security Group:      sg-0db7137e55b7bb3d9
Security Group Name: wedding-game-sg

EC2 Instance:        i-083bcc1b409c1ecb6
Instance Type:       t4g.nano (ARM64, 512MB)
Public IP:           54.208.89.87
Private IP:          172.31.16.100
```

### GitHub
```
Repository:          cmaldonado98/wedding-ed-game
URL:                 https://github.com/cmaldonado98/wedding-ed-game
Repo ID:             1145531835
```

---

## ⚡ COMANDOS RÁPIDOS

### EC2 Control
```bash
# Ver estado
aws ec2 describe-instances --instance-ids i-083bcc1b409c1ecb6 \
  --query 'Reservations[0].Instances[0].[InstanceId,State.Name,PublicIpAddress]' \
  --output table

# Detener (no cobra compute, sí cobra EBS $0.08/mes)
aws ec2 stop-instances --instance-ids i-083bcc1b409c1ecb6

# Iniciar
aws ec2 start-instances --instance-ids i-083bcc1b409c1ecb6

# TERMINAR (elimina todo, costo $0)
aws ec2 terminate-instances --instance-ids i-083bcc1b409c1ecb6
```

### SSH Access
```bash
# Conectar al servidor
ssh -i wedding-game-key.pem ubuntu@54.208.89.87

# Ver logs del container
ssh -i wedding-game-key.pem ubuntu@54.208.89.87 'docker logs wedding-game'

# Ver logs del user-data (setup inicial)
ssh -i wedding-game-key.pem ubuntu@54.208.89.87 'sudo cat /var/log/user-data.log'

# Restart app
ssh -i wedding-game-key.pem ubuntu@54.208.89.87 'cd /home/ubuntu/wedding-game && docker-compose restart'
```

### Docker Commands (en el servidor)
```bash
# Ver containers
docker ps

# Ver logs
docker logs wedding-game -f

# Rebuild
cd /home/ubuntu/wedding-game
docker-compose down
docker-compose build --no-cache
docker-compose up -d

# Limpiar
docker system prune -af
```

### Verificar Servicios
```bash
# Nginx
ssh -i wedding-game-key.pem ubuntu@54.208.89.87 'systemctl status nginx'

# Docker
ssh -i wedding-game-key.pem ubuntu@54.208.89.87 'docker --version'

# App health
curl -I http://54.208.89.87
```

---

## 💰 MONITOREO DE COSTOS

### Ver Costos del Mes
```bash
aws ce get-cost-and-usage \
  --time-period Start=2026-01-01,End=2026-01-31 \
  --granularity MONTHLY \
  --metrics "UnblendedCost" "UsageQuantity" \
  --group-by Type=SERVICE \
  --output table
```

### Ver Instancias Corriendo
```bash
aws ec2 describe-instances \
  --filters "Name=instance-state-name,Values=running" \
  --query 'Reservations[*].Instances[*].[InstanceId,InstanceType,LaunchTime,Tags[?Key==`Name`].Value|[0]]' \
  --output table
```

### Calcular Costo Acumulado
```bash
# Por hora: $0.0042
# Por día (24h): $0.0042 * 24 = $0.10
# Por día boda (8h): $0.0042 * 8 = $0.03
# Por semana: $0.0042 * 24 * 7 = $0.70
# Por mes: $0.0042 * 24 * 30 = $3.07
```

---

## 🗑️ CLEANUP COMPLETO

### Script de Eliminación (cuando termines)
```bash
#!/bin/bash
# cleanup-wedding-game.sh

set -e

echo "🗑️  Eliminando recursos de Wedding Game..."

# 1. Terminar EC2
echo "Terminando EC2 instance..."
aws ec2 terminate-instances --instance-ids i-083bcc1b409c1ecb6
echo "Esperando terminación..."
aws ec2 wait instance-terminated --instance-ids i-083bcc1b409c1ecb6

# 2. Eliminar Security Group
echo "Eliminando Security Group..."
aws ec2 delete-security-group --group-id sg-0db7137e55b7bb3d9

# 3. Eliminar Key Pair
echo "Eliminando Key Pair..."
aws ec2 delete-key-pair --key-name wedding-game-key
rm -f wedding-game-key.pem

# 4. Eliminar IAM User
echo "Eliminando IAM User..."
aws iam delete-access-key --user-name github-actions-wedding --access-key-id AKIA6GBMDMUS4SELRE77
aws iam detach-user-policy --user-name github-actions-wedding \
  --policy-arn arn:aws:iam::975050073381:policy/GitHubActionsWeddingPolicy
aws iam delete-user --user-name github-actions-wedding
aws iam delete-policy --policy-arn arn:aws:iam::975050073381:policy/GitHubActionsWeddingPolicy

echo "✅ Todos los recursos eliminados!"
echo "Verifica en la consola de AWS: https://console.aws.amazon.com/ec2"
```

Para ejecutar:
```bash
chmod +x cleanup-wedding-game.sh
./cleanup-wedding-game.sh
```

---

## 🔐 GitHub Secrets (configurar en GitHub)

Ve a: https://github.com/cmaldonado98/wedding-ed-game/settings/secrets/actions

Agregar estos secrets:
```
EC2_SSH_KEY              = (contenido de wedding-game-key.pem)
SUPABASE_URL             = your_supabase_url
SUPABASE_ANON_KEY        = your_supabase_anon_key
SUPABASE_SERVICE_ROLE_KEY = your_service_role_key
JWT_SECRET               = random_jwt_secret_here
```

---

## 📊 HEALTH CHECKS

### Test Completo
```bash
#!/bin/bash
# health-check.sh

echo "🏥 Health Check - Wedding Game"
echo "================================"

echo "1. EC2 Instance Status:"
aws ec2 describe-instances --instance-ids i-083bcc1b409c1ecb6 \
  --query 'Reservations[0].Instances[0].[State.Name,PublicIpAddress]' \
  --output text

echo ""
echo "2. HTTP Response:"
curl -s -o /dev/null -w "Status: %{http_code}\nTime: %{time_total}s\n" http://54.208.89.87

echo ""
echo "3. SSH Connectivity:"
ssh -i wedding-game-key.pem -o ConnectTimeout=5 ubuntu@54.208.89.87 'echo "SSH OK"' 2>&1

echo ""
echo "4. Docker Status:"
ssh -i wedding-game-key.pem ubuntu@54.208.89.87 'docker ps --format "{{.Names}}: {{.Status}}"'

echo ""
echo "✅ Health check complete!"
```

---

## 📱 URLs de la Aplicación

- **Frontend**: http://54.208.89.87
- **API Base**: http://54.208.89.87/api
- **Health**: http://54.208.89.87/api/health

---

## 🎯 Próximos Pasos

1. **Configurar GitHub Secrets** para el deploy automático
2. **Desarrollar features**:
   - OTP Login con Amazon SES
   - Wallet system (Supabase)
   - Shop module
   - QR code generation
3. **Testing** antes de la boda
4. **Monitorear costos** semanalmente
5. **Cleanup** después de la boda

---

**Última actualización**: 2026-01-29  
**Mantenido por**: Carlos Maldonado
