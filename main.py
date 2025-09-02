import asyncio
import logging
import mysql.connector
from aiogram import Bot, Dispatcher
from aiogram.types import Message, ReplyKeyboardMarkup, KeyboardButton
from aiogram.filters import Command
import config

logging.basicConfig(level=logging.INFO)

# Инициализация
bot = Bot(token=config.TELEGRAM_TOKEN)
dp = Dispatcher()

# Клавиатура
kb = ReplyKeyboardMarkup(
    keyboard=[
        [KeyboardButton(text="Тестовая кнопка")],
        [KeyboardButton(text="Проверить БД")]
    ],
    resize_keyboard=True
)

# Проверка админа по username
def is_admin(username: str) -> bool:
    return username and username.lower() in [u.lower() for u in config.ADMINS]

# Функция подключения к БД
def get_connection():
    return mysql.connector.connect(**config.DB_CONFIG)

# /start
@dp.message(Command("start"))
async def start_cmd(message: Message):
    if is_admin(message.from_user.username):
        await message.answer("Привет, админ! Нажми кнопку для теста.", reply_markup=kb)
    else:
        await message.answer("У тебя нет прав для этой игры.")

# Тестовая кнопка
@dp.message(lambda m: m.text == "Тестовая кнопка")
async def test_button(message: Message):
    if is_admin(message.from_user.username):
        print(f"[SERVER] Команда от @{message.from_user.username}")
        await message.answer("Сообщение отправлено на сервер (тест).")
    else:
        await message.answer("Эта кнопка только для админов.")

# Кнопка проверки БД
@dp.message(lambda m: m.text == "Проверить БД")
async def check_db(message: Message):
    if is_admin(message.from_user.username):
        try:
            conn = get_connection()
            cur = conn.cursor()
            cur.execute("SELECT NOW()")
            ts = cur.fetchone()[0]
            conn.close()
            await message.answer(f"✅ Подключение к БД успешно!\nВремя на сервере: {ts}")
        except Exception as e:
            await message.answer(f"❌ Ошибка подключения к БД: {e}")
    else:
        await message.answer("Эта кнопка только для админов.")

# Рассылка тестового сообщения всем админам (по username)
async def send_test_message():
    inactive_admins = []
    for admin in config.ADMINS:
        try:
            chat = await bot.get_chat(f"@{admin}")
            await bot.send_message(chat.id, "Сообщение от сервера: бот работает ✅")
        except Exception as e:
            inactive_admins.append(admin)
            logging.error(f"Ошибка при отправке @{admin}: {e}")
    if inactive_admins:
        logging.warning(f"Эти админы ещё не нажали /start: {', '.join(inactive_admins)}")

# Фоновый цикл
async def background_loop():
    while True:
        await send_test_message()
        await asyncio.sleep(30)

# Главная точка входа
async def main():
    asyncio.create_task(background_loop())  # фоновая задача
    await dp.start_polling(bot)

if __name__ == "__main__":
    asyncio.run(main())
