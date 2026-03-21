export default function PharmacyPage() {
  const inventory = [
    { id: 1, name: 'Paracetamol 500mg', quantity: 450, price: 5.99 },
    { id: 2, name: 'Amoxicillin 250mg', quantity: 120, price: 12.99 }
  ]

  return (
    <div className="max-w-7xl mx-auto px-4 py-8">
      <div className="flex justify-between items-center mb-6">
        <h1 className="text-3xl font-bold text-gray-800">Pharmacy & Inventory</h1>
        <button className="bg-blue-600 text-white px-4 py-2 rounded-lg">+ Add Item</button>
      </div>

      <div className="bg-yellow-50 border border-yellow-200 rounded-xl p-4 mb-6">
        <p className="text-yellow-800">⚠️ Low Stock Alert: 2 items need reorder</p>
      </div>

      <div className="bg-white rounded-xl shadow-lg overflow-hidden">
        <table className="w-full">
          <thead className="bg-gray-50">
            <tr>
              <th className="px-6 py-3 text-left">Item Name</th>
              <th className="px-6 py-3 text-left">Quantity</th>
              <th className="px-6 py-3 text-left">Price</th>
            </tr>
          </thead>
          <tbody>
            {inventory.map((item) => (
              <tr key={item.id} className="border-t">
                <td className="px-6 py-4">{item.name}</td>
                <td className="px-6 py-4">{item.quantity} units</td>
                <td className="px-6 py-4"></td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  )
}
