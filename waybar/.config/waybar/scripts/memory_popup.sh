
#!/bin/bash
processes=$(ps -eo comm,rss --sort=-rss | head -n 6 | tail -n 5 | awk '{printf "%s %.2fGB\n", $1, $2/1024/1024}')
notify-send "Top 5 memory processes" "$processes"
