alias "nu day" = nu run day
alias "nu run" = nu run day

def "nu run day" [day: number] {
	nu -c $'./day_($day)/nushell/solve.nu'
}
