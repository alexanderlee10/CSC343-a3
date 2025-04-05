WITH participation_counts AS (
    SELECT sp.member_id,
           COUNT(DISTINCT sp.session_id) AS total_sessions
    FROM SessionParticipation sp
    GROUP BY sp.member_id
),
max_sessions AS (
    SELECT MAX(total_sessions) AS max_sessions
    FROM participation_counts
)
SELECT m.full_name,
       pc.total_sessions
FROM participation_counts pc
JOIN Members m ON m.member_id = pc.member_id
JOIN max_sessions ms ON pc.total_sessions = ms.max_sessions;