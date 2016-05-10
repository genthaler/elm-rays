module View exposing (root)

import Collage exposing (..)
import Color exposing (Color)
import Element exposing (Element, flow, down, container, centered, middle)
import Html exposing (Html)
import Text exposing (link, fromString)
import Types exposing (..)


root : Model -> Html Msg
root model =
  case ( model.size, model.mouse ) of
    ( Just size, Just position ) ->
      element model.walls
        ( size.width, size.height )
        ( toFloat position.x, toFloat position.y )
        |> Element.toHtml

    _ ->
      Html.text "Initializing."


element : Walls -> ( Int, Int ) -> ( Float, Float ) -> Element
element walls ( width, height ) ( x, y ) =
  let
    rayPosition =
      { x = x - ((toFloat width) / 2.0)
      , y = ((toFloat height) / 2.0) - y
      }
  in
    [ collage width
        height
        [ group
            (let
              solutions =
                solveRays walls rayPosition
                  |> List.sortBy (.vector >> .angle)

              cycled =
                solutions ++ (List.take 1 solutions)
             in
              List.map2 (,) cycled (List.tail cycled |> Maybe.withDefault [])
                |> List.map (drawTriangles rayColor)
            )
        , circle 5
            |> filled Color.red
            |> move (toXY rayPosition)
        , group (List.map (drawLine wallLineStyle) walls)
        ]
    , [ fromString "A raycasting hack in "
      , link "http://elm-lang.org/" (fromString "Elm")
      , fromString ", based on "
      , link "http://ncase.me/sight-and-light" (fromString "this excellent tutorial")
      , fromString "."
      ]
        |> Text.concat
        |> centered
        |> container width 30 middle
    , link "https://github.com/krisajenkins/elm-rays" (fromString "Source Code")
        |> centered
        |> container width 30 middle
    ]
      |> flow down


drawLine : LineStyle -> Line -> Form
drawLine lineStyle line =
  let
    lineStart =
      toXY (start line)

    lineEnd =
      toXY (end line)
  in
    segment lineStart lineEnd
      |> traced lineStyle


drawTriangles : Color -> ( Line, Line ) -> Form
drawTriangles color ( a, b ) =
  [ start a
  , end a
  , end b
  , start b
  ]
    |> List.map toXY
    |> polygon
    |> filled color


rayColor : Color
rayColor =
  Color.lightYellow


wallLineStyle : LineStyle
wallLineStyle =
  { defaultLine
    | width = 8
    , cap = Round
  }
