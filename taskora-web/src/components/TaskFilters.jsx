const statuses = [
  { value: 'all', label: 'Tümü' },
  { value: 'pending', label: 'Bekleyen' },
  { value: 'in_progress', label: 'Devam Eden' },
  { value: 'completed', label: 'Tamamlanan' },
]

export default function TaskFilters({ status, onStatusChange, priority, onPriorityChange, search, onSearchChange }) {
  return (
    <div className="flex flex-col gap-3 lg:flex-row lg:items-center lg:justify-between">
      <div className="flex flex-wrap gap-1 rounded-xl bg-[#f1f5f7] p-1" role="group" aria-label="Durum filtresi">
        {statuses.map(option => (
          <button key={option.value} type="button" onClick={() => onStatusChange(option.value)} aria-pressed={status === option.value} className={`rounded-lg px-3 py-2 text-xs font-semibold transition sm:px-4 sm:text-sm ${status === option.value ? 'bg-white text-brand shadow-sm' : 'text-muted hover:bg-white/60 hover:text-ink'}`}>{option.label}</button>
        ))}
      </div>
      <div className="flex flex-col gap-3 sm:flex-row">
        <label className="sr-only" htmlFor="search-tasks">Görevlerde ara</label>
        <div className="relative flex-1 sm:w-60">
          <svg className="pointer-events-none absolute left-3 top-1/2 -translate-y-1/2 text-[#8da0af]" width="17" height="17" viewBox="0 0 24 24" fill="none" aria-hidden="true"><circle cx="10.8" cy="10.8" r="6.8" stroke="currentColor" strokeWidth="2"/><path d="m16 16 4 4" stroke="currentColor" strokeWidth="2" strokeLinecap="round"/></svg>
          <input id="search-tasks" type="search" value={search} onChange={event => onSearchChange(event.target.value)} placeholder="Görevlerde ara..." className="w-full rounded-xl border border-line bg-white py-2.5 pl-10 pr-3 text-sm outline-none transition placeholder:text-[#9aa9b4] focus:border-brand focus:ring-2 focus:ring-[#d9edf8]" />
        </div>
        <label className="sr-only" htmlFor="priority-filter">Öncelik filtresi</label>
        <select id="priority-filter" value={priority} onChange={event => onPriorityChange(event.target.value)} className="rounded-xl border border-line bg-white px-3 py-2.5 text-sm text-ink outline-none focus:border-brand focus:ring-2 focus:ring-[#d9edf8]">
          <option value="all">Tüm Öncelikler</option>
          <option value="low">Düşük</option>
          <option value="medium">Orta</option>
          <option value="high">Yüksek</option>
        </select>
      </div>
    </div>
  )
}
