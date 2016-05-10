module Types exposing (..)

import Mouse
import Window


type alias Walls =
  List Line


type alias Line =
  { position : Position
  , vector : Vector
  }


type alias Position =
  { x : Float
  , y : Float
  }


type alias Vector =
  { length : Float
  , angle : Float
  }


start : Line -> Position
start line =
  line.position


end : Line -> Position
end line =
  let
    ( dx, dy ) =
      fromPolar ( line.vector.length, line.vector.angle )
  in
    { x = line.position.x + dx
    , y = line.position.y + dy
    }


toXY : Position -> ( Float, Float )
toXY p =
  ( p.x, p.y )


withLength : Float -> Line -> Line
withLength length line =
  let
    vector =
      line.vector
  in
    { line | vector = { vector | length = length } }


adjustAngle : Float -> Line -> Line
adjustAngle delta line =
  let
    vector =
      line.vector
  in
    { line | vector = { vector | angle = vector.angle + delta } }


lineBetween : Position -> Position -> Line
lineBetween from to =
  { position = from
  , vector = vectorBetween from to
  }


vectorBetween : Position -> Position -> Vector
vectorBetween p1 p2 =
  let
    dx =
      p2.x - p1.x

    dy =
      p2.y - p1.y
  in
    { length = sqrt (dx * dx + dy * dy)
    , angle = atan2 (p2.y - p1.y) (p2.x - p1.x)
    }


solveRays : Walls -> Position -> List Line
solveRays walls rayStart =
  walls
    |> List.concatMap (toRays rayStart)
    |> List.filterMap (curtail walls)


curtail : Walls -> Line -> Maybe Line
curtail walls line =
  walls
    |> List.filterMap (intersect line)
    |> List.sortBy (.vector >> .length)
    |> List.head


norms : Line -> ( Float, Float )
norms line =
  ( cos line.vector.angle
  , sin line.vector.angle
  )


intersect : Line -> Line -> Maybe Line
intersect r s =
  let
    ( r_px, r_py ) =
      toXY (start r)

    ( s_px, s_py ) =
      toXY (start s)

    ( r_dx, r_dy ) =
      norms r

    ( s_dx, s_dy ) =
      norms s

    sm =
      ((r_px * r_dy) - (r_py * r_dx) + (s_py * r_dx) - (s_px * r_dy))
        / ((s_dx * r_dy) - (s_dy * r_dx))

    rm =
      (s_px - r_px + (s_dx * sm)) / r_dx
  in
    if isNaN sm || isNaN rm then
      Nothing
    else if sm < 0 then
      Nothing
    else if s.vector.length < sm then
      Nothing
    else if rm < 0 then
      Nothing
    else
      Just (withLength rm r)


toRays : Position -> Line -> List Line
toRays position line =
  let
    rayToStart =
      lineBetween position (start line)

    rayToEnd =
      lineBetween position (end line)
  in
    [ adjustAngle (degrees 0.5) rayToStart
    , adjustAngle (degrees -0.5) rayToStart
    , adjustAngle (degrees 0.5) rayToEnd
    , adjustAngle (degrees -0.5) rayToEnd
    ]


type alias Model =
  { walls : Walls
  , mouse : Maybe Mouse.Position
  , size : Maybe Window.Size
  }


type Msg
  = Mouse Mouse.Position
  | Resize Window.Size
  | Error Never
