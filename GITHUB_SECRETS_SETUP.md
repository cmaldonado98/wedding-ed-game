# 🔐 Configuración de GitHub Secrets

## 📍 URL de configuración
**[Configurar Secrets aquí](https://github.com/cmaldonado98/wedding-ed-game/settings/secrets/actions)**

---

## ✅ Secrets a Configurar

Ve a: **Settings → Secrets and variables → Actions → New repository secret**

### 1️⃣ EC2_SSH_KEY
**Nombre**: `EC2_SSH_KEY`  
**Valor**: (Copiar contenido completo del archivo `wedding-game-key.pem`)

```
-----BEGIN RSA PRIVATE KEY-----
MIIEpAIBAAKCAQEA0uqcHnLFvWKw1q5wrGH5fh9WLoCId4hWPB0+he4cXuTKGP07
aujpANzCbX+WxvnydMZxARL9OyddAyTTyVXiOhl1Bn0wetW1Hb3Ipv2XjSuaJ26y
v8UepjjA9SGQ7GvUEmqeiSy9ZErelyoq1GTEJD//bvLrdxE5TYCYbniMZ1oq6M9E
VhhTpycRLho5/nZjHqCiX3UVGFyyE1+xLsU/qxtM0/BBk7kbFgsVsPWZQ3SLHLaM
MKBAtbaTahRd+Zyodh8ihH4I+jiSxgFqHoFeypNbs07JLaL8Nij0ASlvuBe/yPbS
sWK28liyr8w+LfeWXG+NKYjyG8N1QKHlmbbupQIDAQABAoIBAQCOtHpJB7LO/tVT
i9dkay3Zre4rrH+pEK/4IHlLON4tPnOXEM+A+HGeSb+rQqaLnlXzuMiAx45a1blT
BTnegaN9V/gcGdwRYEMZCm2WvwIpXBUDFR0QL5kbMk8sDDf4HsTwaP83JPRHxXhx
novAzoLItLLfxI585gofY7mc0Z4/n5JmPjEKSUMbKua0HSUT65RenAbp7GACdd6oS
29FccAJW0I74gb1ToLgUTFGTdus/qUEhKwWmIVYwnTAvc2qRJwVsyIiJZp6RXSEg
69bAnSgpqSeDyBGfG4MrQlRrPMo1wHOKMHNtBfFx95m9PGaOtbD6d7eeDCE2o6gR
iVCXoKWJAoGBAO7qOaovXo4X9kjw+ap67yCtPHGdGX0mW7KRoXKc4nLmkduvvX/+
oBXRS6Fx0ok7xY+Eb3jjyybBW1EksNWLENWZ4cCKR4ZUOb5kmWbstunz7OU/Icq+
17UUqNLPV1gf5LltqVmrdCO27tY38oluTFfBKj2E7WhZumW1BNAX89KLAoGBAOH/
0ibjv12M4Od0jJnKEPMj5OFlAx0OybohuNzHtVYcJbz5Mc9xJyHaIruMWKhrPEwY
a8zqtxQN8obF/07nPs3uWFkWPc7YOZZl4XwYs1jeK8jhM4hfl5f22acFuo1DUPsY
Uh3gkhtsx+MRaHVCTk7CYvxEKP/9qDcV7CqBNlmPAoGBALMeK6lp5iwFzwGUmLm1
fP40ovJS478uOOVBxZbWA/g84PGhaiNB1OdGiLs7SKrWgyE8Gw65SZ9+q2XEakdP
AYoC2nutsD4He1tAtLmzktcHp32fvUfxmGsMWB3kkQlir+pNSwANSP9VsO4t98oN
RXMtQOvqcssfKl4CPt98dbJNAoGAKU1AUb0jduxNGd+R5nUoPdcceBimxgOy2CJb
j3Wr7S29s9hywu9x8FzWJiJS/YyDe4CnCs8GYFLgNMMwknHuZ2IcoUNQTmHzvEmo
OK6m8CHCLLcDXPPjV3FUe5KvciuQPCNIto8ZBIwPx66hwXQ5rWkW//VQ7N+lg1Ot
UmNE1H8CgYBBnVE/Y9kbOGlN+xCB61y9iIK3SipTiZSKMkwGfEHc1V+Q3tu/1XWj
qQ+dWtUA72EDlDbCmSqcWyBYC4icUzE0DqL6vfeKlzuoqx1cBns+9TKkyQAIBWNh
lu7F7Rg0nzmkr6jQOUY1c52vkf8f2fWpOmVXTQKCp5Du/MAF6eG+pA==
-----END RSA PRIVATE KEY-----
```

---

### 2️⃣ SUPABASE_URL
**Nombre**: `SUPABASE_URL`  
**Valor**: 
```
https://cleeumrziseyvctsfxxx.supabase.co
```

---

### 3️⃣ SUPABASE_ANON_KEY
**Nombre**: `SUPABASE_ANON_KEY`  
**Valor**: 
```
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNsZWV1bXJ6aXNleXZjdHNmeHh4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Njc5OTE3NTUsImV4cCI6MjA4MzU2Nzc1NX0.0mD7ALbFeB3A-A14OcOeRIuYJ4FU5-mnnJwENwZq05A
```

---

### 4️⃣ SUPABASE_SERVICE_ROLE_KEY
**Nombre**: `SUPABASE_SERVICE_ROLE_KEY`  
**Valor**: 
```
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNsZWV1bXJ6aXNleXZjdHNmeHh4Iiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2Nzk5MTc1NSwiZXhwIjoyMDgzNTY3NzU1fQ.PSjyE_zFhDb_WWo8dfgXUadQg7FTBgVktzTDhsCztLQ
```

---

### 5️⃣ JWT_SECRET (Opcional pero recomendado)
**Nombre**: `JWT_SECRET`  
**Valor**: (Generar uno nuevo o usar uno existente)

Para generar uno nuevo, ejecuta en terminal:
```bash
openssl rand -base64 32
```

Ejemplo:
```
Kp8vR3xN9mQ2wL5yT6uH1jS4bC7fG0aE8dZ3vM2nB5k=
```

---

### 6️⃣ PAYPHONE_TOKEN (Para pagos)
**Nombre**: `PAYPHONE_TOKEN`  
**Valor**: 
```
T9m46OH8aa2d4P5jbsw23-Y4R2eBEpyfpy0j_IF1SXLcFr48WsGcbzOnZWwj6sqbNAVfhdXKsrcnj9CRcCcQQa0fHYRv-o6HD3qMeZv1Eygzu8J3jr1WkUAiQr1sJF_N_haSWwf-vK1vBS2A9Nj5-XrdxLFI93VDax41qDvvyXqXeIpymMiICMXKQ_YdZaOB-6Hdd1AQRWXO3LU4ABJrO4_lNtCzUOK8AvEF0E6E8gjSo9vUkpmjLsfwEbgbuJg_BLYR6DfPD4anXh3T2C1HzN-YATrwN-QFk8nuPOf9nnZEWuQIXzJJ7kjo7Di_L0_a9hro9Q
```

---

### 7️⃣ PAYPHONE_STORE_ID
**Nombre**: `PAYPHONE_STORE_ID`  
**Valor**: 
```
2045aab0-cad6-4c59-9b17-3e90bd793b17
```

---

### 8️⃣ GEMINI_API_KEY (Para validación con IA)
**Nombre**: `GEMINI_API_KEY`  
**Valor**: 
```
AIzaSyD4E614NZ8IF61r37ELU2Hbc203amwQnxQ
```

---

## 📋 Checklist de Verificación

Después de agregar todos los secrets, verifica que tienes estos 8:

- [ ] `EC2_SSH_KEY` - SSH key para conectar al servidor
- [ ] `SUPABASE_URL` - URL de Supabase
- [ ] `SUPABASE_ANON_KEY` - Clave anónima de Supabase
- [ ] `SUPABASE_SERVICE_ROLE_KEY` - Clave de servicio de Supabase
- [ ] `JWT_SECRET` - Secret para tokens JWT
- [ ] `PAYPHONE_TOKEN` - Token de Payphone
- [ ] `PAYPHONE_STORE_ID` - ID de tienda Payphone
- [ ] `GEMINI_API_KEY` - API key de Google Gemini

---

## 🚀 Siguiente Paso

Una vez configurados todos los secrets:

1. Ve a la pestaña **Actions** del repositorio
2. Haz un push a `main` o ejecuta manualmente el workflow
3. El deploy se hará automáticamente

O simplemente:
```bash
git add .
git commit -m "feat: welcome page and CI/CD setup"
git push origin main
```

---

## 🔧 Verificar Secrets

Para verificar que los secrets están configurados (sin ver los valores):

```bash
# Instalar GitHub CLI si no lo tienes
brew install gh

# Listar secrets
gh secret list --repo cmaldonado98/wedding-ed-game
```

Deberías ver:
```
EC2_SSH_KEY               Updated YYYY-MM-DD
GEMINI_API_KEY            Updated YYYY-MM-DD
JWT_SECRET                Updated YYYY-MM-DD
PAYPHONE_STORE_ID         Updated YYYY-MM-DD
PAYPHONE_TOKEN            Updated YYYY-MM-DD
SUPABASE_ANON_KEY         Updated YYYY-MM-DD
SUPABASE_SERVICE_ROLE_KEY Updated YYYY-MM-DD
SUPABASE_URL              Updated YYYY-MM-DD
```

---

## ⚠️ Importante

- **NO COMMITEAR** los secrets al repositorio
- **NO COMPARTIR** las claves públicamente
- Los secrets solo se usan en GitHub Actions
- Si cambias un secret, debes actualizarlo en GitHub también

---

## 📞 Problemas?

Si el deploy falla después de configurar los secrets:

1. Ve a **Actions** → Selecciona el workflow fallido
2. Revisa los logs para ver qué secret falta o está mal
3. Actualiza el secret incorrecto
4. Re-ejecuta el workflow (botón "Re-run all jobs")
