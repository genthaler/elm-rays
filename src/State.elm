module State exposing (update, initialState, subscriptions)

import Mouse
import Platform.Cmd as Cmd
import Platform.Sub as Sub
import Task
import Types exposing (..)
import Window exposing (Size)


initialWindowSize : Cmd Msg
initialWindowSize =
    Task.perform Error Resize Window.size


initialState : ( Model, Cmd Msg )
initialState =
    ( { walls =
            [ { position = { x = 0, y = 0 }, vector = { length = 600, angle = degrees 0 } }
            , { position = { x = 0, y = 600 }, vector = { length = 600, angle = degrees 0 } }
            , { position = { x = 0, y = 0 }, vector = { length = 600, angle = degrees 90 } }
            , { position = { x = 600, y = 0 }, vector = { length = 600, angle = degrees 90 } }
            , { position = { x = 400, y = 400 }, vector = { length = 50, angle = degrees 315 } }
            , { position = { x = 220, y = 400 }, vector = { length = 50, angle = degrees 290 } }
            , { position = { x = 100, y = 480 }, vector = { length = 150, angle = degrees 250 } }
            , { position = { x = 450, y = 200 }, vector = { length = 120, angle = degrees 235 } }
            , { position = { x = 70, y = 50 }, vector = { length = 300, angle = degrees 70 } }
            , { position = { x = 300, y = 150 }, vector = { length = 300, angle = degrees 30 } }
            ]
      , size = Nothing
      , mouse = Nothing
      }
    , initialWindowSize
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Resize size ->
            ( { model | size = Just size }
            , Cmd.none
            )

        Mouse mouse ->
            ( { model | mouse = Just mouse }
            , Cmd.none
            )

        Error _ ->
            ( model
            , Cmd.none
            )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.batch
        [ Mouse.moves Mouse
        , Window.resizes Resize
        ]
