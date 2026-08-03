#!/bin/sh

# 1. Nhập đường dẫn thư mục res/
read -p "Nhap duong dan thu muc res (VD: ./ctst/base/res): " FOLDER

if [ ! -d "$FOLDER" ]; then
    echo "Thư mục không tồn tại!"
    exit 1
fi

echo "\n--- BƯỚC 1: Quét file thực tế dính '$', đổi tên và lưu Key ---"

# Tạo một file tạm để lưu danh sách các BaseName bị dính $
KEY_LIST=$(mktemp)

# Tìm tất cả file có tên bắt đầu bằng $
find "$FOLDER" -type f -name '$*' | while read -r FILE_PATH; do
    DIR=$(dirname "$FILE_PATH")
    FILENAME=$(basename "$FILE_PATH")
    
    # Lấy BaseName (Tên không đuôi)
    BASENAME="${FILENAME%.*}"
    
    # Lưu BaseName vào file tạm
    echo "$BASENAME" >> "$KEY_LIST"
    
    # Đổi tên file vật lý (Thay $ thành _)
    NEW_FILENAME="_${FILENAME#\$}"
    mv "$FILE_PATH" "$DIR/$NEW_FILENAME"
    
    echo "Đã đổi tên file: $FILENAME -> $NEW_FILENAME"
done

# Kiểm tra nếu không có file nào dính $
if [ ! -s "$KEY_LIST" ]; then
    echo "Khong tìm thấy file nào bắt đầu bằng '$'. Hoàn thành!"
    rm -f "$KEY_LIST"
    exit 0
fi

# Lọc trùng và SẮP XẾP THEO ĐỘ DÀI GIẢM DẦN (Tránh bẫy chuỗi con)
# (Dùng awk tính độ dài -> sort giảm dần -> lấy lại chuỗi)
SORTED_KEYS=$(sort -u "$KEY_LIST" | awk '{ print length, $0 }' | sort -nr | cut -d" " -f2-)
rm -f "$KEY_LIST"

echo "\n--- BƯỚC 2: Càn quét và update nội dung XML theo Key List ---"

echo "$SORTED_KEYS" | while read -r OLD_KEY; do
    if [ -n "$OLD_KEY" ]; then
        # Tạo Key mới (Thay $ thành _)
        NEW_KEY="_${OLD_KEY#\$}"
        
        echo "Đang thay thế Key: '$OLD_KEY' -> '$NEW_KEY' trong các file XML..."
        
        # Quét tất cả file XML và dùng sed để thay thế trực tiếp
        find "$FOLDER" -type f -name "*.xml" -exec sed -i "s/$OLD_KEY/$NEW_KEY/g" {} +
    fi
done

echo "\n=== HOÀN THÀNH! Đã dọn sạch lỗi aapt2 ==="