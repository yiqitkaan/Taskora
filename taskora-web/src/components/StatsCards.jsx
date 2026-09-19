const cards = [
  { key: 'total', label: 'Toplam Görev', tone: 'text-brand bg-[#eaf4fa]', icon: '□' },
  { key: 'pending', label: 'Bekleyen', tone: 'text-[#b98425] bg-[#fff6e5]', icon: '◷' },
  { key: 'in_progress', label: 'Devam Eden', tone: 'text-[#357eab] bg-[#eaf5fb]', icon: '↗' },
  { key: 'completed', label: 'Tamamlanan', tone: 'text-[#428567] bg-[#eaf6ef]', icon: '✓' },
]

export default function StatsCards({ tasks }) {
  const counts = { total: tasks.length, pending: 0, in_progress: 0, completed: 0 }
  tasks.forEach(task => { if (task.status in counts) counts[task.status] += 1 })

  return (
    <section aria-label="Görev istatistikleri" className="grid grid-cols-2 gap-3 md:grid-cols-4 md:gap-5">
      {cards.map(card => (
        <div key={card.key} className="rounded-2xl border border-line bg-white p-4 shadow-[0_2px_12px_rgba(28,61,83,0.035)] sm:p-5">
          <div className={`mb-4 flex h-9 w-9 items-center justify-center rounded-xl text-xl font-bold ${card.tone}`} aria-hidden="true">{card.icon}</div>
          <p className="text-xs font-semibold text-muted sm:text-sm">{card.label}</p>
          <p className="mt-1 font-display text-3xl font-extrabold leading-tight text-ink">{counts[card.key]}</p>
        </div>
      ))}
    </section>
  )
}
