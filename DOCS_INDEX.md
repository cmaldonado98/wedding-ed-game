# 📚 ÍNDICE COMPLETO DE DOCUMENTACIÓN

## 🎯 Comenzar Aquí

### Para Desarrollo
1. **[README.md](./README.md)** - Inicio rápido y overview del proyecto
2. **[PROJECT_INSTRUCTIONS.md](./PROJECT_INSTRUCTIONS.md)** - ⭐ GUÍA COMPLETA del proyecto
3. **[DESIGN_REFERENCE.md](./DESIGN_REFERENCE.md)** - Sistema de diseño y componentes

### Para Deployment
1. **[SETUP_COMPLETE.md](./SETUP_COMPLETE.md)** - Checklist de setup inicial
2. **[MIGRATION_GUIDE.md](./MIGRATION_GUIDE.md)** - Ejecutar migración de base de datos
3. **[.github/workflows/deploy.yml](./.github/workflows/deploy.yml)** - CI/CD con GitHub Actions

### Para Operaciones
1. **[AWS_RESOURCES.md](./AWS_RESOURCES.md)** - Recursos AWS y monitoreo de costos
2. **[QUICK_REFERENCE.md](./QUICK_REFERENCE.md)** - Comandos rápidos y troubleshooting

---

## 📖 GUÍAS PRINCIPALES

### 1️⃣ PROJECT_INSTRUCTIONS.md (⭐ MÁS IMPORTANTE)
**Contenido**:
- ✅ Paleta de colores completa con variables CSS
- ✅ Configuración de fuentes (Montaga, Playfair, Noto)
- ✅ Schema completo de base de datos con SQL
- ✅ Estructura del proyecto (carpetas y archivos)
- ✅ Variables de entorno necesarias
- ✅ Flujo completo de CI/CD con GitHub Actions
- ✅ Comandos de desarrollo y deployment
- ✅ Roadmap de features por fase
- ✅ Troubleshooting común

**Cuándo usar**: Retomar el proyecto, onboarding de nuevos devs, referencia general

---

### 2️⃣ DESIGN_REFERENCE.md
**Contenido**:
- 🎨 Paleta de colores con ejemplos de uso
- 🔤 Configuración completa de tipografía
- 🎨 Componentes de ejemplo (cards, botones, inputs)
- 🌈 Gradientes recomendados
- ✨ Efectos hover y sombras
- 📱 Breakpoints responsive
- ✅ Checklist de consistencia de diseño
- 💡 Ejemplos de páginas completas

**Cuándo usar**: Crear nuevos componentes, mantener consistencia visual

---

### 3️⃣ MIGRATION_GUIDE.md
**Contenido**:
- 📋 3 opciones para ejecutar migración (Dashboard, CLI, psql)
- ✅ Verificaciones post-migración
- 🧪 Tests básicos de funcionalidad
- 🐛 Troubleshooting de errores comunes
- 📊 Estructura final de base de datos

**Cuándo usar**: Primera vez configurando base de datos, después de cambios en schema

---

### 4️⃣ AWS_RESOURCES.md
**Contenido**:
- 🆔 IDs de todos los recursos AWS creados
- 💰 Cálculos de costos detallados
- 🛑 Comandos para detener/iniciar/terminar EC2
- 📊 Scripts de monitoreo de costos
- ⚠️ Configuración de alertas de presupuesto
- 🎯 Checklist pre/post boda
- 🗑️ Script de cleanup completo

**Cuándo usar**: Monitorear costos, operaciones de infraestructura, cleanup

---

### 5️⃣ QUICK_REFERENCE.md
**Contenido**:
- 🆔 Todos los IDs y claves importantes
- ⚡ Comandos más usados (EC2, SSH, Docker)
- 💰 Comandos de monitoreo de costos
- 🗑️ Script de eliminación completa
- 🔐 Lista de GitHub Secrets necesarios
- 🏥 Health checks
- 📱 URLs de la aplicación

**Cuándo usar**: Referencia rápida diaria, comandos frecuentes

---

### 6️⃣ SETUP_COMPLETE.md
**Contenido**:
- ✅ Lista de recursos creados
- 🚀 Próximos pasos inmediatos
- 💰 Resumen de costos
- 📊 Comandos de monitoreo
- 🎯 Features a desarrollar por fase
- 📅 Timeline de la boda

**Cuándo usar**: Después del setup inicial, planificación de trabajo

---

## 🗄️ ARCHIVOS SQL

### supabase-migration.sql
**Contenido**:
- Schema completo de 5 tablas nuevas:
  - `user_sessions` (OTP)
  - `user_coins` (Wallet)
  - `coin_transactions` (Historial)
  - `shop_items` (Productos)
  - `shop_purchases` (Compras y QR)
- Índices optimizados
- Triggers de timestamps
- Row Level Security (RLS)
- Funciones helper (generate_qr_code, add_coins_to_user)
- Seed data de ejemplo

**Cuándo usar**: Ejecutar una sola vez en Supabase al inicio del proyecto

---

## ⚙️ ARCHIVOS DE CONFIGURACIÓN

### .env.example
Variables de entorno necesarias para el proyecto

### package.json
Dependencias del proyecto:
- Next.js 16
- React 19
- Supabase client
- qrcode (para generación de QR)

### Dockerfile
Configuración para build de producción con Node 20 Alpine

### docker-compose.yml
Orquestación del container con health checks

### next.config.js
Configuración de Next.js con output standalone

### tailwind.config.ts
Configuración de Tailwind con colores de boda

### tsconfig.json
Configuración de TypeScript

---

## 🚀 CI/CD

### .github/workflows/deploy.yml
**Workflow de GitHub Actions**:
1. Checkout del código
2. Setup de SSH key
3. Creación de .env en servidor
4. Copia de archivos al EC2
5. Build de Docker
6. Restart de containers
7. Health check
8. Notificaciones de éxito/fallo

**Triggers**: Push a `main` o workflow_dispatch manual

**Secrets requeridos**: Ver QUICK_REFERENCE.md

---

## 📁 ESTRUCTURA DEL PROYECTO

```
wedding-ed-game/
├── 📚 DOCUMENTACIÓN
│   ├── README.md                    # Inicio rápido
│   ├── PROJECT_INSTRUCTIONS.md      # ⭐ Guía completa
│   ├── DESIGN_REFERENCE.md          # Sistema de diseño
│   ├── MIGRATION_GUIDE.md           # Base de datos
│   ├── AWS_RESOURCES.md             # Infraestructura
│   ├── QUICK_REFERENCE.md           # Comandos
│   ├── SETUP_COMPLETE.md            # Checklist
│   └── DOCS_INDEX.md                # Este archivo
│
├── 🗄️ BASE DE DATOS
│   └── supabase-migration.sql       # Schema completo
│
├── ⚙️ CONFIGURACIÓN
│   ├── .env.example
│   ├── .gitignore
│   ├── package.json
│   ├── next.config.js
│   ├── tailwind.config.ts
│   ├── tsconfig.json
│   ├── postcss.config.js
│   ├── Dockerfile
│   └── docker-compose.yml
│
├── 🚀 CI/CD
│   └── .github/workflows/deploy.yml
│
├── 🔐 SECRETS
│   └── wedding-game-key.pem        # SSH key (NO COMMITEAR)
│
├── 🎨 APP (Next.js 16)
│   ├── app/                        # App Router
│   │   ├── layout.tsx
│   │   ├── page.tsx
│   │   ├── globals.css
│   │   ├── login/
│   │   ├── dashboard/
│   │   ├── wallet/
│   │   ├── shop/
│   │   ├── purchases/
│   │   ├── qr/
│   │   └── api/
│   ├── components/
│   ├── lib/
│   └── types/
│
└── 🛠️ SCRIPTS AWS
    └── ec2-user-data.sh            # Setup inicial de EC2
```

---

## 🎯 FLUJO DE TRABAJO TÍPICO

### Primer Setup (Una vez)
1. Leer **PROJECT_INSTRUCTIONS.md** completo
2. Ejecutar migración SQL con **MIGRATION_GUIDE.md**
3. Configurar .env según **PROJECT_INSTRUCTIONS.md**
4. Configurar GitHub Secrets según **QUICK_REFERENCE.md**
5. Verificar recursos AWS en **AWS_RESOURCES.md**

### Desarrollo Diario
1. `npm run dev` para desarrollo local
2. Consultar **DESIGN_REFERENCE.md** al crear componentes
3. `git push origin main` para deploy automático
4. Ver **QUICK_REFERENCE.md** para comandos comunes

### Monitoreo y Operaciones
1. **QUICK_REFERENCE.md** - Comandos SSH, Docker, logs
2. **AWS_RESOURCES.md** - Monitoreo de costos
3. Ver logs: `ssh -i wedding-game-key.pem ubuntu@54.208.89.87 'docker logs wedding-game -f'`

### Troubleshooting
1. Consultar sección de Troubleshooting en **PROJECT_INSTRUCTIONS.md**
2. Ver **QUICK_REFERENCE.md** para health checks
3. Verificar logs en EC2
4. Revisar GitHub Actions en caso de fallo de deploy

---

## 📊 MAPA DE DECISIONES

### ¿Necesitas...?

#### 🎨 Crear un componente nuevo?
→ **DESIGN_REFERENCE.md** (colores, fuentes, ejemplos)

#### 🗄️ Modificar base de datos?
1. Editar **supabase-migration.sql**
2. Ejecutar con **MIGRATION_GUIDE.md**

#### ☁️ Trabajar con AWS?
→ **AWS_RESOURCES.md** (IDs) + **QUICK_REFERENCE.md** (comandos)

#### 🚀 Hacer deploy?
→ `git push origin main` (GitHub Actions automático)
→ Ver **.github/workflows/deploy.yml** para entender el flujo

#### 💰 Ver costos?
→ **AWS_RESOURCES.md** (scripts) o **QUICK_REFERENCE.md** (comando rápido)

#### 🐛 Resolver un problema?
1. **PROJECT_INSTRUCTIONS.md** > Troubleshooting
2. **QUICK_REFERENCE.md** > Health Checks
3. Logs de EC2 o Docker

#### 📚 Entender el proyecto completo?
→ **PROJECT_INSTRUCTIONS.md** (leer completo)

#### ⚡ Necesitas algo rápido?
→ **QUICK_REFERENCE.md** (siempre)

---

## 🎓 ORDEN DE LECTURA RECOMENDADO

### Para Nuevo Desarrollador
1. **README.md** (5 min) - Overview
2. **PROJECT_INSTRUCTIONS.md** (30-45 min) - Completo
3. **DESIGN_REFERENCE.md** (15 min) - Sistema de diseño
4. **QUICK_REFERENCE.md** (10 min) - Comandos

### Para Deployment
1. **SETUP_COMPLETE.md** (10 min) - Checklist
2. **MIGRATION_GUIDE.md** (15 min) - Base de datos
3. **AWS_RESOURCES.md** (10 min) - Infraestructura

### Para Operaciones
1. **QUICK_REFERENCE.md** (bookmark)
2. **AWS_RESOURCES.md** (monitoreo)

---

## 🔄 MANTENIMIENTO DE DOCS

### Actualizar cuando:
- ✏️ Cambios en infraestructura AWS → **AWS_RESOURCES.md**, **QUICK_REFERENCE.md**
- ✏️ Nuevas tablas en BD → **supabase-migration.sql**, **PROJECT_INSTRUCTIONS.md**
- ✏️ Cambios en diseño → **DESIGN_REFERENCE.md**
- ✏️ Nuevos comandos frecuentes → **QUICK_REFERENCE.md**
- ✏️ Cambios en CI/CD → **.github/workflows/deploy.yml**, **PROJECT_INSTRUCTIONS.md**

---

## 📞 CONTACTO Y RECURSOS

- **GitHub**: https://github.com/cmaldonado98/wedding-ed-game
- **App**: http://54.208.89.87
- **AWS Console**: https://console.aws.amazon.com/ec2
- **Supabase**: https://supabase.com/dashboard
- **Proyecto Principal**: https://github.com/cmaldonado98/wedding-esteban-dany

---

**Última actualización**: 2026-01-29  
**Mantenido por**: Carlos Maldonado  
**Versión de docs**: 1.0
