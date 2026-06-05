#!/bin/bash
# Test API Gateway throttling (5 req/s, burst 10)
# Fires 15 concurrent requests per second for 3 seconds to exhaust burst and trigger 429

URL="https://gvgj1vds22.execute-api.eu-north-1.amazonaws.com/prod/01/1234567890001"

echo "🚀 Sustained load: 15 requests/s for 3 seconds (45 total)..."
echo "   Limit: 5 req/s, burst 10. Expect 429s after burst is exhausted."
echo ""

for second in 1 2 3; do
  echo "--- Second $second ---"
  for i in $(seq 1 15); do
    curl -s -o /dev/null -w "  Req $second.$i: HTTP %{http_code}\n" "$URL" &
  done
  wait
  sleep 0.2
done

echo ""
echo "✅ Done. Any '429' responses indicate throttling is working."
