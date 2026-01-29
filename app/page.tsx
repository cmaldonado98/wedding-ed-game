export default function HomePage() {
  return (
    <main className="min-h-screen flex items-center justify-center bg-gradient-to-br from-pink-50 via-purple-50 to-blue-50">
      <div className="text-center space-y-8 p-8">
        <div className="space-y-4">
          <h1 className="text-6xl font-bold bg-gradient-to-r from-pink-600 via-purple-600 to-blue-600 bg-clip-text text-transparent">
            🎮 Wedding Game
          </h1>
          <p className="text-2xl text-gray-700">
            Esteban & Dany
          </p>
          <p className="text-gray-500 max-w-md mx-auto">
            Sistema de gamificación con login OTP, wallet de monedas y tienda virtual
          </p>
        </div>

        <div className="grid gap-4 max-w-lg mx-auto">
          <div className="bg-white rounded-lg shadow-lg p-6 border-2 border-purple-200">
            <div className="text-4xl mb-2">🔐</div>
            <h3 className="font-semibold text-lg mb-1">OTP Login</h3>
            <p className="text-sm text-gray-600">Acceso seguro via email</p>
          </div>

          <div className="bg-white rounded-lg shadow-lg p-6 border-2 border-pink-200">
            <div className="text-4xl mb-2">💰</div>
            <h3 className="font-semibold text-lg mb-1">Wallet</h3>
            <p className="text-sm text-gray-600">Sistema de monedas virtuales</p>
          </div>

          <div className="bg-white rounded-lg shadow-lg p-6 border-2 border-blue-200">
            <div className="text-4xl mb-2">🛍️</div>
            <h3 className="font-semibold text-lg mb-1">Shop</h3>
            <p className="text-sm text-gray-600">Tickets, passes y VIP access</p>
          </div>

          <div className="bg-white rounded-lg shadow-lg p-6 border-2 border-green-200">
            <div className="text-4xl mb-2">📱</div>
            <h3 className="font-semibold text-lg mb-1">QR Codes</h3>
            <p className="text-sm text-gray-600">Generación y validación</p>
          </div>
        </div>

        <div className="pt-8 space-y-2 text-sm text-gray-500">
          <p>Desplegado en AWS EC2 t4g.nano</p>
          <p>Costo: $0.10/día | GitHub Actions CI/CD</p>
        </div>
      </div>
    </main>
  );
}
