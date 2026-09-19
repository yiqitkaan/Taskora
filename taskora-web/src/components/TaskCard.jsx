const statusInfo = {
  pending: { label: 'Bekliyor', style: 'bg-[#fff7e8] text-[#ac7b22] border-[#f8e6bd]', dot: 'bg-[#e4ad45]' },
  in_progress: { label: 'Devam Ediyor', style: 'bg-[#ebf5fc] text-[#2878a6] border-[#d5eaf7]', dot: 'bg-[#4b9ecb]' },
  completed: { label: 'Tamamlandı', style: 'bg-[#ecf7f0] text-[#438461] border-[#d7ebdd]', dot: 'bg-[#62aa7a]' },
}
const priorityInfo = { low: ['Düşük', 'text-[#668696]'], medium: ['Orta', 'text-[#b27b32]'], high: ['Yüksek', 'text-[#c15c55]'] }

export default function TaskCard({ task, onEdit, onDelete }) {
  const status = statusInfo[task.status] || statusInfo.pending
  const priority = priorityInfo[task.priority] || priorityInfo.medium
  return (
    <article className="flex h-full flex-col rounded-2xl border border-line bg-white p-5 shadow-[0_3px_15px_rgba(28,61,83,0.04)] transition hover:shadow-[0_8px_24px_rgba(28,61,83,0.08)] sm:p-6">
      <div className="mb-4 flex flex-wrap items-center gap-2">
        <span className={`inline-flex items-center gap-1.5 rounded-full border px-2.5 py-1 text-xs font-bold ${status.style}`}><span className={`h-1.5 w-1.5 rounded-full ${status.dot}`} />{status.label}</span>
        <span className={`text-xs font-bold ${priority[1]}`}>● <span className="text-ink/70">{priority[0]} öncelik</span></span>
      </div>
      <h3 className="font-display text-lg font-bold leading-snug text-ink">{task.title}</h3>
      <p className="mt-2 line-clamp-2 min-h-10 text-sm leading-5 text-muted">{task.description || 'Açıklama eklenmedi.'}</p>
      <div className="mt-auto pt-5">
        <div className="flex flex-wrap items-center justify-between gap-2 border-t border-line pt-4 text-xs text-muted">
          <span className="flex items-center gap-2"><span className="flex h-7 w-7 items-center justify-center rounded-full bg-[#e9f1f7] font-bold text-brand">{task.assignee?.trim().slice(0, 1).toLocaleUpperCase('tr-TR') || '?'}</span><span className="max-w-36 truncate" title={task.assignee}>{task.assignee}</span></span>
          <span>Proje #{task.projectId ?? '—'}</span>
        </div>
        <div className="mt-4 flex items-center justify-end gap-2">
          <button type="button" onClick={() => onEdit(task)} className="rounded-lg border border-line px-3 py-1.5 text-xs font-bold text-brand transition hover:border-brand hover:bg-[#eef7fc] focus-visible:outline-2 focus-visible:outline-brand">Düzenle</button>
          <button type="button" onClick={() => onDelete(task)} className="rounded-lg border border-line px-3 py-1.5 text-xs font-bold text-[#b95b58] transition hover:border-[#e7b9b5] hover:bg-[#fff4f3] focus-visible:outline-2 focus-visible:outline-[#b95b58]">Sil</button>
        </div>
      </div>
    </article>
  )
}
