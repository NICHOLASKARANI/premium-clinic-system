'use client'

import { useState, useEffect } from 'react'
import Link from 'next/link'

export default function Dashboard() {
  const [patients, setPatients] = useState<any[]>([])
  const [loading, setLoading] = useState(true)
  const [apiStatus, setApiStatus] = useState('checking')

  const API_URL = 'https://clinic-backend-1dxu.onrender.com'

  useEffect(() => {
    checkAPI()
    fetchPatients()
  }, [])

  const checkAPI = async () => {
    try {
      const response = await fetch(`${API_URL}/health`)
      if (response.ok) {
        setApiStatus('connected')
      } else {
        setApiStatus('error')
      }
    } catch (error) {
      setApiStatus('error')
    }
  }

  const fetchPatients = async () => {
    try {
      const response = await fetch(`${API_URL}/graphql`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          query: `
            query {
              patients {
                patients {
                  id
                  firstName
                  lastName
                  email
                  phone
                }
              }
            }
          `
        })
      })
      const data = await response.json()
      if (data.data) {
        setPatients(data.data.patients?.patients || [])
      }
    } catch (error) {
      console.error('Error fetching patients:', error)
    } finally {
      setLoading(false)
    }
  }

  return (
    <div className="min-h-screen bg-gray-100">
      <nav className="bg-white shadow-lg">
        <div className="max-w-7xl mx-auto px-4">
          <div className="flex justify-between h-16">
            <div className="flex items-center">
              <h1 className="text-xl font-bold text-blue-600">🏥 Clinic Management System</h1>
            </div>
            <div className="flex items-center space-x-4">
              <Link href="/dashboard" className="text-gray-700 hover:text-blue-600 px-3 py-2 rounded-md font-medium">
                Dashboard
              </Link>
              <Link href="/patients" className="text-gray-700 hover:text-blue-600 px-3 py-2 rounded-md">
                Patients
              </Link>
              <Link href="/appointments" className="text-gray-700 hover:text-blue-600 px-3 py-2 rounded-md">
                Appointments
              </Link>
            </div>
          </div>
        </div>
      </nav>

      <div className="max-w-7xl mx-auto px-4 py-8">
        <div className={`mb-6 p-4 rounded-lg ${
          apiStatus === 'connected' ? 'bg-green-100 text-green-700 border border-green-200' : 
          apiStatus === 'error' ? 'bg-red-100 text-red-700 border border-red-200' : 
          'bg-yellow-100 text-yellow-700 border border-yellow-200'
        }`}>
          {apiStatus === 'connected' && '✅ Backend Connected Successfully'}
          {apiStatus === 'error' && '⚠️ Backend Connection Issue'}
          {apiStatus === 'checking' && '🔄 Checking Backend Connection...'}
        </div>

        <div className="grid grid-cols-1 md:grid-cols-4 gap-6 mb-8">
          <div className="bg-white rounded-lg shadow p-6">
            <h3 className="text-gray-500 text-sm font-medium">Total Patients</h3>
            <p className="text-3xl font-bold text-gray-800 mt-2">{loading ? '...' : patients.length}</p>
          </div>
          <div className="bg-white rounded-lg shadow p-6">
            <h3 className="text-gray-500 text-sm font-medium">Appointments Today</h3>
            <p className="text-3xl font-bold text-gray-800 mt-2">0</p>
          </div>
          <div className="bg-white rounded-lg shadow p-6">
            <h3 className="text-gray-500 text-sm font-medium">Active Prescriptions</h3>
            <p className="text-3xl font-bold text-gray-800 mt-2">0</p>
          </div>
          <div className="bg-white rounded-lg shadow p-6">
            <h3 className="text-gray-500 text-sm font-medium">Revenue (MTD)</h3>
            <p className="text-3xl font-bold text-gray-800 mt-2">$0</p>
          </div>
        </div>

        <div className="bg-white rounded-lg shadow">
          <div className="px-6 py-4 border-b flex justify-between items-center">
            <h2 className="text-xl font-semibold text-gray-800">Recent Patients</h2>
            <button 
              onClick={() => alert('Add Patient feature coming soon!')}
              className="bg-blue-600 text-white px-4 py-2 rounded-lg hover:bg-blue-700"
            >
              + Add Patient
            </button>
          </div>
          <div className="overflow-x-auto">
            <table className="w-full">
              <thead className="bg-gray-50">
                <tr>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Name</th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Email</th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Phone</th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Actions</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-gray-200">
                {loading ? (
                  <tr>
                    <td colSpan={4} className="px-6 py-4 text-center text-gray-500">Loading patients...</td>
                  </tr>
                ) : patients.length === 0 ? (
                  <tr>
                    <td colSpan={4} className="px-6 py-4 text-center text-gray-500">
                      No patients yet. Click "Add Patient" to create your first patient!
                    </td>
                  </tr>
                ) : (
                  patients.map((patient) => (
                    <tr key={patient.id} className="hover:bg-gray-50">
                      <td className="px-6 py-4 font-medium text-gray-900">{patient.firstName} {patient.lastName}</td>
                      <td className="px-6 py-4 text-gray-600">{patient.email || '—'}</td>
                      <td className="px-6 py-4 text-gray-600">{patient.phone}</td>
                      <td className="px-6 py-4">
                        <button className="text-blue-600 hover:text-blue-800">View</button>
                      </td>
                    </tr>
                  ))
                )}
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
  )
}
