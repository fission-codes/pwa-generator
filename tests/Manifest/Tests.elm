module Manifest.Tests exposing (all)

import Expect
import Fuzz exposing (Fuzzer, string)
import Json.Decode as Decode exposing (decodeValue)
import Json.Encode as Encode exposing (Value, null)
import Manifest exposing (Manifest)
import Manifest.Display as Display exposing (Display)
import Manifest.Icon as Icon exposing (Icon)
import Manifest.Orientation as Orientation exposing (Orientation)
import Test exposing (..)


all : Test
all =
    describe "Manifest decoders and encoders"
        [ test "Decodes chess example and encodes it back" <|
            \_ ->
                decodeValue Manifest.decoder chess
                    |> Result.map Manifest.encode
                    |> Expect.equal (Ok chess)
        , test "Decodes crypto plunge example and encodes it back" <|
            \_ ->
                decodeValue Manifest.decoder cryptoPlunge
                    |> Result.map Manifest.encode
                    |> Expect.equal (Ok cryptoPlunge)
        , test "Decodes condor example and encodes it back" <|
            \_ ->
                decodeValue Manifest.decoder condor
                    |> Result.map Manifest.encode
                    |> Expect.equal (Ok condor)
        ]


chess : Value
chess =
    Encode.object
        [ ( "name", Encode.string "Deluxe Chess" )
        , ( "short_name", Encode.string "chess" )
        , ( "description", Encode.string "A full-featured chess game." )
        , ( "lang", Encode.string "en-US" )
        , ( "start_url", Encode.string "/" )
        , ( "scope", Encode.string "/" )
        , ( "background_color", Encode.string "#ffffff" )
        , ( "theme_color", Encode.string "#dd1111" )
        , ( "display", Encode.string "fullscreen" )
        , ( "orientation", Encode.string "any" )
        , ( "icons", Encode.list Encode.object [] )
        ]


cryptoPlunge : Value
cryptoPlunge =
    Encode.object
        [ ( "name", Encode.string "Ultimate Crypto Plunge" )
        , ( "short_name", Encode.string "cryptoplunge" )
        , ( "description", Encode.string "Learn cryptography through puzzles" )
        , ( "lang", Encode.string "hr" )
        , ( "start_url", Encode.string "/" )
        , ( "scope", Encode.string "/" )
        , ( "background_color", Encode.string "#000000" )
        , ( "theme_color", Encode.string "#ffffff" )
        , ( "display", Encode.string "standalone" )
        , ( "orientation", Encode.string "natural" )
        , ( "icons"
          , Encode.list Encode.object
                [ [ ( "src", Encode.string "crypto.png" )
                  , ( "sizes", Encode.string "256x256" )
                  , ( "type", Encode.string "image/png" )
                  ]
                ]
          )
        ]


condor : Value
condor =
    Encode.object
        [ ( "name", Encode.string "Flight of the Condor" )
        , ( "short_name", Encode.string "Condor" )
        , ( "description", Encode.string "Fly as if you were the mighty condor!" )
        , ( "lang", Encode.string "gu" )
        , ( "start_url", Encode.string "/condor/index.html" )
        , ( "scope", Encode.string "/condor/" )
        , ( "background_color", Encode.string "#111" )
        , ( "theme_color", Encode.string "#2222ee" )
        , ( "display", Encode.string "minimal-ui" )
        , ( "orientation", Encode.string "portrait" )
        , ( "icons"
          , Encode.list Encode.object
                [ [ ( "src", Encode.string "condor.png" )
                  , ( "sizes", Encode.string "256x256" )
                  , ( "type", Encode.string "image/png" )
                  ]
                , [ ( "src", Encode.string "flight.webp" )
                  , ( "sizes", Encode.string "128x128 256x256" )
                  , ( "type", Encode.string "image/webp" )
                  ]
                ]
          )
        ]
