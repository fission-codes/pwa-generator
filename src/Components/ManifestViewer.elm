module Components.ManifestViewer exposing (view)

import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Html exposing (Html)
import Html.Attributes
import Manifest exposing (Manifest)
import Manifest.Color
import Manifest.Display as Display exposing (Display)
import Manifest.Icon exposing (Icon)
import Manifest.Orientation as Orientation
import UI.Colors as Colors
import UI.Fonts as Fonts


view :
    { manifest : Manifest
    , fontColor : Color
    }
    -> Element msg
view { manifest, fontColor } =
    column
        [ alignTop
        , width (px 480)
        , padding 10
        , spacing 25
        , Font.color fontColor
        ]
        [ row [ spacing 15 ]
            [ viewIcon { name = manifest.name, icons = manifest.icons }
            , paragraph [ centerY, Font.family Fonts.workSans, Font.size 32 ] [ text manifest.name ]
            ]
        , viewColors
            { themeColor = manifest.themeColor
            , backgroundColor = manifest.backgroundColor
            }
        , column
            [ spacing 12
            , Font.family Fonts.karla
            , Font.size 22
            ]
            [ paragraph []
                [ el [ Font.semiBold ] (text "Short Name: ")
                , text manifest.shortName
                ]
            , paragraph []
                [ el [ Font.semiBold ] (text "Language: ")
                , text manifest.lang
                ]
            , paragraph []
                [ el [ Font.semiBold ] (text "Display: ")
                , text (Display.displayToString manifest.display)
                ]
            , paragraph []
                [ el [ Font.semiBold ] (text "Orientation: ")
                , text (Orientation.orientationToString manifest.orientation)
                ]
            , paragraph []
                [ el [ Font.semiBold ] (text "Start URL: ")
                , text manifest.startUrl
                ]
            , paragraph []
                [ el [ Font.semiBold ] (text "Scope: ")
                , text manifest.scope
                ]
            , paragraph []
                [ el [ Font.semiBold ] (text "Description: ")
                , text manifest.description
                ]
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


viewColors :
    { themeColor : String
    , backgroundColor : String
    }
    -> Element msg
viewColors { themeColor, backgroundColor } =
    row [ width fill, spacing 15 ]
        [ column
            [ width fill, spacing 5 ]
            [ el
                [ alignLeft
                , width fill
                , height (px 100)
                , case Manifest.Color.fromHex themeColor of
                    Just color ->
                        Background.color color

                    Nothing ->
                        Background.color Colors.offWhite
                , Border.color Colors.lightestGray
                , Border.width 2
                ]
                none
            , el
                [ centerX
                , Font.family Fonts.karla
                , Font.size 16
                ]
                (text "Theme color")
            ]
        , column
            [ width fill, spacing 5 ]
            [ el
                [ alignLeft
                , width fill
                , height (px 100)
                , case Manifest.Color.fromHex backgroundColor of
                    Just color ->
                        Background.color color

                    Nothing ->
                        Background.color Colors.offWhite
                , Border.color Colors.lightestGray
                , Border.width 2
                ]
                none
            , el
                [ centerX
                , Font.family Fonts.karla
                , Font.size 16
                ]
                (text "Background color")
            ]
        ]
