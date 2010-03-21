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
t scheduleWithFixedRate(a, 1)
t scheduleWithFixedRate(c, 5)
t scheduleWithFixedRate(block("stop" println; t stop), 30)
t start
t join
