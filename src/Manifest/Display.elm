module Manifest.Display exposing
    ( Display
    , decoder
    , encode
    , fromString
    , init
    , toString
    )

import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode exposing (Value)


type Display
    = Fullscreen
    | Standalone
    | MinimalUI
    | Browser


init : Display
init =
    Standalone


fromString : String -> Maybe Display
fromString str =
    case str of
        "fullscreen" ->
            Just Fullscreen

        "standalone" ->
            Just Standalone

        "minimal-ui" ->
            Just MinimalUI

        "browser" ->
            Just Browser

        _ ->
            Nothing


decoder : Decoder Display
decoder =
    Decode.string
        |> Decode.andThen
            (\str ->
                case str of
                    "fullscreen" ->
                        Decode.succeed Fullscreen

                    "standalone" ->
                        Decode.succeed Standalone

                    "minimal-ui" ->
                        Decode.succeed MinimalUI

                    "browser" ->
                        Decode.succeed Browser

                    _ ->
                        Decode.fail "Invalid display"
            )


encode : Display -> Value
encode display =
    Encode.string (toString display)


toString : Display -> String
toString display =
    case display of
        Fullscreen ->
            "fullscreen"

        Standalone ->
            "standalone"

        MinimalUI ->
            "minimal-ui"

        Browser ->
            "browser"
