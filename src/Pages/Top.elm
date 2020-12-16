module Pages.Top exposing (Model, Msg, Params, page)

import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Html.Attributes exposing (align, manifest)
import Manifest exposing (Manifest)
import Manifest.Color
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
import UI.Colors as Colors exposing (Colors)
import UI.Fonts as Fonts


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
    , colors : Colors
    }


init : Shared.Model -> Url Params -> ( Model, Cmd Msg )
init shared { params } =
    ( { session = shared.session
      , device = shared.device
      , manifests = shared.manifests
      , colors = shared.colors
      }
    , Cmd.none
    )



-- UPDATE


type Msg
    = Nop


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Nop ->
            ( model, Cmd.none )


save : Model -> Shared.Model -> Shared.Model
save model shared =
    shared


load : Shared.Model -> Model -> ( Model, Cmd Msg )
load shared model =
    ( { model
        | session = shared.session
        , device = shared.device
        , manifests = shared.manifests
      }
    , Cmd.none
    )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Document Msg
view model =
    { title = "Manifests"
    , body =
        [ case model.device.class of
            Phone ->
                column [ width fill, paddingXY 10 20 ]
                    [ viewManifestList
                        { manifests = model.manifests
                        , device = model.device
                        , fontColor = model.colors.fontColor
                        }
                    ]

            Tablet ->
                case model.device.orientation of
                    Portrait ->
                        column [ width fill, paddingXY 10 20 ]
                            [ viewEditorControls model.colors.fontColor
                            , viewManifestList
                                { manifests = model.manifests
                                , device = model.device
                                , fontColor = model.colors.fontColor
                                }
                            ]

                    Landscape ->
                        column
                            [ centerX
                            , width (px 1000)
                            , paddingXY 0 30
                            ]
                            [ viewEditorControls model.colors.fontColor
                            , viewManifestList
                                { manifests = model.manifests
                                , device = model.device
                                , fontColor = model.colors.fontColor
                                }
                            ]

            _ ->
                column
                    [ centerX
                    , width (px 1000)
                    , paddingXY 0 30
                    ]
                    [ viewEditorControls model.colors.fontColor
                    , viewManifestList
                        { manifests = model.manifests
                        , device = model.device
                        , fontColor = model.colors.fontColor
                        }
                    ]
        ]
    }


viewEditorControls : Color -> Element Msg
viewEditorControls fontColor =
    row
        [ width fill
        ]
        [ link
            [ alignRight
            , Font.color fontColor
            ]
            { url = Route.toString Route.Create
            , label =
                el [] <|
                    html <|
                        MaterialIcons.add 30 Inherit
            }
        ]


viewManifestList :
    { manifests : List Manifest
    , device : Device
    , fontColor : Color
    }
    -> Element Msg
viewManifestList { manifests, device, fontColor } =
    column
        [ width fill
        , paddingXY 0 20
        , spacing 12
        , Font.color fontColor
        ]
    <|
        List.map (viewManifest device) manifests


viewManifest : Device -> Manifest -> Element Msg
viewManifest device manifest =
    let
        themeColor =
            Maybe.withDefault Colors.lightPurple <|
                Manifest.Color.fromHex manifest.themeColor

        linkUrl =
            case device.class of
                Phone ->
                    Route.toString (Route.Preview__AppShortName_String { appShortName = manifest.shortName })

                _ ->
                    Route.toString (Route.Edit__AppShortName_String { appShortName = manifest.shortName })
    in
    link [ width fill ]
        { url = linkUrl
        , label =
            row
                [ width fill
                , padding 10
                , spacing 20
                , Border.widthXY 1 1
                , Border.rounded 2
                , mouseOver
                    [ Border.color themeColor
                    ]
                , Border.color Colors.lightGray
                , htmlAttribute (Html.Attributes.class "adaptive-border-color")
                , Font.family Fonts.karla
                ]
            <|
                [ row [ alignLeft, spacing 10 ]
                    [ image [ width (px 24) ]
                        { src = "../public/images/badge-outline-colored.svg"
                        , description = "App Icon goes here"
                        }
                    , column [ width fill ]
                        [ text manifest.name
                        ]
                    ]
                , row [ alignRight, spacing 20 ] <|
                    [ column
                        [ Background.color (viewColor manifest.backgroundColor)
                        , Border.color Colors.lightGray
                        , Border.width 1
                        , width (px 24)
                        , height (px 24)
                        ]
                        []
                    , column
                        [ Background.color (viewColor manifest.themeColor)
                        , Border.color Colors.lightGray
                        , Border.width 1
                        , width (px 24)
                        , height (px 24)
                        ]
                        []
                    ]
                        ++ (case device.class of
                                Phone ->
                                    [ none ]

                                Tablet ->
                                    case device.orientation of
                                        Portrait ->
                                            [ none ]

                                        Landscape ->
                                            [ column [ width (px 110) ]
                                                [ text (Display.toString manifest.display) ]
                                            ]

                                _ ->
                                    [ column [ width (px 110) ]
                                        [ text (Display.toString manifest.display) ]
                                    ]
                           )
                ]
        }


viewColor : String -> Color
viewColor colorString =
    case Manifest.Color.fromHex colorString of
        Just color ->
            color

        Nothing ->
            Colors.white
