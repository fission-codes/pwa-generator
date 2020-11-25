module Manifest.Display.Tests exposing (all)

import Expect
import Fuzz exposing (Fuzzer, string)
import Json.Decode as Decode exposing (decodeValue)
import Json.Encode as Encode exposing (Value, null)
import Manifest.Display as Display exposing (Display)
import Test exposing (..)


all : Test
all =
    describe "Display decoders and encoders"
        [ test "Decodes \"fullscreen\" into Fullscreen and encodes it back" <|
            \_ ->
                decodeValue Display.decoder (Encode.string "fullscreen")
                    |> Result.map Display.encode
                    |> Expect.equal (Ok (Encode.string "fullscreen"))
        , test "Decodes \"standalone\" into Standalone and encodes it back" <|
            \_ ->
                decodeValue Display.decoder (Encode.string "standalone")
                    |> Result.map Display.encode
                    |> Expect.equal (Ok (Encode.string "standalone"))
        , test "Decodes \"minimal-ui\" into MinimalUI and encodes it back" <|
            \_ ->
                decodeValue Display.decoder (Encode.string "minimal-ui")
                    |> Result.map Display.encode
                    |> Expect.equal (Ok (Encode.string "minimal-ui"))
        , test "Decodes \"browser\" into Browser and encodes it back" <|
            \_ ->
                decodeValue Display.decoder (Encode.string "browser")
                    |> Result.map Display.encode
                    |> Expect.equal (Ok (Encode.string "browser"))
        , fuzz string "Fails when given invalid display values" <|
            \randomString ->
                decodeValue Display.decoder (Encode.string randomString)
                    |> Result.mapError (always ())
                    |> Expect.equal (Err ())
        ]
