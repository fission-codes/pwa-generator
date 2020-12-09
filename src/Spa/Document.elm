module Spa.Document exposing
    ( Document
    , map
    , toBrowserDocument
    )

import Browser
import Element exposing (..)


type alias Document msg =
    { title : String
    , body : List (Element msg)
    }


map : (msg1 -> msg2) -> Document msg1 -> Document msg2
map fn doc =
    { title = doc.title
    , body = List.map (Element.map fn) doc.body
    }


toBrowserDocument : Document msg -> Browser.Document msg
toBrowserDocument doc =
    { title = doc.title
    , body =
        [ Element.layoutWith
            { options =
                [ focusStyle
                    { borderColor = Just (rgb255 0 0 0)
                    , backgroundColor = Nothing
                    , shadow =
                        Just
                            { color = rgb255 100 70 250
                            , offset = ( 0, 0 )
                            , blur = 2
                            , size = 1
                            }
                    }
                ]
            }
            [ width fill, height fill ]
            (column [ width fill, height fill ] doc.body)
        ]
    }
