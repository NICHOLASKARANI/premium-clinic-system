'use client'

import { useState } from 'react'
import { useRouter } from 'next/navigation'
import Link from 'next/link'

export default function NewAppointment() {
  const router = useRouter()
  const [loading, setLoading] = useState(false)
  const [formData, setFormData] = useState({
    patientId: '',
    startTime: '',
    type: 'Consultation',
    reason: ''
  })

  const API_URL = 'https://clinic-backend-1dxu.onrender.com'

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    setLoading(true)
    try {
      alert('Appointment scheduling coming soon!')
      router.push('/appointments')
    } catch (error) {
      console.error('Error:', error)
    } finally {
      setLoading(false)
    }
  }

  return (
    <div className="max-w-2xl mx-auto px-4 py-8">
      <div className="bg-white rounded-xl shadow-lg p-6">
        <h1 className="text-2xl font-bold mb-4">Schedule Appointment</h1>
        <form onSubmit={handleSubmit} className="space-y-4">
          <div>
            <label className="block text-sm font-medium mb-1">Patient ID</label>
            <input
              type="text"
              className="w-full border rounded-lg px-3 py-2"
              value={formData.patientId}
              onChange={(e) => setFormData({...formData, patientId: e.target.value})}
            />
          </div>
          <div>
            <label className="block text-sm font-medium mb-1">Date & Time</label>
            <input
              type="datetime-local"
              className="w-full border rounded-lg px-3 py-2"
              value={formData.startTime}
              onChange={(e) => setFormData({...formData, startTime: e.target.value})}
            />
          </div>
          <div>
            <label className="block text-sm font-medium mb-1">Type</label>
            <select
              className="w-full border rounded-lg px-3 py-2"
              value={formData.type}
              onChange={(e) => setFormData({...formData, type: e.target.value})}
            >
              <option>Consultation</option>
              <option>Follow-up</option>
              <option>Check-up</option>
            </select>
          </div>
          <div className="flex gap-3 pt-4">
            <button type="submit" disabled={loading} className="bg-green-600 text-white px-4 py-2 rounded-lg">
              {loading ? 'Scheduling...' : 'Schedule'}
            </button>
            <Link href="/appointments">
              <button type="button" className="border rounded-lg px-4 py-2">Cancel</button>
            </Link>
          </div>
        </form>
      </div>
    </div>
  )
}
