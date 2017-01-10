!function(){"use strict";var e="undefined"==typeof window?global:window;if("function"!=typeof e.require){var t={},n={},i={},r={}.hasOwnProperty,o=/^\.\.?(\/|$)/,s=function(e,t){for(var n,i=[],r=(o.test(t)?e+"/"+t:t).split("/"),s=0,a=r.length;s<a;s++)n=r[s],".."===n?i.pop():"."!==n&&""!==n&&i.push(n);return i.join("/")},a=function(e){return e.split("/").slice(0,-1).join("/")},u=function(t){return function(n){var i=s(a(t),n);return e.require(i,t)}},c=function(e,t){var i=null;i=m&&m.createHot(e);var r={id:e,exports:{},hot:i};return n[e]=r,t(r.exports,u(e),r),r.exports},l=function(e){return i[e]?l(i[e]):e},f=function(e,t){return l(s(a(e),t))},h=function(e,i){null==i&&(i="/");var o=l(e);if(r.call(n,o))return n[o].exports;if(r.call(t,o))return c(o,t[o]);throw new Error("Cannot find module '"+e+"' from '"+i+"'")};h.alias=function(e,t){i[t]=e};var d=/\.[^.\/]+$/,p=/\/index(\.[^\/]+)?$/,v=function(e){if(d.test(e)){var t=e.replace(d,"");r.call(i,t)&&i[t].replace(d,"")!==t+"/index"||(i[t]=e)}if(p.test(e)){var n=e.replace(p,"");r.call(i,n)||(i[n]=e)}};h.register=h.define=function(e,i){if("object"==typeof e)for(var o in e)r.call(e,o)&&h.register(o,e[o]);else t[e]=i,delete n[e],v(e)},h.list=function(){var e=[];for(var n in t)r.call(t,n)&&e.push(n);return e};var m=e._hmr&&new e._hmr(f,h,t,n);h._cache=n,h.hmr=m&&m.wrap,h.brunch=!0,e.require=h}}(),function(){var e=(window,function(e,t,n){var i={},r=function(t,n){var o;try{return o=e(n+"/node_modules/"+t)}catch(s){if(s.toString().indexOf("Cannot find module")===-1)throw s;if(n.indexOf("node_modules")!==-1){var a=n.split("/"),u=a.lastIndexOf("node_modules"),c=a.slice(0,u).join("/");return r(t,c)}}return i};return function(o){if(o in t&&(o=t[o]),o){if("."!==o[0]&&n){var s=r(o,n);if(s!==i)return s}return e(o)}}});require.register("phoenix/priv/static/phoenix.js",function(t,n,i){n=e(n,{},"phoenix"),function(){!function(e){"use strict";function t(e){if(Array.isArray(e)){for(var t=0,n=Array(e.length);t<e.length;t++)n[t]=e[t];return n}return Array.from(e)}function n(e,t){if(!(e instanceof t))throw new TypeError("Cannot call a class as a function")}var i="function"==typeof Symbol&&"symbol"==typeof Symbol.iterator?function(e){return typeof e}:function(e){return e&&"function"==typeof Symbol&&e.constructor===Symbol?"symbol":typeof e},r=function(){function e(e,t){for(var n=0;n<t.length;n++){var i=t[n];i.enumerable=i.enumerable||!1,i.configurable=!0,"value"in i&&(i.writable=!0),Object.defineProperty(e,i.key,i)}}return function(t,n,i){return n&&e(t.prototype,n),i&&e(t,i),t}}();Object.defineProperty(e,"__esModule",{value:!0});var o="1.0.0",s={connecting:0,open:1,closing:2,closed:3},a=1e4,u={closed:"closed",errored:"errored",joined:"joined",joining:"joining",leaving:"leaving"},c={close:"phx_close",error:"phx_error",join:"phx_join",reply:"phx_reply",leave:"phx_leave"},l={longpoll:"longpoll",websocket:"websocket"},f=function(){function e(t,i,r,o){n(this,e),this.channel=t,this.event=i,this.payload=r||{},this.receivedResp=null,this.timeout=o,this.timeoutTimer=null,this.recHooks=[],this.sent=!1}return r(e,[{key:"resend",value:function(e){this.timeout=e,this.cancelRefEvent(),this.ref=null,this.refEvent=null,this.receivedResp=null,this.sent=!1,this.send()}},{key:"send",value:function(){this.hasReceived("timeout")||(this.startTimeout(),this.sent=!0,this.channel.socket.push({topic:this.channel.topic,event:this.event,payload:this.payload,ref:this.ref}))}},{key:"receive",value:function(e,t){return this.hasReceived(e)&&t(this.receivedResp.response),this.recHooks.push({status:e,callback:t}),this}},{key:"matchReceive",value:function(e){var t=e.status,n=e.response;e.ref;this.recHooks.filter(function(e){return e.status===t}).forEach(function(e){return e.callback(n)})}},{key:"cancelRefEvent",value:function(){this.refEvent&&this.channel.off(this.refEvent)}},{key:"cancelTimeout",value:function(){clearTimeout(this.timeoutTimer),this.timeoutTimer=null}},{key:"startTimeout",value:function(){var e=this;this.timeoutTimer||(this.ref=this.channel.socket.makeRef(),this.refEvent=this.channel.replyEventName(this.ref),this.channel.on(this.refEvent,function(t){e.cancelRefEvent(),e.cancelTimeout(),e.receivedResp=t,e.matchReceive(t)}),this.timeoutTimer=setTimeout(function(){e.trigger("timeout",{})},this.timeout))}},{key:"hasReceived",value:function(e){return this.receivedResp&&this.receivedResp.status===e}},{key:"trigger",value:function(e,t){this.channel.trigger(this.refEvent,{status:e,response:t})}}]),e}(),h=e.Channel=function(){function e(t,i,r){var o=this;n(this,e),this.state=u.closed,this.topic=t,this.params=i||{},this.socket=r,this.bindings=[],this.timeout=this.socket.timeout,this.joinedOnce=!1,this.joinPush=new f(this,c.join,this.params,this.timeout),this.pushBuffer=[],this.rejoinTimer=new v(function(){return o.rejoinUntilConnected()},this.socket.reconnectAfterMs),this.joinPush.receive("ok",function(){o.state=u.joined,o.rejoinTimer.reset(),o.pushBuffer.forEach(function(e){return e.send()}),o.pushBuffer=[]}),this.onClose(function(){o.rejoinTimer.reset(),o.socket.log("channel","close "+o.topic+" "+o.joinRef()),o.state=u.closed,o.socket.remove(o)}),this.onError(function(e){o.isLeaving()||o.isClosed()||(o.socket.log("channel","error "+o.topic,e),o.state=u.errored,o.rejoinTimer.scheduleTimeout())}),this.joinPush.receive("timeout",function(){o.isJoining()&&(o.socket.log("channel","timeout "+o.topic,o.joinPush.timeout),o.state=u.errored,o.rejoinTimer.scheduleTimeout())}),this.on(c.reply,function(e,t){o.trigger(o.replyEventName(t),e)})}return r(e,[{key:"rejoinUntilConnected",value:function(){this.rejoinTimer.scheduleTimeout(),this.socket.isConnected()&&this.rejoin()}},{key:"join",value:function(){var e=arguments.length<=0||void 0===arguments[0]?this.timeout:arguments[0];if(this.joinedOnce)throw"tried to join multiple times. 'join' can only be called a single time per channel instance";return this.joinedOnce=!0,this.rejoin(e),this.joinPush}},{key:"onClose",value:function(e){this.on(c.close,e)}},{key:"onError",value:function(e){this.on(c.error,function(t){return e(t)})}},{key:"on",value:function(e,t){this.bindings.push({event:e,callback:t})}},{key:"off",value:function(e){this.bindings=this.bindings.filter(function(t){return t.event!==e})}},{key:"canPush",value:function(){return this.socket.isConnected()&&this.isJoined()}},{key:"push",value:function(e,t){var n=arguments.length<=2||void 0===arguments[2]?this.timeout:arguments[2];if(!this.joinedOnce)throw"tried to push '"+e+"' to '"+this.topic+"' before joining. Use channel.join() before pushing events";var i=new f(this,e,t,n);return this.canPush()?i.send():(i.startTimeout(),this.pushBuffer.push(i)),i}},{key:"leave",value:function(){var e=this,t=arguments.length<=0||void 0===arguments[0]?this.timeout:arguments[0];this.state=u.leaving;var n=function(){e.socket.log("channel","leave "+e.topic),e.trigger(c.close,"leave",e.joinRef())},i=new f(this,c.leave,{},t);return i.receive("ok",function(){return n()}).receive("timeout",function(){return n()}),i.send(),this.canPush()||i.trigger("ok",{}),i}},{key:"onMessage",value:function(e,t,n){return t}},{key:"isMember",value:function(e){return this.topic===e}},{key:"joinRef",value:function(){return this.joinPush.ref}},{key:"sendJoin",value:function(e){this.state=u.joining,this.joinPush.resend(e)}},{key:"rejoin",value:function(){var e=arguments.length<=0||void 0===arguments[0]?this.timeout:arguments[0];this.isLeaving()||this.sendJoin(e)}},{key:"trigger",value:function(e,t,n){var i=c.close,r=c.error,o=c.leave,s=c.join;if(!(n&&[i,r,o,s].indexOf(e)>=0&&n!==this.joinRef())){var a=this.onMessage(e,t,n);if(t&&!a)throw"channel onMessage callbacks must return the payload, modified or unmodified";this.bindings.filter(function(t){return t.event===e}).map(function(e){return e.callback(a,n)})}}},{key:"replyEventName",value:function(e){return"chan_reply_"+e}},{key:"isClosed",value:function(){return this.state===u.closed}},{key:"isErrored",value:function(){return this.state===u.errored}},{key:"isJoined",value:function(){return this.state===u.joined}},{key:"isJoining",value:function(){return this.state===u.joining}},{key:"isLeaving",value:function(){return this.state===u.leaving}}]),e}(),d=(e.Socket=function(){function e(t){var i=this,r=arguments.length<=1||void 0===arguments[1]?{}:arguments[1];n(this,e),this.stateChangeCallbacks={open:[],close:[],error:[],message:[]},this.channels=[],this.sendBuffer=[],this.ref=0,this.timeout=r.timeout||a,this.transport=r.transport||window.WebSocket||d,this.heartbeatIntervalMs=r.heartbeatIntervalMs||3e4,this.reconnectAfterMs=r.reconnectAfterMs||function(e){return[1e3,2e3,5e3,1e4][e-1]||1e4},this.logger=r.logger||function(){},this.longpollerTimeout=r.longpollerTimeout||2e4,this.params=r.params||{},this.endPoint=t+"/"+l.websocket,this.reconnectTimer=new v(function(){i.disconnect(function(){return i.connect()})},this.reconnectAfterMs)}return r(e,[{key:"protocol",value:function(){return location.protocol.match(/^https/)?"wss":"ws"}},{key:"endPointURL",value:function(){var e=p.appendParams(p.appendParams(this.endPoint,this.params),{vsn:o});return"/"!==e.charAt(0)?e:"/"===e.charAt(1)?this.protocol()+":"+e:this.protocol()+"://"+location.host+e}},{key:"disconnect",value:function(e,t,n){this.conn&&(this.conn.onclose=function(){},t?this.conn.close(t,n||""):this.conn.close(),this.conn=null),e&&e()}},{key:"connect",value:function(e){var t=this;e&&(console&&console.log("passing params to connect is deprecated. Instead pass :params to the Socket constructor"),this.params=e),this.conn||(this.conn=new this.transport(this.endPointURL()),this.conn.timeout=this.longpollerTimeout,this.conn.onopen=function(){return t.onConnOpen()},this.conn.onerror=function(e){return t.onConnError(e)},this.conn.onmessage=function(e){return t.onConnMessage(e)},this.conn.onclose=function(e){return t.onConnClose(e)})}},{key:"log",value:function(e,t,n){this.logger(e,t,n)}},{key:"onOpen",value:function(e){this.stateChangeCallbacks.open.push(e)}},{key:"onClose",value:function(e){this.stateChangeCallbacks.close.push(e)}},{key:"onError",value:function(e){this.stateChangeCallbacks.error.push(e)}},{key:"onMessage",value:function(e){this.stateChangeCallbacks.message.push(e)}},{key:"onConnOpen",value:function(){var e=this;this.log("transport","connected to "+this.endPointURL(),this.transport.prototype),this.flushSendBuffer(),this.reconnectTimer.reset(),this.conn.skipHeartbeat||(clearInterval(this.heartbeatTimer),this.heartbeatTimer=setInterval(function(){return e.sendHeartbeat()},this.heartbeatIntervalMs)),this.stateChangeCallbacks.open.forEach(function(e){return e()})}},{key:"onConnClose",value:function(e){this.log("transport","close",e),this.triggerChanError(),clearInterval(this.heartbeatTimer),this.reconnectTimer.scheduleTimeout(),this.stateChangeCallbacks.close.forEach(function(t){return t(e)})}},{key:"onConnError",value:function(e){this.log("transport",e),this.triggerChanError(),this.stateChangeCallbacks.error.forEach(function(t){return t(e)})}},{key:"triggerChanError",value:function(){this.channels.forEach(function(e){return e.trigger(c.error)})}},{key:"connectionState",value:function(){switch(this.conn&&this.conn.readyState){case s.connecting:return"connecting";case s.open:return"open";case s.closing:return"closing";default:return"closed"}}},{key:"isConnected",value:function(){return"open"===this.connectionState()}},{key:"remove",value:function(e){this.channels=this.channels.filter(function(t){return t.joinRef()!==e.joinRef()})}},{key:"channel",value:function(e){var t=arguments.length<=1||void 0===arguments[1]?{}:arguments[1],n=new h(e,t,this);return this.channels.push(n),n}},{key:"push",value:function(e){var t=this,n=e.topic,i=e.event,r=e.payload,o=e.ref,s=function(){return t.conn.send(JSON.stringify(e))};this.log("push",n+" "+i+" ("+o+")",r),this.isConnected()?s():this.sendBuffer.push(s)}},{key:"makeRef",value:function(){var e=this.ref+1;return e===this.ref?this.ref=0:this.ref=e,this.ref.toString()}},{key:"sendHeartbeat",value:function(){this.isConnected()&&this.push({topic:"phoenix",event:"heartbeat",payload:{},ref:this.makeRef()})}},{key:"flushSendBuffer",value:function(){this.isConnected()&&this.sendBuffer.length>0&&(this.sendBuffer.forEach(function(e){return e()}),this.sendBuffer=[])}},{key:"onConnMessage",value:function(e){var t=JSON.parse(e.data),n=t.topic,i=t.event,r=t.payload,o=t.ref;this.log("receive",(r.status||"")+" "+n+" "+i+" "+(o&&"("+o+")"||""),r),this.channels.filter(function(e){return e.isMember(n)}).forEach(function(e){return e.trigger(i,r,o)}),this.stateChangeCallbacks.message.forEach(function(e){return e(t)})}}]),e}(),e.LongPoll=function(){function e(t){n(this,e),this.endPoint=null,this.token=null,this.skipHeartbeat=!0,this.onopen=function(){},this.onerror=function(){},this.onmessage=function(){},this.onclose=function(){},this.pollEndpoint=this.normalizeEndpoint(t),this.readyState=s.connecting,this.poll()}return r(e,[{key:"normalizeEndpoint",value:function(e){return e.replace("ws://","http://").replace("wss://","https://").replace(new RegExp("(.*)/"+l.websocket),"$1/"+l.longpoll)}},{key:"endpointURL",value:function(){return p.appendParams(this.pollEndpoint,{token:this.token})}},{key:"closeAndRetry",value:function(){this.close(),this.readyState=s.connecting}},{key:"ontimeout",value:function(){this.onerror("timeout"),this.closeAndRetry()}},{key:"poll",value:function(){var e=this;this.readyState!==s.open&&this.readyState!==s.connecting||p.request("GET",this.endpointURL(),"application/json",null,this.timeout,this.ontimeout.bind(this),function(t){if(t){var n=t.status,i=t.token,r=t.messages;e.token=i}else var n=0;switch(n){case 200:r.forEach(function(t){return e.onmessage({data:JSON.stringify(t)})}),e.poll();break;case 204:e.poll();break;case 410:e.readyState=s.open,e.onopen(),e.poll();break;case 0:case 500:e.onerror(),e.closeAndRetry();break;default:throw"unhandled poll status "+n}})}},{key:"send",value:function(e){var t=this;p.request("POST",this.endpointURL(),"application/json",e,this.timeout,this.onerror.bind(this,"timeout"),function(e){e&&200===e.status||(t.onerror(status),t.closeAndRetry())})}},{key:"close",value:function(e,t){this.readyState=s.closed,this.onclose()}}]),e}()),p=e.Ajax=function(){function e(){n(this,e)}return r(e,null,[{key:"request",value:function(e,t,n,i,r,o,s){if(window.XDomainRequest){var a=new XDomainRequest;this.xdomainRequest(a,e,t,i,r,o,s)}else{var a=window.XMLHttpRequest?new XMLHttpRequest:new ActiveXObject("Microsoft.XMLHTTP");this.xhrRequest(a,e,t,n,i,r,o,s)}}},{key:"xdomainRequest",value:function(e,t,n,i,r,o,s){var a=this;e.timeout=r,e.open(t,n),e.onload=function(){var t=a.parseJSON(e.responseText);s&&s(t)},o&&(e.ontimeout=o),e.onprogress=function(){},e.send(i)}},{key:"xhrRequest",value:function(e,t,n,i,r,o,s,a){var u=this;e.timeout=o,e.open(t,n,!0),e.setRequestHeader("Content-Type",i),e.onerror=function(){a&&a(null)},e.onreadystatechange=function(){if(e.readyState===u.states.complete&&a){var t=u.parseJSON(e.responseText);a(t)}},s&&(e.ontimeout=s),e.send(r)}},{key:"parseJSON",value:function(e){return e&&""!==e?JSON.parse(e):null}},{key:"serialize",value:function(e,t){var n=[];for(var r in e)if(e.hasOwnProperty(r)){var o=t?t+"["+r+"]":r,s=e[r];"object"===("undefined"==typeof s?"undefined":i(s))?n.push(this.serialize(s,o)):n.push(encodeURIComponent(o)+"="+encodeURIComponent(s))}return n.join("&")}},{key:"appendParams",value:function(e,t){if(0===Object.keys(t).length)return e;var n=e.match(/\?/)?"&":"?";return""+e+n+this.serialize(t)}}]),e}();p.states={complete:4};var v=(e.Presence={syncState:function(e,t,n,i){var r=this,o=this.clone(e),s={},a={};return this.map(o,function(e,n){t[e]||(a[e]=n)}),this.map(t,function(e,t){var n=o[e];n?!function(){var i=t.metas.map(function(e){return e.phx_ref}),o=n.metas.map(function(e){return e.phx_ref}),u=t.metas.filter(function(e){return o.indexOf(e.phx_ref)<0}),c=n.metas.filter(function(e){return i.indexOf(e.phx_ref)<0});u.length>0&&(s[e]=t,s[e].metas=u),c.length>0&&(a[e]=r.clone(n),a[e].metas=c)}():s[e]=t}),this.syncDiff(o,{joins:s,leaves:a},n,i)},syncDiff:function(e,n,i,r){var o=n.joins,s=n.leaves,a=this.clone(e);return i||(i=function(){}),r||(r=function(){}),this.map(o,function(e,n){var r=a[e];if(a[e]=n,r){var o;(o=a[e].metas).unshift.apply(o,t(r.metas))}i(e,r,n)}),this.map(s,function(e,t){var n=a[e];if(n){var i=t.metas.map(function(e){return e.phx_ref});n.metas=n.metas.filter(function(e){return i.indexOf(e.phx_ref)<0}),r(e,n,t),0===n.metas.length&&delete a[e]}}),a},list:function(e,t){return t||(t=function(e,t){return t}),this.map(e,function(e,n){return t(e,n)})},map:function(e,t){return Object.getOwnPropertyNames(e).map(function(n){return t(n,e[n])})},clone:function(e){return JSON.parse(JSON.stringify(e))}},function(){function e(t,i){n(this,e),this.callback=t,this.timerCalc=i,this.timer=null,this.tries=0}return r(e,[{key:"reset",value:function(){this.tries=0,clearTimeout(this.timer)}},{key:"scheduleTimeout",value:function(){var e=this;clearTimeout(this.timer),this.timer=setTimeout(function(){e.tries=e.tries+1,e.callback()},this.timerCalc(this.tries+1))}}]),e}())}("undefined"==typeof t?window.Phoenix=window.Phoenix||{}:t)}()}),require.register("phoenix_html/priv/static/phoenix_html.js",function(t,n,i){n=e(n,{},"phoenix_html"),function(){"use strict";function e(e){var t="A"===e.tagName,n="parent"===e.getAttribute("data-submit");return t&&n}function t(t){for(;t&&t.getAttribute;){if(e(t)){var n=t.getAttribute("data-confirm");return(null===n||confirm(n))&&t.parentNode.submit(),!0}t=t.parentNode}return!1}window.addEventListener("click",function(e){if(e.target&&t(e.target))return e.preventDefault(),!1},!1)}()}),require.register("web/static/js/app.js",function(e,t,n){"use strict";t("phoenix_html"),t("./global"),t("./post_preview"),"interactive"==document.readyState||"complete"==document.readyState?InstantClick.init():document.addEventListener("DOMContentLoaded",InstantClick.init)}),require.register("web/static/js/dom.js",function(e,t,n){"use strict";function i(e){fastdom.measure(e)}function r(e){fastdom.mutate(e)}function o(e){return Array.prototype.slice.call(document.querySelectorAll(e))}function s(e){var t=document.querySelectorAll(e);return t[0]||null}function a(e,t){r(function(){return e.classList.add(t)})}function u(e,t){i(function(){return e.classList.remove(t)})}function c(e,t){o(e).forEach(t)}Object.defineProperty(e,"__esModule",{value:!0}),e.read=i,e.write=r,e.select=o,e.selectOne=s,e.addClass=a,e.removeClass=u,e.behave=c}),require.register("web/static/js/events.js",function(e,t,n){"use strict";function i(e){InstantClick.on("change",e)}Object.defineProperty(e,"__esModule",{value:!0}),e.onReady=i}),require.register("web/static/js/global.js",function(e,t,n){"use strict";Element.prototype.on=Element.prototype.addEventListener}),require.register("web/static/js/net.js",function(e,t,n){"use strict";function i(e){if(e&&e.__esModule)return e;var t={};if(null!=e)for(var n in e)Object.prototype.hasOwnProperty.call(e,n)&&(t[n]=e[n]);return t["default"]=e,t}function r(e,t,n,i){var r=new XMLHttpRequest;r.open(e,t,!0),r.setRequestHeader("Content-Type","application/x-www-form-urlencoded; charset=UTF-8"),r.onload=function(){if(r.status>=200&&r.status<400){r.responseText;n(r.responseText)}else i(!1)},r.onerror=function(){i(!0)},r.send()}function o(e,t){a.write(function(){return t.innerHTML=""}),a.addClass(t,"is-loading"),r("GET",e,function(e){a.removeClass(t,"is-loading"),a.write(function(){return t.innerHTML=e})},function(e){return null})}Object.defineProperty(e,"__esModule",{value:!0}),e.request=r,e.loadUrlIntoElement=o;var s=t("./dom"),a=i(s)}),require.register("web/static/js/post_preview.js",function(e,t,n){"use strict";function i(e){if(e&&e.__esModule)return e;var t={};if(null!=e)for(var n in e)Object.prototype.hasOwnProperty.call(e,n)&&(t[n]=e[n]);return t["default"]=e,t}function r(){return m.selectOne(y.selectors.postPreview)}function o(){r().innerHTML="",m.removeClass(r(),y.classes.postPreviewOpen)}function s(e){p.loadUrlIntoElement(e+"/embed",r())}function a(e){s(e),m.addClass(r(),y.classes.postPreviewOpen)}function u(e){return e.classList.contains(y.classes.postPreview)}function c(e){return e.ctrlKey||e.shiftKey||e.metaKey||e.button&&1==e.button}function u(e){return e.classList.contains(y.classes.postPreview)}function l(e){for(var t=e;t!==document.documentElement;){if(u(t))return!0;t=t.parentNode}return!1}function f(){return window.innerWidth<800}var h=t("./events"),d=t("./net"),p=i(d),v=t("./dom"),m=i(v),y={selectors:{postPreview:".js-post-preview"},classes:{postPreview:"js-post-preview",postPreviewOpen:"is-open"}};(0,h.onReady)(function(){document.documentElement.on("click",function(e){l(e.target)||o()}),m.behave(".js-open-preview",function(e){e.on("click",function(e){c(e)||f()||(e.preventDefault(),a(e.target.href))})})})}),require.register("web/static/js/socket.js",function(e,t,n){"use strict";Object.defineProperty(e,"__esModule",{value:!0});var i=t("phoenix"),r=new i.Socket("/socket",{params:{token:window.userToken}});r.connect();var o=r.channel("topic:subtopic",{});o.join().receive("ok",function(e){console.log("Joined successfully",e)}).receive("error",function(e){console.log("Unable to join",e)}),e["default"]=r}),require.alias("phoenix_html/priv/static/phoenix_html.js","phoenix_html"),require.alias("phoenix/priv/static/phoenix.js","phoenix"),require.register("___globals___",function(e,t,n){})}(),require("___globals___"),!function(e){"use strict";function t(){var t=this;t.reads=[],t.writes=[],t.raf=a.bind(e)}function n(e){e.scheduled||(e.scheduled=!0,e.raf(i.bind(null,e)))}function i(e){var t,i=e.writes,o=e.reads;try{r(o),r(i)}catch(s){t=s}if(e.scheduled=!1,(o.length||i.length)&&n(e),t){if(!e["catch"])throw t;e["catch"](t)}}function r(e){for(var t;t=e.shift();)t()}function o(e,t){var n=e.indexOf(t);return!!~n&&!!e.splice(n,1)}function s(e,t){for(var n in t)t.hasOwnProperty(n)&&(e[n]=t[n])}var a=e.requestAnimationFrame||e.webkitRequestAnimationFrame||e.mozRequestAnimationFrame||e.msRequestAnimationFrame||function(e){return setTimeout(e,16)};t.prototype={constructor:t,measure:function(e,t){var i=t?e.bind(t):e;return this.reads.push(i),n(this),i},mutate:function(e,t){var i=t?e.bind(t):e;return this.writes.push(i),n(this),i},clear:function(e){return o(this.reads,e)||o(this.writes,e)},extend:function(e){if("object"!=typeof e)throw new Error("expected object");var t=Object.create(this);return s(t,e),t.fastdom=this,t.initialize&&t.initialize(),t},"catch":null};var u=e.fastdom=e.fastdom||new t;"f"==(typeof define)[0]?define(function(){return u}):"o"==(typeof module)[0]&&(module.exports=u)}("undefined"!=typeof window?window:this);var InstantClick=function(e,t){function n(e){var t=e.indexOf("#");return 0>t?e:e.substr(0,t)}function r(e){for(;e&&"A"!=e.nodeName;)e=e.parentNode;return e}function o(e){var i=t.protocol+"//"+t.host;if(!(i=e.target||e.hasAttribute("download")||0!=e.href.indexOf(i+"/")||-1<e.href.indexOf("#")&&n(e.href)==y)){if(T){e:{do{if(!e.hasAttribute)break;if(e.hasAttribute("data-no-instant"))break;if(e.hasAttribute("data-instant")){e=!0;break e}}while(e=e.parentNode);e=!1}e=!e}else e:{do{if(!e.hasAttribute)break;if(e.hasAttribute("data-instant"))break;if(e.hasAttribute("data-no-instant")){e=!0;break e}}while(e=e.parentNode);e=!1}i=e}return!i}function s(e,t,n,i){for(var r=!1,o=0;o<I[e].length;o++)if("receive"==e){var s=I[e][o](t,n,i);s&&("body"in s&&(n=s.body),"title"in s&&(i=s.title),r=s)}else I[e][o](t,n,i);return r}function a(t,i,r,o){if(e.documentElement.replaceChild(i,e.body),r){if(history.pushState(null,null,r),i=r.indexOf("#"),i=-1<i&&e.getElementById(r.substr(i+1)),o=0,i)for(;i.offsetParent;)o+=i.offsetTop,i=i.offsetParent;scrollTo(0,o),y=n(r)}else scrollTo(0,o);e.title=O&&e.title==t?t+String.fromCharCode(160):t,p(),B.done(),s("change",!1),t=e.createEvent("HTMLEvents"),t.initEvent("instantclick:newpage",!0,!0),dispatchEvent(t)}function u(e){k>+new Date-500||(e=r(e.target))&&o(e)&&v(e.href)}function c(e){k>+new Date-500||(e=r(e.target))&&o(e)&&(e.addEventListener("mouseout",h),C?(g=e.href,b=setTimeout(v,C)):v(e.href))}function l(e){k=+new Date,(e=r(e.target))&&o(e)&&(E?e.removeEventListener("mousedown",u):e.removeEventListener("mouseover",c),v(e.href))}function f(e){var t=r(e.target);!t||!o(t)||1<e.which||e.metaKey||e.ctrlKey||(e.preventDefault(),m(t.href))}function h(){b?(clearTimeout(b),b=!1):q&&!H&&(w.abort(),H=q=!1)}function d(){if(!(4>w.readyState)&&0!=w.status){if(S.ready=+new Date-S.start,w.getResponseHeader("Content-Type").match(/\/(x|ht|xht)ml/)){var t=e.implementation.createHTMLDocument("");t.documentElement.innerHTML=w.responseText.replace(/<noscript[\s\S]+<\/noscript>/gi,""),L=t.title,M=t.body;var i=s("receive",P,M,L);i&&("body"in i&&(M=i.body),"title"in i&&(L=i.title)),i=n(P),_[i]={body:M,title:L,scrollY:i in _?_[i].scrollY:0};for(var r,t=t.head.children,i=0,o=t.length-1;0<=o;o--)if(r=t[o],r.hasAttribute("data-instant-track")){r=r.getAttribute("href")||r.getAttribute("src")||r.innerHTML;for(var a=N.length-1;0<=a;a--)N[a]==r&&i++}i!=N.length&&(A=!0)}else A=!0;H&&(H=!1,m(P))}}function p(t){if(e.body.addEventListener("touchstart",l,!0),E?e.body.addEventListener("mousedown",u,!0):e.body.addEventListener("mouseover",c,!0),e.body.addEventListener("click",f,!0),!t){t=e.body.getElementsByTagName("script");var n,r,o,s;for(i=0,j=t.length;i<j;i++)n=t[i],n.hasAttribute("data-no-instant")||(r=e.createElement("script"),n.src&&(r.src=n.src),n.innerHTML&&(r.innerHTML=n.innerHTML),o=n.parentNode,s=n.nextSibling,o.removeChild(n),o.insertBefore(r,s))}}function v(e){!E&&"display"in S&&100>+new Date-(S.start+S.display)||(b&&(clearTimeout(b),b=!1),e||(e=g),q&&(e==P||H))||(q=!0,H=!1,P=e,A=M=!1,S={start:+new Date},s("fetch"),w.open("GET",e),w.send())}function m(e){"display"in S||(S.display=+new Date-S.start),b||!q?b&&P&&P!=e?t.href=e:(v(e),B.start(0,!0),s("wait"),H=!0):H?t.href=e:A?t.href=P:M?(_[y].scrollY=pageYOffset,H=q=!1,a(L,M,P)):(B.start(0,!0),s("wait"),H=!0)}var y,g,b,k,w,T,E,C,x=navigator.userAgent,O=-1<x.indexOf(" CriOS/"),R="createTouch"in e,_={},P=!1,L=!1,A=!1,M=!1,S={},q=!1,H=!1,N=[],I={fetch:[],receive:[],wait:[],change:[]},B=function(){function t(t,o){l=t,e.getElementById(a.id)&&e.body.removeChild(a),a.style.opacity="1",e.getElementById(a.id)&&e.body.removeChild(a),r(),o&&setTimeout(n,0),clearTimeout(f),f=setTimeout(i,500)}function n(){l=10,r()}function i(){l+=1+2*Math.random(),98<=l?l=98:f=setTimeout(i,500),r()}function r(){u.style[c]="translate("+l+"%)",e.getElementById(a.id)||e.body.appendChild(a)}function o(){e.getElementById(a.id)?(clearTimeout(f),l=100,r(),a.style.opacity="0"):(t(100==l?0:l),setTimeout(o,0))}function s(){a.style.left=pageXOffset+"px",a.style.width=innerWidth+"px",a.style.top=pageYOffset+"px";var e="orientation"in window&&90==Math.abs(orientation);a.style[c]="scaleY("+innerWidth/screen[e?"height":"width"]*2+")"}var a,u,c,l,f;return{init:function(){a=e.createElement("div"),a.id="instantclick",u=e.createElement("div"),u.id="instantclick-bar",u.className="instantclick-bar",a.appendChild(u);var t=["Webkit","Moz","O"];if(c="transform",!(c in u.style))for(var n=0;3>n;n++)t[n]+"Transform"in u.style&&(c=t[n]+"Transform");var i="transition";if(!(i in u.style))for(n=0;3>n;n++)t[n]+"Transition"in u.style&&(i="-"+t[n].toLowerCase()+"-"+i);t=e.createElement("style"),t.innerHTML="#instantclick{position:"+(R?"absolute":"fixed")+";top:0;left:0;width:100%;pointer-events:none;z-index:2147483647;"+i+":opacity .25s .1s}.instantclick-bar{background:#29d;width:100%;margin-left:-100%;height:2px;"+i+":all .25s}",e.head.appendChild(t),R&&(s(),addEventListener("resize",s),addEventListener("scroll",s))},start:t,done:o}}(),D="pushState"in history&&(!x.match("Android")||x.match("Chrome/"))&&"file:"!=t.protocol;return{supported:D,init:function(){if(!y)if(D){for(var i=arguments.length-1;0<=i;i--){var r=arguments[i];!0===r?T=!0:"mousedown"==r?E=!0:"number"==typeof r&&(C=r)}y=n(t.href),_[y]={body:e.body,title:e.title,scrollY:pageYOffset};for(var o,r=e.head.children,i=r.length-1;0<=i;i--)o=r[i],o.hasAttribute("data-instant-track")&&(o=o.getAttribute("href")||o.getAttribute("src")||o.innerHTML,N.push(o));w=new XMLHttpRequest,w.addEventListener("readystatechange",d),p(!0),B.init(),s("change",!0),addEventListener("popstate",function(){var e=n(t.href);e!=y&&(e in _?(_[y].scrollY=pageYOffset,y=e,a(_[e].title,_[e].body,!1,_[e].scrollY)):t.href=t.href)})}else s("change",!0)},on:function(e,t){I[e].push(t)}}}(document,location);require("web/static/js/app");
//# sourceMappingURL=/js/app.js.map