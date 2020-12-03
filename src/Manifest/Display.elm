module Manifest.Display exposing
    ( Display
    , decoder
    , displayToString
    , encode
    , init
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
    Encode.string (displayToString display)


displayToString : Display -> String
displayToString display =
    case display of
        Fullscreen ->
            "fullscreen"

        Standalone ->
            "standalone"

        MinimalUI ->
            "minimal-ui"

        Browser ->
            "browser"
