port module Api exposing
    ( copyToClipboard
    , delete
    , gotManifestDeleted
    , gotManifestSaved
    , gotManifests
    , load
    , login
    , save
    , viewerChanges
    )

import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode exposing (Value)
import Manifest exposing (Manifest)



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



-- PERSISTENCE


port load : Value -> Cmd msg


port onManifestLoaded : (Encode.Value -> msg) -> Sub msg


gotManifest : (Maybe Manifest -> msg) -> Sub msg
gotManifest toMsg =
    onManifestLoaded <|
        \value ->
            Decode.decodeValue Manifest.decoder value
                |> Result.toMaybe
                |> toMsg


port save : Value -> Cmd msg


port onManifestSaved : (Encode.Value -> msg) -> Sub msg


gotManifestSaved : (Maybe Manifest -> msg) -> Sub msg
gotManifestSaved toMsg =
    onManifestSaved <|
        \value ->
            Decode.decodeValue Manifest.decoder value
                |> Result.toMaybe
                |> toMsg


port delete : Value -> Cmd msg


port onManifestDeleted : (Encode.Value -> msg) -> Sub msg


gotManifestDeleted : (Maybe Manifest -> msg) -> Sub msg
gotManifestDeleted toMsg =
    onManifestDeleted <|
        \value ->
            Decode.decodeValue Manifest.decoder value
                |> Result.toMaybe
                |> toMsg


port onManifestsLoaded : (Encode.Value -> msg) -> Sub msg


gotManifests : (List Manifest -> msg) -> Sub msg
gotManifests toMsg =
    onManifestsLoaded <|
        \value ->
            toMsg <|
                case Decode.decodeValue (Decode.list Manifest.decoder) value of
                    Ok manifests ->
                        manifests

                    Err err ->
                        []



-- CLIPBOARD


port copyToClipboard : Value -> Cmd msg
