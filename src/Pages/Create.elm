module Pages.Create exposing (Model, Msg, Params, page)

import Api
import Browser.Navigation exposing (Key)
import Components.ManifestEditor as ManifestEditor exposing (Problem)
import Components.ManifestOutputs as ManifestOutputs
import Element exposing (..)
import Element.Border as Border
import Element.Events as Events
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
    , key : Key
    , device : Device
    , manifest : Manifest
    , colors : Colors
    , problems : List Problem
    }


init : Shared.Model -> Url Params -> ( Model, Cmd Msg )
init shared { params } =
    ( { session = shared.session
      , key = shared.key
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
    | Save Manifest
    | Cancel


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

        Save manifest ->
            ( model
            , Cmd.none
            )

        Cancel ->
            ( model
            , Browser.Navigation.replaceUrl model.key (Route.toString Route.Top)
            )


updateColors : Colors -> Manifest -> Colors
updateColors currentColors manifest =
    { backgroundColor =
        Maybe.withDefault currentColors.backgroundColor <|
            Manifest.Color.fromHex manifest.backgroundColor
    , themeColor =
        Maybe.withDefault currentColors.themeColor <|
            Manifest.Color.fromHex manifest.themeColor
    , fontColor =
        Maybe.withDefault currentColors.fontColor <|
            Manifest.Color.contrast manifest.backgroundColor
    , themeFontColor =
        Maybe.withDefault currentColors.themeFontColor <|
            Manifest.Color.contrast manifest.themeColor
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
                            ]
                            [ viewEditorControls
                                { manifest = model.manifest
                                , problems = model.problems
                                , colors = model.colors
                                }
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
                    ]
                    [ viewEditorControls
                        { manifest = model.manifest
                        , problems = model.problems
                        , colors = model.colors
                        }
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


viewEditorControls :
    { manifest : Manifest
    , problems : List Problem
    , colors : Colors
    }
    -> Element Msg
viewEditorControls { manifest, problems, colors } =
    row
        [ width fill ]
        [ row [ alignRight, spacing 5 ]
            [ if List.isEmpty problems then
                el [ Events.onClick (Save manifest), Font.color colors.fontColor ] <|
                    html <|
                        MaterialIcons.save 30 Inherit

              else
                none
            , el [ Events.onClick Cancel, Font.color colors.fontColor ] <|
                html <|
                    MaterialIcons.delete 30 Inherit
            ]
        ]
