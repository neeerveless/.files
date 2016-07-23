run_segment() {
  cpus_line=$(top -l 2 | grep "CPU usage:" | awk 'NR==2' | sed 's/CPU usage: //')
  cpu_user=$(echo "$cpus_line" | awk '{print $1}' | sed 's/%//')
  cpu_sys=$(echo "$cpus_line" | awk '{print $3}' | sed 's/%//')
  used_cpu=$(echo "$cpu_user + $cpu_sys" | bc)
  printf "Ⓒ %05.2f%%" $used_cpu | sed 's/ 0/  /'
  return 0
}
