module UI.Colors exposing
    ( Colors
    , black
    , darkGray
    , init
    , lightGray
    , lightPurple
    , lightestGray
    , offWhite
    , purple
    , white
    )

import Element exposing (Color, rgb255)


type alias Colors =
    { backgroundColor : Color
    , themeColor : Color
    , fontColor : Color
    , themeFontColor : Color
    }


init : Colors
init =
    { backgroundColor = white
    , themeColor = lightPurple
    , fontColor = black
    , themeFontColor = black
    }


lightPurple : Color
lightPurple =
    rgb255 235 236 245


purple : Color
purple =
    rgb255 100 70 250


white : Color
white =
    rgb255 255 255 255


offWhite : Color
offWhite =
    rgb255 245 245 245


lightestGray : Color
lightestGray =
    rgb255 235 235 235


lightGray : Color
lightGray =
    rgb255 200 200 200


darkGray : Color
darkGray =
    rgb255 50 50 50


black : Color
black =
    rgb255 0 0 0
