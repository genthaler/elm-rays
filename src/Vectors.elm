module Vectors exposing (Line, Position, start, end, lineBetween, adjustAngle, withLength, components)


type alias Position =
    { x : Float
    , y : Float
    }


type alias Vector =
    { length : Float
    , angle : Float
    }


type alias Line =
    { position : Position
    , vector : Vector
    }


start : Line -> Position
start =
    .position


end : Line -> Position
end line =
    let
        ( dx, dy ) =
            fromPolar ( line.vector.length, line.vector.angle )
    in
        { x = line.position.x + dx
        , y = line.position.y + dy
        }


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


adjustAngle : Float -> Line -> Line
adjustAngle delta line =
    let
        vector =
            line.vector
    in
        { line | vector = { vector | angle = vector.angle + delta } }


components : Line -> { dx : Float, dy : Float }
components line =
    { dx = cos line.vector.angle
    , dy = sin line.vector.angle
    }


withLength : Float -> Line -> Line
withLength length line =
    let
        vector =
            line.vector
    in
        { line | vector = { vector | length = length } }
