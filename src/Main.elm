module Main exposing (main)

{-| The entry-point for the raycaster.

@docs main
-}

import Html
import Types
import State exposing (..)
import View exposing (..)


{-| Start the program running.
-}
main : Program Never Types.Model Types.Msg
main =
    Html.program
        { init = ( State.initialModel, State.initialCmd )
        , update = State.update
        , subscriptions = State.subscriptions
        , view = View.root
        }
