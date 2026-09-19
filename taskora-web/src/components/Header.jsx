export default function Header({ onCreate }) {
  return (
    <>
      <header className="border-b border-line bg-white">
        <div className="mx-auto flex max-w-6xl items-center justify-between px-5 py-4 sm:px-8">
          <div className="flex items-center gap-3">
            <div className="flex h-9 w-9 items-center justify-center rounded-xl bg-brand text-white shadow-sm" aria-hidden="true">
              <svg width="21" height="21" viewBox="0 0 24 24" fill="none"><path d="M6 7.5h12M6 12h8M6 16.5h12" stroke="currentColor" strokeWidth="2.2" strokeLinecap="round"/><circle cx="18.5" cy="12" r="1.5" fill="currentColor"/></svg>
            </div>
            <span className="font-display text-xl font-extrabold tracking-tight text-ink">TASKORA</span>
            <span className="ml-2 hidden border-l border-line pl-4 text-xs font-medium text-muted sm:block">Görev Yönetimi</span>
          </div>
          <div className="flex items-center gap-3">
            <span className="hidden text-sm text-muted sm:block">Çalışma alanı</span>
            <div className="flex h-9 w-9 items-center justify-center rounded-full border border-[#cde0ed] bg-[#edf6fc] text-xs font-bold text-brand" title="Yiğit Kaan Bilir">YB</div>
          </div>
        </div>
      </header>
      <div className="border-b border-line bg-white">
        <div className="mx-auto flex max-w-6xl items-center gap-7 px-5 sm:px-8">
          <span className="border-b-2 border-brand py-3 text-sm font-semibold text-brand">Genel Bakış</span>
        </div>
      </div>
      <div className="mx-auto flex max-w-6xl flex-col gap-5 px-5 pb-7 pt-10 sm:flex-row sm:items-end sm:justify-between sm:px-8">
        <div>
          <p className="mb-2 text-xs font-bold uppercase tracking-[0.2em] text-brand">ÇALIŞMA ALANI / GÖREVLER</p>
          <h1 className="font-display text-3xl font-extrabold tracking-tight text-ink sm:text-4xl">Genel Bakış</h1>
          <p className="mt-2 text-sm text-muted sm:text-base">Görevlerini planla, takip et ve tamamla.</p>
        </div>
        <button onClick={onCreate} className="inline-flex min-h-11 items-center justify-center gap-2 rounded-xl bg-brand px-5 py-2.5 text-sm font-bold text-white shadow-sm transition hover:bg-brand-dark focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-brand">
          <span className="text-xl leading-none" aria-hidden="true">+</span> Yeni Görev
        </button>
      </div>
    </>
  )
}
