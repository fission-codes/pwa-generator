module Session exposing
    ( Session
    , changes
    , isGuest
    , loading
    , viewer
    )

import Api
import Viewer exposing (Viewer)


type Session
    = LoggedIn Viewer
    | Loading
    | Guest


loading : Session
loading =
    Loading


viewer : Session -> Maybe Viewer
viewer session =
    case session of
        LoggedIn val ->
            Just val

        Loading ->
            Nothing

        Guest ->
            Nothing


isGuest : Session -> Bool
isGuest session =
    case session of
        Guest ->
            True

        _ ->
            False



-- CHANGES


changes : (Session -> msg) -> Sub msg
changes toMsg =
    Api.viewerChanges
        (\maybeViewer -> toMsg (fromViewer maybeViewer))
        Viewer.decoder


fromViewer : Maybe Viewer -> Session
fromViewer maybeViewer =
    case maybeViewer of
        Just val ->
            LoggedIn val

        Nothing ->
            Guest
