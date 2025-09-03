import mysql.connector
import config

def get_connection():
    return mysql.connector.connect(**config.DB_CONFIG)

def get_game_status():
    conn = get_connection()
    cur = conn.cursor(dictionary=True)
    cur.execute("SELECT id, status FROM games ORDER BY id DESC LIMIT 1")
    row = cur.fetchone()
    conn.close()
    return row  # {'id': 1, 'status': 'in_progress'} или None
