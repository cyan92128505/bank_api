# Logger configuration
import logging
import sys
from pkg.config.config import settings

# 新增 logger
logger = logging.getLogger(settings.API_NAME)

# 設置日誌級別
logger.setLevel(logging.INFO)

# 新增控制台處理器
console_handler = logging.StreamHandler(sys.stdout)
console_handler.setLevel(logging.INFO)

# 新增格式器
formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')
console_handler.setFormatter(formatter)

# 將處理器添加到 logger
logger.addHandler(console_handler)
