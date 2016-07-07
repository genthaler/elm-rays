module Types exposing (Walls, Model, Msg(..), solveRays)

import Mouse
import Vectors exposing (..)


type alias Walls =
    List Line


type alias Model =
    { walls : Walls
    , mouse : Maybe Mouse.Position
    }


type Msg
    = Mouse Mouse.Position


solveRays : Walls -> Position -> List Line
solveRays walls rayStart =
    walls
        |> List.concatMap (toRays rayStart)
        |> List.filterMap (curtail walls)


toRays : Position -> Line -> List Line
toRays position line =
    let
        rayToStart =
            lineBetween position (start line)

        rayToEnd =
            lineBetween position (end line)
    in
        [ adjustAngle (degrees 0.1) rayToStart
        , adjustAngle (degrees -0.1) rayToStart
        , adjustAngle (degrees 0.1) rayToEnd
        , adjustAngle (degrees -0.1) rayToEnd
        ]


curtail : Walls -> Line -> Maybe Line
curtail walls line =
    walls
        |> List.filterMap (intersect line)
        |> List.sortBy (.vector >> .length)
        |> List.head
