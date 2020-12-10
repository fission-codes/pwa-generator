module UI.Fonts exposing (cousine, karla, workSans)

import Element.Font as Font


karla : List Font.Font
karla =
    [ Font.external
        { url = "https://fonts.googleapis.com/css2?family=Karla:wght@400;600&display=swap"
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


cousine : List Font.Font
cousine =
    [ Font.external
        { url = "https://fonts.googleapis.com/css2?family=Cousine&display=swap"
        , name = "Cousine"
        }
    , Font.monospace
    ]
