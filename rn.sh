#!/usr/bin/env bash

. config.sh

API_ROOT="api/v1"
AUTH_HEADER="Authorization: Bearer $ACCESS_TOKEN"
DRY_RUN=0

get_curr_name() {
  curl -s \
    -H "$AUTH_HEADER" \
    "$INSTANCE_URL/$API_ROOT/accounts/verify_credentials" |
    jq -r .display_name
}

update_name() {
  curl -s \
    -H "$AUTH_HEADER" \
    -X PATCH \
    -d display_name="$1" \
    "$INSTANCE_URL/$API_ROOT/accounts/update_credentials" > /dev/null
}

while getopts 'd' OPTION; do
  case $OPTION in
    d)
      DRY_RUN=1
      ;;
  esac
done
shift "$(($OPTIND -1))"

CURR_NAME=$(get_curr_name)
NEW_NAME=$(shuf -n 1 "$NAME_FILE")

while [ "$NEW_NAME" = "$CURR_NAME" ]; do
  NEW_NAME=$(shuf -n 1 "$NAME_FILE")
done

echo New name: $NEW_NAME

if [ "$DRY_RUN" -eq 1 ]; then
  echo "Dry run, exiting."
  exit 0
fi

update_name "$NEW_NAME"