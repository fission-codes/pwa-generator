module Manifest.Orientation exposing
    ( Orientation
    , decoder
    , encode
    , fromString
    , init
    , toString
    )

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


init : Orientation
init =
    Natural


fromString : String -> Maybe Orientation
fromString str =
    case str of
        "any" ->
            Just Any

        "natural" ->
            Just Natural

        "landscape" ->
            Just Landscape

        "portrait" ->
            Just Portrait

        "portrait-primary" ->
            Just PortraitPrimary

        "portrait-secondary" ->
            Just PortraitSecondary

        "landscape-primary" ->
            Just LandscapePrimary

        "landscape-secondary" ->
            Just LandscapeSecondary

        _ ->
            Nothing


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
    Encode.string (toString orientation)


toString : Orientation -> String
toString orientation =
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
