import TaskCard from './TaskCard'

export default function TaskList({ tasks, hasAnyTasks, onEdit, onDelete, onCreate, onClearFilters }) {
  if (tasks.length === 0) {
    return (
      <div className="rounded-2xl border border-dashed border-[#cddde7] bg-white px-6 py-16 text-center">
        <div className="mx-auto mb-4 flex h-12 w-12 items-center justify-center rounded-2xl bg-[#eaf4fa] text-2xl text-brand" aria-hidden="true">□</div>
        <h3 className="font-display text-lg font-bold text-ink">{hasAnyTasks ? 'Eşleşen görev bulunamadı.' : 'Henüz görev bulunmuyor.'}</h3>
        <p className="mt-2 text-sm text-muted">{hasAnyTasks ? 'Filtreleri veya arama terimini değiştirebilirsiniz.' : 'İlk görevinizi oluşturarak başlayın.'}</p>
        <button type="button" onClick={hasAnyTasks ? onClearFilters : onCreate} className="mt-5 rounded-xl bg-brand px-5 py-2.5 text-sm font-bold text-white transition hover:bg-brand-dark focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-brand">{hasAnyTasks ? 'Filtreleri temizle' : 'Yeni Görev Oluştur'}</button>
      </div>
    )
  }
  return <div className="grid gap-4 sm:grid-cols-2 lg:gap-5">{tasks.map(task => <TaskCard key={task.id} task={task} onEdit={onEdit} onDelete={onDelete} />)}</div>
}
