from aiogram import Router
from . import get_task, get_hint, enter_code

router = Router()
router.include_router(get_task.router)
router.include_router(get_hint.router)
router.include_router(enter_code.router)
