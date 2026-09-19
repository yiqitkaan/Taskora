import { useEffect, useState } from 'react'
import Header from '../components/Header'
import StatsCards from '../components/StatsCards'
import TaskFilters from '../components/TaskFilters'
import TaskList from '../components/TaskList'
import TaskForm from '../components/TaskForm'
import { getTasks, saveTasks } from '../utils/storage'

const normalizeSearch = value => value.toLocaleLowerCase('tr-TR').replaceAll('ı', 'i')

export default function Dashboard() {
  const [tasks, setTasks] = useState(getTasks)
  const [status, setStatus] = useState('all')
  const [priority, setPriority] = useState('all')
  const [search, setSearch] = useState('')
  const [formTask, setFormTask] = useState(null)
  const [formOpen, setFormOpen] = useState(false)
  const [storageError, setStorageError] = useState(false)

  useEffect(() => { setStorageError(!saveTasks(tasks)) }, [tasks])

  const term = normalizeSearch(search.trim())
  const visibleTasks = tasks.filter(task =>
    (status === 'all' || task.status === status) &&
    (priority === 'all' || task.priority === priority) &&
    (!term || normalizeSearch(`${task.title} ${task.description}`).includes(term))
  )

  function openCreate() { setFormTask(null); setFormOpen(true) }
  function openEdit(task) { setFormTask(task); setFormOpen(true) }
  function closeForm() { setFormOpen(false); setFormTask(null) }

  function saveTask(values) {
    if (formTask) {
      setTasks(current => current.map(task => task.id === formTask.id ? { ...task, ...values, updatedAt: new Date().toISOString() } : task))
    } else {
      setTasks(current => {
        const now = new Date().toISOString()
        const id = Math.max(0, ...current.map(task => task.id)) + 1
        return [...current, { id, ...values, createdAt: now, updatedAt: now }]
      })
    }
    closeForm()
  }

  function deleteTask(task) {
    if (window.confirm('Bu görevi silmek istediğinize emin misiniz?')) {
      setTasks(current => current.filter(item => item.id !== task.id))
    }
  }

  function clearFilters() { setStatus('all'); setPriority('all'); setSearch('') }

  return (
    <div className="min-h-screen bg-canvas">
      <Header onCreate={openCreate} />
      <main className="mx-auto max-w-6xl px-5 pb-16 sm:px-8">
        {storageError && <p role="alert" className="mb-5 rounded-xl border border-[#edc4bc] bg-[#fff3f0] px-4 py-3 text-sm text-[#a85247]">Tarayıcı verileri kaydedemedi. LocalStorage erişimini kontrol edin.</p>}
        <StatsCards tasks={tasks} />
        <section className="mt-9" aria-labelledby="tasks-heading">
          <div className="mb-5 flex flex-wrap items-center justify-between gap-2"><div><h2 id="tasks-heading" className="font-display text-xl font-extrabold text-ink">Görevler</h2><p className="mt-1 text-sm text-muted">Ekibinizin tüm görevleri bir arada.</p></div><span className="rounded-full border border-line bg-white px-3 py-1.5 text-xs font-semibold text-muted">{visibleTasks.length} görev gösteriliyor</span></div>
          <TaskFilters status={status} onStatusChange={setStatus} priority={priority} onPriorityChange={setPriority} search={search} onSearchChange={setSearch} />
          <div className="mt-5"><TaskList tasks={visibleTasks} hasAnyTasks={tasks.length > 0} onEdit={openEdit} onDelete={deleteTask} onCreate={openCreate} onClearFilters={clearFilters} /></div>
        </section>
      </main>
      <footer className="border-t border-line bg-white py-5 text-center text-xs text-muted">TASKORA · Görev Yönetimi</footer>
      {formOpen && <TaskForm key={formTask?.id ?? 'new'} task={formTask} onSave={saveTask} onClose={closeForm} />}
    </div>
  )
}
