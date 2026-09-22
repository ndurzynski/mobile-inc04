# Activity 04: Flutter Widget Wars & State Destruction Derby

Team name: [Team Name]

## Team Members

| Name | Student ID |
| --- | --- |
| Niki Durzynski | 002842770 |
| Eziz Bagshiyev | 002938018 |
| Dominic Le | 002905910 |

## Build Challenge

For Round 3 we built Viral Content Studio, a single-screen app where the user tries to make a post go viral. All of the code is in `lib/main.dart`.

The screen has four engagement buttons. LIKE adds 1 point, COMMENT adds 2, SHARE adds 3 and SAVE adds 2. Each tap increments that button's counter, adds its points to the engagement total and increases the streak. A progress bar fills toward 20 points. At 20 points the bar turns orange, a "TRENDING" banner appears and the background changes color. A metrics card shows the likes, comments, shares, saves and current streak.

Each button uses a `GestureDetector` that shrinks the button and flattens its shadow while a finger holds it down. The icon in the app bar switches between light and dark mode, and the RESET button sets every counter back to zero.

| Checkpoint | Widget |
| --- | --- |
| #1 StatelessWidgets | `StudioTitle`, `MetricsBadge`, `TrendingBanner` |
| #2 Custom StatefulWidget | `EngagementMeter` |
| #3 + #6 Interactive buttons with GestureDetector | `EngagementButton` |
| #5 Light/dark theme switcher | `ViralContentApp` and the app bar `IconButton` |

## State Defense

The theme flag `isDarkMode` lives in `_ViralContentAppState` at the root of the app. It has to live there because `MaterialApp` rebuilds with a new `ThemeData` when the flag changes. The screen receives the flag as `isDark`, along with an `onToggleTheme` callback. The screen calls the callback to change the theme, but it never owns the flag. This is the "lift state up, pass callbacks down" pattern.

All engagement data (`likes`, `comments`, `shares`, `saves`, `streak`, `isTrending`) lives in `_ViralStudioScreenState`. Only `_addEngagement()` and the reset button change it, and both wrap the change in `setState()` so Flutter rebuilds the screen. `totalEngagement` is a getter that adds up the counters each time it runs, so it can never disagree with them. `MetricsBadge`, `StudioTitle` and `TrendingBanner` are `StatelessWidget`s. They display the values the parent passes in and rebuild when the parent rebuilds.

`isPressed` in `_EngagementButtonState` is the only local state in the app. The press animation of one button is the only thing that reads it, so it stays inside that button, and a held finger rebuilds nothing else. The button reports the tap to the parent through `widget.onPressed`. That call happens in `onTapUp`, so a tap counts only after the finger lifts. `EngagementMeter` is a `StatefulWidget` because Checkpoint #2 requires one, but it draws everything from `widget.score` and `widget.isTrending`. The screen state remains the only place that stores the numbers.

## Round 1 Findings

The full report, with the final-score screenshot, is in [STATE IDENTIFICATION BLITZ — TEAM FINDINGS REPORT.pdf](STATE%20IDENTIFICATION%20BLITZ%20%E2%80%94%20TEAM%20FINDINGS%20REPORT.pdf).

```
STATE IDENTIFICATION BLITZ — TEAM FINDINGS REPORT
Team Name: [Team Name]

SCENARIO 1 / 6 — PriceTag: We answered "STATELESS" — CORRECT (actual: STATELESS)
SCENARIO 2 / 6 — LikeToggle: We answered "STATEFUL" — CORRECT (actual: STATEFUL)
SCENARIO 3 / 6 — MenuActionTile: We answered "STATELESS" — CORRECT (actual: STATELESS)
SCENARIO 4 / 6 — SearchField: We answered "STATEFUL" — CORRECT (actual: STATEFUL)
SCENARIO 5 / 6 — StatBadge: We answered "STATELESS" — CORRECT (actual: STATELESS)
SCENARIO 6 / 6 — PulsingDot: We answered "STATEFUL" — CORRECT (actual: STATEFUL)

Final Score: 6 / 6
```

## Round 2 Bug Fixes

| Bug | Name | Fix |
| --- | --- | --- |
| #1 | Scope Failure | We moved `powerLevel` out of `build()` and made it a field of the `State` class, so the value no longer resets on every rebuild. |
| #2 | Silent Mutator | We wrapped the slider update in `setState()` (`onChanged: (newVal) => setState(() => powerLevel = newVal)`) so Flutter redraws the widget. |
| #3 | Geometry Inversion | We swapped the shadow branches. The unpressed button now gets the large `Offset(8, 8)` and `Offset(-8, -8)` shadows, and the pressed button gets the small `Offset(2, 2)` and `Offset(-2, -2)` shadows. |
| #4 | Event Race | We moved the `widget.onPressed` call (`_triggerAction("TURBO BOOST")`) from `onTapDown` to `onTapUp`, so the action fires once when the finger lifts instead of when it first touches the button. |
