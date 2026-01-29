export default function HomePage() {
  return (
    <main className="min-h-screen flex items-center justify-center bg-gradient-to-br from-rose-100 via-pink-100 to-purple-100">
      <div className="text-center space-y-12 p-8 max-w-4xl mx-auto">
        {/* Encabezado Principal */}
        <div className="space-y-6">
          <div className="text-8xl mb-6 animate-bounce">
            🎊
          </div>
          
          <h1 className="font-['Playfair_Display',serif] text-7xl md:text-8xl font-bold bg-gradient-to-r from-rose-600 via-pink-600 to-purple-600 bg-clip-text text-transparent leading-tight">
            Bienvenidos
          </h1>
          
          <div className="space-y-4">
            <p className="font-['Montaga',serif] text-4xl md:text-5xl text-gray-800">
              a la Tienda de la Fiesta
            </p>
            <p className="font-['Playfair_Display',serif] text-5xl md:text-6xl font-bold text-transparent bg-clip-text bg-gradient-to-r from-pink-500 to-purple-500">
              Esteban & Dany
            </p>
          </div>
        </div>

        {/* Mensaje de bienvenida */}
        <div className="bg-white/80 backdrop-blur-sm rounded-2xl shadow-2xl p-8 border-2 border-pink-200">
          <div className="flex items-center justify-center gap-3 mb-4">
            <span className="text-4xl">🛍️</span>
            <span className="text-4xl">💝</span>
            <span className="text-4xl">🎉</span>
          </div>
          <p className="text-2xl text-gray-700 font-['Noto_Serif',serif] leading-relaxed">
            Pronto podrás disfrutar de nuestra tienda virtual
          </p>
          <p className="text-lg text-gray-600 mt-4">
            Juegos, premios y diversión en nuestra boda
          </p>
        </div>

        {/* Footer */}
        <div className="pt-8 space-y-2 text-gray-500">
          <p className="flex items-center justify-center gap-2">
            <span>💻</span>
            <span>Desplegado en AWS EC2</span>
          </p>
          <p className="flex items-center justify-center gap-2">
            <span>🚀</span>
            <span>CI/CD con GitHub Actions</span>
          </p>
        </div>
      </div>
    </main>
  );
}
