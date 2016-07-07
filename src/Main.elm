module Main exposing (main)

{-| The entry-point for the raycaster.

@docs main
-}

import Html.App
import State exposing (..)
import View exposing (..)


{-| Start the program running.
-}
main : Program Never
main =
    Html.App.program
        { init = ( State.initialModel, State.initialCmd )
        , subscriptions = State.subscriptions
        , update = State.update
        , view = View.root
        }
