WITH session_participants AS (
    SELECT gs.session_id,
           gs.event_id,
           COUNT(sp.member_id) AS participant_count
    FROM GameSessions gs
    LEFT JOIN SessionParticipation sp ON gs.session_id = sp.session_id
    GROUP BY gs.session_id, gs.event_id
)
SELECT e.event_id,
       e.event_date,
       e.location,
       ROUND(AVG(sp.participant_count),2) AS avg_participants
FROM Events e
JOIN session_participants sp ON e.event_id = sp.event_id
GROUP BY e.event_id, e.event_date, e.location
ORDER BY e.event_id;
