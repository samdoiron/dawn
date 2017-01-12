module Icon exposing (icon, clickableIcon)

import Html exposing (Html, Attribute, div)
import Html.Attributes exposing (class, attribute)

import Html.Events exposing (onClick)
import Svg exposing (svg, use)
import Svg.Attributes exposing (xlinkHref, version)

import Types exposing (..)

-- Icons must be defined with the id "icon-<name>" in
-- the index.html file in order to be usable.

-- Material design icons are recommended.

icon : String -> Html Msg
icon =
  iconWithAttrs [ Svg.Attributes.class "s-icon" ]

clickableIcon : Msg -> String -> Html Msg
clickableIcon msg =
  iconWithAttrs 
    [ Svg.Attributes.class "s-icon is-clickable"
    , onClick msg
    ]

iconWithAttrs : (List (Attribute Msg)) -> String -> Html Msg
iconWithAttrs attrs name =
  svg ([ version "1.1"
      , attribute "xmlns:xlink" "http://www.w3.org/1999/xlink"
      ] ++ attrs)
    [ use [ xlinkHref ("#icon-" ++ name) ] [] ]
