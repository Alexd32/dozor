from aiogram import Router
from . import start_game, stop_game, show_stats

router = Router()
router.include_router(start_game.router)
router.include_router(stop_game.router)
router.include_router(show_stats.router)

__all__ = ["router"]
