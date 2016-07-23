#!/usr/local/bin/zsh

  mems_line=$(top -l 2 | grep "PhysMem:" | awk 'NR==2' | sed 's/PhysMem: //')
  used_mem=$(echo "$mems_line" | awk '{print $1}')
  unused_mem=$(echo "$mems_line" | awk '{print $5}')

  if [[ $used_mem =~ "G$" ]]; then
    used_mem=$(echo "$used_mem" | sed 's/G//')
    used_mem=$(echo "$used_mem * 1024" | bc)
  else
    used_mem=$(echo "$used_mem" | sed 's/M//')
  fi
  if [[ $unused_mem =~ "G$" ]]; then
    unused_mem=$(echo "$unused_mem" | sed 's/G//')
    unused_mem=$(echo "$unused_mem * 1024" | bc)
  else
    unused_mem=$(echo "$unused_mem" | sed 's/M//')
  fi
  total_mem=$(echo "$used_mem + $unused_mem" | bc)
  used_mem_rate=$(echo "$used_mem / $total_mem * 100" | bc -l)
  printf "Ⓜ  %05.2f%%" $used_mem_rate | sed 's/ 0/  /'
