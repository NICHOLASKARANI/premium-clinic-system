'use client'

import { useState, useEffect } from 'react'
import Link from 'next/link'

export default function AppointmentsPage() {
  const [appointments, setAppointments] = useState([])
  const [loading, setLoading] = useState(true)

  const API_URL = 'https://clinic-backend-1dxu.onrender.com'

  useEffect(() => {
    fetchAppointments()
  }, [])

  const fetchAppointments = async () => {
    try {
      const query = 'query { appointments { appointments { id patient { firstName lastName } startTime status type } } }'
      const response = await fetch(API_URL + '/graphql', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ query })
      })
      const data = await response.json()
      if (data.data) {
        setAppointments(data.data.appointments?.appointments || [])
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
        <h1 className="text-3xl font-bold text-gray-800">Appointments</h1>
        <Link href="/appointments/new">
          <button className="bg-green-600 text-white px-4 py-2 rounded-lg">
            + New Appointment
          </button>
        </Link>
      </div>

      <div className="bg-white rounded-xl shadow-lg overflow-hidden">
        {loading ? (
          <div className="text-center py-8">Loading appointments...</div>
        ) : appointments.length === 0 ? (
          <div className="text-center py-8">
            <p>No appointments found. Click "New Appointment" to get started.</p>
          </div>
        ) : (
          <div className="divide-y">
            {appointments.map((apt: any) => (
              <div key={apt.id} className="p-6 hover:bg-gray-50">
                <div className="font-semibold">
                  {apt.patient?.firstName} {apt.patient?.lastName}
                </div>
                <div className="text-sm text-gray-600 mt-1">
                  {new Date(apt.startTime).toLocaleString()} - {apt.type}
                </div>
                <div className="text-sm mt-1">
                  <span className="px-2 py-1 bg-yellow-100 text-yellow-800 rounded-full text-xs">
                    {apt.status}
                  </span>
                </div>
              </div>
            ))}
          </div>
        )}
      </div>
    </div>
  )
}
