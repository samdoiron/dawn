import "phoenix_html"
import './global'


// Need to do both because this script is run async, and the document
// may be interactive / complete before it is run, so DOMContentLoaded was
// already fired
if (document.readyState == 'interactive' || document.readyState == 'complete') {
  InstantClick.init()
} else {
  document.addEventListener('DOMContentLoaded', InstantClick.init);
}

import "./post_preview"
