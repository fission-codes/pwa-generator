module Pages.Top exposing (Model, Msg, Params, page)

import Element exposing (..)
import Element.Border as Border
import Element.Font as Font
import Html.Attributes exposing (manifest)
import Manifest exposing (Manifest)
import Material.Icons.Outlined as MaterialIcons
import Material.Icons.Types exposing (Coloring(..))
import Session exposing (Session)
import Shared
import Spa.Document exposing (Document)
import Spa.Generated.Route as Route
import Spa.Page as Page exposing (Page)
import Spa.Url exposing (Url)
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
    ()


type alias Model =
    { session : Session
    , device : Device
    , manifests : List Manifest
    }


init : Shared.Model -> Url Params -> ( Model, Cmd Msg )
init shared { params } =
    ( { session = shared.session
      , device = shared.device
      , manifests = Manifest.placeholders
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


load : Shared.Model -> Model -> ( Model, Cmd Msg )
load shared model =
    ( { model
        | session = shared.session
        , device = shared.device
      }
    , Cmd.none
    )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Document Msg
view model =
    { title = "Homepage"
    , body =
        [ case model.device.class of
            Phone ->
                column [ width fill, paddingXY 10 20 ] [ viewManifestList model.manifests ]

            Tablet ->
                case model.device.orientation of
                    Portrait ->
                        column [ width fill, paddingXY 10 20, spacing 20 ]
                            [ viewEditorControls
                            , viewManifestList model.manifests
                            ]

                    Landscape ->
                        column
                            [ centerX
                            , width (px 1000)
                            , paddingXY 0 30
                            , spacing 30
                            ]
                            [ viewEditorControls
                            , viewManifestList model.manifests
                            ]

            _ ->
                column
                    [ centerX
                    , width (px 1000)
                    , paddingXY 0 30
                    , spacing 30
                    ]
                    [ viewEditorControls
                    , viewManifestList model.manifests
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
        [ link [ alignRight, Font.color Colors.darkGray ]
            { url = Route.toString Route.Create
            , label =
                el [] <|
                    html <|
                        MaterialIcons.playlist_add 28 Inherit
            }
        ]


viewManifestList : List Manifest -> Element Msg
viewManifestList manifests =
    column
        [ width fill
        , spacing 5
        , Border.width 1
        , Border.color Colors.lightGray
        ]
    <|
        List.map viewManifest manifests


viewManifest : Manifest -> Element Msg
viewManifest manifest =
    row [] [ text manifest.shortName ]
