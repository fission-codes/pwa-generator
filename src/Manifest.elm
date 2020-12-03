module Manifest exposing
    ( Manifest
    , decoder
    , encode
    , init
    , placeholders
    )

import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline exposing (required)
import Json.Encode as Encode exposing (Value)
import Manifest.Display as Display exposing (Display)
import Manifest.Icon as Icon exposing (Icon)
import Manifest.Orientation as Orientation exposing (Orientation)


type alias Manifest =
    { name : String
    , shortName : String
    , description : String
    , lang : String
    , startUrl : String
    , scope : String
    , backgroundColor : String
    , themeColor : String
    , display : Display
    , orientation : Orientation
    , icons : List Icon
    }


init : Manifest
init =
    { name = ""
    , shortName = ""
    , description = ""
    , lang = "en"
    , startUrl = "/"
    , scope = "/"
    , backgroundColor = "#ffffff"
    , themeColor = "#ebecf5"
    , display = Display.init
    , orientation = Orientation.init
    , icons = []
    }


decoder : Decoder Manifest
decoder =
    Decode.succeed Manifest
        |> required "name" Decode.string
        |> required "short_name" Decode.string
        |> required "description" Decode.string
        |> required "lang" Decode.string
        |> required "start_url" Decode.string
        |> required "scope" Decode.string
        |> required "background_color" Decode.string
        |> required "theme_color" Decode.string
        |> required "display" Display.decoder
        |> required "orientation" Orientation.decoder
        |> required "icons" (Decode.list Icon.decoder)


encode : Manifest -> Value
encode manifest =
    Encode.object
        [ ( "name", Encode.string manifest.name )
        , ( "short_name", Encode.string manifest.shortName )
        , ( "description", Encode.string manifest.description )
        , ( "lang", Encode.string manifest.lang )
        , ( "start_url", Encode.string manifest.startUrl )
        , ( "scope", Encode.string manifest.scope )
        , ( "background_color", Encode.string manifest.backgroundColor )
        , ( "theme_color", Encode.string manifest.themeColor )
        , ( "display", Display.encode manifest.display )
        , ( "orientation", Orientation.encode manifest.orientation )
        , ( "icons", Encode.list Icon.encode manifest.icons )
        ]


placeholders : List Manifest
placeholders =
    [ Manifest
        "Deluxe Chess"
        "chess"
        "A full-featured chess game."
        "en-US"
        "/"
        "/"
        "#ffffff"
        "#dd1111"
        Display.init
        Orientation.init
        []
    , Manifest
        "Ultimate Crypto Plunge"
        "cryptoplunge"
        "Learn cryptography through puzzles"
        "hr"
        "/"
        "/"
        "#000000"
        "#ffffff"
        Display.init
        Orientation.init
        [ Icon.placeholder ]
    , Manifest
        "Flight of the Condor"
        "Condor"
        "Fly as if you were the mighty condor!"
        "gu"
        "/"
        "/"
        "#111111"
        "#2222ee"
        Display.init
        Orientation.init
        [ Icon.placeholder, Icon.placeholder ]
    ]
