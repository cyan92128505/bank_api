from pkg.logger import logger

async def shutdown_event():
    logger.info("Application shutdown initiated")
    # Add any cleanup tasks here
    logger.info("Application shutdown complete")