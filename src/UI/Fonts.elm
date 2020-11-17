module UI.Fonts exposing (karla, workSans)

import Element.Font as Font


karla : List Font.Font
karla =
    [ Font.external
        { url = "https://fonts.googleapis.com/css2?family=Karla&display=swap"
        , name = "Karla"
        }
    , Font.serif
    ]


workSans : List Font.Font
workSans =
    [ Font.external
        { url = "https://fonts.googleapis.com/css2?family=Work+Sans&display=swap"
        , name = "Work Sans"
        }
    , Font.sansSerif
    ]
