module State exposing (update, initialState, subscriptions)

import Mouse
import Platform.Cmd as Cmd
import Platform.Sub as Sub
import Task
import Types exposing (..)
import Window exposing (Size)


initialState : ( Model, Cmd Msg )
initialState =
  ( { walls =
        [ { position = { x = -300, y = -300 }, vector = { length = 600, angle = degrees 0 } }
        , { position = { x = 300, y = -300 }, vector = { length = 600, angle = degrees 90 } }
        , { position = { x = -300, y = -300 }, vector = { length = 600, angle = degrees 90 } }
        , { position = { x = 300, y = 300 }, vector = { length = 600, angle = degrees 180 } }
        , { position = { x = 100, y = 100 }, vector = { length = 50, angle = degrees 315 } }
        , { position = { x = -80, y = 100 }, vector = { length = 50, angle = degrees 290 } }
        , { position = { x = -200, y = 180 }, vector = { length = 150, angle = degrees 250 } }
        , { position = { x = 150, y = -100 }, vector = { length = 120, angle = degrees 235 } }
        , { position = { x = -230, y = -250 }, vector = { length = 300, angle = degrees 70 } }
        , { position = { x = 0, y = -150 }, vector = { length = 300, angle = degrees 30 } }
        ]
    , size = Nothing
    , mouse = Nothing
    }
  , Task.perform Error Resize Window.size
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
