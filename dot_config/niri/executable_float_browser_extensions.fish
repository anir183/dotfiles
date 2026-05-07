#!/usr/bin/env fish

# config
# format: "regex|width|height"
set RULES \
    'Extension: .* Mozilla Firefox|20%|50%' \
    'Extension: .* Zen Browser|25%|55%' \
    'Extension: .* LibreWolf|20%|50%' \
    'Bitwarden|30%|60%'

set ids

# main event listener loop
niri msg -j event-stream | jq --unbuffered -r '
  .
  | select(has("WindowOpenedOrChanged"))
  | .["WindowOpenedOrChanged"].window
  | select(.title? and .is_floating == false)
  | "\(.id)|\(.title)"
' | while read -l line

    # split "id|title"
    set parts (string split '|' $line)
    set id $parts[1]
    set title (string join '|' $parts[2..-1])

    # skip if already handled
    if contains $id $ids
        continue
    end

    # check for each rule
    for rule in $RULES
        set r (string split '|' $rule)
        set regex  $r[1]
        set width  $r[2]
        set height $r[3]

        if string match -rq -- $regex $title
            set ids $ids $id

            # float
            niri msg action toggle-window-floating --id=$id

            # let window settle a bit
            sleep 0.1

            # resize
            niri msg action set-window-width  $width  --id=$id
            niri msg action set-window-height $height --id=$id

            # let window settle a bit
            sleep 0.1

            # center
            niri msg action center-window --id=$id

            # let window settle a bit
            sleep 0.1

            # sanity center as sometimes the window is a bit off center
            # TODO: find a better fix?
            niri msg action center-window --id=$id

            break
        end
    end
end
