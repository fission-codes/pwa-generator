module Manifest.Orientation exposing (Orientation, decoder, encode, orientationToString)

import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode exposing (Value)


type Orientation
    = Any
    | Natural
    | Landscape
    | Portrait
    | PortraitPrimary
    | PortraitSecondary
    | LandscapePrimary
    | LandscapeSecondary


decoder : Decoder Orientation
decoder =
    Decode.string
        |> Decode.andThen
            (\str ->
                case str of
                    "any" ->
                        Decode.succeed Any

                    "natural" ->
                        Decode.succeed Natural

                    "landscape" ->
                        Decode.succeed Landscape

                    "portrait" ->
                        Decode.succeed Portrait

                    "portrait-primary" ->
                        Decode.succeed PortraitPrimary

                    "portrait-secondary" ->
                        Decode.succeed PortraitSecondary

                    "landscape-primary" ->
                        Decode.succeed LandscapePrimary

                    "landscape-secondary" ->
                        Decode.succeed LandscapeSecondary

                    _ ->
                        Decode.fail "Invalid orientation"
            )


encode : Orientation -> Value
encode orientation =
    Encode.string (orientationToString orientation)


orientationToString : Orientation -> String
orientationToString orientation =
    case orientation of
        Any ->
            "any"

        Natural ->
            "natural"

        Landscape ->
            "landscape"

        Portrait ->
            "portrait"

        PortraitPrimary ->
            "portrait-primary"

        PortraitSecondary ->
            "portrait-secondary"

        LandscapePrimary ->
            "landscape-primary"

        LandscapeSecondary ->
            "landscape-secondary"
