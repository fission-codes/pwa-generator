module Manifest.Color exposing (contrast, fromHex)

import Char exposing (isHexDigit)
import Element exposing (Color, rgba255)
import Hex
import Parser exposing (..)
import UI.Colors as Colors


type alias ColorSpace =
    { red : Int
    , green : Int
    , blue : Int
    , alpha : Float
    }



-- CONTRAST


{-| Contrast and brightness computations are derived from
<https://stackoverflow.com/a/58427960/6513123>. These account for the alpha
channel and are "to taste" and the 186 threshold can be adjusted.

It might also be worth implementing the W3C spec recommendations at
<https://www.w3.org/TR/WCAG20/#contrast-ratiodef>.

-}
contrast : String -> Maybe Color
contrast hexString =
    case Parser.run hexColor hexString of
        Ok colorSpace ->
            if brightness colorSpace > 150 then
                Just Colors.black

            else
                Just Colors.white

        Err err ->
            Nothing


brightness : ColorSpace -> Float
brightness colorSpace =
    (toFloat colorSpace.red * 0.299)
        + (toFloat colorSpace.green * 0.587)
        + (toFloat colorSpace.blue * 0.114)
        + ((1 - colorSpace.alpha) * 255)



-- CONVERT


fromHex : String -> Maybe Color
fromHex hexString =
    case Parser.run hexColor hexString of
        Ok colorSpace ->
            Just <|
                rgba255
                    colorSpace.red
                    colorSpace.green
                    colorSpace.blue
                    colorSpace.alpha

        Err err ->
            Nothing



-- PARSE


hexColor : Parser ColorSpace
hexColor =
    hexColorString
        |> andThen
            (\str ->
                if String.length str == 3 then
                    shortHexColor str

                else if String.length str == 4 then
                    shortAlphaHexColor str

                else if String.length str == 6 then
                    longHexColor str

                else if String.length str == 8 then
                    longAlphaHexColor str

                else
                    problem "Invalid hex color"
            )


hexColorString : Parser String
hexColorString =
    succeed identity
        |. symbol "#"
        |= (getChompedString <| chompWhile Char.isHexDigit)
        |. end


shortHexColor : String -> Parser ColorSpace
shortHexColor str =
    succeed ColorSpace
        |= (shortColor <| String.slice 0 1 str)
        |= (shortColor <| String.slice 1 2 str)
        |= (shortColor <| String.slice 2 3 str)
        |= succeed (identity 1)


longHexColor : String -> Parser ColorSpace
longHexColor str =
    succeed ColorSpace
        |= (longColor <| String.slice 0 2 str)
        |= (longColor <| String.slice 2 4 str)
        |= (longColor <| String.slice 4 6 str)
        |= succeed (identity 1)


shortAlphaHexColor : String -> Parser ColorSpace
shortAlphaHexColor str =
    succeed ColorSpace
        |= (shortColor <| String.slice 0 1 str)
        |= (shortColor <| String.slice 1 2 str)
        |= (shortColor <| String.slice 2 3 str)
        |= (shortAlpha <| String.slice 3 4 str)


longAlphaHexColor : String -> Parser ColorSpace
longAlphaHexColor str =
    succeed ColorSpace
        |= (longColor <| String.slice 0 2 str)
        |= (longColor <| String.slice 2 4 str)
        |= (longColor <| String.slice 4 6 str)
        |= (longAlpha <| String.slice 6 8 str)


shortColor : String -> Parser Int
shortColor str =
    case Hex.fromString str of
        Ok n ->
            succeed (n * 16 + n)

        Err err ->
            problem "Invalid hex value"


longColor : String -> Parser Int
longColor str =
    case Hex.fromString str of
        Ok n ->
            succeed n

        Err err ->
            problem "Invalid hex value"


shortAlpha : String -> Parser Float
shortAlpha str =
    case Hex.fromString str of
        Ok n ->
            succeed (toFloat (n * 16 + n) / 255)

        Err err ->
            problem "Invalid alpha channel"


longAlpha : String -> Parser Float
longAlpha str =
    case Hex.fromString str of
        Ok n ->
            succeed (toFloat n / 255)

        Err err ->
            problem "Invalid alpha channel"
