module View.Svg exposing (root)

import Html exposing (Html)
import Mouse
import String
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Types exposing (..)
import Vectors exposing (..)


root : Walls -> Mouse.Position -> Html msg
root walls position =
    svg
        [ width "600"
        , height "600"
        ]
        [ drawRays walls position
        , drawWalls walls
        , drawCursor position
        ]


neighbours : List a -> List ( a, a )
neighbours xs =
    List.map2 (,)
        xs
        ((xs ++ xs)
            |> List.tail
            |> Maybe.withDefault []
        )


drawRays : Walls -> Mouse.Position -> Svg msg
drawRays walls position =
    solveRays walls
        { x = toFloat position.x
        , y = toFloat position.y
        }
        |> List.sortBy (.vector >> .angle)
        |> neighbours
        |> List.map drawTriangle
        |> g []


drawWalls : Walls -> Svg msg
drawWalls walls =
    g []
        (List.map drawLine walls)


drawLine : Line -> Svg msg
drawLine line =
    Svg.line
        [ x1 <| toString <| fst <| toXY <| Vectors.start line
        , y1 <| toString <| snd <| toXY <| Vectors.start line
        , x2 <| toString <| fst <| toXY <| Vectors.end line
        , y2 <| toString <| snd <| toXY <| Vectors.end line
        , stroke "black"
        , strokeWidth "5"
        , strokeLinecap "round"
        ]
        []


drawTriangle : ( Line, Line ) -> Svg msg
drawTriangle ( a, b ) =
    let
        toPair ( x, y ) =
            toString x ++ "," ++ toString y
    in
        polygon
            [ fill "#fce64e"
            , stroke "#fce64e"
            , points
                (String.join " "
                    <| List.map (toXY >> toPair)
                    <| [ Vectors.start a
                       , Vectors.end a
                       , Vectors.end b
                       , Vectors.start b
                       ]
                )
            ]
            []


drawCursor : Mouse.Position -> Svg msg
drawCursor position =
    circle
        [ cx <| toString position.x
        , cy <| toString position.y
        , r "5"
        , fill "red"
        ]
        []
