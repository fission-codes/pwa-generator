module Color.Tests exposing (determineContrast, fromHexColor)

import Element exposing (rgba255)
import Expect
import Fuzz exposing (Fuzzer, string)
import Manifest.Color exposing (contrast, fromHex)
import Test exposing (..)


fromHexColor : Test
fromHexColor =
    describe "Hex color parser"
        [ describe "Parses"
            [ test "white" <|
                \_ ->
                    fromHex "#ffffff"
                        |> Expect.equal (Just (rgba255 255 255 255 1))
            , test "black" <|
                \_ ->
                    fromHex "#000000"
                        |> Expect.equal (Just (rgba255 0 0 0 1))
            , test "red" <|
                \_ ->
                    fromHex "#ff0000"
                        |> Expect.equal (Just (rgba255 255 0 0 1))
            , test "green" <|
                \_ ->
                    fromHex "#00ff00"
                        |> Expect.equal (Just (rgba255 0 255 0 1))
            , test "blue" <|
                \_ ->
                    fromHex "#0000ff"
                        |> Expect.equal (Just (rgba255 0 0 255 1))
            , test "short white" <|
                \_ ->
                    fromHex "#fff"
                        |> Expect.equal (Just (rgba255 255 255 255 1))
            , test "short black" <|
                \_ ->
                    fromHex "#000"
                        |> Expect.equal (Just (rgba255 0 0 0 1))
            , test "short red" <|
                \_ ->
                    fromHex "#f00"
                        |> Expect.equal (Just (rgba255 255 0 0 1))
            , test "red with alpha channel" <|
                \_ ->
                    fromHex "#ff0000ff"
                        |> Expect.equal (Just (rgba255 255 0 0 1))
            , test "short red with alpha channel" <|
                \_ ->
                    fromHex "#f00f"
                        |> Expect.equal (Just (rgba255 255 0 0 1))
            ]
        , describe "Does not parse when"
            [ test "missing the #" <|
                \_ ->
                    fromHex "ffffff"
                        |> Expect.equal Nothing
            , test "only five hex digits" <|
                \_ ->
                    fromHex "#fffff"
                        |> Expect.equal Nothing
            , test "only two hex digits" <|
                \_ ->
                    fromHex "#ff"
                        |> Expect.equal Nothing
            , test "only one hex digit" <|
                \_ ->
                    fromHex "#f"
                        |> Expect.equal Nothing
            , test "no hex digits" <|
                \_ ->
                    fromHex "#"
                        |> Expect.equal Nothing
            , test "bad hex digit" <|
                \_ ->
                    fromHex "#p11111"
                        |> Expect.equal Nothing
            , test "bad hex digits" <|
                \_ ->
                    fromHex "#pym"
                        |> Expect.equal Nothing
            ]
        ]


determineContrast : Test
determineContrast =
    describe "Font contrast function"
        [ describe "determines black"
            [ test "on white" <|
                \_ ->
                    contrast "#ffffff"
                        |> Expect.equal (rgba255 0 0 0 1)
            , test "on short white" <|
                \_ ->
                    contrast "#fff"
                        |> Expect.equal (rgba255 0 0 0 1)
            , test "on white with alpha channel at full opacity" <|
                \_ ->
                    contrast "#ffffffff"
                        |> Expect.equal (rgba255 0 0 0 1)
            , test "on short white with alpha channel at full opacity" <|
                \_ ->
                    contrast "#ffff"
                        |> Expect.equal (rgba255 0 0 0 1)
            , test "on black with alpha channel at full transparency" <|
                \_ ->
                    contrast "#ffffff00"
                        |> Expect.equal (rgba255 0 0 0 1)
            , test "on short black with alpha channel at full transparency" <|
                \_ ->
                    contrast "#fff0"
                        |> Expect.equal (rgba255 0 0 0 1)
            ]
        , describe "determines white"
            [ test "on black" <|
                \_ ->
                    contrast "#000000"
                        |> Expect.equal (rgba255 255 255 255 1)
            , test "on short black" <|
                \_ ->
                    contrast "#000"
                        |> Expect.equal (rgba255 255 255 255 1)
            , test "on black with an alpha channel at full opacity" <|
                \_ ->
                    contrast "#000000ff"
                        |> Expect.equal (rgba255 255 255 255 1)
            , test "on short black with an alpha channel at full opacity" <|
                \_ ->
                    contrast "#000f"
                        |> Expect.equal (rgba255 255 255 255 1)
            ]
        ]
