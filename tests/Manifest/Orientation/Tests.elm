module Manifest.Orientation.Tests exposing (all)

import Expect
import Fuzz exposing (Fuzzer, string)
import Json.Decode as Decode exposing (decodeValue)
import Json.Encode as Encode exposing (Value, null)
import Manifest.Orientation as Orientation exposing (Orientation)
import Test exposing (..)


all : Test
all =
    describe "Orientation decoders and encoders"
        [ test "Decodes \"any\" into Any and encodes it back" <|
            \_ ->
                decodeValue Orientation.decoder (Encode.string "any")
                    |> Result.map Orientation.encode
                    |> Expect.equal (Ok (Encode.string "any"))
        , test "Decodes \"natural\" into Natural and encodes it back" <|
            \_ ->
                decodeValue Orientation.decoder (Encode.string "natural")
                    |> Result.map Orientation.encode
                    |> Expect.equal (Ok (Encode.string "natural"))
        , test "Decodes \"landscape\" into Landscape and encodes it back" <|
            \_ ->
                decodeValue Orientation.decoder (Encode.string "landscape")
                    |> Result.map Orientation.encode
                    |> Expect.equal (Ok (Encode.string "landscape"))
        , test "Decodes \"portrait\" into Portrait and encodes it back" <|
            \_ ->
                decodeValue Orientation.decoder (Encode.string "portrait")
                    |> Result.map Orientation.encode
                    |> Expect.equal (Ok (Encode.string "portrait"))
        , test "Decodes \"portrait-primary\" into PortraitPrimary and encodes it back" <|
            \_ ->
                decodeValue Orientation.decoder (Encode.string "portrait-primary")
                    |> Result.map Orientation.encode
                    |> Expect.equal (Ok (Encode.string "portrait-primary"))
        , test "Decodes \"portrait-secondary\" into PortraitSecondary and encodes it back" <|
            \_ ->
                decodeValue Orientation.decoder (Encode.string "portrait-secondary")
                    |> Result.map Orientation.encode
                    |> Expect.equal (Ok (Encode.string "portrait-secondary"))
        , test "Decodes \"landscape-primary\" into LandscapePrimary and encodes it back" <|
            \_ ->
                decodeValue Orientation.decoder (Encode.string "landscape-primary")
                    |> Result.map Orientation.encode
                    |> Expect.equal (Ok (Encode.string "landscape-primary"))
        , test "Decodes \"landscape-secondary\" into LandscapeSecondary and encodes it back" <|
            \_ ->
                decodeValue Orientation.decoder (Encode.string "landscape-secondary")
                    |> Result.map Orientation.encode
                    |> Expect.equal (Ok (Encode.string "landscape-secondary"))
        , fuzz string "Fails when given invalid Orientation values" <|
            \randomString ->
                decodeValue Orientation.decoder (Encode.string randomString)
                    |> Result.mapError (always ())
                    |> Expect.equal (Err ())
        ]
