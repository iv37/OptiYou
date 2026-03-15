export default function Loading() {
  return (
    <div className="flex min-h-screen items-center justify-center px-6">
      <div className="glass-panel rounded-[32px] border border-white/60 px-8 py-6 text-center">
        <p className="text-sm text-muted">Loading workspace</p>
        <p className="mt-2 text-lg font-semibold">Preparing your dashboard...</p>
      </div>
    </div>
  );
}
