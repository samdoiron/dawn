port module Dawn exposing (..)

import Html exposing (Html, div, h1, p, text, nav, input, a, node, span, ul, li)
import Html.Attributes exposing (title, class, classList, href, style, attribute)
import Html.Events exposing (onClick)
import List exposing (head, drop, range, map)
import Regex exposing (regex, replace)
import Dict exposing (Dict)

import Types exposing (..)
import Poster exposing (poster)
import NavDrawer exposing (navDrawer)
import Icon exposing (icon, clickableIcon)
import Channel exposing (..)


port setStorage : Save -> Cmd msg

main : Program Never Model Msg
main = Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }

--- MODEL

model : Model
model =
    { community = "pics"
    , selectedPost = Nothing
    , drawerState = Closed
    , coverVisibility = Invisible
    , communities =
          [ "Programming"
          , "AskReddit"
          , "Funny"
          , "Gifs"
          , "me_irl"
          , "Videos"
          , "Technology"
          , "ShowerThoughts"
          , "ExplainLikeImFive"
          , "Overwatch"
          , "TodayILearned"
          , "AskScience"
          , "UpliftingNews"
          , "Pics"
          ]
          |> List.map emptyCommunity
          |> List.map (\c -> (c.name, c))
          |> Dict.fromList
    }

emptyCommunity : String -> Community
emptyCommunity name =
  { name = String.toLower(name)
  , posts = []
  , discussions = []
  }

defaultCommunity : Community
defaultCommunity =
  { name ="Default"
  , discussions = []
  , posts = []
  }

--- INIT

init : (Model, Cmd Msg)
init = 
  ( model
  , Cmd.none )

--- UPDATE

closeDrawer : Model -> Model
closeDrawer model =
  { model | drawerState = Closed
          , coverVisibility = Invisible }
        
updateCommunity : Community -> Model -> Model
updateCommunity community model =
  let
    newCommunities =
      Dict.update
        model.community
        (Maybe.map <| \_ -> community)

        model.communities
  in
    { model | communities = newCommunities }

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    UpdateCommunity community ->
      (updateCommunity community model, Cmd.none)

    SelectPost selected ->
      ({ model | selectedPost = Just selected }, Cmd.none)

    ClosePost ->
      ({ model | selectedPost = Nothing }, Cmd.none)

    OpenDrawer ->
      ({ model | drawerState = Open
               , coverVisibility = Visible }, Cmd.none)

    CloseDrawer ->
      ({ model | drawerState = Closed 
               , coverVisibility = Invisible }, Cmd.none)

    SelectCommunity selected ->
      (closeDrawer { model | community = selected.name })
        ! [ Channel.subscribeToCommunity selected.name ]

--- VIEW

view : Model -> Html Msg
view model =
  let
    fetched =
      Dict.get model.community model.communities 
    
    community =
      Maybe.withDefault defaultCommunity fetched
  in
    div [ class "l-app" ]
      [ region [ header community.name ] [ postsGrid community.posts ]
      , selectedPostRegion model.selectedPost
      , communityDrawer
          model.drawerState
          (Dict.values model.communities)
      , pageCover model.coverVisibility
      ]

region : List (Html Msg) -> List (Html Msg) -> Html Msg
region fixed scrollable =
  div [ class "l-region" ]
    [ div [ class "l-region-fixed" ] fixed
    , div [ class "l-region-scrollable "] scrollable
    ]

selectedPostRegion : Maybe Post -> Html Msg
selectedPostRegion maybe =
  case maybe of
    Just post ->
      region [] [ selectedPostView post ]

    Nothing ->
      region [] []


selectedPostView : Post -> Html Msg
selectedPostView post =
   div 
    [ class "s-big-card" ]
    [ div
      [ class "s-top-bar is-transparent" ]
      [ clickableIcon ClosePost "close"
      , h1 [ class "t-title s-fade-out"
           , title post.title
           ]
           [ text post.title ]
      ]
    , poster post.url ]


postsGrid : List Post -> Html Msg
postsGrid posts =
    div [ class "s-grid" ] (map postView posts)

header : String -> Html Msg
header title = div [ class "s-top-bar t-dark" ]
           [ clickableIcon OpenDrawer "menu"
           , h1 [ class "s-clickable l-community-name t-title"
                , onClick OpenDrawer ]
              [ text <| title ]
           , nav [ class "l-community-tabs s-tabs" ]
               [ span [ class "s-tab is-active" ] [ text "Posts" ]
               , span [ class "s-tab" ] [ text "Discussions" ]
               ]
           ]

postView : Post -> Html Msg
postView post = div [ onClick (SelectPost post)
                    , class "s-card is-actionable"
                    ]

                    [ div [ class "s-card-visual", postStyles post ] []
                    , div [ class "s-card-body" ]
                        [ h1 [ class "t-body-2" ] [ text post.title ]
                        ]
                    ]             

postStyles : Post -> Html.Attribute Msg
postStyles post =
  style [ ( "backgroundImage", "url(" ++ protocol_relative(post.thumbnail) ++ ")" )]

protocol_relative : Maybe Url -> Url
protocol_relative maybe =
  case maybe of
    Just url ->
      replace Regex.All (regex "http://") (\_ -> "//") url
    
    Nothing ->
      "data:image/png,"

pageCover : Visibility -> Html Msg
pageCover visibility =
  div
    [ classList
        [ ("s-page-cover", True)
        , ("is-visible", visibility == Visible)
        ]
    , onClick CloseDrawer
    ]
    []

communitiesView : List Community -> Html Msg
communitiesView items =
  ul
    [ class "s-list" ]
    (map communityItem items)

communityItem : Community -> Html Msg
communityItem item =
  li
    [ classList
      [ ("s-list-item", True)
      , ("t-list-item", True)
      , ("is-selected", False) -- FIXME
      ]
    , onClick (SelectCommunity item)
    ]
    [ text item.name ]

communityDrawer : NavDrawerState -> List Community -> Html Msg
communityDrawer state communities =
  navDrawer state [ communitiesView communities ]

fullwidthError : String -> Html Msg
fullwidthError message =
  fullwidthMessage [ icon "error", text message ]

fullwidthMessage : List (Html Msg) -> Html Msg
fullwidthMessage children =
  div [ class "s-fullwidth-message" ] children


--- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
  Channel.communityUpdates UpdateCommunity