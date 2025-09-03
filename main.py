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

# Клавиатура игрока
player_kb = ReplyKeyboardMarkup(
    keyboard=[
        [KeyboardButton(text="Получить задание")],
        [KeyboardButton(text="Получить подсказку")],
        [KeyboardButton(text="Ввести код")]
    ],
    resize_keyboard=True
)

# Клавиатура админа
admin_kb = ReplyKeyboardMarkup(
    keyboard=[
        [KeyboardButton(text="Тестовая кнопка")],
        [KeyboardButton(text="Проверить БД")]
    ],
    resize_keyboard=True
)

# Проверка админа
def is_admin(username: str) -> bool:
    return username and username.lower() in [u.lower() for u in config.ADMINS]

# Подключение к БД
def get_connection():
    return mysql.connector.connect(**config.DB_CONFIG)

# Получить текущий статус игры
def get_game_status():
    conn = get_connection()
    cur = conn.cursor(dictionary=True)
    cur.execute("SELECT id, status FROM games ORDER BY id DESC LIMIT 1")
    row = cur.fetchone()
    conn.close()
    return row  # {'id': 1, 'status': 'in_progress'} или None

# /start (универсально)
@dp.message(Command("start"))
async def start_cmd(message: Message):
    username = message.from_user.username

    if is_admin(username):
        await message.answer("👑 Привет, админ! Вот твои кнопки:", reply_markup=admin_kb)
        return

    if not username:
        await message.answer("❌ У тебя нет username в Telegram. Установи его в настройках.")
        return

    try:
        conn = get_connection()
        cur = conn.cursor(dictionary=True)
        cur.execute("""
            SELECT gp.team
            FROM game_players gp
            JOIN players p ON gp.player_id = p.id
            WHERE p.username = %s
            LIMIT 1
        """, (username,))
        row = cur.fetchone()
        conn.close()

        if row:
            await message.answer(f"✅ Команда зарегистрирована: {row['team']}", reply_markup=player_kb)
        else:
            await message.answer("❌ Нет доступа")
    except Exception as e:
        await message.answer(f"Ошибка подключения к БД: {e}")

# Игрок: получить задание
@dp.message(lambda m: m.text == "Получить задание")
async def get_task(message: Message):
    game = get_game_status()
    if not game or game["status"] == "not_started":
        await message.answer("⏳ Игра не началась")
        return
    if game["status"] == "finished":
        await message.answer("🏁 Игра завершена")
        return

    # TODO: логика выдачи задания
    await message.answer("📜 Тест: выдаём задание игроку.")

# Игрок: получить подсказку
@dp.message(lambda m: m.text == "Получить подсказку")
async def get_hint(message: Message):
    game = get_game_status()
    if not game or game["status"] == "not_started":
        await message.answer("⏳ Игра не началась")
        return
    if game["status"] == "finished":
        await message.answer("🏁 Игра завершена")
        return

    # TODO: логика выдачи подсказки
    await message.answer("💡 Тест: выдаём подсказку.")

# Игрок: ввести код
@dp.message(lambda m: m.text == "Ввести код")
async def enter_code(message: Message):
    game = get_game_status()
    if not game or game["status"] == "not_started":
        await message.answer("⏳ Игра не началась")
        return
    if game["status"] == "finished":
        await message.answer("🏁 Игра завершена")
        return

    # TODO: логика проверки кода
    await message.answer("🔑 Тест: введи код для задания.")

# Админ: тестовая кнопка
@dp.message(lambda m: m.text == "Тестовая кнопка")
async def test_button(message: Message):
    if is_admin(message.from_user.username):
        print(f"[SERVER] Команда от @{message.from_user.username}")
        await message.answer("Сообщение отправлено на сервер (тест).")
    else:
        await message.answer("Эта кнопка только для админов.")

# Админ: проверка БД
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

# Фоновая рассылка админам
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
    asyncio.create_task(background_loop())
    await dp.start_polling(bot)

if __name__ == "__main__":
    asyncio.run(main())
