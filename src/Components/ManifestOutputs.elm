module Components.ManifestOutputs exposing (view)

import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Events as Events
import Element.Font as Font
import Element.Input as Input
import Html exposing (Html)
import Html.Attributes
import Manifest exposing (Manifest)
import Manifest.Color
import Manifest.Display as Display exposing (Display)
import Manifest.Icon exposing (Icon)
import Manifest.Orientation as Orientation
import Material.Icons.Outlined as MaterialIcons
import Material.Icons.Types exposing (Coloring(..))
import UI.Colors as Colors
import UI.Fonts as Fonts


view :
    { manifest : Manifest
    , onCopyToClipboard : String -> msg
    }
    -> Element msg
view options =
    column [ width fill, paddingXY 10 20, spacing 20 ]
        [ viewManifest options
        , viewHtmlHead options
        ]



-- VIEW: MANIFEST


viewManifest :
    { manifest : Manifest
    , onCopyToClipboard : String -> msg
    }
    -> Element msg
viewManifest { manifest, onCopyToClipboard } =
    let
        manifestFields =
            [ { name = "name"
              , value = manifest.name
              }
            , { name = "short_name"
              , value = manifest.shortName
              }
            , { name = "description"
              , value = manifest.description
              }
            , { name = "lang"
              , value = manifest.lang
              }
            , { name = "start_url"
              , value = manifest.startUrl
              }
            , { name = "scope"
              , value = manifest.scope
              }
            , { name = "background_color"
              , value = manifest.backgroundColor
              }
            , { name = "theme_color"
              , value = manifest.themeColor
              }
            , { name = "display"
              , value = Display.displayToString manifest.display
              }
            , { name = "orientation"
              , value = Orientation.orientationToString manifest.orientation
              }
            ]
    in
    column
        [ width (px 480)
        , height (px 480)
        , paddingXY 15 20
        , spacing 20
        , scrollbars
        , Background.color Colors.offWhite
        , Border.rounded 3
        , Font.color Colors.darkGray
        , Font.size 16
        ]
        [ row
            [ width fill
            , height (px 22)
            , Font.family Fonts.cousine
            ]
            [ el [ alignBottom ] (text "manifest.json")
            , Input.button
                [ alignTop
                , alignRight
                ]
                { onPress = Just <| onCopyToClipboard "manifest-output"
                , label =
                    html <|
                        MaterialIcons.content_copy 20 Inherit
                }
            ]
        , column [ Font.family Fonts.cousine ]
            [ html <|
                Html.table [ Html.Attributes.id "manifest-output" ] <|
                    Html.tr [] [ Html.td [] [ Html.span [] [ Html.text "{" ] ] ]
                        :: List.indexedMap
                            (viewJsonField { spaces = 2, len = List.length manifestFields })
                            manifestFields
                        ++ (if not (List.isEmpty manifest.icons) then
                                viewJsonIcons manifest.icons

                            else
                                []
                           )
                        ++ [ Html.tr [] [ Html.td [] [ Html.span [] [ Html.text "}" ] ] ] ]
            ]
        ]


viewJsonIcons : List Icon -> List (Html msg)
viewJsonIcons icons =
    Html.tr []
        [ Html.td []
            [ Html.span [ Html.Attributes.style "color" "#5c2699" ] [ Html.text "  \"icons\": [" ]
            ]
        ]
        :: (List.indexedMap (viewJsonIcon (List.length icons)) icons
                |> List.concat
           )
        ++ [ Html.tr [] [ Html.td [] [ Html.text "  ]" ] ] ]


viewJsonIcon : Int -> Int -> Icon -> List (Html msg)
viewJsonIcon len index icon =
    let
        iconFields =
            [ { name = "src"
              , value = icon.src
              }
            , { name = "sizes"
              , value = icon.sizes
              }
            , { name = "type"
              , value = icon.mimeType
              }
            ]
    in
    Html.tr [ Html.Attributes.style "line-height" "20px" ] [ Html.td [] [ Html.text (String.padLeft 5 ' ' "{") ] ]
        :: List.indexedMap
            (viewJsonField { spaces = 6, len = List.length iconFields })
            iconFields
        ++ (if len > 1 && index < len - 1 then
                [ Html.tr [ Html.Attributes.style "line-height" "20px" ] [ Html.td [] [ Html.text (String.padLeft 6 ' ' "},") ] ] ]

            else
                [ Html.tr [ Html.Attributes.style "line-height" "20px" ] [ Html.td [] [ Html.text (String.padLeft 5 ' ' "}") ] ] ]
           )


viewJsonField :
    { spaces : Int, len : Int }
    -> Int
    ->
        { name : String
        , value : String
        }
    -> Html msg
viewJsonField { spaces, len } index { name, value } =
    Html.tr [ Html.Attributes.style "line-height" "20px" ]
        [ Html.td [] <|
            [ Html.span [ Html.Attributes.style "color" "#5c2699" ]
                [ Html.text
                    (String.repeat spaces " " ++ "\"" ++ name ++ "\"")
                ]
            , Html.text ": "
            ]
                ++ (if len > 1 && index < len - 1 then
                        [ Html.span [ Html.Attributes.style "color" "#c41a16" ] [ Html.text ("\"" ++ value ++ "\"") ]
                        , Html.text ","
                        ]

                    else
                        [ Html.span [ Html.Attributes.style "color" "#c41a16" ] [ Html.text ("\"" ++ value ++ "\"") ] ]
                   )
        ]



-- VIEW: HTML HEAD


viewHtmlHead :
    { manifest : Manifest
    , onCopyToClipboard : String -> msg
    }
    -> Element msg
viewHtmlHead { manifest, onCopyToClipboard } =
    column
        [ width (px 480)
        , height (px 480)
        , paddingXY 15 20
        , spacing 20
        , scrollbars
        , Background.color Colors.offWhite
        , Border.rounded 3
        , Font.color Colors.darkGray
        , Font.size 16
        ]
        [ row
            [ width fill
            , height (px 22)
            , Font.family Fonts.cousine
            ]
            [ el [ alignBottom ] (text "index.html")
            , Input.button
                [ alignTop, alignRight ]
                { onPress = Just <| onCopyToClipboard "head-output"
                , label =
                    html <|
                        MaterialIcons.content_copy 20 Inherit
                }
            ]
        , column [ Font.family Fonts.cousine ]
            [ html <|
                Html.table [ Html.Attributes.id "head-output" ] <|
                    [ viewHtmlTag "link" [ ( "rel", "manifest" ), ( "href", "manifest.json" ) ]
                    , viewHtmlTag "meta" [ ( "name", "mobile-web-app-capable" ), ( "content", "yes" ) ]
                    , viewHtmlTag "meta" [ ( "name", "apple-mobile-web-app-capable" ), ( "content", "yes" ) ]
                    , viewHtmlTag "meta" [ ( "name", "msapplication-starturl" ), ( "content", "yes" ) ]
                    , viewHtmlTag "meta" [ ( "name", "viewport" ), ( "content", "width=device-width, initial-scale=1, shrink-to-fit=no" ) ]
                    ]
                        ++ List.concatMap viewIconTags manifest.icons
            ]
        ]


viewIconTags : Icon -> List (Html msg)
viewIconTags icon =
    [ viewHtmlTag "meta"
        [ ( "rel", "icon" )
        , ( "type", icon.mimeType )
        , ( "sizes", icon.sizes )
        , ( "href", icon.src )
        ]
    , viewHtmlTag "meta"
        [ ( "rel", "apple-touch-icon" )
        , ( "type", icon.mimeType )
        , ( "sizes", icon.sizes )
        , ( "href", icon.src )
        ]
    ]


viewHtmlTag : String -> List ( String, String ) -> Html msg
viewHtmlTag tagName attributes =
    Html.tr [ Html.Attributes.style "line-height" "20px" ]
        [ Html.td [] <|
            [ Html.text "<"
            , Html.span [ Html.Attributes.style "color" "#5c2699" ] [ Html.text tagName ]
            ]
                ++ List.map viewHtmlAttribute attributes
                ++ [ Html.text ">" ]
        ]


viewHtmlAttribute : ( String, String ) -> Html msg
viewHtmlAttribute ( name, val ) =
    Html.span []
        [ Html.text (" " ++ name ++ "=")
        , Html.span [ Html.Attributes.style "color" "#c41a16" ] [ Html.text ("\"" ++ val ++ "\"") ]
        ]
