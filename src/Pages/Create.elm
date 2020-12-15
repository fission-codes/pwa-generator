module Pages.Create exposing (Model, Msg, Params, page)

import Api
import Components.ManifestEditor as ManifestEditor exposing (Problem)
import Components.ManifestOutputs as ManifestOutputs
import Element exposing (..)
import Element.Border as Border
import Element.Font as Font
import Html.Attributes exposing (manifest)
import Json.Encode as Encode
import Manifest exposing (Manifest)
import Manifest.Color
import Material.Icons.Outlined as MaterialIcons
import Material.Icons.Types exposing (Coloring(..))
import Session exposing (Session)
import Shared
import Spa.Document exposing (Document)
import Spa.Generated.Route as Route
import Spa.Page as Page exposing (Page)
import Spa.Url as Url exposing (Url)
import UI.Colors as Colors exposing (Colors)


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
    , manifest : Manifest
    , colors : Colors
    , problems : List Problem
    }


init : Shared.Model -> Url Params -> ( Model, Cmd Msg )
init shared { params } =
    ( { session = shared.session
      , device = shared.device
      , manifest = Manifest.init
      , colors = Colors.init
      , problems = []
      }
    , Cmd.none
    )



-- UPDATE


type Msg
    = UpdateManifest (List Problem) Manifest
    | CopyToClipboard String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UpdateManifest problems manifest ->
            ( { model
                | manifest = manifest
                , problems = problems
                , colors = updateColors model.colors manifest
              }
            , Cmd.none
            )

        CopyToClipboard elemId ->
            ( model
            , Api.copyToClipboard (Encode.string elemId)
            )


updateColors : Colors -> Manifest -> Colors
updateColors currentColors manifest =
    { backgroundColor =
        Maybe.withDefault currentColors.backgroundColor <|
            Manifest.Color.fromHex manifest.backgroundColor
    , themeColor =
        Maybe.withDefault currentColors.themeColor <|
            Manifest.Color.fromHex manifest.themeColor
    , fontColor = Manifest.Color.contrast manifest.backgroundColor
    , themeFontColor = Manifest.Color.contrast manifest.themeColor
    }


save : Model -> Shared.Model -> Shared.Model
save model shared =
    { shared | colors = model.colors }


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
    { title = "Create"
    , body =
        [ case model.device.class of
            Phone ->
                column [ width fill, paddingXY 10 20 ]
                    [ paragraph [ Font.center ] [ text "Please use a tablet or desktop computer to create manifests." ]
                    ]

            Tablet ->
                case model.device.orientation of
                    Portrait ->
                        column [ width fill, paddingXY 10 20 ]
                            [ paragraph [ Font.center ] [ text "Please use landscape mode to create a manifest." ]
                            ]

                    Landscape ->
                        column
                            [ centerX
                            , width (px 1000)
                            , paddingXY 0 30
                            , spacing 30
                            ]
                            [ viewEditorControls model.manifest
                            , row [ width fill, spacing 30 ]
                                [ ManifestEditor.view
                                    { manifest = model.manifest
                                    , problems = model.problems
                                    , colors = model.colors
                                    , onUpdateManifest = UpdateManifest
                                    }
                                , ManifestOutputs.view
                                    { manifest = model.manifest
                                    , onCopyToClipboard = CopyToClipboard
                                    }
                                ]
                            ]

            _ ->
                column
                    [ centerX
                    , width (px 1000)
                    , paddingXY 0 30
                    , spacing 30
                    ]
                    [ viewEditorControls model.manifest
                    , row [ width fill, spacing 30 ]
                        [ ManifestEditor.view
                            { manifest = model.manifest
                            , problems = model.problems
                            , colors = model.colors
                            , onUpdateManifest = UpdateManifest
                            }
                        , ManifestOutputs.view
                            { manifest = model.manifest
                            , onCopyToClipboard = CopyToClipboard
                            }
                        ]
                    ]
        ]
    }


viewEditorControls : Manifest -> Element Msg
viewEditorControls manifest =
    row
        [ width fill
        , Border.width 1
        , Border.color Colors.lightGray
        ]
        [ row [ alignRight, spacing 5, Font.color Colors.darkGray ]
            [ el [ Font.color (Manifest.Color.contrast manifest.backgroundColor) ] <|
                html <|
                    MaterialIcons.save 28 Inherit
            , link []
                { url = Route.toString Route.Top
                , label =
                    el [ Font.color (Manifest.Color.contrast manifest.backgroundColor) ] <|
                        html <|
                            MaterialIcons.delete 28 Inherit
                }
            ]
        ]
