#!/usr/bin/env bash
echo "Tape 'quit' pour sortir."
while true; do
  read -r -p "> " PROMPT
  [ -z "$PROMPT" ] && continue
  [ "$PROMPT" = "quit" ] && break

  RESP=$(curl -sS https://api.openai.com/v1/chat/completions \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $OPENAI_API_KEY" \
    -d "$(jq -n --arg prompt "$PROMPT" '{
      model: "gpt-3.5-turbo",
      messages: [
        {role:"system", content:"You are a helpful assistant."},
        {role:"user", content:$prompt}
      ],
      max_tokens: 400,
      temperature: 0.7
    }')")

  echo "$RESP" | jq -r '.choices[0].message.content'
done
