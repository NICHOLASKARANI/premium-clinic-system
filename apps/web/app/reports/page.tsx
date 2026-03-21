export default function ReportsPage() {
  return (
    <div className="max-w-7xl mx-auto px-4 py-8">
      <div className="flex justify-between items-center mb-6">
        <h1 className="text-3xl font-bold text-gray-800">Analytics & Reports</h1>
        <button className="bg-blue-600 text-white px-4 py-2 rounded-lg">Export Report</button>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-4 gap-6 mb-8">
        <div className="bg-white rounded-xl shadow-lg p-6">
          <p className="text-gray-500 text-sm">Total Patients</p>
          <p className="text-2xl font-bold">1,245</p>
          <p className="text-green-600 text-sm">↑ 12%</p>
        </div>
        <div className="bg-white rounded-xl shadow-lg p-6">
          <p className="text-gray-500 text-sm">Total Revenue</p>
          <p className="text-2xl font-bold">,500</p>
          <p className="text-green-600 text-sm">↑ 8%</p>
        </div>
        <div className="bg-white rounded-xl shadow-lg p-6">
          <p className="text-gray-500 text-sm">Appointments</p>
          <p className="text-2xl font-bold">342</p>
          <p className="text-green-600 text-sm">↑ 5%</p>
        </div>
        <div className="bg-white rounded-xl shadow-lg p-6">
          <p className="text-gray-500 text-sm">Occupancy Rate</p>
          <p className="text-2xl font-bold">78%</p>
          <p className="text-green-600 text-sm">↑ 3%</p>
        </div>
      </div>
    </div>
  )
}
