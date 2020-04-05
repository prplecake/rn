#!/usr/bin/env bash

. config.sh

API_ROOT="api/v1"
AUTH_HEADER="Authorization: Bearer $ACCESS_TOKEN"
DRY_RUN=0

# Return the user's current display name
get_curr_name() {
  curl -s \
    -H "$AUTH_HEADER" \
    "$INSTANCE_URL/$API_ROOT/accounts/verify_credentials" \
  | jq -r .display_name
}

# Updates the user's display name
update_name() {
  RESP=`curl -s \
    -H "$AUTH_HEADER" \
    -X PATCH \
    -d display_name="$1" \
    "$INSTANCE_URL/$API_ROOT/accounts/update_credentials"`
  
  ERR=$(echo $RESP | jq -r .error)

  # An error would generally happen if the display name is too long.
  if [ "$ERR" != "null" ]; then
    echo "Error setting display name."
    echo $RESP | jq -r .error
    exit 1
  else 
    echo "Successfully updated display name."
  fi
}

while getopts 'd' OPTION; do
  case $OPTION in
    d)
      DRY_RUN=1
      ;;
  esac
done
shift "$(($OPTIND -1))"

# Get the current name, and the new name by filtering the current name out of
# the list of possible names.
CURR_NAME=$(get_curr_name)
NEW_NAME=$(grep -v "$CURR_NAME" "$NAME_FILE" | shuf -n 1)

echo New name: $NEW_NAME

# If we're during a dry run, just quit here, otherwise actually do the updating.
if [ "$DRY_RUN" -eq 1 ]; then
  echo "Dry run, exiting."
  exit 0
fi

update_name "$NEW_NAME"