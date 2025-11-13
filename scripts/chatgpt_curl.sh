#!/usr/bin/env bash
# usage: export OPENAI_API_KEY="ta_cle"; bash chatgpt_curl.sh

if [ -z "$OPENAI_API_KEY" ]; then
  echo "Exporte ta clé: export OPENAI_API_KEY=\"ta_cle_ici\""
  exit 1
fi

echo "Tape 'quit' pour sortir."
while true; do
  read -p "> " PROMPT
  if [ -z "$PROMPT" ]; then
    continue
  fi
  if [ "$PROMPT" = "quit" ] || [ "$PROMPT" = "exit" ]; then
    break
  fi

  RESP=$(curl -sS https://api.openai.com/v1/chat/completions \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $OPENAI_API_KEY" \
    -d @- <<-JSON
{
  "model": "gpt-3.5-turbo",
  "messages": [
    {"role": "system", "content": "You are a helpful assistant."},
    {"role": "user", "content": "$PROMPT"}
  ],
  "max_tokens": 400,
  "temperature": 0.7
}
JSON
)

  # afficher le texte renvoyé
  echo "$RESP" | jq -r '.choices[0].message.content'
done
