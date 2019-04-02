module Main exposing (main)

{-| The entry-point for the raycaster.

@docs main

-}

import Browser
import State exposing (..)
import Types
import View exposing (..)


{-| Start the program running.
-}
main : Program () Types.Model Types.Msg
main =
    Browser.document
        { init = always ( State.initialModel, State.initialCmd )
        , update = State.update
        , subscriptions = State.subscriptions
        , view = View.root
        }
