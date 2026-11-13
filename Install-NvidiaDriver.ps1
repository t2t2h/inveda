# Install-NvidiaDriver.ps1
# يثبّت/يحدّث تعريفات NVIDIA تلقائياً عبر winget (الطريقة الرسمية الآمنة).
# شغّله بصلاحيات Admin: كليك يمين على الملف -> Run as Administrator (أو افتح PowerShell كـ Admin ثم نفّذه).

Write-Host "`n=== تثبيت/تحديث تعريف NVIDIA ===`n" -ForegroundColor Cyan

# 0) تحقق من صلاحيات المسؤول
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Host "⚠️ لازم تشغّل هذا السكربت بصلاحيات Admin. أعد تشغيله بـ Run as Administrator." -ForegroundColor Yellow
    exit 1
}

# 1) تأكد إن عندك كرت NVIDIA أصلاً
$gpu = Get-CimInstance Win32_VideoController | Where-Object { $_.Name -match 'NVIDIA' }
if (-not $gpu) {
    Write-Host "❌ ما لقيت كرت شاشة NVIDIA بجهازك." -ForegroundColor Red
    exit 1
}
Write-Host "🎮 الكرت المكتشف: $($gpu.Name)`n"

# 2) تأكد إن winget موجود (مثبّت افتراضياً بويندوز 10/11 الحديثة)
$winget = Get-Command winget -ErrorAction SilentlyContinue
if (-not $winget) {
    Write-Host "❌ winget غير موجود بجهازك." -ForegroundColor Red
    Write-Host "   ثبّته من متجر Microsoft (App Installer) ثم أعد تشغيل السكربت." -ForegroundColor Yellow
    Write-Host "   أو حمّل التعريف يدوياً من: https://www.nvidia.com/Download/index.aspx" -ForegroundColor Yellow
    exit 1
}

# 3) تثبيت/تحديث تطبيق NVIDIA (يدير تعريف الشاشة والصوت HDMI تلقائياً)
Write-Host "📦 جاري تثبيت/تحديث NVIDIA App عبر winget..." -ForegroundColor Cyan
winget install --id Nvidia.NVIDIAApp --silent --accept-package-agreements --accept-source-agreements

if ($LASTEXITCODE -eq 0) {
    Write-Host "`n✅ تم تثبيت NVIDIA App بنجاح." -ForegroundColor Green
    Write-Host "افتحه الآن من قائمة ابدأ -> بصفحة Drivers اضغط Download ثم Install ليحدّث تعريف الشاشة والصوت تلقائياً." -ForegroundColor Green
} else {
    Write-Host "`n⚠️ winget رجع خطأ. جرّب الطريقة اليدوية:" -ForegroundColor Yellow
    Write-Host "https://www.nvidia.com/Download/index.aspx" -ForegroundColor Yellow
    Start-Process "https://www.nvidia.com/Download/index.aspx"
}

Write-Host "`n=== انتهى ===`n" -ForegroundColor Cyan
