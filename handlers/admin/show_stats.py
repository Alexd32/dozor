import logging
from datetime import datetime
from aiogram import Router, F
from aiogram.types import Message
from db import get_connection
from limits import TASK_TIME_LIMIT, SHTRAF_TIME

router = Router(name="admin_show_stats")

MAX_LEN = 3900

async def _send_chunked(message: Message, text: str, parse_mode: str = "HTML"):
    if len(text) <= MAX_LEN:
        await message.answer(text, parse_mode=parse_mode)
        return

    lines = text.split("\n")
    buf = []
    size = 0
    for line in lines:
        add = len(line) + 1
        if size + add > MAX_LEN and buf:
            await message.answer("\n".join(buf), parse_mode=parse_mode)
            buf = [line]
            size = len(line) + 1
        else:
            buf.append(line)
            size += add
    if buf:
        await message.answer("\n".join(buf), parse_mode=parse_mode)


@router.message(F.text == "Показать статистику")
async def show_stats(message: Message):
    try:
        conn = get_connection()
        cur = conn.cursor(dictionary=True)

        cur.execute("SELECT id, status, started_at, finished_at FROM games ORDER BY id DESC LIMIT 1")
        game = cur.fetchone()
        if not game:
            await message.answer("⚠️ В базе нет игр.")
            return

        status_map = {
            "not_started": "Игра ещё не началась",
            "in_progress": "Игра идёт",
            "finished": "Игра завершена"
        }
        started_at = game["started_at"]
        finished_at = game["finished_at"]
        now = datetime.now()

        game_elapsed_str = "—"
        if started_at:
            if game["status"] == "finished" and finished_at:
                dt = finished_at - started_at
            else:
                dt = now - started_at
            game_elapsed_str = format_td(dt)

        cur.execute("SELECT COUNT(*) AS cnt FROM tasks WHERE game_id = %s", (game["id"],))
        tasks_total = (cur.fetchone() or {}).get("cnt", 0)

        cur.execute("""
            SELECT gp.team,
                   p.username,
                   pt.seq_num,
                   t.name AS task_name,
                   pt.status,
                   pt.started_at AS task_start,
                   pt.finished_at AS task_finish
              FROM game_players gp
              JOIN players p
                ON p.id = gp.player_id
         LEFT JOIN player_tasks pt
                ON pt.player_id = gp.player_id AND pt.game_id = gp.game_id
         LEFT JOIN tasks t
                ON t.id = pt.task_id
             WHERE gp.game_id = %s
          ORDER BY gp.team, pt.seq_num
        """, (game["id"],))
        rows = cur.fetchall()

        teams = {}
        for r in rows:
            key = (r["team"], r["username"])
            if key not in teams:
                teams[key] = {
                    "tasks": [],
                    "pure_seconds": 0,
                    "last_success_finish": None,
                    "success_count": 0
                }

            if r["seq_num"] is not None:
                status_view = {
                    "waiting_answer": "⏳ В процессе",
                    "hint1": "💡 Подсказка 1",
                    "hint2": "💡 Подсказка 2",
                    "success": "✅ Выполнено",
                    "timeout": "⏰ Просрочено",
                    "finished": "🏁 Завершено",
                    "not_started": "—",
                    None: "—"
                }.get(r["status"], "—")

                task_time_str = ""
                sec = None
                if r["status"] == "success" and r["task_start"] and r["task_finish"]:
                    try:
                        sec = int((r["task_finish"] - r["task_start"]).total_seconds())
                        task_time_str = f" ({sec // 60} мин {sec % 60} сек)"
                    except Exception:
                        task_time_str = ""
                elif r["status"] == "timeout":
                    sec = (TASK_TIME_LIMIT + SHTRAF_TIME) * 60
                    task_time_str = f" ({TASK_TIME_LIMIT} мин 0 сек + {SHTRAF_TIME} мин штрафное время)"

                teams[key]["tasks"].append(
                    f"  • {r['seq_num']}: {r.get('task_name') or '—'} — {status_view}{task_time_str}"
                )

                if sec is not None:
                    teams[key]["pure_seconds"] += max(sec, 0)
                    teams[key]["success_count"] += 1
                    if r["status"] == "success" and r["task_finish"]:
                        if (teams[key]["last_success_finish"] is None) or (r["task_finish"] > teams[key]["last_success_finish"]):
                            teams[key]["last_success_finish"] = r["task_finish"]

        results = []
        for (team, username), data in teams.items():
            finished_all = (tasks_total > 0 and data["success_count"] >= tasks_total)

            stop_time = None
            if finished_all and data["last_success_finish"]:
                stop_time = data["last_success_finish"]
            elif game["status"] == "finished" and finished_at:
                stop_time = finished_at
            elif game["status"] == "in_progress":
                stop_time = now

            elapsed_seconds = None
            elapsed_str = "—"
            if started_at and stop_time:
                delta = stop_time - started_at
                elapsed_seconds = max(int(delta.total_seconds()), 0)
                elapsed_str = format_sec(elapsed_seconds)

            pure_str = "—"
            if data["pure_seconds"] > 0:
                pure_str = format_sec(data["pure_seconds"])

            results.append({
                "team": team,
                "username": username,
                "elapsed_seconds": elapsed_seconds,
                "elapsed_str": elapsed_str,
                "pure_str": pure_str,
                "tasks": data["tasks"]
            })

        header = [
            "📊 <b>Статистика по игре</b>",
            f"Статус игры: <b>{status_map.get(game['status'], game['status'])}</b>",
            f"⏱ Время игры: <b>{game_elapsed_str}</b>",
        ]
        await _send_chunked(message, "\n".join(header), parse_mode="HTML")

        for r in results:
            block = []
            block.append(f"👥 <b>Команда:</b> {r['team']} (<i>@{r['username']}</i>)")
            block.append(f"⏱ Общее время: <b>{r['elapsed_str']}</b>")
            block.append(f"🕒 Чистое время заданий: <b>{r['pure_str']}</b>")
            block.extend(r["tasks"] or ["  • Заданий пока нет"])
            await _send_chunked(message, "\n".join(block), parse_mode="HTML")

        if game["status"] == "finished":
            sortable = [r for r in results if r["elapsed_seconds"] is not None]
            sortable.sort(key=lambda x: x["elapsed_seconds"])

            rating_lines = ["🏆 <b>Рейтинг команд (по общему времени игры):</b>"]
            if not sortable:
                rating_lines.append("—")
            else:
                for i, r in enumerate(sortable, 1):
                    line = f"{i} место — {r['team']} (@{r['username']}) — {r['elapsed_str']}"
                    rating_lines.append(f"<b>{line}</b>" if i == 1 else line)

            await _send_chunked(message, "\n".join(rating_lines), parse_mode="HTML")

    except Exception as e:
        logging.exception("Ошибка при показе статистики")
        await message.answer(f"⚠️ Ошибка при показе статистики: {e}")
    finally:
        try:
            cur.close()
            conn.close()
        except Exception:
            pass


def format_td(td):
    return format_sec(int(td.total_seconds()))

def format_sec(seconds: int) -> str:
    h, rem = divmod(max(0, seconds), 3600)
    m, s = divmod(rem, 60)
    if h:
        return f"{h} ч {m} мин {s} сек"
    if m:
        return f"{m} мин {s} сек"
    return f"{s} сек"
