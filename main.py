import asyncio
import logging
from aiogram import Bot, Dispatcher
import config

# Импортируем роутеры из модулей
from handlers import start, admin, player

logging.basicConfig(level=logging.INFO)

bot = Bot(token=config.TELEGRAM_TOKEN)
dp = Dispatcher()


async def main():
    # Подключаем роутеры
    dp.include_router(start.router)
    dp.include_router(admin.router)
    dp.include_router(player.router)

    logging.info("✅ Бот запущен и ждёт события...")
    await dp.start_polling(bot)


if __name__ == "__main__":
    asyncio.run(main())
