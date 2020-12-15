module Components.ManifestEditor exposing (Problem, view)

import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Element.Region exposing (description)
import Html.Attributes exposing (manifest)
import Manifest exposing (Manifest)
import Manifest.Color
import Manifest.Display as Display exposing (Display)
import Manifest.Icon exposing (Icon)
import Manifest.Orientation as Orientation exposing (Orientation)
import Parser exposing (problem)
import UI.Colors as Colors exposing (Colors)
import UI.Fonts as Fonts



-- UPDATE


mapName : (String -> String) -> Manifest -> Manifest
mapName transform manifest =
    { manifest | name = transform manifest.name }


mapThemeColor : (String -> String) -> Manifest -> Manifest
mapThemeColor transform manifest =
    { manifest | themeColor = transform manifest.themeColor }


mapBackgroundColor : (String -> String) -> Manifest -> Manifest
mapBackgroundColor transform manifest =
    { manifest | backgroundColor = transform manifest.backgroundColor }


mapShortName : (String -> String) -> Manifest -> Manifest
mapShortName transform manifest =
    { manifest | shortName = transform manifest.shortName }


mapDescription : (String -> String) -> Manifest -> Manifest
mapDescription transform manifest =
    { manifest | description = transform manifest.description }


mapLang : (String -> String) -> Manifest -> Manifest
mapLang transform manifest =
    { manifest | lang = transform manifest.lang }


mapStartUrl : (String -> String) -> Manifest -> Manifest
mapStartUrl transform manifest =
    { manifest | startUrl = transform manifest.startUrl }


mapScope : (String -> String) -> Manifest -> Manifest
mapScope transform manifest =
    { manifest | scope = transform manifest.scope }


mapDisplay : (Display -> Display) -> Manifest -> Manifest
mapDisplay transform manifest =
    { manifest | display = transform manifest.display }


mapOrientation : (Orientation -> Orientation) -> Manifest -> Manifest
mapOrientation transform manifest =
    { manifest | orientation = transform manifest.orientation }



-- VIEW


view :
    { manifest : Manifest
    , problems : List Problem
    , colors : Colors
    , onUpdateManifest : List Problem -> Manifest -> msg
    }
    -> Element msg
view ({ manifest, problems, colors, onUpdateManifest } as options) =
    column
        [ alignTop
        , centerX
        , width (px 480)
        , height fill
        , padding 10
        , spacing 25
        ]
        [ row [ width fill, spacing 15 ]
            [ viewIcon { name = manifest.name, icons = manifest.icons }
            , viewInput
                { text = manifest.name
                , label = "Name"
                , placeholder = "App Full Name"
                , fontColor = colors.fontColor
                , problems = problemMessages Name problems
                , mapField =
                    \name ->
                        mapName (\_ -> name) manifest
                , validateField =
                    \val ->
                        validateField val Name problems
                , onUpdateManifest = onUpdateManifest
                }
            ]
        , row [ width fill, spacing 15 ]
            [ viewThemeColor options
            , viewBackgroundColor options
            ]
        , viewInput
            { text = manifest.shortName
            , label = "Short Name"
            , placeholder = "Short Name"
            , fontColor = colors.fontColor
            , problems = []
            , mapField =
                \shortName ->
                    mapShortName (\_ -> shortName) manifest
            , validateField =
                \_ ->
                    problems
            , onUpdateManifest = onUpdateManifest
            }
        , viewDescription
            { manifest = manifest
            , text = manifest.lang
            , placeholder = "Description"
            , label = "Desciption"
            , fontColor = colors.fontColor
            , onUpdateManifest = onUpdateManifest problems
            }
        , viewInput
            { text = manifest.lang
            , label = "Lang"
            , placeholder = "Language"
            , fontColor = colors.fontColor
            , problems = []
            , mapField =
                \lang ->
                    mapLang (\_ -> lang) manifest
            , validateField =
                \_ ->
                    problems
            , onUpdateManifest = onUpdateManifest
            }
        , viewInput
            { text = manifest.startUrl
            , label = "Start URL"
            , placeholder = "Start URL"
            , fontColor = colors.fontColor
            , problems = problemMessages StartUrl problems
            , mapField =
                \startUrl ->
                    mapStartUrl (\_ -> startUrl) manifest
            , validateField =
                \val ->
                    validateField val StartUrl problems
            , onUpdateManifest = onUpdateManifest
            }
        , viewInput
            { text = manifest.scope
            , label = "Scope"
            , placeholder = "Scope"
            , fontColor = colors.fontColor
            , problems = problemMessages Scope problems
            , mapField =
                \scope ->
                    mapScope (\_ -> scope) manifest
            , validateField =
                \val ->
                    validateField val Scope problems
            , onUpdateManifest = onUpdateManifest
            }
        , row [ spacing 50 ]
            [ viewOrientation
                { manifest = manifest
                , selected = manifest.orientation
                , colors = colors
                , onUpdateManifest = onUpdateManifest problems
                }
            , viewDisplay
                { manifest = manifest
                , selected = manifest.display
                , colors = colors
                , onUpdateManifest = onUpdateManifest problems
                }
            ]
        ]


viewIcon :
    { name : String, icons : List Icon }
    -> Element msg
viewIcon { name, icons } =
    image [ alignTop, width (Element.px 48) ]
        { src = "../public/images/badge-outline-colored.svg"
        , description = name ++ " icon"
        }


viewInput :
    { text : String
    , label : String
    , placeholder : String
    , fontColor : Color
    , problems : List String
    , mapField : String -> Manifest
    , validateField : String -> List Problem
    , onUpdateManifest : List Problem -> Manifest -> msg
    }
    -> Element msg
viewInput options =
    column [ width fill, spacing 5 ]
        [ Input.text
            [ padding 4
            , Font.size 18
            , Border.color Colors.lightGray
            , Border.width 1
            , Border.rounded 2
            ]
            { onChange =
                \val ->
                    options.onUpdateManifest
                        (options.validateField val)
                        (options.mapField val)
            , text = options.text
            , placeholder = Just (Input.placeholder [] (text options.placeholder))
            , label =
                Input.labelAbove
                    [ Font.size 14, Font.color options.fontColor ]
                    (text options.label)
            }
        , viewProblems
            { problems = options.problems
            , fontColor = options.fontColor
            }
        ]


viewThemeColor :
    { manifest : Manifest
    , problems : List Problem
    , colors : Colors
    , onUpdateManifest : List Problem -> Manifest -> msg
    }
    -> Element msg
viewThemeColor { manifest, problems, colors, onUpdateManifest } =
    column
        [ width fill
        , height fill
        , spacing 5
        ]
        [ el
            [ alignLeft
            , width fill
            , height (px 100)
            , Background.color colors.themeColor
            , Border.color Colors.lightestGray
            , Border.width 2
            ]
            none
        , el
            [ centerX
            , Font.family Fonts.karla
            , Font.size 16
            , Font.color colors.fontColor
            ]
            (text "Theme color")
        , Input.text
            [ padding 2
            , Font.size 18
            , Border.color Colors.lightGray
            , Border.width 1
            , Border.rounded 2
            ]
            { onChange =
                \themeColor ->
                    onUpdateManifest
                        (validateField themeColor ThemeColor problems)
                        (mapThemeColor (\_ -> themeColor) manifest)
            , text = manifest.themeColor
            , placeholder = Just (Input.placeholder [] (text "#000000"))
            , label = Input.labelHidden "Theme color"
            }
        , viewProblems
            { problems = problemMessages ThemeColor problems
            , fontColor = colors.fontColor
            }
        ]


viewBackgroundColor :
    { manifest : Manifest
    , problems : List Problem
    , colors : Colors
    , onUpdateManifest : List Problem -> Manifest -> msg
    }
    -> Element msg
viewBackgroundColor { manifest, problems, colors, onUpdateManifest } =
    column
        [ width fill
        , height fill
        , spacing 5
        ]
        [ el
            [ alignLeft
            , width fill
            , height (px 100)
            , Background.color colors.backgroundColor
            , Border.color Colors.lightestGray
            , Border.width 2
            ]
            none
        , el
            [ centerX
            , Font.family Fonts.karla
            , Font.size 16
            , Font.color colors.fontColor
            ]
            (text "Background color")
        , Input.text
            [ padding 2
            , Font.size 18
            , Border.color Colors.lightGray
            , Border.width 1
            , Border.rounded 2
            ]
            { onChange =
                \backgroundColor ->
                    onUpdateManifest
                        (validateField backgroundColor BackgroundColor problems)
                        (mapBackgroundColor (\_ -> backgroundColor) manifest)
            , text = manifest.backgroundColor
            , placeholder = Just (Input.placeholder [] (text "#ffffff"))
            , label = Input.labelHidden "Background color"
            }
        , viewProblems
            { problems = problemMessages BackgroundColor problems
            , fontColor = colors.fontColor
            }
        ]


viewDescription :
    { manifest : Manifest
    , text : String
    , placeholder : String
    , label : String
    , fontColor : Color
    , onUpdateManifest : Manifest -> msg
    }
    -> Element msg
viewDescription options =
    Input.multiline
        [ height (px 75)
        , padding 4
        , Font.size 18
        , Border.color Colors.lightGray
        , Border.width 1
        , Border.rounded 2
        ]
        { onChange =
            \description ->
                options.onUpdateManifest
                    (mapDescription (\_ -> description) options.manifest)
        , text = options.manifest.description
        , placeholder = Just (Input.placeholder [] (text "Description"))
        , label =
            Input.labelAbove
                [ Font.size 14, Font.color options.fontColor ]
                (text "Description")
        , spellcheck = False
        }


viewOrientation :
    { manifest : Manifest
    , selected : Orientation
    , colors : Colors
    , onUpdateManifest : Manifest -> msg
    }
    -> Element msg
viewOrientation options =
    column [ alignTop ]
        [ Input.radio [ spacing 20, Font.size 16, Font.color options.colors.fontColor ]
            { onChange =
                \orientation ->
                    options.onUpdateManifest <|
                        mapOrientation
                            (\_ -> Maybe.withDefault options.selected (Orientation.fromString orientation))
                            options.manifest
            , options =
                List.map (radioOption options.colors)
                    [ { label = "Any", value = "any" }
                    , { label = "Natural", value = "natural" }
                    , { label = "Landscape", value = "landscape" }
                    , { label = "Portrait", value = "portrait" }
                    , { label = "Portrait Primary", value = "portrait-primary" }
                    , { label = "Portrait Secondary", value = "portrait-secondary" }
                    , { label = "Landscape Primary", value = "landscape-primary" }
                    , { label = "Landscape Secondary", value = "landscape-secondary" }
                    ]
            , selected = Just (Orientation.orientationToString options.selected)
            , label =
                Input.labelAbove
                    [ Font.size 18
                    , Font.color options.colors.fontColor
                    , paddingEach { top = 0, right = 0, bottom = 20, left = 0 }
                    ]
                    (text "Orienation")
            }
        ]


viewDisplay :
    { manifest : Manifest
    , onUpdateManifest : Manifest -> msg
    , selected : Display
    , colors : Colors
    }
    -> Element msg
viewDisplay options =
    column [ alignTop ]
        [ Input.radio [ spacing 20, Font.size 16, Font.color options.colors.fontColor ]
            { onChange =
                \display ->
                    options.onUpdateManifest <|
                        mapDisplay
                            (\_ -> Maybe.withDefault options.selected (Display.fromString display))
                            options.manifest
            , options =
                List.map (radioOption options.colors)
                    [ { label = "Fullscreen", value = "fullscreen" }
                    , { label = "Standalone", value = "standalone" }
                    , { label = "Minimal-UI", value = "minimal-ui" }
                    , { label = "Browser", value = "browser" }
                    ]
            , selected = Just (Display.displayToString options.selected)
            , label =
                Input.labelAbove
                    [ Font.size 18
                    , Font.color options.colors.fontColor
                    , paddingEach { top = 0, right = 0, bottom = 20, left = 0 }
                    ]
                    (text "Display")
            }
        ]


radioOption :
    Colors
    -> { label : String, value : String }
    -> Input.Option String msg
radioOption colors option =
    Input.optionWith option.value <|
        \status ->
            row
                [ spacing 10
                , alignLeft
                , width shrink
                ]
                [ el
                    [ width (px 14)
                    , height (px 14)
                    , Background.color colors.backgroundColor
                    , Border.rounded 7
                    , Border.width <|
                        case status of
                            Input.Idle ->
                                1

                            Input.Focused ->
                                1

                            Input.Selected ->
                                5
                    , Border.color <|
                        case status of
                            Input.Idle ->
                                colors.fontColor

                            Input.Focused ->
                                colors.themeColor

                            Input.Selected ->
                                colors.themeColor
                    ]
                    none
                , el [ width fill, Font.color colors.fontColor ] (text option.label)
                ]


viewProblems : { problems : List String, fontColor : Color } -> Element msg
viewProblems { problems, fontColor } =
    column [ width fill ] <|
        List.map
            (\message ->
                el [ Font.size 11, Font.color fontColor ] <| text message
            )
            problems



-- VALIDATION


type ValidatedField
    = Name
    | StartUrl
    | Scope
    | BackgroundColor
    | ThemeColor


type alias Problem =
    ( ValidatedField, String )


validateField : String -> ValidatedField -> List Problem -> List Problem
validateField val field problems =
    case field of
        Name ->
            if String.isEmpty val then
                ( Name, "Name field cannot be empty" ) :: problems

            else
                List.filter
                    (\problem ->
                        Tuple.first problem /= Name
                    )
                    problems

        StartUrl ->
            if
                String.isEmpty val
                    || List.any
                        (\validStart ->
                            String.startsWith validStart val
                        )
                        [ "./", "../", "/" ]
            then
                List.filter
                    (\problem ->
                        Tuple.first problem /= StartUrl
                    )
                    problems

            else
                problems
                    |> List.filter (\problem -> Tuple.first problem /= StartUrl)
                    |> (::) ( StartUrl, "Must be empty or a valid relative path" )

        Scope ->
            if
                String.isEmpty val
                    || List.any
                        (\validStart ->
                            String.startsWith validStart val
                        )
                        [ "./", "../", "/" ]
                    || List.any
                        (\dotPath ->
                            val == dotPath
                        )
                        [ ".", ".." ]
            then
                List.filter
                    (\problem ->
                        Tuple.first problem /= Scope
                    )
                    problems

            else
                problems
                    |> List.filter (\problem -> Tuple.first problem /= Scope)
                    |> (::) ( Scope, "Must be empty or a valid relative path" )

        BackgroundColor ->
            case Manifest.Color.fromHex val of
                Just color ->
                    List.filter
                        (\problem ->
                            Tuple.first problem /= BackgroundColor
                        )
                        problems

                Nothing ->
                    problems
                        |> List.filter (\problem -> Tuple.first problem /= BackgroundColor)
                        |> (::) ( BackgroundColor, "Must be a valid hex color" )

        ThemeColor ->
            case Manifest.Color.fromHex val of
                Just color ->
                    List.filter
                        (\problem ->
                            Tuple.first problem /= ThemeColor
                        )
                        problems

                Nothing ->
                    problems
                        |> List.filter (\problem -> Tuple.first problem /= ThemeColor)
                        |> (::) ( ThemeColor, "Must be a valid hex color" )


problemMessages : ValidatedField -> List Problem -> List String
problemMessages field problems =
    List.filter (\problem -> Tuple.first problem == field) problems
        |> List.map (\problem -> Tuple.second problem)
