'use client'

import { useState } from 'react'
import { Video, Calendar, Users, Clock, Phone } from 'lucide-react'

export default function TelehealthPage() {
  const [upcomingCalls] = useState([
    { id: 1, patient: 'John Doe', time: '10:30 AM', date: 'Today' },
    { id: 2, patient: 'Jane Smith', time: '2:00 PM', date: 'Today' },
    { id: 3, patient: 'Bob Johnson', time: '11:00 AM', date: 'Tomorrow' }
  ])

  return (
    <div className="max-w-7xl mx-auto px-4 py-8">
      <div className="flex justify-between items-center mb-8">
        <div>
          <h1 className="text-3xl font-bold text-gray-800">Telehealth</h1>
          <p className="text-gray-600 mt-2">Virtual consultations with patients</p>
        </div>
        <button className="bg-blue-600 text-white px-4 py-2 rounded-lg hover:bg-blue-700 flex items-center space-x-2">
          <Video className="w-5 h-5" />
          <span>Schedule Call</span>
        </button>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
        <div className="lg:col-span-2">
          <div className="bg-white rounded-xl shadow-lg p-6">
            <h2 className="text-xl font-semibold mb-4">Upcoming Calls</h2>
            <div className="space-y-4">
              {upcomingCalls.map((call) => (
                <div key={call.id} className="border border-gray-200 rounded-lg p-4 hover:shadow-md transition-shadow">
                  <div className="flex justify-between items-center">
                    <div>
                      <h3 className="font-semibold text-gray-800">{call.patient}</h3>
                      <div className="flex items-center space-x-4 mt-2 text-sm text-gray-600">
                        <div className="flex items-center space-x-1">
                          <Calendar className="w-4 h-4" />
                          <span>{call.date}</span>
                        </div>
                        <div className="flex items-center space-x-1">
                          <Clock className="w-4 h-4" />
                          <span>{call.time}</span>
                        </div>
                      </div>
                    </div>
                    <button className="bg-green-600 text-white px-4 py-2 rounded-lg hover:bg-green-700 flex items-center space-x-2">
                      <Video className="w-4 h-4" />
                      <span>Join Call</span>
                    </button>
                  </div>
                </div>
              ))}
            </div>
          </div>
        </div>

        <div className="space-y-6">
          <div className="bg-gradient-to-br from-blue-500 to-blue-600 rounded-xl shadow-lg p-6 text-white">
            <h3 className="text-lg font-semibold mb-4">Telehealth Statistics</h3>
            <div className="space-y-3">
              <div className="flex justify-between">
                <span>Total Calls Today</span>
                <span className="font-bold">8</span>
              </div>
              <div className="flex justify-between">
                <span>Completed This Week</span>
                <span className="font-bold">24</span>
              </div>
              <div className="flex justify-between">
                <span>Patient Satisfaction</span>
                <span className="font-bold">96%</span>
              </div>
            </div>
          </div>

          <div className="bg-white rounded-xl shadow-lg p-6">
            <h3 className="text-lg font-semibold mb-4">Quick Tips</h3>
            <ul className="space-y-2 text-sm text-gray-600">
              <li className="flex items-center space-x-2">
                <Phone className="w-4 h-4 text-green-600" />
                <span>Test your camera & mic before calls</span>
              </li>
              <li className="flex items-center space-x-2">
                <Video className="w-4 h-4 text-blue-600" />
                <span>Ensure stable internet connection</span>
              </li>
            </ul>
          </div>
        </div>
      </div>
    </div>
  )
}
