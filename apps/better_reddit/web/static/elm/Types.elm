module Types exposing (..)

import Dict exposing (Dict)

type alias Url = String

type alias Model =
    { community : String
    , selectedPost : Maybe Post
    , drawerState : NavDrawerState
    , coverVisibility : Visibility
    , communities : Dict String Community
    }

type alias Save =
  { community : Community
  }

type alias Community =
  { name : String
  , posts: List Post
  , discussions : List Discussion
  }

type alias Post =
  { id : Int
  , title : String
  , score: Int
  , url : String
  , thumbnail : Maybe Url
  }

type alias Discussion =
  { id : Int
  , title : String
  , score: Int
  , url : String
  }

type Msg
  = UpdateCommunity Community
  | SelectCommunity Community
  | SelectPost Post
  | ClosePost
  | OpenDrawer
  | CloseDrawer

type NavDrawerState
  = Open
  | Closed

type Visibility
  = Visible
  | Invisible
