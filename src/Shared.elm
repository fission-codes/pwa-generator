module Shared exposing
    ( Flags
    , Model
    , Msg
    , init
    , subscriptions
    , update
    , view
    )

import Browser.Navigation exposing (Key)
import Element exposing (..)
import Element.Background as Background
import Element.Font as Font
import Spa.Document exposing (Document)
import Spa.Generated.Route as Route
import UI.Colors as Colors
import UI.Fonts as Fonts
import Url exposing (Url)



-- INIT


type alias Flags =
    ()


type alias Model =
    { url : Url
    , key : Key
    }


init : Flags -> Url -> Key -> ( Model, Cmd Msg )
init flags url key =
    ( Model url key
    , Cmd.none
    )



-- UPDATE


type Msg
    = ReplaceMe


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ReplaceMe ->
            ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view :
    { page : Document msg, toMsg : Msg -> msg }
    -> Model
    -> Document msg
view { page, toMsg } model =
    { title = page.title
    , body =
        [ column
            [ spacing 20
            , height fill
            , width fill
            ]
            [ row
                [ width fill
                , spacing 20
                , paddingXY 20 30
                , Background.color Colors.lightPurple
                ]
                [ link []
                    { url = Route.toString Route.Top
                    , label =
                        row [ spacing 7 ]
                            [ image [ Element.width (Element.px 36) ]
                                { src = "../public/images/badge-outline-colored.svg"
                                , description = "Fission logo"
                                }
                            , el
                                [ Font.size 28
                                , Font.family Fonts.workSans
                                , Font.color Colors.darkGray
                                ]
                                (text "Fission PWA Generator")
                            ]
                    }
                ]
            , column [ height fill ] page.body
            ]
        ]
    }
