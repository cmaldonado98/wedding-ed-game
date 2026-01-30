# Wedding Game - Esteban & Dany

Sistema de gamificación para la boda de Esteban y Dany desplegado en AWS con CI/CD automatizado.

## 🏗️ Arquitectura

### Stack Tecnológico

- **Frontend/Backend**: Next.js 16.1.0 (App Router) + React 19
- **Base de Datos**: Supabase (PostgreSQL)
- **Estilos**: Tailwind CSS
- **Infraestructura**: AWS EC2 (t4g.nano ARM64)
- **Contenedores**: Docker + Docker Compose
- **Reverse Proxy**: Nginx
- **CI/CD**: GitHub Actions

### Diagrama de Arquitectura

```
┌─────────────────────────────────────────────────────────────┐
│                     GitHub Repository                        │
│                   (wedding-ed-game)                          │
└────────────────────┬────────────────────────────────────────┘
                     │ git push main
                     ▼
┌─────────────────────────────────────────────────────────────┐
│                   GitHub Actions                             │
│  ┌──────────────────────────────────────────────────────┐  │
│  │ 1. Build Docker Image (multi-platform: amd64/arm64)  │  │
│  │    - Build Next.js app with Supabase env vars       │  │
│  │    - Cache with GitHub Actions cache                │  │
│  │    - Push to GitHub Container Registry (ghcr.io)    │  │
│  └──────────────────────────────────────────────────────┘  │
│  ┌──────────────────────────────────────────────────────┐  │
│  │ 2. Deploy to EC2                                     │  │
│  │    - SSH to EC2 instance                            │  │
│  │    - Pull latest Docker image from ghcr.io          │  │
│  │    - Update .env file                               │  │
│  │    - docker-compose down && up -d                   │  │
│  └──────────────────────────────────────────────────────┘  │
└────────────────────┬────────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────────┐
│              AWS EC2 (t4g.nano ARM64)                        │
│              IP: 54.208.89.87                                │
│  ┌──────────────────────────────────────────────────────┐  │
│  │ Nginx (Port 80)                                      │  │
│  │   ↓ reverse proxy                                    │  │
│  │ Docker Container (Port 3000)                         │  │
│  │   - Next.js App (Production)                         │  │
│  │   - Image: ghcr.io/cmaldonado98/wedding-ed-game     │  │
│  └──────────────────────────────────────────────────────┘  │
└────────────────────┬────────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────────┐
│                    Supabase Cloud                            │
│              (PostgreSQL Database)                           │
└─────────────────────────────────────────────────────────────┘
```

## 🚀 Deployment Flow

1. **Developer Push**: Código se pushea a branch `main`
2. **GitHub Actions**: 
   - Construye imagen Docker multi-platform (~3-4 min)
   - Pushea a GitHub Container Registry (público)
3. **EC2 Deployment**:
   - Pull de imagen pre-construida (~30 seg)
   - Restart de container (~10 seg)
4. **Total**: ~4-5 minutos por deployment

## 🔧 Configuración Local

### Requisitos

- Node.js 20+
- npm o yarn
- Docker (opcional)

### Variables de Entorno

Crear archivo `.env` en la raíz:

```env
# Supabase Configuration
NEXT_PUBLIC_SUPABASE_URL=your_supabase_url
NEXT_PUBLIC_SUPABASE_ANON_KEY=your_supabase_anon_key
SUPABASE_SERVICE_ROLE_KEY=your_service_role_key
SUPABASE_PROJECT_ID=your_project_id

# App Configuration
NEXT_PUBLIC_APP_URL=http://localhost:3000
```

### Instalación y Ejecución

```bash
# Instalar dependencias
npm install

# Modo desarrollo
npm run dev

# Build de producción
npm run build
npm start

# Con Docker
docker-compose up -d
```

## 🔐 GitHub Secrets Requeridos

Para el CI/CD, configurar en GitHub → Settings → Secrets:

- `EC2_SSH_KEY`: Clave privada SSH para acceder a EC2
- `SUPABASE_URL`: URL de tu proyecto Supabase
- `SUPABASE_ANON_KEY`: Clave anónima de Supabase
- `SUPABASE_SERVICE_ROLE_KEY`: Clave de servicio de Supabase

## 📦 Estructura del Proyecto

```
wedding-ed-game/
├── app/                    # Next.js App Router
│   ├── globals.css        # Estilos globales
│   ├── layout.tsx         # Layout principal
│   └── page.tsx           # Página de bienvenida
├── public/                # Assets estáticos
├── .github/
│   └── workflows/
│       └── deploy.yml     # GitHub Actions workflow
├── docker-compose.yml     # Configuración Docker Compose
├── Dockerfile             # Imagen Docker multi-stage
├── next.config.js         # Configuración Next.js
├── tailwind.config.ts     # Configuración Tailwind
├── package.json           # Dependencias del proyecto
└── AWS_RESOURCES.md       # Recursos de AWS (IDs, IPs, etc.)
```

## 🐳 Docker

### Multi-Stage Build

El Dockerfile usa 4 stages:
1. **base**: Node.js 20 Alpine
2. **deps**: Instalación de dependencias
3. **builder**: Build de Next.js con variables de entorno
4. **runner**: Imagen final optimizada (~70MB)

### Multi-Platform Support

La imagen se construye para:
- `linux/amd64` (x86_64)
- `linux/arm64` (ARM, para EC2 t4g.nano)

## 🌐 Infraestructura AWS

Ver [AWS_RESOURCES.md](./AWS_RESOURCES.md) para detalles completos de la infraestructura.

### Resumen:
- **Instancia**: EC2 t4g.nano (ARM64, 512MB RAM, 10GB EBS)
- **Región**: us-east-1
- **OS**: Ubuntu 22.04 LTS
- **Red**: VPC default, subnet pública
- **Almacenamiento**: Swap de 2GB configurado

## 🔄 Optimizaciones

### Build Multi-Platform
- Build en GitHub Actions (servidores potentes)
- No build en EC2 (instancia pequeña)
- Cache de layers de Docker

### Nginx Reverse Proxy
- Puerto 80 → Nginx → Container:3000
- Headers de proxy configurados
- Sin conflictos de puertos

### Memoria Limitada
- Swap de 2GB en EC2
- Docker image optimizada
- Output standalone de Next.js

## 📊 Métricas

- **Tiempo de Build**: ~3-4 min (GitHub Actions)
- **Tiempo de Deploy**: ~30-40 seg (EC2)
- **Tamaño de Imagen**: ~70MB (comprimida)
- **Memoria en Uso**: ~250-300MB (container)

## 🔗 Enlaces

- **App en Producción**: http://54.208.89.87
- **Repositorio**: https://github.com/cmaldonado98/wedding-ed-game
- **Docker Registry**: ghcr.io/cmaldonado98/wedding-ed-game

## 📝 Notas Técnicas

- La instancia EC2 usa arquitectura ARM64 (t4g.nano)
- El build multi-platform es necesario para compatibilidad
- GitHub Container Registry está configurado como público
- El workflow de GitHub Actions tiene permisos de `packages: write`
- Nginx actúa como reverse proxy en puerto 80
