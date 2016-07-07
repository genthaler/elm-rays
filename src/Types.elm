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

        delta =
            degrees 0.1
    in
        [ adjustAngle delta rayToStart
        , adjustAngle (delta * -1) rayToStart
        , adjustAngle delta rayToEnd
        , adjustAngle (delta * -1) rayToEnd
        ]


curtail : Walls -> Line -> Maybe Line
curtail walls line =
    walls
        |> List.filterMap (intersect line)
        |> List.sortBy (.vector >> .length)
        |> List.head


intersect : Line -> Line -> Maybe Line
intersect ray target =
    let
        rayStart =
            start ray

        wallStart =
            start target

        rayComponents =
            components ray

        targetComponents =
            components target

        targetLength =
            ((rayStart.x * rayComponents.dy)
                - (rayStart.y * rayComponents.dx)
                + (wallStart.y * rayComponents.dx)
                - (wallStart.x * rayComponents.dy)
            )
                / ((rayComponents.dy * targetComponents.dx)
                    - (rayComponents.dx * targetComponents.dy)
                  )

        rayLength =
            (wallStart.x - rayStart.x + (targetComponents.dx * targetLength))
                / rayComponents.dx
    in
        if rayLength < 0 then
            Nothing
        else if targetLength < 0 || target.vector.length < targetLength then
            Nothing
        else
            Just (withLength rayLength ray)
