export default function AccessoNegatoPage() {
  return (
    <div className="min-h-screen flex items-center justify-center bg-slate-100 dark:bg-slate-800 px-4">
      <div className="w-full max-w-md text-center">
        <h1 className="text-2xl font-bold text-slate-800 dark:text-slate-100">Accesso non più attivo</h1>
        <p className="text-slate-500 dark:text-slate-400 mt-3 text-sm">
          Il tuo accesso al CRM è stato revocato o non è attivo. Se pensi sia un
          errore, contatta un responsabile.
        </p>
        <form action="/auth/signout" method="post" className="mt-6">
          <button
            type="submit"
            className="rounded-lg bg-brand-600 text-white font-medium px-5 py-2.5 hover:bg-brand-700 transition"
          >
            Esci
          </button>
        </form>
      </div>
    </div>
  );
}
