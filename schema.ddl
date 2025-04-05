--
--  A3GLG Schema
--  Author: [Your Name]
--  File: schema.ddl
--
--  Documenting design decisions as required by the assignment:
--
--  Could not enforce (without triggers or assertions):
--    1. “No member can participate in two game sessions at the same time.”
--       Enforcing that a member not appear in more than one session for the same event
--       requires a more complex constraint or an assertion/trigger.
--    2. “No exec member can facilitate two game sessions at once, or facilitate a session
--       while playing in another session.” Similarly requires an assertion or trigger
--       to prevent certain combinations in SessionParticipation.
--    3. “Exactly one lead per event type.” A simple check constraint is insufficient
--       in standard SQL. We would need an assertion or trigger to enforce that exactly
--       one row in the committee table has is_lead = TRUE for each event type.
--
--  Did not enforce (though it is possible in SQL without triggers/assertions):
--    - For the domain data, we did not enforce that a "Damaged" copy can never be used
--      in a GameSession. A partial solution could be attempted with a CHECK that disallows
--      references to a "Damaged" copy, but that typically requires triggers.
--
--  Extra constraints:
--    1. We require that min_players <= max_players (CHECK).
--    2. We require that category and condition come from a set of allowed values (CHECK).
--    3. We have decided that each (title, publisher, release_year) combination is unique,
--       presuming that no two different “board games” would share all three.
--
--  Assumptions:
--    1. We allow storing only one “role” string for each exec. If an exec changes roles,
--       presumably we update the row.
--    2. We treat “Damaged” board games as still present in inventory. Whether or not they
--       can be used in sessions is not enforced by the schema (would need triggers).
--    3. A game can have 1..n copies. We do not store “0” copies because that would not appear
--       in GameCopies at all.
--

/* ----------------------------------------------------------
   1. Drop and create schema, as required
----------------------------------------------------------- */
DROP SCHEMA IF EXISTS A3GLG CASCADE;
CREATE SCHEMA A3GLG;
SET SEARCH_PATH TO A3GLG;

/* ----------------------------------------------------------
   2. Members Table
   - Stores all club members
   - Primary Key: member_id
----------------------------------------------------------- */
CREATE TABLE Members (
    member_id       SERIAL PRIMARY KEY,
    full_name       VARCHAR(100) NOT NULL,
    email           VARCHAR(100) NOT NULL UNIQUE,
    level_of_study  VARCHAR(20) NOT NULL
        CHECK (level_of_study IN ('Undergraduate','Graduate','Alumni'))
);

/* ----------------------------------------------------------
   3. Execs Table
   - Subset of members who are executives
   - Each Exec is also a Member (1-to-1 relationship via PK=FK)
   - Primary Key: exec_id references Members(member_id)
----------------------------------------------------------- */
CREATE TABLE Execs (
    exec_id     INT PRIMARY KEY
        REFERENCES Members(member_id)
        ON DELETE CASCADE,
    role        VARCHAR(50) NOT NULL,
    date_since  DATE NOT NULL
);

/* ----------------------------------------------------------
   4. Games Table
   - Each unique board game
   - We enforce a unique (title, publisher, release_year) to
     minimize duplicates.
   - Primary Key: game_id
----------------------------------------------------------- */
CREATE TABLE Games (
    game_id         SERIAL PRIMARY KEY,
    title           VARCHAR(200) NOT NULL,
    category        VARCHAR(50) NOT NULL
        CHECK (category IN (
            'Strategy','Party','Deck-building','Role-playing','Social-deduction'
        )),
    min_players     INT NOT NULL,
    max_players     INT NOT NULL,
    publisher       VARCHAR(100) NOT NULL,
    release_year    INT NOT NULL,
    CONSTRAINT players_check
        CHECK (min_players <= max_players),
    CONSTRAINT unique_game
        UNIQUE (title, publisher, release_year)
);

/* ----------------------------------------------------------
   5. GameCopies Table
   - Tracks each physical copy of a game that GLG owns
   - Condition from a set of enumerated values
   - Primary Key: copy_id
   - Foreign Key: game_id -> Games
----------------------------------------------------------- */
CREATE TABLE GameCopies (
    copy_id         SERIAL PRIMARY KEY,
    game_id         INT NOT NULL
        REFERENCES Games(game_id)
        ON DELETE CASCADE,
    acquired_date   DATE NOT NULL,
    condition       VARCHAR(20) NOT NULL
        CHECK (condition IN (
            'New','Lightly-used','Worn','Incomplete','Damaged'
        ))
);

/* ----------------------------------------------------------
   6. EventTypes Table
   - Abstract "type" of event (e.g. "Weekly Game Night",
     "Term Kickoff", etc.)
   - Each type can occur multiple times on different dates/locations
   - The same exec committee is responsible for all occurrences
   - Primary Key: event_type_id
----------------------------------------------------------- */
CREATE TABLE EventTypes (
    event_type_id   SERIAL PRIMARY KEY,
    event_name      VARCHAR(200) NOT NULL,
    -- You could enforce no two EventTypes share same event_name if you want:
    CONSTRAINT event_name_unique UNIQUE (event_name)
);

/* ----------------------------------------------------------
   7. EventTypeCommittee Table
   - Many-to-many relationship between an event type and
     the execs in its organizing committee.
   - is_lead: indicates if this exec is the lead for that event type.
   - We want exactly one lead per event type, but that requires
     triggers or assertions to *fully* enforce.
   - Primary Key: (event_type_id, exec_id)
----------------------------------------------------------- */
CREATE TABLE EventTypeCommittee (
    event_type_id   INT NOT NULL
        REFERENCES EventTypes(event_type_id)
        ON DELETE CASCADE,
    exec_id         INT NOT NULL
        REFERENCES Execs(exec_id)
        ON DELETE CASCADE,
    is_lead         BOOLEAN NOT NULL DEFAULT FALSE,
    PRIMARY KEY (event_type_id, exec_id)
    -- A partial approach (one lead max) might be:
    --   UNIQUE (event_type_id, is_lead) WHERE is_lead = TRUE
    -- but that is not fully standard; triggers or assertions do it better.
);

/* ----------------------------------------------------------
   8. Events Table
   - Each occurrence of a given event type.
   - The same event_type_id can appear multiple times with different
     date/location. This satisfies "Events with the same name can
     occur multiple times."
   - Must have a valid event_type_id from EventTypes.
   - Primary Key: event_id
----------------------------------------------------------- */
CREATE TABLE Events (
    event_id        SERIAL PRIMARY KEY,
    event_type_id   INT NOT NULL
        REFERENCES EventTypes(event_type_id)
        ON DELETE CASCADE,
    event_date      DATE NOT NULL,
    location        VARCHAR(200) NOT NULL
);

/* ----------------------------------------------------------
   9. GameSessions Table
   - A "game session" at a specific event occurrence
   - Involves a particular board game copy, has exactly one facilitating exec
   - Primary Key: session_id
----------------------------------------------------------- */
CREATE TABLE GameSessions (
    session_id      SERIAL PRIMARY KEY,
    event_id        INT NOT NULL
        REFERENCES Events(event_id)
        ON DELETE CASCADE,
    copy_id         INT NOT NULL
        REFERENCES GameCopies(copy_id)
        ON DELETE RESTRICT,
    facilitator_id  INT NOT NULL
        REFERENCES Execs(exec_id)
        ON DELETE RESTRICT
    -- We do NOT enforce "Damaged copies cannot be used" in pure DDL,
    -- as that typically requires a trigger or more advanced constraint.
);

/* ----------------------------------------------------------
   10. SessionParticipation Table
   - Tracks which members played in which session
   - Many-to-many relationship
   - Primary Key: (session_id, member_id)
   - We do NOT enforce "no member can be in two sessions at once" solely in DDL.
----------------------------------------------------------- */
CREATE TABLE SessionParticipation (
    session_id  INT NOT NULL
        REFERENCES GameSessions(session_id)
        ON DELETE CASCADE,
    member_id   INT NOT NULL
        REFERENCES Members(member_id)
        ON DELETE CASCADE,
    PRIMARY KEY (session_id, member_id)
);
