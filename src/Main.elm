module Main exposing (Model, Msg(..), Player, main)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


main : Program () Model Msg
main =
    Browser.sandbox { init = init, view = view, update = update }


init : Model
init =
    { firstPlayer = playerStart "Alice"
    , secondPlayer = playerStart "Bert"
    }


update : Msg -> Model -> Model
update msg model =
    case msg of
        UpdateInput player input ->
            updatePlayer model { player | scoreInput = input }

        SubmitScore player ->
            updatePlayer model (addScore player)


updatePlayer : Model -> Player -> Model
updatePlayer originalModel player =
    if player.name == originalModel.firstPlayer.name then
        { originalModel | firstPlayer = player }

    else
        { originalModel | secondPlayer = player }


addScore : Player -> Player
addScore player =
    let
        newScore =
            parseInt player.scoreInput
    in
    { name = player.name
    , scoreInput = ""
    , scores = List.append player.scores [ newScore ]
    , finalScore = player.finalScore + newScore
    }


type alias Model =
    { firstPlayer : Player
    , secondPlayer : Player
    }


type alias Player =
    { name : String
    , scoreInput : String
    , scores : List Int
    , finalScore : Int
    }


type Msg
    = UpdateInput Player String
    | SubmitScore Player


playerStart : String -> Player
playerStart name =
    { name = name
    , scoreInput = ""
    , scores = [ 5, 6, 10, 20 ]
    , finalScore = 41
    }


parseInt : String -> Int
parseInt s =
    case String.toInt s of
        Nothing ->
            0

        Just v ->
            v


view : Model -> Html Msg
view model =
    board model


board : Model -> Html Msg
board model =
    div []
        [ playerColumn model.firstPlayer "left"
        , playerColumn model.secondPlayer "right"
        ]


playerColumn : Player -> String -> Html Msg
playerColumn player leftOrRight =
    div
        [ style "position" "fixed"
        , style "width" "50%"
        , style leftOrRight "0"
        ]
        [ h1 [] [ text (String.concat [ player.name, " (", String.fromInt player.finalScore, ")" ]) ]
        , scores player
        , scoreInput player
        ]


scores : Player -> Html Msg
scores player =
    div [] (List.map score player.scores)


score : Int -> Html Msg
score s =
    p [] [ text (String.fromInt s) ]


scoreInput : Player -> Html Msg
scoreInput player =
    span []
        [ input
            [ placeholder (String.concat [ player.name, "'s score" ])
            , value player.scoreInput
            , onInput (UpdateInput player)
            ]
            []
        , button
            [ onClick (SubmitScore player)
            ]
            [ text "add" ]
        ]
