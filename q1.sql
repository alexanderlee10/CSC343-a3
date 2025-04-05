SELECT e.event_id,
       e.event_date,
       e.location,
       ROUND(
         100.0 * COUNT(DISTINCT sp.member_id)
         / (SELECT COUNT(*) FROM members),
         2
       ) AS participation_percentage
FROM Events e
JOIN GameSessions gs ON gs.event_id = e.event_id
JOIN SessionParticipation sp ON sp.session_id = gs.session_id
GROUP BY e.event_id, e.event_date, e.location
ORDER BY e.event_id;