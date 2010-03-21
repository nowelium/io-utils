doFile("Timer.io")

a := block(
    "every 1 sec" println
    Date now println
    b := block(
        "[b]sub block" println
    )
    b @@call
    System sleep(3)
)
c := block(
    "every 5 src" println
    Date now println
    d := block(
        "[d]sub block" println
    )
    d @@call
)

t := Timer clone
t scheduleWithFixedDelay(a, 1)
t scheduleWithFixedDelay(c, 5)
t scheduleWithFixedDelay(block("stop" println; t stop), 30)
t start
t join
