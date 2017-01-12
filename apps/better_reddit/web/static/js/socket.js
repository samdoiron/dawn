import {Socket} from "phoenix"
import * as Elm from './elm.js'

let socket = new Socket("/socket")
socket.connect()

let dawn = Elm.Dawn.fullscreen();
let subscriptions = {};

dawn.ports.subscribeToCommunity.subscribe(function (name) {
  // Allowing multiple subscriptions makes elm code cleaner, but
  // is wasteful, so just ignore them here.
  if (subscriptions.hasOwnProperty(name)) {
    return
  }
  subscriptions[name] = true;

  let channel = socket.channel('hot:' + name.toLowerCase());
  channel.join()
    .receive('ok', resp => { console.log('Subscribed to', name, resp ) })
    .receive('error', err => { console.error('Error with', name, err) })

  channel.on('update', msg => {
    console.log('Update in channel', name, msg)
    dawn.ports.communityUpdates.send(msg)
  });
});


export default socket