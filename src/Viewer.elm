module Viewer exposing (Viewer, decoder, username)

import Json.Decode as Decode exposing (Decoder)


type Viewer
    = Viewer String


username : Viewer -> String
username (Viewer val) =
    val


decoder : Decoder Viewer
decoder =
    Decode.field "username" Decode.string
        |> Decode.map Viewer
