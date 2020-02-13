module Main exposing (main)

import Browser
import Html exposing (..)


type alias Model =
    { firstPlayer : Player
    , secondPlayer : Player
    }


type alias Player =
    { name : String
    , scores : List Int
    , finalScore : Int
    }


playerStart : Player
playerStart =
    { name = "Player", scores = [ 5, 6, 10, 20 ], finalScore = 41 }


type Msg
    = Message


main : Program () Model Msg
main =
    Browser.sandbox { init = init, view = view, update = update }


init : Model
init =
    { firstPlayer = playerStart
    , secondPlayer = playerStart
    }


view : Model -> Html Msg
view model =
    board model


board : Model -> Html Msg
board model =
    div []
        [ row model.firstPlayer
        , row model.secondPlayer
        ]


row : Player -> Html Msg
row player =
    div []
        [ h1 [] [ text player.name ]
        , scores player
        ]


scores : Player -> Html Msg
scores player =
    div [] (List.map score player.scores)


score : Int -> Html Msg
score s =
    p [] [ text (String.fromInt s) ]


update : Msg -> Model -> Model
update msg model =
    model
