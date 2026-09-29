#!/bin/sh
# 4dlivetoday API: no key needed. Pipe through `jq` for readable output.
BASE=https://4dlivetoday.com/api/v1

curl -s "$BASE/latest"                        # newest draw of every operator
curl -s "$BASE/results/2026-09-27"            # every operator on one date (Malaysia time)
curl -s "$BASE/operators/magnum?limit=5"      # last 5 Magnum 4D draws
curl -s "$BASE/numbers/1063"                  # every draw where 1063 won
curl -s "$BASE/games/toto_supreme?limit=3"    # Supreme Toto 6/58
curl -s "$BASE/games/sg_toto?limit=3"         # Singapore Toto
curl -s "$BASE/schedule"                      # upcoming draw dates
