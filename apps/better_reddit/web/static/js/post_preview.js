import {onReady} from './events';
import * as Net from './net';
import * as DOM from './dom';

const CONFIG = {
  selectors: {
    postPreview: '.js-post-preview',
  },

  classes: {
    postPreview: 'js-post-preview',
    postPreviewOpen: 'is-open'
  }
}


function getPostPreview() {
  return DOM.selectOne(CONFIG.selectors.postPreview);
}

function closePostPreview() {
  getPostPreview().innerHTML = '';
  DOM.removeClass(getPostPreview(),
                  CONFIG.classes.postPreviewOpen);
}

function loadPreview(url) {
  Net.loadUrlIntoElement(url + '/embed', getPostPreview());
}

function openPostPreview(url) {
  loadPreview(url);
  DOM.addClass(getPostPreview(),
               CONFIG.classes.postPreviewOpen);
}

function isPostPreview(element) {
  return element.classList.contains(CONFIG.classes.postPreview);
}

function isNewTabOpenAttempt(e) {
  return e.ctrlKey || e.shiftKey || e.metaKey || (e.button && e.button == 1);
}

function isPostPreview(node) {
  return node.classList.contains(CONFIG.classes.postPreview);
}

function isChildOfPostPreview(initialNode) {
  let node = initialNode; 
  while (node !== document.documentElement) {
    if (isPostPreview(node)) {
      return true;
    }
    node = node.parentNode;
  }
  return false;
}

function isMobile() {
  return window.innerWidth < 800;
}

onReady(() => {
  document.documentElement.on('click', e => {
    if (!isChildOfPostPreview(e.target)) {
      closePostPreview();
    }
  });

  DOM.behave('.js-open-preview', link => {
    link.on('click', e => {
      if (!isNewTabOpenAttempt(e) && !isMobile()){
        e.preventDefault();
        openPostPreview(e.target.href);
      }
    });
  });
});
