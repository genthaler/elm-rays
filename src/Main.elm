module Main exposing (..)

import Html.App
import State exposing (..)
import View exposing (..)


main : Program Never
main =
  Html.App.program
    { init = State.initialState
    , subscriptions = State.subscriptions
    , update = State.update
    , view = View.root
    }
