/*
NBA 2018 Draft Class Analysis
Created: 2025-07-05
Description: Comprehensive analysis of the 2018 NBA Draft class including redraft, value assessment, and team performance metrics.
*/

-- 1. First, create a CTE to calculate the impact score
WITH PlayerImpact AS (
    SELECT 
        ID,
        Player,
        Draft_Status,
        Draft_Position AS Original_Position,
        Team,
        G,
        MP,
        PTS,
        TRB,
        AST,
        STL,
        BLK,
        FG_PCT,
        FT_PCT,
        [3P_PCT],
        -- Calculate raw impact score (weighted sum of key stats)
        -- Base impact score components using total statistics
        (
            (PTS * 1.0) + 
            (TRB * 1.2) + 
            (AST * 1.5) + 
            (STL * 3.0) + 
            (BLK * 3.0) - 
            (TOV * 1.0) +  -- Penalty for turnovers
            (FG_PCT * 100) + 
            (FT_PCT * 50) + 
            ([3P_PCT] * 50)
        ) * 
        -- Games played multiplier (G/500)
        (CAST(G AS FLOAT) / 500.0) AS RawImpactScore
    FROM [dbo].[Revised_2018_NBA_Draft]
    WHERE G > 0  -- Only include players who actually played
),
-- 2. Normalize the impact scores to 1-100 scale
NormalizedImpact AS (
    SELECT 
        *,
        -- Normalize to 1-100 scale
        1 + ((RawImpactScore - MIN(RawImpactScore) OVER ()) * 99) / 
            (NULLIF(MAX(RawImpactScore) OVER () - MIN(RawImpactScore) OVER (), 0)) AS NormalizedImpactScore
    FROM PlayerImpact
),
-- 3. Add redraft position
Redraft AS (
    SELECT 
        *,
        ROW_NUMBER() OVER (ORDER BY NormalizedImpactScore DESC) AS Redraft_Position
    FROM NormalizedImpact
),
-- 4. Add value status and position change
PlayerValuation AS (
    SELECT 
        *,
        -- Calculate position difference (positive means better than drafted, negative means worse)
        CASE 
            WHEN Original_Position = 0 THEN 60 - Redraft_Position  -- Undrafted players get maximum possible position difference
            ELSE Original_Position - Redraft_Position
        END AS Position_Difference,
        -- Value Status categorization
        CASE 
            WHEN Original_Position = 0 AND Redraft_Position <= 30 THEN 'MASSIVE UNDRAFTED STEAL'
            WHEN Original_Position = 0 AND Redraft_Position <= 60 THEN 'UNDRAFTED STEAL'
            WHEN Original_Position > 20 AND Redraft_Position <= 10 THEN 'HUGE STEAL'
            WHEN Original_Position > 30 AND Redraft_Position <= 15 THEN 'STEAL'
            WHEN Original_Position BETWEEN 1 AND 10 AND Redraft_Position > 30 THEN 'MAJOR BUST'
            WHEN Original_Position BETWEEN 1 AND 5 AND Redraft_Position > 20 THEN 'BUST'
            ELSE 'Expected Value'
        END AS Value_Status,
        -- Position Change calculation
        CASE 
            WHEN Original_Position = 0 THEN 'Undrafted -> Pick ' + CAST(Redraft_Position as VARCHAR(3))
            ELSE 'Pick ' + CAST(Original_Position as VARCHAR(3)) + ' -> Pick ' + CAST(Redraft_Position as VARCHAR(3))
        END AS Position_Change
    FROM Redraft
)

-- Main analysis queries with new fields
SELECT 
    Player,
    Team,
    Draft_Status,
    Original_Position,
    Redraft_Position,
    Position_Change,
    Value_Status,
    ROUND(RawImpactScore, 2) AS RawImpactScore,
    ROUND(NormalizedImpactScore, 2) AS NormalizedImpactScore,
    G AS GamesPlayed,
    ROUND(PTS * 1.0 / G, 1) AS PPG,
    ROUND(AST * 1.0 / G, 1) AS APG,
    ROUND(TRB * 1.0 / G, 1) AS RPG
FROM PlayerValuation
ORDER BY Redraft_Position;

-- Additional analysis by value status
SELECT 
    Value_Status,
    COUNT(*) AS PlayerCount,
    ROUND(AVG(RawImpactScore), 2) AS AvgRawImpact,
    ROUND(AVG(NormalizedImpactScore), 2) AS AvgNormalizedImpact,
    STRING_AGG(Player, ', ') WITHIN GROUP (ORDER BY NormalizedImpactScore DESC) AS Players
FROM PlayerValuation
GROUP BY Value_Status
ORDER BY 
    CASE Value_Status
        WHEN 'MASSIVE UNDRAFTED STEAL' THEN 1
        WHEN 'HUGE STEAL' THEN 2
        WHEN 'UNDRAFTED STEAL' THEN 3
        WHEN 'STEAL' THEN 4
        WHEN 'Expected Value' THEN 5
        WHEN 'BUST' THEN 6
        WHEN 'MAJOR BUST' THEN 7
        ELSE 8
    END;

-- Team analysis with value status breakdown
SELECT 
    Team,
    COUNT(*) AS TotalPlayers,
    SUM(CASE WHEN Value_Status = 'MASSIVE UNDRAFTED STEAL' THEN 1 ELSE 0 END) AS MassiveUndraftedSteals,
    SUM(CASE WHEN Value_Status = 'HUGE STEAL' THEN 1 ELSE 0 END) AS HugeSteals,
    SUM(CASE WHEN Value_Status = 'UNDRAFTED STEAL' THEN 1 ELSE 0 END) AS UndraftedSteals,
    SUM(CASE WHEN Value_Status = 'STEAL' THEN 1 ELSE 0 END) AS Steals,
    SUM(CASE WHEN Value_Status = 'MAJOR BUST' THEN 1 ELSE 0 END) AS MajorBusts,
    SUM(CASE WHEN Value_Status = 'BUST' THEN 1 ELSE 0 END) AS Busts,
    ROUND(AVG(NormalizedImpactScore), 2) AS AvgNormalizedImpact,
    -- Add player with highest normalized impact score
    (
        SELECT TOP 1 Player 
        FROM PlayerValuation pv2 
        WHERE pv2.Team = pv.Team 
        ORDER BY NormalizedImpactScore DESC
    ) AS TopImpactPlayer,
    (
        SELECT TOP 1 ROUND(NormalizedImpactScore, 2)
        FROM PlayerValuation pv2 
        WHERE pv2.Team = pv.Team 
        ORDER BY NormalizedImpactScore DESC
    ) AS TopImpactScore,
    (
        SELECT TOP 1 G
        FROM PlayerValuation pv2 
        WHERE pv2.Team = pv.Team 
        ORDER BY NormalizedImpactScore DESC
    ) AS TopPlayerGamesPlayed
FROM PlayerValuation pv
GROUP BY Team
ORDER BY AvgNormalizedImpact DESC;
