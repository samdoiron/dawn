import * as DOM from './dom';

export function request(method, url, callback, error) {
  let request = new XMLHttpRequest();
  request.open(method, url, true);
  request.setRequestHeader('Content-Type',
                           'application/x-www-form-urlencoded; charset=UTF-8');

  request.onload = () => {
    if (request.status >= 200 && request.status < 400) {
      var resp = request.responseText;
      callback(request.responseText);
    } else {
      error(false);
    }
  };

  request.onerror = () => {
    error(true);
  };

  request.send();
}

export function loadUrlIntoElement(url, element) {
  DOM.write(() => element.innerHTML = '');
  DOM.addClass(element, 'is-loading');
  request('GET', url, content => {
    DOM.removeClass(element, 'is-loading');
    DOM.write(() => element.innerHTML = content);
  }, error => null);
}
