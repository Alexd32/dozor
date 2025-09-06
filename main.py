import asyncio
import logging
from bot_instance import bot, dp

from handlers.start import router as start_router
from handlers.admin import router as admin_router
from handlers.player import router as player_router

logging.basicConfig(level=logging.INFO)

async def main():
    dp.include_router(start_router)   # /start
    dp.include_router(admin_router)   # кнопки админа
    dp.include_router(player_router)  # кнопки игрока

    logging.info("✅ Бот запущен и ждёт события...")
    await dp.start_polling(bot)

if __name__ == "__main__":
    asyncio.run(main())
