MessageResourceTest := UnitTest clone do(
    type := "MessageResourceTest"
    setUp := method(
    )
    tearDown := method(
    )
    testMessage := method(
        serverStart := HogeMessage SERVER_START {name := "hoge"}
        assertEquals(serverStart, "サーバ hoge が始動しました")
        assertNotEquals(serverStart, "サーバ #{name} が始動しました")
        assertNotEquals(serverStart, "サーバ aaaa が始動しました")
    )
    testGetMessage := method(
        params := Object clone do(
            name := "foo"
        )
        serverStop := HogeMessage getMessage("SERVER_STOP", params)
        assertEquals(serverStop, "サーバ foo が停止しました")
    )
    testLocaleMessage := method(
        serverStart := FooMessage SERVER_START {name := "hoge"}
        assertEquals(serverStart, "server hoge has started")
        assertNotEquals(serverStart, "サーバ hoge が始動しました")
    )
    testMessageNotFound := method(
        assertRaisesException(HogeMessage hello)
        assertRaisesException(HogeMessage getMessage("world", nil))
    )
    testNilMessageParams := method(
        assertRaisesException(HogeMessage SERVER_START {nil})
        assertRaisesException(HogeMessage getMessage(SERVER_START, nil))
        e := try (
            assertNotNil(HogeMessage NONE_MSG)
            assertEquals(HogeMessage NONE_MSG, "ほげ")
        ); e catch(Exception,
            fail("パラメータが無いので、メッセージのままでOK")
        )
        e1 := try (
            assertNotNil(HogeMessage getMessage("NONE_MSG"))
            assertEquals(HogeMessage getMessage("NONE_MSG"), "ほげ")
        ); e1 catch(Exception,
            fail("パラメータが無いので、メッセージのままでOK")
        )
    )
    testUnknownLocale := method(
        serverStart := BarMessage SERVER_START {name := "hoge"}
        assertEquals(serverStart, "server hoge has started")
        assertNotEquals(serverStart, "サーバ hoge が始動しました")
    )

    HogeMessage := MessageResource clone do (
        ja_JP := {
            SERVER_START := "サーバ #{name} が始動しました",
            SERVER_STOP := "サーバ #{name} が停止しました",
            NONE_MSG := "ほげ"
        }
    )
    FooMessage := MessageResource clone do (
        locale := "C"
        C := {
            SERVER_START := "server #{name} has started",
            SERVER_STOP :=  "server #{name} has stopped"
        }
    )
    BarMessage := FooMessage clone do (
        locale := "bar"
    )
    MessageResource UnitTest on
)
