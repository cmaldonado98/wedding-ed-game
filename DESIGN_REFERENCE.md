# 🎨 REFERENCIA RÁPIDA DE DISEÑO

## 🎨 Paleta de Colores

```css
/* Copiar y pegar en tu código */

/* === COLORES PRINCIPALES === */
--wedding-primary: #C6754D;    /* Marrón cálido - Color principal */
--wedding-rose: #f5cbcc;        /* Rosa suave - Femenino */
--wedding-lavender: #d1c1d9;    /* Lavanda - Elegante */
--wedding-purple: #9579B4;      /* Púrpura - Acentos */
--wedding-beige: #F1DBD0;       /* Beige - Suave */
--wedding-sage: #ADB697;        /* Verde salvia - Natural */
--wedding-forest: #4D5D53;      /* Verde bosque - Profundo */

/* === COLORES NEUTROS === */
--neutral-bg: #FCF9F7;          /* Fondo principal - Crema muy claro */
--neutral-text: #2B1105;        /* Texto principal - Marrón oscuro */
--cream-bg: #fbf8f0;            /* Fondo alternativo - Crema */

/* === COLORES DE SUPERFICIE === */
--background-light: #F9F7F2;    /* Fondo claro general */
--surface-light: #FFFFFF;       /* Tarjetas y superficies */
--text-main-light: #1C1C1E;     /* Texto principal oscuro */
--text-muted-light: #8E8E93;    /* Texto secundario */

/* === ACENTOS === */
--accent-lavender: #E6E6FA;     /* Lavanda claro - Backgrounds */
--highlight-lavender: #d3c3db;  /* Lavanda highlight - Badges */
--lavender-border: #D3CDE6;     /* Bordes lavanda */
```

---

## 🖼️ Uso de Colores por Contexto

### Fondos
```css
/* Fondo principal de página */
background-color: var(--neutral-bg);         /* #FCF9F7 */

/* Tarjetas y cards */
background-color: var(--surface-light);      /* #FFFFFF */

/* Sections alternadas */
background-color: var(--cream-bg);           /* #fbf8f0 */

/* Highlights suaves */
background-color: var(--accent-lavender);    /* #E6E6FA */
```

### Textos
```css
/* Título principal */
color: var(--neutral-text);                  /* #2B1105 */

/* Texto normal */
color: var(--text-main-light);               /* #1C1C1E */

/* Texto secundario/muted */
color: var(--text-muted-light);              /* #8E8E93 */
```

### Botones y CTAs
```css
/* Botón primario */
background-color: var(--wedding-primary);    /* #C6754D */
color: #FFFFFF;

/* Botón secundario */
background-color: var(--wedding-purple);     /* #9579B4 */
color: #FFFFFF;

/* Botón suave */
background-color: var(--wedding-lavender);   /* #d1c1d9 */
color: var(--neutral-text);
```

### Bordes y Divisores
```css
border-color: var(--lavender-border);        /* #D3CDE6 */
border-color: var(--wedding-beige);          /* #F1DBD0 */
```

### Badges y Tags
```css
background-color: var(--highlight-lavender); /* #d3c3db */
color: var(--neutral-text);
```

---

## 🔤 Tipografía

### Fuentes por Uso

```typescript
// Importar en layout.tsx
import { Inter, Playfair_Display, Noto_Serif, Noto_Sans } from 'next/font/google'

const inter = Inter({ 
  subsets: ['latin'], 
  variable: '--font-inter',
  display: 'swap' 
})

const playfair = Playfair_Display({ 
  subsets: ['latin'], 
  variable: '--font-playfair',
  display: 'swap' 
})

const notoSerif = Noto_Serif({ 
  subsets: ['latin'], 
  variable: '--font-noto-serif',
  display: 'swap' 
})

const notoSans = Noto_Sans({ 
  subsets: ['latin'], 
  variable: '--font-noto-sans',
  display: 'swap' 
})
```

### Clases Tailwind de Fuentes

```html
<!-- Títulos principales (h1, h2) -->
<h1 className="font-montaga text-4xl">Título Principal</h1>

<!-- Subtítulos elegantes -->
<h2 className="font-serif text-3xl">Subtítulo Serif</h2>

<!-- Títulos modernos -->
<h3 className="font-display text-2xl">Título Display</h3>

<!-- Texto de cuerpo -->
<p className="font-body text-base">Texto de párrafo</p>

<!-- Texto general -->
<p className="font-sans text-base">Texto Sans Serif</p>
```

### Tamaños de Texto

```html
<!-- Extra grande - Heros -->
<h1 className="text-5xl lg:text-6xl">Hero Title</h1>

<!-- Grande - Títulos principales -->
<h2 className="text-4xl lg:text-5xl">Page Title</h2>

<!-- Mediano - Subtítulos -->
<h3 className="text-2xl lg:text-3xl">Section Title</h3>

<!-- Normal - Cuerpo -->
<p className="text-base lg:text-lg">Body Text</p>

<!-- Pequeño - Secondary -->
<span className="text-sm">Small Text</span>

<!-- Extra pequeño - Captions -->
<span className="text-xs">Caption</span>
```

---

## 🎨 Componentes de Ejemplo

### Card con Estilo de Boda

```tsx
<div className="bg-surface-light rounded-lg shadow-lg p-6 border-2 border-lavender-border">
  <div className="flex items-center gap-4">
    <div className="w-12 h-12 rounded-full bg-accent-lavender flex items-center justify-center">
      <span className="text-2xl">🎮</span>
    </div>
    <div>
      <h3 className="font-montaga text-xl text-neutral-text">Título</h3>
      <p className="font-body text-sm text-text-muted-light">Descripción</p>
    </div>
  </div>
</div>
```

### Botón Primario

```tsx
<button className="bg-wedding-primary hover:bg-wedding-forest text-white font-body px-6 py-3 rounded-lg transition-colors duration-200 shadow-md hover:shadow-lg">
  Comprar Ahora
</button>
```

### Botón Secundario (Lavanda)

```tsx
<button className="bg-wedding-lavender hover:bg-wedding-purple text-neutral-text hover:text-white font-body px-6 py-3 rounded-lg transition-all duration-200">
  Ver Detalles
</button>
```

### Badge

```tsx
<span className="inline-flex items-center px-3 py-1 rounded-full text-xs font-body bg-highlight-lavender text-neutral-text">
  Nuevo
</span>
```

### Input con Estilo de Boda

```tsx
<input
  type="text"
  className="w-full px-4 py-3 border-2 border-lavender-border rounded-lg focus:outline-none focus:border-wedding-purple transition-colors bg-surface-light text-neutral-text font-body"
  placeholder="Ingresa tu email"
/>
```

### Coin Balance Display

```tsx
<div className="flex items-center gap-2 bg-gradient-to-r from-wedding-rose to-wedding-lavender p-4 rounded-lg">
  <span className="text-3xl">💰</span>
  <div>
    <p className="text-sm font-body text-text-muted-light">Balance</p>
    <p className="text-2xl font-montaga text-neutral-text">1,250 coins</p>
  </div>
</div>
```

### Progress Bar

```tsx
<div className="w-full bg-accent-lavender rounded-full h-2 overflow-hidden">
  <div 
    className="bg-gradient-to-r from-wedding-purple to-wedding-rose h-full transition-all duration-300"
    style={{ width: '65%' }}
  />
</div>
```

---

## 🎨 Gradientes Recomendados

```css
/* Gradiente principal (rosa a lavanda) */
background: linear-gradient(135deg, #f5cbcc 0%, #d1c1d9 100%);

/* Gradiente suave (beige a lavanda) */
background: linear-gradient(135deg, #F1DBD0 0%, #E6E6FA 100%);

/* Gradiente vibrante (púrpura a rosa) */
background: linear-gradient(135deg, #9579B4 0%, #f5cbcc 100%);

/* Gradiente natural (sage a forest) */
background: linear-gradient(135deg, #ADB697 0%, #4D5D53 100%);

/* Overlay oscuro */
background: linear-gradient(180deg, rgba(0,0,0,0.3) 0%, rgba(0,0,0,0.7) 100%);
```

### Clases Tailwind de Gradientes

```html
<!-- Rosa a Lavanda -->
<div className="bg-gradient-to-r from-wedding-rose to-wedding-lavender">

<!-- Púrpura a Rosa -->
<div className="bg-gradient-to-br from-wedding-purple to-wedding-rose">

<!-- Sage a Forest -->
<div className="bg-gradient-to-b from-wedding-sage to-wedding-forest">

<!-- Texto con gradiente -->
<h1 className="bg-gradient-to-r from-wedding-primary via-wedding-purple to-wedding-rose bg-clip-text text-transparent">
  Título con Gradiente
</h1>
```

---

## 🌟 Efectos y Sombras

```css
/* Sombras suaves */
box-shadow: 0 2px 8px rgba(43, 17, 5, 0.1);           /* Sombra sutil */
box-shadow: 0 4px 12px rgba(149, 121, 180, 0.15);    /* Sombra lavanda */
box-shadow: 0 8px 24px rgba(198, 117, 77, 0.2);      /* Sombra primary */

/* Tailwind shadows con colores de boda */
<div className="shadow-lg shadow-wedding-lavender/20">
<div className="shadow-xl shadow-wedding-purple/30">
```

### Hover Effects

```tsx
/* Elevación al hover */
<div className="transition-all duration-300 hover:shadow-xl hover:-translate-y-1">

/* Scale al hover */
<button className="transition-transform duration-200 hover:scale-105">

/* Brillo al hover */
<div className="transition-all duration-300 hover:brightness-110">
```

---

## 📱 Responsive Breakpoints

```css
/* Mobile First */
.container {
  /* Base: Mobile */
  padding: 1rem;
}

/* sm: >= 640px */
@media (min-width: 640px) {
  .container { padding: 1.5rem; }
}

/* md: >= 768px */
@media (min-width: 768px) {
  .container { padding: 2rem; }
}

/* lg: >= 1024px */
@media (min-width: 1024px) {
  .container { padding: 3rem; }
}

/* xl: >= 1280px */
@media (min-width: 1280px) {
  .container { padding: 4rem; }
}
```

### Tailwind Responsive Classes

```html
<!-- Padding responsive -->
<div className="p-4 md:p-6 lg:p-8 xl:p-10">

<!-- Text size responsive -->
<h1 className="text-3xl md:text-4xl lg:text-5xl xl:text-6xl">

<!-- Grid responsive -->
<div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">

<!-- Flex direction responsive -->
<div className="flex flex-col md:flex-row gap-4">
```

---

## 🎯 Checklist de Consistencia

Al crear un componente nuevo, asegúrate de:

- ✅ Usar fuentes del sistema (`font-montaga`, `font-body`, `font-serif`)
- ✅ Usar colores de la paleta de boda (variables CSS o Tailwind)
- ✅ Aplicar sombras suaves con opacidad
- ✅ Añadir transiciones suaves (duration-200 o duration-300)
- ✅ Mantener bordes redondeados consistentes (rounded-lg)
- ✅ Usar espaciado consistente (gap-4, p-4, p-6)
- ✅ Implementar estados hover interactivos
- ✅ Hacer responsive con breakpoints apropiados
- ✅ Mantener contraste accesible (WCAG AA mínimo)

---

## 🎨 Ejemplos de Páginas Completas

### Landing Page

```tsx
<div className="min-h-screen bg-gradient-to-br from-neutral-bg via-accent-lavender to-cream-bg">
  <div className="container mx-auto px-4 py-12">
    <h1 className="font-montaga text-5xl lg:text-6xl text-center text-neutral-text mb-8">
      Wedding Game
    </h1>
    <p className="font-body text-lg text-text-muted-light text-center max-w-2xl mx-auto">
      Sistema de gamificación para la boda de Esteban & Dany
    </p>
  </div>
</div>
```

### Shop Card

```tsx
<div className="bg-surface-light rounded-xl shadow-lg overflow-hidden border border-lavender-border hover:shadow-xl transition-all duration-300 hover:-translate-y-1">
  <img src="..." alt="..." className="w-full h-48 object-cover" />
  <div className="p-6">
    <span className="inline-block px-3 py-1 rounded-full text-xs font-body bg-highlight-lavender text-neutral-text mb-3">
      VIP
    </span>
    <h3 className="font-montaga text-2xl text-neutral-text mb-2">
      Ticket VIP
    </h3>
    <p className="font-body text-text-muted-light mb-4">
      Acceso ilimitado a la barra premium
    </p>
    <div className="flex items-center justify-between">
      <span className="font-body text-2xl text-wedding-primary">
        500 💰
      </span>
      <button className="bg-wedding-primary hover:bg-wedding-forest text-white px-4 py-2 rounded-lg transition-colors">
        Comprar
      </button>
    </div>
  </div>
</div>
```

---

**Nota**: Esta guía está basada en el diseño del proyecto principal `wedding-esteban-dany` para mantener consistencia visual entre ambas aplicaciones.
