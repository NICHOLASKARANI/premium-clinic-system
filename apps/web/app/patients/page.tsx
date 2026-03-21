'use client'

import { useState, useEffect } from 'react'
import Link from 'next/link'
import { Search, Edit, Trash2, UserPlus } from 'lucide-react'

export default function PatientsListPage() {
  const [patients, setPatients] = useState([])
  const [loading, setLoading] = useState(true)
  const [searchTerm, setSearchTerm] = useState('')

  const API_URL = 'https://clinic-backend-1dxu.onrender.com'

  useEffect(() => {
    fetchPatients()
  }, [])

  const fetchPatients = async () => {
    try {
      const response = await fetch(API_URL + '/graphql', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          query: 
            query {
              patients {
                patients {
                  id
                  firstName
                  lastName
                  email
                  phone
                  dateOfBirth
                  gender
                }
              }
            }
          
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

  const filteredPatients = patients.filter(patient =>
    (patient.firstName + ' ' + patient.lastName).toLowerCase().includes(searchTerm.toLowerCase()) ||
    (patient.email || '').toLowerCase().includes(searchTerm.toLowerCase()) ||
    patient.phone.includes(searchTerm)
  )

  return (
    <div className="max-w-7xl mx-auto px-4 py-8">
      <div className="flex justify-between items-center mb-6">
        <div>
          <h1 className="text-3xl font-bold text-gray-800">Patients</h1>
          <p className="text-gray-600 mt-2">Manage your patient records</p>
        </div>
        <Link href="/patients/new">
          <button className="bg-gradient-to-r from-blue-500 to-blue-600 text-white px-4 py-2 rounded-lg hover:from-blue-600 hover:to-blue-700 transition-all flex items-center space-x-2">
            <UserPlus className="w-5 h-5" />
            <span>Add Patient</span>
          </button>
        </Link>
      </div>

      <div className="bg-white rounded-xl shadow-lg p-6 mb-6">
        <div className="relative">
          <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400 w-5 h-5" />
          <input
            type="text"
            placeholder="Search patients by name, email, or phone..."
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
            className="w-full pl-10 pr-4 py-2 border border-gray-300 rounded-lg focus:ring-blue-500 focus:border-blue-500"
          />
        </div>
      </div>

      <div className="bg-white rounded-xl shadow-lg overflow-hidden">
        {loading ? (
          <div className="text-center py-8 text-gray-500">Loading patients...</div>
        ) : filteredPatients.length === 0 ? (
          <div className="text-center py-8">
            <p className="text-gray-500 mb-4">No patients found.</p>
            <Link href="/patients/new">
              <button className="bg-blue-600 text-white px-4 py-2 rounded-lg">Add Your First Patient</button>
            </Link>
          </div>
        ) : (
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
                {filteredPatients.map((patient) => (
                  <tr key={patient.id} className="hover:bg-gray-50">
                    <td className="px-6 py-4 font-medium text-gray-900">
                      {patient.firstName} {patient.lastName}
                    </td>
                    <td className="px-6 py-4 text-gray-600">{patient.email || '—'}</td>
                    <td className="px-6 py-4 text-gray-600">{patient.phone}</td>
                    <td className="px-6 py-4">
                      <Link href={/patients//edit}>
                        <button className="text-blue-600 hover:text-blue-800 mr-3">
                          <Edit className="w-5 h-5" />
                        </button>
                      </Link>
                      <button className="text-red-600 hover:text-red-800">
                        <Trash2 className="w-5 h-5" />
                      </button>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}
      </div>
    </div>
  )
}
