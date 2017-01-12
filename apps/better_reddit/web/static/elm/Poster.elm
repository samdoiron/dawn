module Poster exposing (poster)

import Html exposing (Html, div, img, text, video, source, iframe)
import Html.Attributes exposing (class, src, href, target, rel, type_,  src, attribute)
import Regex exposing (..)
import List exposing (map, head, foldr)

import Maybe exposing (withDefault, andThen)

import Types exposing (..)

type PosterClass
  = Image Url
  | Video Url
  | Gfycat String
  | Default Url


poster : Url -> Html Msg
poster url =
  case (classify url) of
    Image url ->
      wrapper [ newTabLink url 
                  [ img [ class "s-poster-image", src url ] []
                  ]
              ]
    Video url ->
      wrapper [ video []
                  [ source
                      [ type_ "video/mp4"
                      , src url
                      ]
                      []
                  ]
              ]

    Gfycat id ->
      wrapper 
        [ div [ class "s-gfycat" ]
          [ iframe
              [ src <| "https://gfycat.com/ifr/" ++ id
              , attribute "frameborder" "0"
              , attribute "scrolling" "no"
              , attribute "width" "100%"
              , attribute "height" "100%"
              , attribute "allowfullscreen" "allowfullscreen"
              ]
            []
          ]
        ]

    Default url ->
      wrapper [ newTabLink url [ text "View in New Tab" ] ]


newTabLink : Url -> List (Html Msg) -> Html Msg
newTabLink url html =
  Html.a [ href url, target "_blank", rel "noopener" ] html

classify : Url -> PosterClass
classify url =
  findFirstOrDefault url
    [ plainImage
    , imgurComments
    , redditUpload
    , gifv
    , gfycat
    ]
    (Default url)

plainImage : Url -> Maybe PosterClass
plainImage url =
  let
    imagePath =
      (regex  ".*\\.(jpg|jpeg|png|webp|gif)(\\?.+)?$")
  in
    if (contains imagePath url) then
      Just (Image url)
    else
      Nothing

redditUpload : Url -> Maybe PosterClass
redditUpload url =
  let
    upload =
      (regex "(https?://)i\\.reddituploads.com/.*$")
  in
    if (contains upload url) then
      Just (Image url)
    else
      Nothing
  
wrapper : List (Html Msg) -> Html Msg
wrapper children =
  div [ class "s-poster" ] children


imgurComments : Url -> Maybe PosterClass
imgurComments url =
  url |> imgurId |> (Maybe.map imgurUrl)

gifv : Url -> Maybe PosterClass
gifv url =
  let
    gifvUrl =
      (regex  ".*\\.gifv(\\?.+)?$")

    id =
      imgurId url 
  in
    case (contains gifvUrl url, id) of
      (True, Just id) ->
        Just (Video <| "https://i.imgur.com/" ++ id ++ ".mp4")
      _ ->
        Nothing

gfycat : Url -> Maybe PosterClass
gfycat url =
  let
    gfycatUrl =
      (regex "https?://(?:www.)?gfycat.com/\\w+\\/?")

    id =
      gfycatId url

  in
    case (contains gfycatUrl url, id) of
      (True, Just id) ->
        Just (Gfycat id)

      _ ->
        Nothing

gfycatId : Url -> Maybe String
gfycatId url =
  url
    |> String.split "/"
    |> last

last : List a -> Maybe a
last = head << List.reverse

imgurId : Url -> Maybe String
imgurId url =
    let
      matches =
        find All (regex "^https?://(?:(?:www|i).)?imgur.com/([0-9a-zA-Z]+)(\\..*)?/?$")  url

      firstSubmatches =
        (head matches)
        |> (Maybe.map .submatches)
    in
      case (andThen head firstSubmatches) of
        Just id
          -> id

        _ ->
          Nothing
    
imgurUrl : String -> PosterClass
imgurUrl id = Image ("//imgur.com/" ++ id ++ ".jpg")

findFirstOrDefault : a -> List (a -> Maybe b) -> b -> b
findFirstOrDefault val funcs default =
  let
    candidates =
      map (\f -> f val) funcs
    
    selected =
      foldr (orElse) Nothing candidates
  in
    withDefault default selected

orElse : Maybe a -> Maybe a -> Maybe a
orElse a b =
  case a of
    Just _ ->
      a
    Nothing ->
      b