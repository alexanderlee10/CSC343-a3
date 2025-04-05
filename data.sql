-------------------------------
-- 1. Insert into Members Table
-------------------------------
INSERT INTO Members (member_id, full_name, email, level_of_study) VALUES
(1, 'Jason', 'jason@example.com', 'Undergraduate'),
(2, 'Zach', 'zach@example.com', 'Undergraduate'),
(3, 'Josh', 'josh@example.com', 'Undergraduate'),
(4, 'Eryka', 'eryka@example.com', 'Undergraduate'),
(5, 'Grace', 'grace@example.com', 'Undergraduate'),
(6, 'Tawfiq', 'tawfiq@example.com', 'Undergraduate'),
(7, 'Jimbo', 'jimbo@example.com', 'Undergraduate'),
(8, 'Evelyn', 'evelyn@example.com', 'Undergraduate'),
(9, 'Christian', 'christian@example.com', 'Undergraduate'),
(10, 'Cameron', 'cameron@example.com', 'Undergraduate'),
(11, 'Honda', 'honda@example.com', 'Undergraduate'),
(12, 'Justin', 'justin@example.com', 'Undergraduate'),
(13, 'Ari', 'ari@example.com', 'Undergraduate'),
(14, 'Max', 'max@example.com', 'Undergraduate'),
(15, 'Akshay', 'akshay@example.com', 'Undergraduate'),
(16, 'Ella', 'ella@example.com', 'Undergraduate');

-------------------------------
-- 2. Insert into Execs Table
-- Only a subset of members are execs.
-------------------------------
INSERT INTO Execs (exec_id, role, date_since) VALUES
(1, 'Organizer', '2025-01-01'),  -- Jason
(2, 'Organizer', '2025-01-01'),  -- Zach
(3, 'Organizer', '2025-01-01'),  -- Josh
(4, 'Organizer', '2025-01-01');  -- Eryka

-------------------------------
-- 3. Insert into Games Table
-------------------------------
INSERT INTO Games (game_id, title, category, min_players, max_players, publisher, release_year) VALUES
(1, 'Blood on the Clocktower', 'Social-deduction', 4, 10, 'PublisherA', 2020),
(2, 'Turing Machine', 'Strategy', 2, 4, 'PublisherB', 2019),
(3, 'Cascadia', 'Deck-building', 2, 4, 'PublisherC', 2021),
(4, 'Cryptid', 'Strategy', 2, 4, 'PublisherD', 2018),
(5, 'Avalon', 'Party', 5, 10, 'PublisherE', 2022),
(6, '7 Wonders', 'Strategy', 3, 7, 'PublisherF', 2017);

-------------------------------
-- 4. Insert into GameCopies Table
-- The club owns:
--   1 copy each of Blood on the Clocktower, Turing Machine, Cascadia, Cryptid,
--   2 copies each of Avalon and 7 Wonders.
-------------------------------
INSERT INTO GameCopies (copy_id, game_id, acquired_date, condition) VALUES
(1, 1, '2025-01-10', 'New'),   -- Blood on the Clocktower
(2, 2, '2025-01-10', 'New'),   -- Turing Machine
(3, 3, '2025-01-10', 'New'),   -- Cascadia
(4, 4, '2025-01-10', 'New'),   -- Cryptid
(5, 5, '2025-01-10', 'New'),   -- Avalon (first copy)
(6, 5, '2025-01-10', 'New'),   -- Avalon (second copy)
(7, 6, '2025-01-10', 'New'),   -- 7 Wonders (first copy)
(8, 6, '2025-01-10', 'New');   -- 7 Wonders (second copy)

-------------------------------
-- 5. Insert into EventTypes Table
-------------------------------
INSERT INTO EventTypes (event_type_id, event_name) VALUES
(1, 'Weekly Boardgame Event'),
(2, 'Basement Clocktower Event'),
(3, 'Outdoor Social Event');

-------------------------------
-- 6. Insert into EventTypeCommittee Table
-- Assign organizing exec(s) for each event type.
-------------------------------
-- Weekly Boardgame Event organized by Jason
INSERT INTO EventTypeCommittee (event_type_id, exec_id, is_lead) VALUES
(1, 1, TRUE);

-- Basement Clocktower Event organized by Zach
INSERT INTO EventTypeCommittee (event_type_id, exec_id, is_lead) VALUES
(2, 2, TRUE);

-- Outdoor Social Event organized by Josh (lead) and Eryka
INSERT INTO EventTypeCommittee (event_type_id, exec_id, is_lead) VALUES
(3, 3, TRUE),
(3, 4, FALSE);

-------------------------------
-- 7. Insert into Events Table
-- Create event occurrences.
-------------------------------
-- Weekly Boardgame Event occurrences (event_type_id = 1)
INSERT INTO Events (event_id, event_type_id, event_date, location) VALUES
(1, 1, '2025-03-05', 'Weekly Venue'),
(2, 1, '2025-03-12', 'Weekly Venue');

-- Basement Clocktower Event occurrences (event_type_id = 2)
INSERT INTO Events (event_id, event_type_id, event_date, location) VALUES
(3, 2, '2025-03-05', 'Basement Venue'),
(4, 2, '2025-03-12', 'Basement Venue');

-- Outdoor Social Event occurrence (no game sessions) (event_type_id = 3)
INSERT INTO Events (event_id, event_type_id, event_date, location) VALUES
(5, 3, '2025-12-15', 'Outdoor Park');

-------------------------------
-- 8. Insert into GameSessions Table
-------------------------------
-- Weekly Boardgame Event (Event IDs 1 and 2)
-- Session 1 (Event 1): Turing Machine, facilitated by Eryka (exec_id=4), using copy_id 2.
INSERT INTO GameSessions (session_id, event_id, copy_id, facilitator_id) VALUES
(1, 1, 2, 4),
-- Session 2 (Event 1): 7 Wonders, facilitated by Jason (exec_id=1), using copy_id 7.
(2, 1, 7, 1),
-- Session 3 (Event 2): Cascadia, facilitated by Eryka (exec_id=4), using copy_id 3.
(3, 2, 3, 4),
-- Session 4 (Event 2): Avalon, facilitated by Jason (exec_id=1), using copy_id 5.
(4, 2, 5, 1),
-- Session 5 (Event 2): 7 Wonders, facilitated by Josh (exec_id=3), using copy_id 8.
(5, 2, 8, 3),
-- Basement Clocktower Event (Event IDs 3 and 4)
-- Session 6 (Event 3): Blood on the Clocktower, facilitated by Zach (exec_id=2), using copy_id 1.
(6, 3, 1, 2),
-- Session 7 (Event 4): Blood on the Clocktower, facilitated by Zach (exec_id=2), using copy_id 1.
(7, 4, 1, 2);

-------------------------------
-- 9. Insert into SessionParticipation Table
-------------------------------
-- Session 1 (session_id=1): Turing Machine session; participants: Eryka, Josh, Grace.
INSERT INTO SessionParticipation (session_id, member_id) VALUES
(1, 4),
(1, 3),
(1, 5);

-- Session 2 (session_id=2): 7 Wonders session; participants: Jason, Tawfiq, Jimbo, Evelyn, Christian.
INSERT INTO SessionParticipation (session_id, member_id) VALUES
(2, 1),
(2, 6),
(2, 7),
(2, 8),
(2, 9);

-- Session 3 (session_id=3): Cascadia session; participants: Eryka, Grace, Evelyn, Ella.
INSERT INTO SessionParticipation (session_id, member_id) VALUES
(3, 4),
(3, 5),
(3, 8),
(3, 16);

-- Session 4 (session_id=4): Avalon session; participants: Jason, Jimbo, Tawfiq, Cameron, Zach, Honda.
INSERT INTO SessionParticipation (session_id, member_id) VALUES
(4, 1),
(4, 7),
(4, 6),
(4, 10),
(4, 2),
(4, 11);

-- Session 5 (session_id=5): 7 Wonders session; participants: Josh, Justin, Ari, Max.
INSERT INTO SessionParticipation (session_id, member_id) VALUES
(5, 3),
(5, 12),
(5, 13),
(5, 14);

-- Session 6 (session_id=6): Blood on the Clocktower session; participants: Zach, Jimbo, Tawfiq, Jason, Evelyn, Honda, Akshay.
INSERT INTO SessionParticipation (session_id, member_id) VALUES
(6, 2),
(6, 7),
(6, 6),
(6, 1),
(6, 8),
(6, 11),
(6, 15);

-- Session 7 (session_id=7): Blood on the Clocktower session; participants: Zach, Jimbo, Tawfiq, Jason, Evelyn, Honda, Akshay.
INSERT INTO SessionParticipation (session_id, member_id) VALUES
(7, 2),
(7, 7),
(7, 6),
(7, 1),
(7, 8),
(7, 11),
(7, 15);
