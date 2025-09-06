import logging
from aiogram import Router
from aiogram.types import Message
from db import get_connection, get_game_status

router = Router()

@router.message(lambda m: m.text == "Показать статистику")
async def show_stats(message: Message):
    try:
        game = get_game_status()
        if not game:
            await message.answer("⚠️ В базе нет активных игр.")
            return

        status_map_game = {
            "not_started": "Игра ещё не началась",
            "in_progress": "Игра идёт",
            "finished": "Игра завершена"
        }
        game_status_text = status_map_game.get(game["status"], game["status"])

        conn = get_connection()
        cur = conn.cursor(dictionary=True)
        cur.execute("""
            SELECT gp.team, p.username, pt.seq_num, t.name AS task_name, pt.status
            FROM game_players gp
            JOIN players p ON p.id = gp.player_id
            LEFT JOIN player_tasks pt ON gp.player_id = pt.player_id AND gp.game_id = pt.game_id
            LEFT JOIN tasks t ON pt.task_id = t.id
            WHERE gp.game_id = %s
            ORDER BY gp.team, pt.seq_num
        """, (game["id"],))
        rows = cur.fetchall()
        conn.close()

        if not rows:
            await message.answer(f"📊 <b>Статистика по игре</b>\nСтатус игры: <b>{game_status_text}</b>\n\n❌ Игроков нет.", parse_mode="HTML")
            return

        # Сгруппируем по игрокам
        stats = {}
        for r in rows:
            key = (r["team"], r["username"])
            if key not in stats:
                stats[key] = []
            if r["seq_num"] is not None:
                stats[key].append({
                    "seq_num": r["seq_num"],
                    "task_name": r["task_name"] or "Без названия",
                    "status": r["status"]
                })

        # Строим текст
        text = [f"📊 <b>Статистика по игре</b>\nСтатус игры: <b>{game_status_text}</b>\n"]
        for (team, username), tasks in stats.items():
            text.append(f"\n👥 <b>Команда:</b> {team} (<i>@{username}</i>)")
            if not tasks:
                text.append("  • Заданий пока нет")
            else:
                for t in tasks:
                    status_map = {
                        "waiting_answer": "⏳ В процессе",
                        "hint1": "💡 Подсказка 1",
                        "hint2": "💡 Подсказка 2",
                        "success": "✅ Выполнено",
                        "timeout": "⏰ Просрочено",
                        "finished": "🏁 Завершено",
                        None: "—"
                    }
                    st = status_map.get(t["status"], "—")
                    text.append(f"  • Задание {t['seq_num']}: {t['task_name']} — {st}")

        await message.answer("\n".join(text), parse_mode="HTML")

    except Exception as e:
        logging.error(f"Ошибка при показе статистики: {e}")
        await message.answer(f"⚠️ Ошибка при показе статистики: {e}")
