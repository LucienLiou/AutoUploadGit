#!/bin/zsh

# 載入環境變數
source .env
echo "請拖入檔案："
read folderPath
cd $folderPath
#.zip 的上傳方法
for file in *.zip; do
  if [[ -f "$file" ]]; then
    # 解壓縮檔案
    unzip "$file"
    # 上傳檔案到 GitHub
  repository_name="${file%.zip}"
    curl -u "$GITHUB_USER:$ACCESS_TOKEN" \
         -X POST \
         -H "Accept: application/vnd.github.v3+json" \
         "https://api.github.com/user/repos" \
         -d "{\"name\":\"$repository_name\"}"
    git init
    git add .
    git commit -m "Initial commit"
    git remote add origin "https://github.com/$GITHUB_USER/$repository_name.git"
    git push -u origin master && echo "完成上傳"
    wait

    # 刪除壓縮檔案和解壓縮後的檔案
    rm -rf "$repository_name"
  fi
done
