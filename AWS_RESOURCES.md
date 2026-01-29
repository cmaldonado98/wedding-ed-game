# 🔐 AWS Resources - Wedding Game

## 📋 RECURSOS CREADOS

### IAM User
- **Name**: `github-actions-wedding`
- **Access Key ID**: `AKIA6GBMDMUS4SELRE77`
- **Created**: 2026-01-29
- **Purpose**: Deploy desde GitHub Actions
- **Cost**: $0 (IAM es gratis)

### EC2 Key Pair
- **Name**: `wedding-game-key`
- **File**: `wedding-game-key.pem`
- **Created**: 2026-01-29
- **Cost**: $0 (Keys son gratis)

### Security Group
- **ID**: `sg-0db7137e55b7bb3d9`
- **Name**: `wedding-game-sg`
- **Ports**: 22 (SSH from 157.100.89.190), 80 (HTTP), 443 (HTTPS)
- **Created**: 2026-01-29
- **Cost**: $0 (Security Groups son gratis)

### EC2 Instance ✅
- **Instance ID**: `i-083bcc1b409c1ecb6`
- **Type**: `t4g.nano` (2 vCPUs ARM, 512MB RAM)
- **State**: `running`
- **Public IP**: `54.208.89.87`
- **Private IP**: `172.31.16.100`
- **AMI**: `ami-03dc355fadfbaaf26` (Ubuntu 22.04 ARM64)
- **Region**: `us-east-1b`
- **Created**: 2026-01-29
- **Cost**: $0.0042/hora = $0.10/día

### EBS Volume
- **Size**: 10 GB (gp3)
- **Device**: `/dev/sda1`
- **Tags**: Name=wedding-game-root, Project=Boda
- **Cost**: $0.08/mes

---

## 💰 MONITOREO DE COSTOS

### Costos Actuales
```
IAM User:           $0.00
EC2 Key Pair:       $0.00
─────────────────────────
TOTAL ACTUAL:       $0.00
```

### Costos Proyectados (cuando lances EC2)
```
EC2 t4g.nano:       $0.0042/hora
├── Por hora:       $0.0042i-083bcc1b409c1ecb6

# Verificar estado
aws ec2 describe-instances --instance-ids i-083bcc1b409c1ecb6 \
  --query 'Reservations[0].Instances[0].State.Name'
```

### Iniciar EC2 nuevamente
```bash
aws ec2 start-instances --instance-ids i-083bcc1b409c1ecb6
```

### ELIMINAR TODO (cuando termines)
```bash
# 1. Terminar EC2
aws ec2 terminate-instances --instance-ids i-083bcc1b409c1ecb6

# 2. Eliminar Security Group (espera 2 min después de terminar EC2)
aws ec2 delete-security-group --group-id sg-0db7137e55b7bb3d9

# 3. Eliminar Key Pair
aws ec2 delete-key-pair --key-name wedding-game-key
rm wedding-game-key.pem

# 4. Eliminar IAM User
aws iam delete-access-key --user-name github-actions-wedding --access-key-id AKIA6GBMDMUS4SELRE77
aws iam detach-user-policy --user-name github-actions-wedding --policy-arn arn:aws:iam::975050073381:policy/GitHubActionsWeddingPolicy
aws iam delete-user --user-name github-actions-wedding
aws iam delete-policy --policy-arn arn:aws:iam::975050073381
aws ec2 start-instances --instance-ids INSTANCE_ID
```

### ELIMINAR TODO (cuando termines)
```bash
# 1. Terminar EC2
aws ec2 terminate-instances --instance-ids INSTANCE_ID

# 2. Eliminar Security Group (espera 2 min después de terminar EC2)
aws ec2 delete-security-group --group-id SG_ID

# 3. Eliminar Key Pair
aws ec2 delete-key-pair --key-name wedding-game-key

# 4. Eliminar IAM User
aws iam delete-access-key --user-name github-actions-wedding --access-key-id AKIA6GBMDMUS4SELRE77
aws iam detach-user-policy --user-name github-actions-wedding --policy-arn arn:aws:iam::ACCOUNT_ID:policy/GitHubActionsWeddingPolicy
aws iam delete-user --user-name github-actions-wedding
aws iam delete-policy --policy-arn arn:aws:iam::ACCOUNT_ID:policy/GitHubActionsWeddingPolicy
```

---

## 📊 VERIFICAR COSTOS EN TIEMPO REAL

### AWS CLI Commands
```bash
# Ver costos del mes actual
aws ce get-cost-and-usage \
  --time-period Start=2026-01-01,End=2026-01-31 \
  --granularity MONTHLY \
  --metrics "UnblendedCost" \
  --group-by Type=SERVICE

# Ver instancias EC2 corriendo
aws ec2 describe-instances \
  --filters "Name=instance-state-name,Values=running" \
  --query 'Reservations[*].Instances[*].[InstanceId,InstanceType,State.Name,PublicIpAddress]' \
  --output table
```

### AWS Console
- Dashboard de costos: https://console.aws.amazon.com/cost-management/home
- EC2 Dashboard: https://console.aws.amazon.com/ec2

---

## ⚠️ ALERTAS DE COSTO

### Configurar Budget Alert (opcional pero recomendado)
```bash
# Crear alerta si gastas más de $5
aws budgets create-budget \
  --account-id $(aws sts get-caller-identity --query Account --output text) \
  --budget file://budget.json
```

budget.json:
```json
{
  "BudgetName": "WeddingGameBudget",
  "BudgetLimit": {
    "Amount": "5",
    "Unit": "USD"
  },
  "TimeUnit": "MONTHLY",
  "BudgetType": "COST"
}
```

---

## 🎯 CHECKLIST PRE-BODA

### 1 Semana Antes
- [ ] Iniciar instancia EC2
- [ ] Verificar deploy
- [ ] Hacer pruebas de carga
- [ ] Verificar costos diarios

### Día de la Boda
- [ ] Verificar que EC2 está corriendo
- [ ] Monitorear métricas
- [ ] Tener acceso SSH listo

### Después de la Boda
- [ ] Detener EC2 (stop, no terminate)
- [ ] Descargar logs si necesitas
- [ ] Después de 1 semana: ELIMINAR TODO
- [ ] Verificar que no quedan recursos cobrando

---

## 📝 NOTAS

- Siempre verifica costos en AWS Console
- Detén la instancia cuando no la uses
- EBS se cobra incluso si EC2 está stopped ($0.08/mes)
- Para costo $0, debes TERMINAR la instancia completamente
