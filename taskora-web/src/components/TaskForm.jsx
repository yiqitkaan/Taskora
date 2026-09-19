import { useEffect, useRef, useState } from 'react'

const blankTask = { title: '', description: '', status: '', priority: '', assignee: '', projectId: '' }
const fieldClass = 'mt-1.5 w-full rounded-xl border border-line bg-white px-3.5 py-2.5 text-sm text-ink outline-none transition placeholder:text-[#9aa9b4] focus:border-brand focus:ring-2 focus:ring-[#d9edf8]'

export default function TaskForm({ task, onSave, onClose }) {
  const [form, setForm] = useState(task ? { ...task, projectId: task.projectId ?? '' } : blankTask)
  const [errors, setErrors] = useState({})
  const titleRef = useRef(null)

  useEffect(() => {
    titleRef.current?.focus()
    const onKeyDown = event => { if (event.key === 'Escape') onClose() }
    window.addEventListener('keydown', onKeyDown)
    return () => window.removeEventListener('keydown', onKeyDown)
  }, [onClose])

  function change(field, value) {
    setForm(current => ({ ...current, [field]: value }))
    setErrors(current => ({ ...current, [field]: undefined }))
  }

  function submit(event) {
    event.preventDefault()
    const nextErrors = {}
    if (!form.title.trim()) nextErrors.title = 'Görev başlığı zorunludur.'
    if (!form.status) nextErrors.status = 'Durum seçiniz.'
    if (!form.priority) nextErrors.priority = 'Öncelik seçiniz.'
    if (!form.assignee.trim()) nextErrors.assignee = 'Sorumlu zorunludur.'
    if (form.projectId !== '' && (!Number.isSafeInteger(Number(form.projectId)) || Number(form.projectId) < 1)) nextErrors.projectId = 'Pozitif bir proje ID giriniz.'
    setErrors(nextErrors)
    if (Object.keys(nextErrors).length) return
    onSave({
      title: form.title.trim(), description: form.description.trim(),
      status: form.status, priority: form.priority, assignee: form.assignee.trim(),
      projectId: form.projectId === '' ? null : Number(form.projectId),
    })
  }

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center bg-[#172e40]/50 p-3 sm:p-5" onMouseDown={event => { if (event.target === event.currentTarget) onClose() }}>
      <div role="dialog" aria-modal="true" aria-labelledby="task-form-title" className="max-h-[calc(100vh-1.5rem)] w-full max-w-xl overflow-y-auto rounded-2xl bg-white shadow-[0_20px_70px_rgba(12,34,51,0.25)] sm:max-h-[calc(100vh-2.5rem)]">
        <div className="flex items-start justify-between border-b border-line px-5 py-5 sm:px-7">
          <div><p className="text-xs font-bold uppercase tracking-[0.16em] text-brand">GÖREV YÖNETİMİ</p><h2 id="task-form-title" className="mt-1 font-display text-xl font-extrabold text-ink">{task ? 'Görevi Düzenle' : 'Yeni Görev'}</h2><p className="mt-1 text-sm text-muted">Görev bilgilerini aşağıdan düzenleyin.</p></div>
          <button type="button" onClick={onClose} aria-label="Formu kapat" className="rounded-lg px-2 py-1 text-xl text-muted transition hover:bg-canvas hover:text-ink focus-visible:outline-2 focus-visible:outline-brand">×</button>
        </div>
        <form onSubmit={submit} noValidate className="space-y-4 px-5 py-5 sm:px-7 sm:py-6">
          <div><label htmlFor="task-title" className="text-sm font-bold text-ink">Görev Başlığı <span className="text-[#bd5f58]">*</span></label><input ref={titleRef} id="task-title" value={form.title} onChange={event => change('title', event.target.value)} placeholder="Örn. Proje planını güncelle" aria-invalid={Boolean(errors.title)} aria-describedby={errors.title ? 'title-error' : undefined} className={fieldClass} />{errors.title && <p id="title-error" className="mt-1 text-xs text-[#bd5f58]">{errors.title}</p>}</div>
          <div><label htmlFor="task-description" className="text-sm font-bold text-ink">Açıklama</label><textarea id="task-description" value={form.description} onChange={event => change('description', event.target.value)} placeholder="Görevin kısa açıklaması" rows="3" className={`${fieldClass} resize-y`} /></div>
          <div className="grid gap-4 sm:grid-cols-2">
            <div><label htmlFor="task-status" className="text-sm font-bold text-ink">Durum <span className="text-[#bd5f58]">*</span></label><select id="task-status" value={form.status} onChange={event => change('status', event.target.value)} aria-invalid={Boolean(errors.status)} aria-describedby={errors.status ? 'status-error' : undefined} className={fieldClass}><option value="">Durum seçin</option><option value="pending">Bekliyor</option><option value="in_progress">Devam Ediyor</option><option value="completed">Tamamlandı</option></select>{errors.status && <p id="status-error" className="mt-1 text-xs text-[#bd5f58]">{errors.status}</p>}</div>
            <div><label htmlFor="task-priority" className="text-sm font-bold text-ink">Öncelik <span className="text-[#bd5f58]">*</span></label><select id="task-priority" value={form.priority} onChange={event => change('priority', event.target.value)} aria-invalid={Boolean(errors.priority)} aria-describedby={errors.priority ? 'priority-error' : undefined} className={fieldClass}><option value="">Öncelik seçin</option><option value="low">Düşük</option><option value="medium">Orta</option><option value="high">Yüksek</option></select>{errors.priority && <p id="priority-error" className="mt-1 text-xs text-[#bd5f58]">{errors.priority}</p>}</div>
          </div>
          <div className="grid gap-4 sm:grid-cols-2">
            <div><label htmlFor="task-assignee" className="text-sm font-bold text-ink">Sorumlu <span className="text-[#bd5f58]">*</span></label><input id="task-assignee" value={form.assignee} onChange={event => change('assignee', event.target.value)} placeholder="Ad Soyad" aria-invalid={Boolean(errors.assignee)} aria-describedby={errors.assignee ? 'assignee-error' : undefined} className={fieldClass} />{errors.assignee && <p id="assignee-error" className="mt-1 text-xs text-[#bd5f58]">{errors.assignee}</p>}</div>
            <div><label htmlFor="task-project" className="text-sm font-bold text-ink">Proje ID</label><input id="task-project" type="number" min="1" step="1" value={form.projectId} onChange={event => change('projectId', event.target.value)} placeholder="Örn. 1" aria-invalid={Boolean(errors.projectId)} aria-describedby={errors.projectId ? 'project-error' : undefined} className={fieldClass} />{errors.projectId && <p id="project-error" className="mt-1 text-xs text-[#bd5f58]">{errors.projectId}</p>}</div>
          </div>
          <div className="flex flex-wrap justify-end gap-3 border-t border-line pt-5"><button type="button" onClick={onClose} className="rounded-xl border border-line px-5 py-2.5 text-sm font-bold text-muted transition hover:bg-canvas focus-visible:outline-2 focus-visible:outline-brand">Vazgeç</button><button type="submit" className="rounded-xl bg-brand px-5 py-2.5 text-sm font-bold text-white transition hover:bg-brand-dark focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-brand">{task ? 'Değişiklikleri Kaydet' : 'Görevi Kaydet'}</button></div>
        </form>
      </div>
    </div>
  )
}
