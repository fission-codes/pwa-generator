module Pages.Edit.AppShortName_String exposing (Model, Msg, Params, page)

import Api
import Components.ManifestEditor as ManifestEditor exposing (Problem)
import Components.ManifestOutputs as ManifestOutputs
import Components.ManifestViewer as ManifestViewer
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Events as Events
import Element.Font as Font
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
import Task
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
    { appShortName : String }


type EditMode
    = Editing
    | NotEditing


type alias Model =
    { session : Session
    , device : Device
    , appShortName : String
    , manifest : Maybe Manifest
    , editMode : EditMode
    , colors : Colors
    , problems : List Problem
    }


init : Shared.Model -> Url Params -> ( Model, Cmd Msg )
init shared { params } =
    let
        maybeManifest =
            List.head <|
                List.filter
                    (\manifest -> manifest.shortName == params.appShortName)
                    shared.manifests

        colors =
            case maybeManifest of
                Just manifest ->
                    let
                        dbg =
                            Debug.log "manifest" manifest
                    in
                    { backgroundColor =
                        Maybe.withDefault Colors.lightPurple <|
                            Manifest.Color.fromHex manifest.backgroundColor
                    , themeColor =
                        Maybe.withDefault Colors.lightPurple <|
                            Manifest.Color.fromHex manifest.themeColor
                    , fontColor =
                        Maybe.withDefault Colors.black <|
                            Manifest.Color.contrast manifest.backgroundColor
                    , themeFontColor =
                        Maybe.withDefault Colors.black <|
                            Manifest.Color.contrast manifest.themeColor
                    }

                Nothing ->
                    Colors.init
    in
    ( { session = shared.session
      , device = shared.device
      , appShortName = params.appShortName
      , manifest = maybeManifest
      , editMode = NotEditing
      , colors = colors
      , problems = []
      }
      -- elm-spa needs an update to sync to Shared
    , Task.perform (\_ -> SyncShared) (Task.succeed Nothing)
    )



-- UPDATE


type Msg
    = Save Manifest
    | Edit
    | Delete Manifest
    | UpdateManifest (List Problem) Manifest
    | CopyToClipboard String
    | SyncShared


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Save manifest ->
            ( { model
                | editMode = NotEditing
              }
            , Cmd.none
            )

        Edit ->
            ( { model
                | editMode = Editing
              }
            , Cmd.none
            )

        Delete manifest ->
            ( model, Cmd.none )

        UpdateManifest problems manifest ->
            ( { model
                | manifest = Just manifest
                , problems = problems
                , colors = updateColors model.colors manifest
              }
            , Cmd.none
            )

        CopyToClipboard elemId ->
            ( model
            , Api.copyToClipboard (Encode.string elemId)
            )

        SyncShared ->
            ( model, Cmd.none )


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
                column [ width fill, paddingXY 10 20 ]
                    [ paragraph [ Font.center ] [ text "Please use a tablet or desktop computer to edit manifests." ]
                    ]

            Tablet ->
                case model.device.orientation of
                    Portrait ->
                        column [ width fill, paddingXY 10 20 ]
                            [ paragraph [ Font.center ] [ text "Please use landscape mode to edit this manifest." ]
                            ]

                    Landscape ->
                        column
                            [ centerX
                            , width (px 1000)
                            , paddingXY 0 30
                            ]
                        <|
                            case model.manifest of
                                Just manifest ->
                                    [ viewEditorControls
                                        { manifest = manifest
                                        , editMode = model.editMode
                                        , problems = model.problems
                                        , colors = model.colors
                                        }
                                    , row [ width fill, spacing 30 ]
                                        [ case model.editMode of
                                            Editing ->
                                                ManifestEditor.view
                                                    { manifest = manifest
                                                    , problems = model.problems
                                                    , colors = model.colors
                                                    , onUpdateManifest = UpdateManifest
                                                    }

                                            NotEditing ->
                                                ManifestViewer.view manifest
                                        , ManifestOutputs.view
                                            { manifest = manifest
                                            , onCopyToClipboard = CopyToClipboard
                                            }
                                        ]
                                    ]

                                Nothing ->
                                    [ none ]

            _ ->
                column
                    [ centerX
                    , width (px 1000)
                    , paddingXY 0 30
                    ]
                <|
                    case model.manifest of
                        Just manifest ->
                            [ viewEditorControls
                                { manifest = manifest
                                , editMode = model.editMode
                                , problems = model.problems
                                , colors = model.colors
                                }
                            , row [ width fill, spacing 30 ]
                                [ case model.editMode of
                                    Editing ->
                                        ManifestEditor.view
                                            { manifest = manifest
                                            , problems = model.problems
                                            , colors = model.colors
                                            , onUpdateManifest = UpdateManifest
                                            }

                                    NotEditing ->
                                        ManifestViewer.view manifest
                                , ManifestOutputs.view
                                    { manifest = manifest
                                    , onCopyToClipboard = CopyToClipboard
                                    }
                                ]
                            ]

                        Nothing ->
                            [ none ]
        ]
    }


viewEditorControls :
    { manifest : Manifest
    , editMode : EditMode
    , problems : List Problem
    , colors : Colors
    }
    -> Element Msg
viewEditorControls { manifest, editMode, problems, colors } =
    row
        [ width fill ]
        [ case editMode of
            Editing ->
                viewEditControls
                    { manifest = manifest
                    , problems = problems
                    , colors = colors
                    }

            NotEditing ->
                viewPreviewControls
                    { manifest = manifest
                    , colors = colors
                    }
        ]


viewEditControls :
    { manifest : Manifest
    , problems : List Problem
    , colors : Colors
    }
    -> Element Msg
viewEditControls { manifest, problems, colors } =
    row [ alignRight, spacing 5, Font.color Colors.darkGray ]
        [ if List.isEmpty problems then
            el [ Events.onClick (Save manifest), Font.color colors.fontColor ] <|
                html <|
                    MaterialIcons.save 30 Inherit

          else
            none
        , el [ Events.onClick (Delete manifest), Font.color colors.fontColor ] <|
            html <|
                MaterialIcons.delete 30 Inherit
        ]


viewPreviewControls :
    { manifest : Manifest
    , colors : Colors
    }
    -> Element Msg
viewPreviewControls { manifest, colors } =
    row [ alignRight, spacing 5, Font.color Colors.darkGray ]
        [ el [ Events.onClick Edit, Font.color colors.fontColor ] <|
            html <|
                MaterialIcons.edit 30 Inherit
        , el [ Events.onClick (Delete manifest), Font.color colors.fontColor ] <|
            html <|
                MaterialIcons.delete 30 Inherit
        ]
