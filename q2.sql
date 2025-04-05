SELECT g.game_id,
       g.title,
       COUNT(gs.session_id) AS total_play_count
FROM Games g
LEFT JOIN GameCopies gc ON gc.game_id = g.game_id
LEFT JOIN GameSessions gs ON gs.copy_id = gc.copy_id
GROUP BY g.game_id, g.title;