# 🚀 Configuración Rápida de GitHub Secrets

## Opción 1: Configuración Manual (Más Fácil)

### 1. Abre la configuración de Secrets
Abre este link en tu navegador:
```
https://github.com/cmaldonado98/wedding-ed-game/settings/secrets/actions
```

### 2. Para cada secret, haz clic en "New repository secret" y copia/pega:

#### Secret 1: EC2_SSH_KEY
- **Name**: `EC2_SSH_KEY`
- **Value**: Copia el contenido completo de `wedding-game-key.pem`:
```bash
# Ejecuta en terminal:
cat /Users/carlosmaldonado/Documents/Projects/wedding-ed-game/wedding-game-key.pem
```
Copia TODO el output (incluyendo BEGIN y END lines)

#### Secret 2: SUPABASE_URL
- **Name**: `SUPABASE_URL`
- **Value**: 
```
https://cleeumrziseyvctsfxxx.supabase.co
```

#### Secret 3: SUPABASE_ANON_KEY
- **Name**: `SUPABASE_ANON_KEY`
- **Value**:
```
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNsZWV1bXJ6aXNleXZjdHNmeHh4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Njc5OTE3NTUsImV4cCI6MjA4MzU2Nzc1NX0.0mD7ALbFeB3A-A14OcOeRIuYJ4FU5-mnnJwENwZq05A
```

#### Secret 4: SUPABASE_SERVICE_ROLE_KEY
- **Name**: `SUPABASE_SERVICE_ROLE_KEY`
- **Value**:
```
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNsZWV1bXJ6aXNleXZjdHNmeHh4Iiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2Nzk5MTc1NSwiZXhwIjoyMDgzNTY3NzU1fQ.PSjyE_zFhDb_WWo8dfgXUadQg7FTBgVktzTDhsCztLQ
```

---

## Opción 2: Con GitHub CLI (Automático)

### 1. Autentícate con GitHub
```bash
gh auth login
```
Selecciona:
- GitHub.com
- HTTPS
- Yes (authenticate Git with GitHub)
- Login with a web browser

### 2. Ejecuta estos comandos uno por uno:

```bash
# Secret 1: EC2_SSH_KEY
gh secret set EC2_SSH_KEY --repo cmaldonado98/wedding-ed-game < /Users/carlosmaldonado/Documents/Projects/wedding-ed-game/wedding-game-key.pem

# Secret 2: SUPABASE_URL
echo "https://cleeumrziseyvctsfxxx.supabase.co" | gh secret set SUPABASE_URL --repo cmaldonado98/wedding-ed-game

# Secret 3: SUPABASE_ANON_KEY
echo "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNsZWV1bXJ6aXNleXZjdHNmeHh4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Njc5OTE3NTUsImV4cCI6MjA4MzU2Nzc1NX0.0mD7ALbFeB3A-A14OcOeRIuYJ4FU5-mnnJwENwZq05A" | gh secret set SUPABASE_ANON_KEY --repo cmaldonado98/wedding-ed-game

# Secret 4: SUPABASE_SERVICE_ROLE_KEY
echo "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNsZWV1bXJ6aXNleXZjdHNmeHh4Iiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2Nzk5MTc1NSwiZXhwIjoyMDgzNTY3NzU1fQ.PSjyE_zFhDb_WWo8dfgXUadQg7FTBgVktzTDhsCztLQ" | gh secret set SUPABASE_SERVICE_ROLE_KEY --repo cmaldonado98/wedding-ed-game
```

### 3. Verifica que se configuraron:
```bash
gh secret list --repo cmaldonado98/wedding-ed-game
```

Deberías ver:
```
EC2_SSH_KEY               Updated YYYY-MM-DD
SUPABASE_ANON_KEY         Updated YYYY-MM-DD
SUPABASE_SERVICE_ROLE_KEY Updated YYYY-MM-DD
SUPABASE_URL              Updated YYYY-MM-DD
```

---

## 🚀 Después de Configurar

Una vez que los 4 secrets estén configurados:

```bash
git push origin main
```

El workflow se ejecutará automáticamente y deployará tu app a:
```
http://54.208.89.87
```

---

## 🔍 Verificar el Deploy

1. Ve a: https://github.com/cmaldonado98/wedding-ed-game/actions
2. Verás el workflow ejecutándose
3. Si todo está OK, verás ✅ verde
4. Visita http://54.208.89.87 para ver tu página de bienvenida

---

## ⚠️ Si el Workflow Falla

1. Ve a Actions y haz clic en el workflow fallido
2. Expande cada paso para ver dónde falló
3. Si falta un secret, ve a la configuración y agrégalo
4. Vuelve a ejecutar el workflow con "Re-run all jobs"
