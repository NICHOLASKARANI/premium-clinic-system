'use client'

import { useState } from 'react'
import { Search, Edit, Trash2, Plus, AlertTriangle } from 'lucide-react'

export default function PharmacyPage() {
  const [inventory] = useState([
    { id: 1, name: 'Paracetamol 500mg', quantity: 450, reorderLevel: 100, expiryDate: '2025-12-31', price: 5.99 },
    { id: 2, name: 'Amoxicillin 250mg', quantity: 120, reorderLevel: 50, expiryDate: '2025-10-15', price: 12.99 }
  ])

  return (
    <div className="max-w-7xl mx-auto px-4 py-8">
      <div className="flex justify-between items-center mb-8">
        <div>
          <h1 className="text-3xl font-bold text-gray-800">Pharmacy & Inventory</h1>
          <p className="text-gray-600 mt-2">Manage medications and supplies</p>
        </div>
        <button className="bg-blue-600 text-white px-4 py-2 rounded-lg hover:bg-blue-700 flex items-center space-x-2">
          <Plus className="w-5 h-5" />
          <span>Add Item</span>
        </button>
      </div>

      <div className="bg-yellow-50 border border-yellow-200 rounded-xl p-6 mb-6">
        <div className="flex items-center space-x-3">
          <AlertTriangle className="w-6 h-6 text-yellow-600" />
          <h3 className="font-semibold text-yellow-800">Low Stock Alert</h3>
        </div>
        <p className="text-yellow-700 mt-2">2 items need reorder</p>
      </div>

      <div className="bg-white rounded-xl shadow-lg overflow-hidden">
        <div className="overflow-x-auto">
          <table className="w-full">
            <thead className="bg-gray-50">
              <tr>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Item Name</th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Quantity</th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Price</th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Actions</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-gray-200">
              {inventory.map((item) => (
                <tr key={item.id}>
                  <td className="px-6 py-4">{item.name}</td>
                  <td className="px-6 py-4">{item.quantity} units</td>
                  <td className="px-6 py-4"></td>
                  <td className="px-6 py-4">
                    <button className="text-blue-600 hover:text-blue-800 mr-2">
                      <Edit className="w-5 h-5" />
                    </button>
                    <button className="text-red-600 hover:text-red-800">
                      <Trash2 className="w-5 h-5" />
                    </button>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>
    </div>
  )
}
