

namespace eval SieveOfEras {
    namespace export generateArr
    namespace export Sieve
}
proc SieveOfEras::generateArr {len} {
    for {set i 0} {$i <= $len} {incr i} {
        set arr($i) 1
    }
    return [array get arr]
}
proc SieveOfEras::Sieve {n} {
    array set prime [generateArr $n]
    for {set i 2} {[expr $i * $i] <= $n} {incr i} {
        if {$prime($i) == 1} {
            for {set j [expr $i * $i]} {$j <= $n} {incr j $i} {
                set prime($j) 0
            }
        }
    }
    set outputString ""
    for {set i 2} {$i <= $n} {incr i} {
        if {$prime($i) == 1} {
            append outputString $i
            append outputString " "
        }
    }
    return $outputString
}


package require logger
set log [logger::init SieveOfEras]
proc log_to_file {lvl txt} {
    set logfile "sieve.log"
    set msg "\[[clock format [clock seconds]]\] $txt"
    set f [open $logfile {WRONLY CREAT APPEND}] ;# instead of "a"
    fconfigure $f -encoding utf-8
    puts $f $msg
    close $f
}
foreach lvl [logger::levels] {
    interp alias {} log_to_file_$lvl {} log_to_file $lvl
    ${log}::logproc $lvl log_to_file_$lvl
}


namespace import SieveOfEras::*

${log}::notice "Initialized SieveOfEras"

if {[catch {set fp [open "task1_input.txt" r]} err]} {
    ${log}::error "Error Opening File, error: $err \n"
    exit 1
} else {
    ${log}::info "File Opened Successfully \n"
}

set output ""
while {[gets $fp line] >= 0} {
    string trim $line
    set n $line
    set answer [SieveOfEras::Sieve $n]
    append output "Sieve of Eratosthenes for $n: $answer \n"
    ${log}::info "Generated Sieve of Eratosthenes for $n: $answer \n"
}
close $fp

set fp [open "task1_output.txt" w]
if { [catch {puts $fp $output} err]} {
    ${log}::error "Error Writing to File, error: $err \n"
    exit 1
} else {
    ${log}::info "Successfully wrote to file: \"task1_output.txt\" \n"
}
${log}::info "Finished Writing to File: \"task1_output.txt\" \n"
close $fp

${log}::info "Finished Execution"

