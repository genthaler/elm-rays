module Types exposing (Model, Msg(..), Walls)

import Browser.Events
import Time
import Vectors exposing (..)


type alias Walls =
    List Line


type alias Model =
    { walls : Walls
    , mouse : Maybe Position
    }


type Msg
    = Mouse ( Int, Int )
