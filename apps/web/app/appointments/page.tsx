'use client'

import { useState, useEffect } from 'react'
import Link from 'next/link'
import { Calendar, Clock, Plus, Video, CheckCircle, XCircle } from 'lucide-react'

export default function AppointmentsPage() {
  const [appointments, setAppointments] = useState([])
  const [loading, setLoading] = useState(true)

  const API_URL = 'https://clinic-backend-1dxu.onrender.com'

  useEffect(() => {
    fetchAppointments()
  }, [])

  const fetchAppointments = async () => {
    try {
      const response = await fetch(API_URL + '/graphql', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          query: 
            query {
              appointments {
                appointments {
                  id
                  patient {
                    firstName
                    lastName
                  }
                  startTime
                  endTime
                  status
                  type
                  isTelehealth
                }
              }
            }
          
        })
      })
      const data = await response.json()
      if (data.data) {
        setAppointments(data.data.appointments?.appointments || [])
      }
    } catch (error) {
      console.error('Error fetching appointments:', error)
    } finally {
      setLoading(false)
    }
  }

  const getStatusColor = (status) => {
    switch (status) {
      case 'SCHEDULED': return 'bg-yellow-100 text-yellow-800'
      case 'CONFIRMED': return 'bg-green-100 text-green-800'
      case 'COMPLETED': return 'bg-blue-100 text-blue-800'
      case 'CANCELLED': return 'bg-red-100 text-red-800'
      default: return 'bg-gray-100 text-gray-800'
    }
  }

  return (
    <div className="max-w-7xl mx-auto px-4 py-8">
      <div className="flex justify-between items-center mb-8">
        <div>
          <h1 className="text-3xl font-bold text-gray-800">Appointments</h1>
          <p className="text-gray-600 mt-2">Schedule and manage patient appointments</p>
        </div>
        <Link href="/appointments/new">
          <button className="bg-gradient-to-r from-green-500 to-green-600 text-white px-4 py-2 rounded-lg hover:from-green-600 hover:to-green-700 transition-all flex items-center space-x-2">
            <Plus className="w-5 h-5" />
            <span>New Appointment</span>
          </button>
        </Link>
      </div>

      {loading ? (
        <div className="text-center py-8 text-gray-500">Loading appointments...</div>
      ) : appointments.length === 0 ? (
        <div className="bg-white rounded-xl shadow-lg p-12 text-center">
          <Calendar className="w-16 h-16 text-gray-400 mx-auto mb-4" />
          <h3 className="text-xl font-semibold text-gray-800 mb-2">No Appointments Yet</h3>
          <p className="text-gray-600 mb-6">Schedule your first appointment to get started</p>
          <Link href="/appointments/new">
            <button className="bg-green-600 text-white px-6 py-2 rounded-lg hover:bg-green-700">
              Schedule Appointment
            </button>
          </Link>
        </div>
      ) : (
        <div className="grid grid-cols-1 gap-4">
          {appointments.map((apt) => (
            <div key={apt.id} className="bg-white rounded-xl shadow-lg p-6 hover:shadow-xl transition-shadow">
              <div className="flex justify-between items-start">
                <div className="flex-1">
                  <div className="flex items-center space-x-3 mb-3">
                    <h3 className="text-lg font-semibold text-gray-800">
                      {apt.patient?.firstName} {apt.patient?.lastName}
                    </h3>
                    <span className={'px-2 py-1 text-xs font-medium rounded-full ' + getStatusColor(apt.status)}>
                      {apt.status}
                    </span>
                    {apt.isTelehealth && (
                      <span className="bg-purple-100 text-purple-800 px-2 py-1 text-xs font-medium rounded-full flex items-center space-x-1">
                        <Video className="w-3 h-3" />
                        <span>Telehealth</span>
                      </span>
                    )}
                  </div>
                  <div className="grid grid-cols-1 md:grid-cols-3 gap-4 text-sm">
                    <div className="flex items-center space-x-2 text-gray-600">
                      <Calendar className="w-4 h-4" />
                      <span>{new Date(apt.startTime).toLocaleDateString()}</span>
                    </div>
                    <div className="flex items-center space-x-2 text-gray-600">
                      <Clock className="w-4 h-4" />
                      <span>{new Date(apt.startTime).toLocaleTimeString()}</span>
                    </div>
                    <div className="flex items-center space-x-2 text-gray-600">
                      <span>Type: {apt.type}</span>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          ))}
        </div>
      )}
    </div>
  )
}
