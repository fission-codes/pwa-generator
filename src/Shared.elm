module Shared exposing
    ( Flags
    , Model
    , Msg
    , init
    , subscriptions
    , update
    , view
    )

import Api
import Browser.Navigation exposing (Key)
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Session exposing (Session)
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
    , session : Session
    }


init : Flags -> Url -> Key -> ( Model, Cmd Msg )
init flags url key =
    ( Model url key Session.loading
    , Cmd.none
    )



-- UPDATE


type Msg
    = Login
    | GotSession Session


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Login ->
            ( model
            , Api.login ()
            )

        GotSession session ->
            ( { model | session = session }
            , Cmd.none
            )


subscriptions : Model -> Sub Msg
subscriptions model =
    Session.changes GotSession



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
                , paddingXY 25 30
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
                , viewSignInButton
                    { session = model.session, toMsg = toMsg }
                ]
            , column [ height fill ] page.body
            ]
        ]
    }


viewSignInButton : { session : Session, toMsg : Msg -> msg } -> Element msg
viewSignInButton { session, toMsg } =
    if Session.isGuest session then
        Input.button
            [ alignRight
            , padding 10
            , Border.rounded 4
            , Background.color Colors.purple
            , Font.family Fonts.karla
            , Font.size 18
            , Font.color Colors.white
            ]
            { onPress = Just (toMsg Login)
            , label = text "Sign In"
            }

    else
        none
