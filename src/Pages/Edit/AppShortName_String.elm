module Pages.Edit.AppShortName_String exposing (Model, Msg, Params, page)

import Components.ManifestEditor as ManifestEditor exposing (ManifestEditor)
import Components.ManifestViewer as ManifestViewer exposing (ManifestViewer)
import Element exposing (..)
import Element.Border as Border
import Element.Font as Font
import Manifest exposing (Manifest)
import Material.Icons.Outlined as MaterialIcons
import Material.Icons.Types exposing (Coloring(..))
import Session exposing (Session)
import Shared
import Spa.Document exposing (Document)
import Spa.Generated.Route as Route
import Spa.Page as Page exposing (Page)
import Spa.Url as Url exposing (Url)
import UI.Colors as Colors


page : Page Params Model Msg
page =
    Page.application
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        , save = save
        , load = load
        }



-- INIT


type alias Params =
    { appShortName : String }


type alias Model =
    { session : Session
    , device : Device
    , appShortName : String
    , manifest : Maybe Manifest
    }


init : Shared.Model -> Url Params -> ( Model, Cmd Msg )
init shared { params } =
    let
        maybeManifest =
            List.head <|
                List.filter
                    (\manifest -> manifest.shortName == params.appShortName)
                    shared.manifests
    in
    ( { session = shared.session
      , device = shared.device
      , appShortName = params.appShortName
      , manifest = maybeManifest
      }
    , Cmd.none
    )



-- UPDATE


type Msg
    = ReplaceMe


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ReplaceMe ->
            ( model, Cmd.none )


save : Model -> Shared.Model -> Shared.Model
save model shared =
    shared


{-| We want to load the manifest once after the user authenticates.
After each write to web native, we update the manifest in Shared, which
keeps it in sync when we return to the page. Loading it once prevents
a data tug-of-war while the user it editing.
-}
load : Shared.Model -> Model -> ( Model, Cmd Msg )
load shared model =
    case model.manifest of
        Just manifest ->
            ( { model
                | session = shared.session
                , device = shared.device
                , manifest = Just manifest
              }
            , Cmd.none
            )

        Nothing ->
            let
                maybeManifest =
                    List.head <|
                        List.filter
                            (\manifest -> manifest.shortName == model.appShortName)
                            shared.manifests
            in
            ( { model
                | session = shared.session
                , device = shared.device
                , manifest = maybeManifest
              }
            , Cmd.none
            )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Document Msg
view model =
    { title = "Editing " ++ model.appShortName
    , body =
        [ case model.device.class of
            Phone ->
                column [ width fill, paddingXY 10 20 ] []

            Tablet ->
                case model.device.orientation of
                    Portrait ->
                        column [ width fill, paddingXY 10 20, spacing 20 ]
                            [ viewEditorControls
                            ]

                    Landscape ->
                        column
                            [ centerX
                            , width (px 1000)
                            , paddingXY 0 30
                            , spacing 30
                            ]
                            [ viewEditorControls
                            ]

            _ ->
                column
                    [ centerX
                    , width (px 1000)
                    , paddingXY 0 30
                    , spacing 30
                    ]
                    [ viewEditorControls
                    ]
        ]
    }


viewEditorControls : Element Msg
viewEditorControls =
    row
        [ width fill
        , Border.width 1
        , Border.color Colors.lightGray
        ]
        [ row [ alignRight, spacing 5, Font.color Colors.darkGray ]
            [ el [] <|
                html <|
                    MaterialIcons.edit 28 Inherit
            , link []
                { url = Route.toString Route.Top
                , label =
                    el [] <|
                        html <|
                            MaterialIcons.delete 28 Inherit
                }
            , el [] <|
                html <|
                    MaterialIcons.save_alt 28 Inherit
            ]
        ]
