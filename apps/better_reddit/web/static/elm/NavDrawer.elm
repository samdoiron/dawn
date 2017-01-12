module NavDrawer exposing (..)

import Types exposing (..)
import Html exposing (Html, div, text, h1)
import Html.Attributes exposing (class)

navDrawer : NavDrawerState -> List (Html Msg) -> Html Msg
navDrawer state children =
  case state of
    Open ->
      div
        [ class "s-nav-drawer is-open" ]
        children

    Closed ->
      div [ class "s-nav-drawer" ] [] 
