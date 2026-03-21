export default function TelehealthPage() {
  return (
    <div className="max-w-7xl mx-auto px-4 py-8">
      <h1 className="text-3xl font-bold text-gray-800 mb-4">Telehealth</h1>
      <p className="text-gray-600 mb-8">Virtual consultations with patients</p>
      
      <div className="bg-white rounded-xl shadow-lg p-6">
        <h2 className="text-xl font-semibold mb-4">Upcoming Calls</h2>
        <div className="space-y-4">
          <div className="border rounded-lg p-4">
            <p className="font-semibold">John Doe - Today at 10:30 AM</p>
            <button className="mt-2 bg-green-600 text-white px-4 py-2 rounded-lg">Join Call</button>
          </div>
          <div className="border rounded-lg p-4">
            <p className="font-semibold">Jane Smith - Today at 2:00 PM</p>
            <button className="mt-2 bg-green-600 text-white px-4 py-2 rounded-lg">Join Call</button>
          </div>
        </div>
      </div>
    </div>
  )
}
