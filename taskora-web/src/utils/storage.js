export const STORAGE_KEY = 'taskora_tasks'

const initialTasks = [
  { id: 1, title: "Görev API'sini hazırlama", description: 'Görev listeleme ve detay endpointleri hazırlanacak.', status: 'completed', priority: 'high', assignee: 'Yiğit Kaan Bilir', projectId: 1, createdAt: '2026-09-19T10:00:00.000Z', updatedAt: '2026-09-19T10:00:00.000Z' },
  { id: 2, title: 'Web arayüzünü geliştirme', description: 'Görev paneli ve form ekranları hazırlanacak.', status: 'in_progress', priority: 'high', assignee: 'Yiğit Kaan Bilir', projectId: 1, createdAt: '2026-09-19T10:15:00.000Z', updatedAt: '2026-09-19T10:15:00.000Z' },
  { id: 3, title: 'Veritabanı modelini hazırlama', description: 'Gelecek sürüm için veri alanları planlanacak.', status: 'pending', priority: 'medium', assignee: 'Ayşe Demir', projectId: 2, createdAt: '2026-09-19T10:30:00.000Z', updatedAt: '2026-09-19T10:30:00.000Z' },
  { id: 4, title: 'Mobil görev ekranını tasarlama', description: 'Mobil görev akışı için ilk taslak oluşturulacak.', status: 'pending', priority: 'medium', assignee: 'Mert Yılmaz', projectId: 3, createdAt: '2026-09-19T10:45:00.000Z', updatedAt: '2026-09-19T10:45:00.000Z' },
]

export function getTasks() {
  try {
    const saved = localStorage.getItem(STORAGE_KEY)
    if (saved === null) return initialTasks.map(task => ({ ...task }))
    const parsed = JSON.parse(saved)
    return Array.isArray(parsed) ? parsed : initialTasks.map(task => ({ ...task }))
  } catch {
    return initialTasks.map(task => ({ ...task }))
  }
}

export function saveTasks(tasks) {
  try {
    localStorage.setItem(STORAGE_KEY, JSON.stringify(tasks))
    return true
  } catch {
    return false
  }
}
