# NBA 2018 Draft Class Analysis

## Overview
This project provides a comprehensive analysis of the 2018 NBA Draft class, evaluating player performance, draft value, and team drafting efficiency. The analysis uses T-SQL to process and analyze player statistics, generating insights into draft steals, busts, and overall team performance.

## Features

### Player Analysis
- **Redraft Rankings**: See how players should have been drafted based on their career performance
- **Impact Scores**: Both raw and normalized (1-100 scale) impact scores for each player
- **Value Assessment**: Categorization of players into:
  - `MASSIVE UNDRAFTED STEAL`: Undrafted players redrafted in top 30
  - `UNDRAFTED STEAL`: Undrafted players redrafted in top 60
  - `HUGE STEAL`: Originally drafted after 20, redrafted in top 10
  - `STEAL`: Originally drafted after 30, redrafted in top 15
  - `MAJOR BUST`: Top 10 picks that fell beyond 30 in redraft
  - `BUST`: Top 5 picks that fell beyond 20 in redraft
  - `Expected Value`: All other players

### Team Analysis
- Draft performance metrics by team
- Count of steals, busts, and value picks per team
- Average impact scores by team
- Top impact player for each team

## Database Schema

The analysis is performed on the `Revised_2018_NBA_Draft` table with the following structure:

| Column | Type | Description |
|--------|------|-------------|
| ID | smallint | Primary key |
| Player | varchar(23) | Player name |
| Draft_Status | varchar(9) | 'Drafted' or 'Undrafted' |
| Draft_Position | smallint | Original draft position (0 for undrafted) |
| G | smallint | Games played |
| PTS | smallint | Total points |
| TRB | smallint | Total rebounds |
| AST | smallint | Total assists |
| STL | smallint | Total steals |
| BLK | smallint | Total blocks |
| FG_PCT | real | Field goal percentage |
| FT_PCT | real | Free throw percentage |
| 3P_PCT | real | 3-point percentage |
| MP_Avg_Per_Gm | real | Minutes per game |
| PTS_Avg_Per_Gm | real | Points per game |
| TRB_Avg_Per_Gm | real | Rebounds per game |
| AST_Avg_Per_Gm | real | Assists per game |
| STL_Avg_Per_Gm | real | Steals per game |
| BLK_Avg_Per_Gm | real | Blocks per game |

## Getting Started

### Prerequisites
- SQL Server Management Studio 2020 or later
- Access to a SQL Server instance
- The `Revised_2018_NBA_Draft` table created in your database

### Installation
1. Clone this repository
2. Open `NBA_2018_Draft_Analysis.sql` in SQL Server Management Studio
3. Execute the script against your database

## Usage

The main analysis is contained in the SQL script, which includes several key queries:

1. **Player Redraft**: Shows how players should have been drafted based on performance
2. **Value Analysis**: Categorizes players by their value relative to draft position
3. **Team Performance**: Evaluates each team's drafting efficiency

## Impact Score Calculation

Player impact is calculated using a weighted formula based on career totals that considers:
- Total points (1.0x)
- Total rebounds (1.2x)
- Total assists (1.5x)
- Total steals (3.0x)
- Total blocks (3.0x)
- Turnovers (-1.0x penalty)
- Field goal percentage (100x)
- Free throw percentage (50x)
- 3-point percentage (50x)
- Games played multiplier (G/500) to account for career length

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- NBA for the statistical data
- Basketball Reference for historical draft information
