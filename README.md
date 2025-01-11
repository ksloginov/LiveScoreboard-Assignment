# Live Football World Cup Scoreboard Library

## Overview
This library provides a simple in-memory scoreboard for live football matches. It allows starting a new match, updating scores, finishing a match, and retrieving a summary of ongoing matches sorted by total scores.

## Features
- Start a new match
- Update match scores
- Finish a match
- Retrieve a summary of ongoing matches sorted by total score

## Usage
To use the library, create an instance of `Scoreboard` and use its methods to manage football matches.

## Example
```
    let scoreboard = Scoreboard()
    scoreboard.startMatch(homeTeam: "Argentina", awayTeam: "France")
    scoreboard.updateScore(homeTeam: "Argentina", awayTeam: "France", homeScore: 3, awayScore: 3)
    let summary = scoreboard.getSummary()
    print(summary)
```

## Assumptions / Considerations

- `Total score` is the sum of the scores of both teams.
- **The same team can play only one match at a time.** If a team is already playing a match, it cannot start another match until the current match is finished.
- There's no upper limit on the number of matches that can be started.
- There's no upper limit on the number of goals in one match by any team.
- **The score may be updated with lower number, to respond to a situation of the falsely reported score or a VAR review.** As I learned while doing this assignment, there **may** be a situation where VAR cancels 2 (or more) goals consequently (if there were issues in the build-up to those goals).
- Scores follow the "European" representation style: home team score is always mentioned first.

**About the team names:**
- The teams are uniquely identified by the team name. The team name is its unique identifier.
- The team name is not empty.
- The team name is case insensitive, i.e. "Argentina" is the same as "ArGEnTiNa".
- Team names may contain spaces, digits, special characters, and more e.g. "New Zealand", "Argentina U23", "Storm!".
- The team name can be **any** string (solely characters, etc.), but it should not be empty.
- The team name is trimmed before being recorded.

**About the match's finish time:**
- The instruction says that the finished match is removed from the scoreboard. To obey the instruction, I opted not to add the `finishedTime` & `isFinished` fields in the `Match` struct. However, in a real-life scenario, we may need to keep these fields to keep track of the history of the matches.

**About score updates:**
- The same team can not play with itself.
- If the match is not started, the score update throws an error.
- If one of the teams is not playing the match (e.g., a typo in the team name), the score update throws an error.
- If the matches' home & away teams are flipped - the score update throws an error.
- The score update may decrease the number of goals scored by any team (e.g., there was a VAR review or the score was initially wrongly reported). However, it cannot decrease the number of goals below 0.
