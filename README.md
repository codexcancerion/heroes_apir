# HEROES APIR

The app is a turn-based card battle game where players and the computer select superheroes to fight using stats like intelligence, strength, and speed. The winner of each round draws an additional card from a master deck. The game continues until one party runs out of cards. It also supports bookmarking heroes, tracking gameplay statistics, and browsing hero profiles.


## Notes
1. This runs with SQLite so run on windows dev not browser.
2. Supeheroes API interaction flows through `https://superheroes-proxy.vercel.app/api/` due to CORS issues on flutter.

## Issues
1. Superheroes API cannot be accessed on flutter due to CORS issues.
