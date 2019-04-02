module State exposing (initialCmd, initialModel, subscriptions, update)

import Basics.Extra exposing (uncurry)
import Browser.Events
import Json.Decode as D
import Platform.Cmd as Cmd
import Platform.Sub as Sub
import Types exposing (..)
import Vectors exposing (..)


initialModel : Model
initialModel =
    { walls =
        [ { position = { x = 0, y = 0 }, vector = { length = 600, angle = degrees 0 } }
        , { position = { x = 0, y = 600 }, vector = { length = 600, angle = degrees 0 } }
        , { position = { x = 0, y = 0 }, vector = { length = 600, angle = degrees 90 } }
        , { position = { x = 600, y = 0 }, vector = { length = 600, angle = degrees 90 } }
        , { position = { x = 400, y = 400 }, vector = { length = 50, angle = degrees 315 } }
        , { position = { x = 220, y = 400 }, vector = { length = 50, angle = degrees 290 } }
        , { position = { x = 100, y = 480 }, vector = { length = 150, angle = degrees 250 } }
        , { position = { x = 450, y = 200 }, vector = { length = 120, angle = degrees 235 } }
        , { position = { x = 70, y = 50 }, vector = { length = 300, angle = degrees 70 } }
        , { position = { x = 300, y = 150 }, vector = { length = 200, angle = degrees 30 } }
        ]
    , mouse = Nothing
    }


initialCmd : Cmd Msg
initialCmd =
    Cmd.none


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Mouse mouse ->
            ( { model | mouse = Just <| uncurry Vectors.Position <| Tuple.mapBoth toFloat toFloat mouse }
            , Cmd.none
            )

        Tick tick ->
            ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.batch [ Browser.Events.onMouseMove (D.map Mouse <| D.map2 Tuple.pair pageX pageY), Browser.Events.onAnimationFrame Tick ]


pageX : D.Decoder Int
pageX =
    D.field "pageX" D.int


pageY : D.Decoder Int
pageY =
    D.field "pageY" D.int
