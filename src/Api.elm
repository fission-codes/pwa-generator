port module Api exposing (copyToClipboard, login, viewerChanges)

import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode exposing (Value)



-- AUTH


port login : () -> Cmd msg


port onAuthChange : (Value -> msg) -> Sub msg


viewerChanges : (Maybe viewer -> msg) -> Decoder viewer -> Sub msg
viewerChanges toMsg decoder =
    onAuthChange
        (\val ->
            Decode.decodeValue decoder val
                |> Result.toMaybe
                |> toMsg
        )


port copyToClipboard : Value -> Cmd msg
