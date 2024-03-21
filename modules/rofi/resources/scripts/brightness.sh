#!/bin/sh
 
print_lines() {
    printf '+\n-\n'
}
handle_choice() {
    case $1 in
    +)
        toadd=10 ;;
    -)
        toadd=-10 ;;
    *)
        toadd=$1 ;;
    esac
    printf '\000message\037Loading...\n'
    setbright $(( $(getbright) + $toadd ))
    printf '\000message\037Brightness: %s\n' "$(getbright)"
}
 
case $ROFI_RETV in
# print lines on start
0) print_lines ;;
# handle select line
1 | 2) handle_choice "$@" && print_lines ;;
esac
