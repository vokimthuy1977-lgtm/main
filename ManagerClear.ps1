# 1. Yêu cầu nhập đường dẫn thư mục
$folderPath = Read-Host "Nhap duong dan thu muc chua cac file"

if (-not (Test-Path $folderPath)) {
    Write-Host "Duong dan khong ton tai!" -ForegroundColor Red
    exit
}

# Mảng lưu danh sách tên file không kèm đuôi mở rộng (BaseName)
$dollarBaseNames = @()

# 2. BƯỚC 1: Quét TẤT CẢ các file có tên bắt đầu bằng '$' và đổi tên file
Write-Host "`n--- BƯỚC 1: Quét tên file, lưu tên KHÔNG ĐUÔI và đổi tên file ---" -ForegroundColor Cyan

# Quét đệ quy tất cả các thư mục con
$files = Get-ChildItem -Path $folderPath -File -Recurse

foreach ($file in $files) {
    if ($file.Name.StartsWith('$')) {
        # Lưu tên KHÔNG CÓ ĐUÔI (ví dụ: "$haha.txt" -> lưu "$haha")
        $dollarBaseNames += $file.BaseName
        
        # Tạo tên file mới thực tế trên đĩa (thay $ ở đầu tên bằng _)
        $newName = '_' + $file.Name.Substring(1)
        
        # Tiến hành đổi tên file thực tế
        Rename-Item -Path $file.FullName -NewName $newName
        Write-Host "Da doi ten file: $($file.FullName) -> $newName" -ForegroundColor Green
    }
}

# Loại bỏ các tên trùng lặp trong mảng
$dollarBaseNames = $dollarBaseNames | Select-Object -Unique

Write-Host "`nTong so từ khóa '$' (không đuôi) da ghi nhan: $($dollarBaseNames.Count)" -ForegroundColor Yellow

if ($dollarBaseNames.Count -eq 0) {
    Write-Host "Khong tim thay file nao bat dau bang '$'. Ket thuc." -ForegroundColor Yellow
    exit
}

# 3. BƯỚC 2: Quét nội dung các file và thay thế tên không đuôi
Write-Host "`n--- BƯỚC 2: Thay thế tên KHÔNG ĐUÔI trong nội dung các file ---" -ForegroundColor Cyan

# Lấy lại danh sách file trong các thư mục con
$updatedFiles = Get-ChildItem -Path $folderPath -File -Recurse

foreach ($file in $updatedFiles) {
    # Đọc toàn bộ nội dung file (UTF-8)
    $content = Get-Content -Path $file.FullName -Raw -Encoding UTF8
    $isModified = $false

    # So sánh nội dung với từng tên KHÔNG CÓ ĐUÔI trong mảng
    foreach ($oldBaseName in $dollarBaseNames) {
        # Tạo chuỗi mới (ví dụ: "$haha" -> "_haha")
        $newBaseName = '_' + $oldBaseName.Substring(1)

        # Kiểm tra xem trong nội dung file có chứa từ khóa (VD: $haha) hay không
        if ($content.Contains($oldBaseName)) {
            $content = $content.Replace($oldBaseName, $newBaseName)
            $isModified = $true
            Write-Host "   + Phat hien '$oldBaseName' trong file '$($file.Name)' -> Da thay bang '$newBaseName'" -ForegroundColor Gray
        }
    }

    # Nếu có thay đổi thì lưu đè lại file
    if ($isModified) {
        Set-Content -Path $file.FullName -Value $content -Encoding UTF8
        Write-Host "-> Da cap nhat noi dung file: $($file.FullName)" -ForegroundColor Green
    }
}

Write-Host "`n=== HOÀN THÀNH TẤT CẢ CÁC BƯỚC ===" -ForegroundColor Green