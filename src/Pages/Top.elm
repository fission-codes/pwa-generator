module Pages.Top exposing (Model, Msg, Params, page)

import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Html.Attributes exposing (manifest)
import Manifest exposing (Manifest)
import Manifest.Color as Color
import Manifest.Display as Display
import Manifest.Orientation as Orientation
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
      , manifests = shared.manifests
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
                column [ width fill, paddingXY 10 20 ] [ viewManifestList model.manifests model.device ]

            Tablet ->
                case model.device.orientation of
                    Portrait ->
                        column [ width fill, paddingXY 10 20, spacing 20 ]
                            [ viewEditorControls
                            , viewManifestList model.manifests model.device
                            ]

                    Landscape ->
                        column
                            [ centerX
                            , width (px 1000)
                            , paddingXY 0 30
                            , spacing 30
                            ]
                            [ viewEditorControls
                            , viewManifestList model.manifests model.device
                            ]

            _ ->
                column
                    [ centerX
                    , width (px 1000)
                    , paddingXY 0 30
                    , spacing 30
                    ]
                    [ viewEditorControls
                    , viewManifestList model.manifests model.device
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


viewManifestList : List Manifest -> Device -> Element Msg
viewManifestList manifests device =
    column
        [ width fill
        , spacing 5
        , Border.width 1
        , Border.color Colors.lightGray
        ]
    <|
        List.map (viewManifest device) manifests


viewManifest : Device -> Manifest -> Element Msg
viewManifest device manifest =
    let
        linkUrl =
            case device.class of
                Phone ->
                    Route.toString (Route.Preview__AppShortName_String { appShortName = manifest.shortName })

                _ ->
                    Route.toString (Route.Edit__AppShortName_String { appShortName = manifest.shortName })
    in
    row
        [ spacing 20
        , padding 10
        , width fill
        ]
        [ column []
            [ image [ width (Element.px 24) ]
                { src = "../public/images/badge-outline-colored.svg"
                , description = "App Icon goes here"
                }
            ]
        , column [ width fill ]
            [ link
                []
                { url = linkUrl
                , label = text manifest.name
                }
            ]
        , column
            [ Background.color (viewColor manifest.backgroundColor)
            , Border.color Colors.lightGray
            , Border.width 1
            , width (Element.px 24)
            , height (Element.px 24)
            ]
            []
        , column
            [ Background.color (viewColor manifest.themeColor)
            , Border.color Colors.lightGray
            , Border.width 1
            , width (Element.px 24)
            , height (Element.px 24)
            ]
            []
        , column []
            [ text (Display.displayToString manifest.display) ]
        , column []
            [ text (Orientation.orientationToString manifest.orientation) ]
        ]


viewColor : String -> Color
viewColor colorString =
    case Color.fromHex colorString of
        Just color ->
            color

        Nothing ->
            Colors.white
