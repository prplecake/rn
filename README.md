make ur masto account have a random name

# what

yeah, just gives ur masto account a random display name, that's it

# how

1. update the settings in `config.example.sh` to reflect ur instance/access token and the file to get names from
2. rename `config.example.sh` to `config.sh`
3. put the names you want to pick from in `$NAME_FILE`, newline separated
4. run `rn.sh`
5. you can run `rn.sh -d` and it won't actually update anything, will just dry run

enjoy