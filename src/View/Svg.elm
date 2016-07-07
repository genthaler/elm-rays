module View.Svg exposing (root)

import Html exposing (Html)
import Mouse
import String
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Types exposing (..)
import Vectors exposing (..)
import Window


root : Walls -> Window.Size -> Mouse.Position -> Html msg
root walls size position =
    svg
        [ width "600"
        , height "600"
        ]
        [ g []
            (let
                solutions =
                    solveRays walls
                        { x = toFloat position.x
                        , y = toFloat position.y
                        }
                        |> List.sortBy (.vector >> .angle)

                cycled =
                    solutions ++ (List.take 1 solutions)
             in
                List.map2 (,) cycled (List.tail cycled |> Maybe.withDefault [])
                    |> List.map drawTriangle
            )
        , g [] (List.map drawLine walls)
        , circle
            [ cx <| toString position.x
            , cy <| toString position.y
            , r "5"
            , fill "red"
            ]
            []
        ]


drawLine : Line -> Svg msg
drawLine line =
    let
        ( startX, startY ) =
            toXY <| Vectors.start line

        ( endX, endY ) =
            toXY <| Vectors.end line
    in
        Svg.line
            [ x1 <| toString <| startX
            , y1 <| toString <| startY
            , x2 <| toString <| endX
            , y2 <| toString <| endY
            , stroke "black"
            , strokeWidth "5"
            , strokeLinecap "round"
            ]
            []


drawTriangle : ( Line, Line ) -> Svg msg
drawTriangle ( a, b ) =
    polygon
        [ fill "#fce64e"
        , stroke "#fce64e"
        , points
            ([ Vectors.start a
             , Vectors.end a
             , Vectors.end b
             , Vectors.start b
             ]
                |> List.map toXY
                |> List.map (\( x, y ) -> toString x ++ "," ++ toString y)
                |> String.join " "
            )
        ]
        []
