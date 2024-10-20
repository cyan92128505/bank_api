from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from contextlib import asynccontextmanager
from pkg.config.config import settings
from pkg.logger import logger

@asynccontextmanager
async def lifespan(app: FastAPI):
    # 啟動事件
    logger.info(f"Starting up the application: {settings.API_NAME}")
    # TODO: 資料庫連線
    yield
    # 關閉事件
    logger.info(f"Shutting down the application: {settings.API_NAME}")
    # TODO: 資料庫斷線


app = FastAPI(title=settings.API_NAME, version="1.0.0", lifespan=lifespan)

# CORS 設置
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # 在生產環境中應該設置為特定域名
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/")
async def root():
    return {"message": f"Welcome to {settings.API_NAME}"}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run("main:app", host="0.0.0.0", port=8000, reload=True)