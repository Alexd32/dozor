from aiogram import Router
from aiogram.types import Message

router = Router()


@router.message(lambda m: m.text == "Помощь админа")
async def admin_help(message: Message):
    await message.answer("🛠 Команды админа:\n/startgame — начать игру\n/stopgame — остановить игру")
