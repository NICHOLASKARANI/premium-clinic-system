'use client'

import { useState, useEffect } from 'react'
import Link from 'next/link'

export default function PatientsListPage() {
  const [patients, setPatients] = useState([])
  const [loading, setLoading] = useState(true)

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
          query: \
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
          \
        })
      })
      const data = await response.json()
      if (data.data) {
        setPatients(data.data.patients?.patients || [])
      }
    } catch (error) {
      console.error('Error:', error)
    } finally {
      setLoading(false)
    }
  }

  return (
    <div className="max-w-7xl mx-auto px-4 py-8">
      <div className="flex justify-between items-center mb-6">
        <h1 className="text-3xl font-bold text-gray-800">Patients</h1>
        <Link href="/patients/new">
          <button className="bg-blue-600 text-white px-4 py-2 rounded-lg">
            + Add Patient
          </button>
        </Link>
      </div>

      <div className="bg-white rounded-xl shadow-lg overflow-hidden">
        {loading ? (
          <div className="text-center py-8">Loading...</div>
        ) : patients.length === 0 ? (
          <div className="text-center py-8">
            <p>No patients found. Click "Add Patient" to get started.</p>
          </div>
        ) : (
          <table className="w-full">
            <thead className="bg-gray-50">
              <tr>
                <th className="px-6 py-3 text-left">Name</th>
                <th className="px-6 py-3 text-left">Email</th>
                <th className="px-6 py-3 text-left">Phone</th>
              </tr>
            </thead>
            <tbody>
              {patients.map((patient: any) => (
                <tr key={patient.id} className="border-t">
                  <td className="px-6 py-4">{patient.firstName} {patient.lastName}</td>
                  <td className="px-6 py-4">{patient.email || '—'}</td>
                  <td className="px-6 py-4">{patient.phone}</td>
                </tr>
              ))}
            </tbody>
          </table>
        )}
      </div>
    </div>
  )
}
