from aiogram.types import ReplyKeyboardMarkup, KeyboardButton

player_kb = ReplyKeyboardMarkup(
    keyboard=[
        [KeyboardButton(text="Получить задание")],
        [KeyboardButton(text="Получить подсказку")],
        [KeyboardButton(text="Ввести код")]
    ],
    resize_keyboard=True
)

admin_kb = ReplyKeyboardMarkup(
    keyboard=[
        [KeyboardButton(text="Тестовая кнопка")],
        [KeyboardButton(text="Проверить БД")]
    ],
    resize_keyboard=True
)
