port module Channel exposing (..)

import Types exposing (..)

port subscribeToCommunity : String -> Cmd msg
port communityUpdates : (Community -> msg) -> Sub msg