from aiogram.types import ReplyKeyboardMarkup, KeyboardButton

# Кнопки игрока
player_kb = ReplyKeyboardMarkup(
    keyboard=[
        [KeyboardButton(text="Получить задание")],
        [KeyboardButton(text="Получить подсказку")],
        [KeyboardButton(text="Ввести код")]
    ],
    resize_keyboard=True
)

# Кнопки админа
admin_kb = ReplyKeyboardMarkup(
    keyboard=[
        [KeyboardButton(text="Начать игру")],
        [KeyboardButton(text="Закончить игру")],
        [KeyboardButton(text="Показать статистику")]
    ],
    resize_keyboard=True
)
