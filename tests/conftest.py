import sys
import os

# 獲取項目根目錄的路徑
project_root = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))

# 將項目根目錄添加到 Python 路徑中
sys.path.insert(0, project_root)
