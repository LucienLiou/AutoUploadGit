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
    cd "${file%.zip}"
    # 上傳檔案到 GitHub

  repository_name="${file%.zip}"
    repo_id=$(curl -s -H "Authorization: token $ACCESS_TOKEN" "https://api.github.com/repos/$GITHUB_USER/$repository_name" | grep -E -o '"id": [0-9]+' | grep -E -o '[0-9]+')
    if [ -z "$repo_id" ]; then
      curl -u "$GITHUB_USER:$ACCESS_TOKEN" \
        -X POST \
        -H "Accept: application/vnd.github.v3+json" \
        "https://api.github.com/user/repos" \
        -d "{\"name\":\"$repository_name\", \"private\": true}"
    fi
    git init
    git checkout -b master
    git add .
    git commit -m "Initial commit"
    git remote add origin "git@github.com:$GITHUB_USER/$repository_name.git"
    git push -u origin master && echo "完成上傳"
    wait
    cd ..
    # 刪除壓縮檔案和解壓縮後的檔案
    rm -rf "$repository_name"
  fi
done
