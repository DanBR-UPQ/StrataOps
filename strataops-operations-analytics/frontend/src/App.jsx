import { useEffect, useState } from "react"
import { Line } from "react-chartjs-2"
import {
  Chart as ChartJS, CategoryScale, LinearScale,
  PointElement, LineElement, Title, Tooltip, Legend
} from "chart.js"
import "./App.css"

ChartJS.register(CategoryScale, LinearScale, PointElement, LineElement, Title, Tooltip, Legend)

const API = "https://strataops-api.onrender.com"

const fmt = (n) => {
  if (n >= 1e6) return (n / 1e6).toFixed(1).replace(/\.0$/, "") + "M"
  if (n >= 1e3) return Math.round(n / 1e3) + "K"
  return n
} 

const defectPill = (v) => {
  const pct = (v * 100).toFixed(1) + "%"
  const cls = v >= 0.07 ? "pill red" : v <= 0.04 ? "pill green" : "pill blue"
  return <span className={cls}>{pct}</span>
}

const downtimePill = (v) => {
  const pct = (v * 100).toFixed(1) + "%"
  const cls = v >= 0.12 ? "pill red" : v <= 0.05 ? "pill green" : "pill blue"
  return <span className={cls}>{pct}</span>
}

const outputPill = (v, isMax) => (
  <span className={isMax ? "pill green" : "pill blue"}>{fmt(v)}</span>
)

export default function App() {
  const [kpis, setKpis] = useState(null)
  const [machines, setMachines] = useState([])
  const [types, setTypes] = useState([])
  const [shifts, setShifts] = useState([])
  const [daily, setDaily] = useState([])

  // Sorting States
  const [machineSort, setMachineSort] = useState({ key: null, dir: 'desc' })
  const [typeSort, setTypeSort] = useState({ key: null, dir: 'desc' })
  const [shiftSort, setShiftSort] = useState({ key: null, dir: 'desc' })

  useEffect(() => {
    fetch(`${API}/kpis`).then(r => r.json()).then(setKpis)
    fetch(`${API}/kpis/machines`).then(r => r.json()).then(setMachines)
    fetch(`${API}/kpis/machine-types`).then(r => r.json()).then(setTypes)
    fetch(`${API}/kpis/shifts`).then(r => r.json()).then(setShifts)
    fetch(`${API}/kpis/daily`).then(r => r.json()).then(setDaily)
  }, [])

  if (!kpis) return <div className="loading">Loading StrataOps...</div>

  // Sorting Helper Function
  const handleSort = (setter, currentSort, key) => {
    setter({ key, dir: currentSort.key === key && currentSort.dir === 'desc' ? 'asc' : 'desc' })
  }

  const sortData = (data, sortState) => {
    if (!sortState.key) return data
    return [...data].sort((a, b) => {
      if (a[sortState.key] < b[sortState.key]) return sortState.dir === 'asc' ? -1 : 1
      if (a[sortState.key] > b[sortState.key]) return sortState.dir === 'asc' ? 1 : -1
      return 0
    })
  }

  const machineMax = Math.max(...machines.map(m => m.total_units_produced))
  const typeMax = Math.max(...types.map(t => t.total_units_produced))

  // Monthly aggregation for charts
  const monthly = {}
  daily.forEach(({ date, total_units_produced, defect_rate, downtime_percentage }) => {
    const key = date.slice(0, 7)
    if (!monthly[key]) monthly[key] = { units: [], defect: [], downtime: [] }
    monthly[key].units.push(total_units_produced)
    monthly[key].defect.push(defect_rate)
    monthly[key].downtime.push(downtime_percentage)
  })
  const monthKeys = Object.keys(monthly).sort()
  const monthLabels = monthKeys.map((k, i) => {
    const [yr, mo] = k.split("-")
    if (mo === "01") return `ene ${yr}`
    if (mo === "07") return `jul ${yr}`
    return ""
  })
  
  const avgArr = (arr) => arr.reduce((a, b) => a + b, 0) / arr.length
  const trendData = monthKeys.map(k => monthly[k].units.reduce((a, b) => a + b, 0))
  const defectData = monthKeys.map(k => +(avgArr(monthly[k].defect) * 100).toFixed(2))
  const downtimeData = monthKeys.map(k => +(avgArr(monthly[k].downtime) * 100).toFixed(2))

  // Upgraded Chart Options for better interaction
  const lineOpts = {
    responsive: true, maintainAspectRatio: false,
    interaction: {
      mode: "index", // This groups tooltips when hovering over an x-axis point
      intersect: false,
    },
    plugins: { 
      legend: { display: false },
      tooltip: {
        backgroundColor: 'rgba(255, 255, 255, 0.95)',
        titleColor: '#1e293b',
        bodyColor: '#475569',
        borderColor: '#e2e8f0',
        borderWidth: 1,
        padding: 10,
        boxPadding: 4,
        usePointStyle: true,
      }
    },
    scales: {
      x: { ticks: { color: "#546e7a", font: { size: 10 }, maxRotation: 0 }, grid: { color: "rgba(180,200,220,0.25)" } },
      y: { ticks: { color: "#546e7a", font: { size: 10 } }, grid: { color: "rgba(180,200,220,0.25)" } }
    }
  }

  // Render Sort Indicator Arrow
  const SortArrow = ({ sortState, columnKey }) => {
    if (sortState.key !== columnKey) return <span style={{ opacity: 0.3, marginLeft: 4 }}>↕</span>
    return <span style={{ marginLeft: 4, color: '#1565c0' }}>{sortState.dir === 'asc' ? '↑' : '↓'}</span>
  }

  return (
    <div className="dash">
      <div className="kpi-row">
        {[
          ["Total Units Produced", fmt(kpis.total_units_produced)],
          ["Production Efficiency", (kpis.efficiency * 100).toFixed(2) + "%"],
          ["Avg Defect Rate", (kpis.defect_rate * 100).toFixed(2) + "%"],
          ["Avg Downtime %", (kpis.downtime_percentage * 100).toFixed(2) + "%"],
        ].map(([label, val]) => (
          <div className="kpi-card" key={label}>
            <div className="kpi-val">{val}</div>
            <div className="kpi-label">{label}</div>
          </div>
        ))}
      </div>

      <div className="main-grid">
        <div className="left-col">
          <div className="panel">
            <div className="panel-title">Machine Analytics</div>
            <table>
              <thead>
                <tr>
                  <th className="sortable-header" onClick={() => handleSort(setMachineSort, machineSort, 'machine_id')}>Machine <SortArrow sortState={machineSort} columnKey="machine_id" /></th>
                  <th className="r sortable-header" onClick={() => handleSort(setMachineSort, machineSort, 'total_units_produced')}>Output <SortArrow sortState={machineSort} columnKey="total_units_produced" /></th>
                  <th className="r sortable-header" onClick={() => handleSort(setMachineSort, machineSort, 'defect_rate')}>Defect Rate <SortArrow sortState={machineSort} columnKey="defect_rate" /></th>
                  <th className="r sortable-header" onClick={() => handleSort(setMachineSort, machineSort, 'downtime_percentage')}>Downtime % <SortArrow sortState={machineSort} columnKey="downtime_percentage" /></th>
                </tr>
              </thead>
              <tbody>{sortData(machines, machineSort).map(m => (
                <tr key={m.machine_id} className="interactive-row">
                  <td>{m.machine_id}</td>
                  <td className="r">{outputPill(m.total_units_produced, m.total_units_produced === machineMax)}</td>
                  <td className="r">{defectPill(m.defect_rate)}</td>
                  <td className="r">{downtimePill(m.downtime_percentage)}</td>
                </tr>
              ))}</tbody>
            </table>
          </div>

          <div className="panel">
            <div className="panel-title">Machine Type Analytics</div>
            <table>
              <thead>
                <tr>
                  <th className="sortable-header" onClick={() => handleSort(setTypeSort, typeSort, 'machine_type')}>Type <SortArrow sortState={typeSort} columnKey="machine_type" /></th>
                  <th className="r sortable-header" onClick={() => handleSort(setTypeSort, typeSort, 'total_units_produced')}>Output <SortArrow sortState={typeSort} columnKey="total_units_produced" /></th>
                  <th className="r sortable-header" onClick={() => handleSort(setTypeSort, typeSort, 'defect_rate')}>Defect Rate <SortArrow sortState={typeSort} columnKey="defect_rate" /></th>
                  <th className="r sortable-header" onClick={() => handleSort(setTypeSort, typeSort, 'downtime_percentage')}>Downtime % <SortArrow sortState={typeSort} columnKey="downtime_percentage" /></th>
                </tr>
              </thead>
              <tbody>{sortData(types, typeSort).map(t => (
                <tr key={t.machine_type} className="interactive-row">
                  <td>{t.machine_type}</td>
                  <td className="r">{outputPill(t.total_units_produced, t.total_units_produced === typeMax)}</td>
                  <td className="r">{defectPill(t.defect_rate)}</td>
                  <td className="r">{downtimePill(t.downtime_percentage)}</td>
                </tr>
              ))}</tbody>
            </table>
          </div>

          <div className="panel">
            <div className="panel-title">Shift Analytics</div>
            <table>
              <thead>
                <tr>
                  <th className="sortable-header" onClick={() => handleSort(setShiftSort, shiftSort, 'shift')}>Shift <SortArrow sortState={shiftSort} columnKey="shift" /></th>
                  <th className="r sortable-header" onClick={() => handleSort(setShiftSort, shiftSort, 'total_units_produced')}>Output <SortArrow sortState={shiftSort} columnKey="total_units_produced" /></th>
                  <th className="r sortable-header" onClick={() => handleSort(setShiftSort, shiftSort, 'defect_rate')}>Defect Rate <SortArrow sortState={shiftSort} columnKey="defect_rate" /></th>
                  <th className="r sortable-header" onClick={() => handleSort(setShiftSort, shiftSort, 'downtime_percentage')}>Downtime % <SortArrow sortState={shiftSort} columnKey="downtime_percentage" /></th>
                </tr>
              </thead>
              <tbody>{sortData(shifts, shiftSort).map(s => (
                <tr key={s.shift} className="interactive-row">
                  <td>{s.shift}</td>
                  <td className="r"><span className="pill green">{fmt(s.total_units_produced)}</span></td>
                  <td className="r">{defectPill(s.defect_rate)}</td>
                  <td className="r">{downtimePill(s.downtime_percentage)}</td>
                </tr>
              ))}</tbody>
            </table>
          </div>
        </div>

        <div className="right-col">
          <div className="panel">
            <div className="panel-title">Monthly Production Trend</div>
            <div style={{ position: "relative", height: "200px" }}>
              <Line data={{ labels: monthLabels, datasets: [{ label: "Total Units", data: trendData, borderColor: "#4fc3f7", backgroundColor: "#4fc3f7", borderWidth: 1.5, pointRadius: 2, pointHoverRadius: 5, tension: 0.3 }] }} options={{ ...lineOpts, scales: { ...lineOpts.scales, y: { ...lineOpts.scales.y, ticks: { ...lineOpts.scales.y.ticks, callback: v => Math.round(v/1000) + "K" } } } }} />
            </div>
          </div>

          <div className="panel">
            <div className="panel-title">Monthly Downtime & Defect Rate</div>
            <div style={{ display: "flex", gap: 14, marginBottom: 6, fontSize: 11, color: "#546e7a" }}>
              <span><span style={{ display:"inline-block", width:10, height:10, borderRadius:"50%", background:"#4fc3f7", marginRight:4 }}></span>Defect Rate</span>
              <span><span style={{ display:"inline-block", width:10, height:10, borderRadius:"50%", background:"#1565c0", marginRight:4 }}></span>Avg Downtime %</span>
            </div>
            <div style={{ position: "relative", height: "190px" }}>
              <Line data={{ labels: monthLabels, datasets: [
                { label: "Defect Rate", data: defectData, borderColor: "#4fc3f7", backgroundColor: "#4fc3f7", borderWidth: 1.5, pointRadius: 2, pointHoverRadius: 5, tension: 0.3 },
                { label: "Avg Downtime %", data: downtimeData, borderColor: "#1565c0", backgroundColor: "#1565c0", borderWidth: 1.5, pointRadius: 2, pointHoverRadius: 5, tension: 0.3, borderDash: [4,3] }
              ]}} options={{ ...lineOpts, scales: { ...lineOpts.scales, y: { ...lineOpts.scales.y, ticks: { ...lineOpts.scales.y.ticks, callback: v => v.toFixed(1) + "%" } } } }} />
            </div>
          </div>
        </div>
      </div>
    </div>
  )
}