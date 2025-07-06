# NBA 2018 Draft Class Analysis

## Overview
This project provides a comprehensive analysis of the 2018 NBA Draft class, evaluating player performance, draft value, and team drafting efficiency. The analysis uses T-SQL to process and analyze player statistics, generating insights into draft steals, busts, and overall team performance.

## Features

### Player Analysis
- **Redraft Rankings**: See how players should have been drafted based on their career performance
- **Impact Scores**: Both raw and normalized (1-100 scale) impact scores for each player
- **Value Assessment**: Categorization of players into:
  - Massive Steal (30+ spots better than draft position)
  - Huge Steal (15-29 spots better)
  - Steal (6-14 spots better)
  - Expected Value (within 5 spots of draft position)
  - Bust (5+ spots worse than draft position)
  - Undrafted Steal/Gem (for undrafted players performing at a high level)

### Team Analysis
- Draft performance metrics by team
- Count of steals, busts, and value picks per team
- Average impact scores by team

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

Player impact is calculated using a weighted formula that considers:
- Points per game (1.0x)
- Rebounds per game (1.2x)
- Assists per game (1.5x)
- Steals per game (3.0x)
- Blocks per game (3.0x)
- Shooting percentages (scaled appropriately)

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- NBA for the statistical data
- Basketball Reference for historical draft information
