module Manifest.Icon exposing (Icon, decoder, encode, placeholder)

import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline exposing (required)
import Json.Encode as Encode exposing (Value)


{-| The Icon type can be improved by enforcing sizes and type
-}
type alias Icon =
    { src : String
    , sizes : String
    , mimeType : String
    }


decoder : Decoder Icon
decoder =
    Decode.succeed Icon
        |> required "src" Decode.string
        |> required "sizes" Decode.string
        |> required "type" Decode.string


encode : Icon -> Value
encode icon =
    Encode.object
        [ ( "src", Encode.string icon.src )
        , ( "sizes", Encode.string icon.sizes )
        , ( "type", Encode.string icon.mimeType )
        ]


placeholder : Icon
placeholder =
    Icon "icon.png" "256x256" "image/png"
