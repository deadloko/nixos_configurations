''theme = "slick"
icons = "awesome"

[[block]]
block = "focused_window"
max_width = 50

[[block]]
block = "disk_space"
path = "/"
alias = "/"
info_type = "available"
unit = "GB"
interval = 20
warning = 20.0
alert = 10.0

[[block]]
block = "memory"
display_type = "memory"
format_mem = "{Mum}MB/{MTm}MB({Mup}%)"
format_swap = "{SUm}MB/{STm}MB({SUp}%)"

[[block]]
block = "cpu"
interval = 1

[[block]]
block = "load"
interval = 1
format = "{1m} {5m} {15m}"

[[block]]
block = "net"
device = "enp0s3"
interval = 5

[[block]]
block = "custom"
command = "xkblayout-state print ' %s'"
interval = 1

[[block]]
block = "time"
interval = 60
format = "%a %d/%m %R"
''
