MessageResource := Object clone do (
    lang ::= nil
    locale ::= nil
    encoding ::= "UTF8"

    init := method(
        replace := Map clone
        replace atPut("-", "")

        self setLang(System getEnvironmentVariable("LANG"))
        split := lang splitNoEmpties(".")

        self setLocale(split at(0))
        self setEncoding(split at(1) uppercase)
        self encodeName := encoding replaceMap(replace)
        self encodingMessage := ("as" .. encoding) asMessage
    )
    __getLocaleMessage := method(locale, id,
        resourceLocale := self getSlot(locale)
        if(resourceLocale isNil) then (
            resourceLocale = self getSlot("C")
        )
        if(resourceLocale isNil) then (
            Exception raise("locale not found locale: " .. locale)
        )
        message := resourceLocale getSlot(id)
        if(message isNil) then (
            Exception raise("message not found id: " .. id)
        )
        message
    )
    getMessage := method(messageId, params,
        message := __getLocaleMessage(locale, messageId)
        message asMutable doMessage(encodingMessage) interpolateInPlace(params)
    )
    curlyBrackets := method(
        obj := Object clone
        call message arguments foreach(arg,
            arg setName("setSlot")
            obj doMessage(arg)
        )
        obj
    )
    forward := method(
        name := call message name
        message := __getLocaleMessage(locale, name)
        message container := self
        message encodingMessage := self encodingMessage
        message curlyBrackets := method(
            obj := call delegateTo(container, call sender)
            self asMutable doMessage(encodingMessage) interpolateInPlace(obj)
        )
        message
    )

    UnitTest := Object clone do (
        on := method(
            target := call sender
            target messageResource := MessageResource clone
            target getArgs := method(a, b, msg,
                messageResource := self messageResource
                args := list()
                if(a isNil not) then (
                    if(a encoding != messageResource encoding) then (
                        a = a doMessage(messageResource encodingMessage)
                    )
                )
                if(b isNil not) then(
                    if(b encoding != messageResource encoding) then (
                        b = b doMessage(messageResource encodingMessage)
                    )
                )
                args append(a, b, msg)
                args
            )
            target __assert := method(name, args, UnitTest performWithArgList(name, args))
            target assertEquals = method(a, b, msg,
                __assert(call message name, getArgs(a, b, msg))
            )
            target assertNotEquals = method(a, b, msg,
                __assert(call message name, getArgs(a, b, msg))
            )
        )
    )
)
