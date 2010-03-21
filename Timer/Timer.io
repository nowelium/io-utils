Timer := Object clone do (
    ScheduleUnit := Object clone do(
        newSlot("command", nil)
        newSlot("period", nil)
        init := method(
            self initial := Date now asNumber
            self current := Date now asNumber
        )
        execute := method(
            self current = Date now asNumber
            diff := (self current - self initial)
            if(period < diff) then (
            	command @@call
            )
        )
    )
    ScheduleFixRateUnit := ScheduleUnit clone do (
        execute := method(
            self current = Date now asNumber
            diff := (self current - self initial)
            if(period < diff) then (
                self initial = self current
                command @@call
            )
        )
    )
    ScheduleFixDelayUnit := ScheduleUnit clone do (
        execute := method(
            self current = Date now asNumber
            diff := (self current - self initial)
            if(period < diff) then (
            	command call
            	self initial = Date now asNumber
            )
        )
    )
    schedule := method(command, period,
        addUnit(ScheduleUnit clone, command, period)
    )
    scheduleWithFixedRate := method(command, period,
        addUnit(ScheduleFixRateUnit clone, command, period)
    )
    scheduleWithFixedDelay := method(command, period,
        addUnit(ScheduleFixDelayUnit clone, command, period)
    )
    addUnit := method(unit, command, period,
        unit setCommand(command)
        unit setPeriod(period)
        self units append(unit)
    )
    start := method(
        block(loop(
            units foreach(unit,
                unit @@execute
            )
            yield
            System sleep(0.01)
        )) @@call
        self running = true
    )
    join := method(
        while(Scheduler yieldingCoros size > 0,
            if(self running not) then(
            	break
            )
        	yield
        )
    )
    stop := method(
        self running = false
    )
    init := method(
        self units := List clone
        self running := false
    )
)

