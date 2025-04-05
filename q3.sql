WITH game_facilitations AS (
    SELECT gc.game_id,
           gs.facilitator_id,
           COUNT(*) AS sessions_facilitated
    FROM GameSessions gs
    JOIN GameCopies gc ON gc.copy_id = gs.copy_id
    GROUP BY gc.game_id, gs.facilitator_id
)
SELECT g.title AS board_game,
       m.full_name AS exec_name,
       gf.sessions_facilitated
FROM game_facilitations gf
JOIN Games g ON g.game_id = gf.game_id
JOIN Execs e ON e.exec_id = gf.facilitator_id
JOIN Members m ON m.member_id = e.exec_id
ORDER BY gf.sessions_facilitated DESC
LIMIT 1;