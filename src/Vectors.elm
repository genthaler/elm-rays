module Vectors exposing (Line, Position, lineBetween, start, end, adjustAngle, intersect)


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
