(function () {
  'use strict';

  var buttonSelector = [
    '.serial-template-accessibility',
    '.serials-template-accessibility',
    '.issuetoc-accessibility',
    '.serial-modern-accessibility'
  ].join(',');

  var state = {
    dark: false,
    text: 0,
    marker: false,
    guide: false,
    originalText: true
  };

  function icon(name) {
    var icons = {
      access: '<svg viewBox="0 0 24 24" aria-hidden="true" focusable="false"><circle cx="12" cy="4" r="2.2"/><path d="M4 9h16"/><path d="M12 6v7"/><path d="M8 21l4-8 4 8"/></svg>',
      close: '<svg viewBox="0 0 24 24" aria-hidden="true" focusable="false"><path d="M6 6l12 12"/><path d="M18 6L6 18"/></svg>',
      moon: '<svg viewBox="0 0 24 24" aria-hidden="true" focusable="false"><path d="M20 15.5A8.5 8.5 0 1 1 8.5 4 7 7 0 0 0 20 15.5z"/></svg>',
      plus: '<svg viewBox="0 0 24 24" aria-hidden="true" focusable="false"><path d="M12 5v14"/><path d="M5 12h14"/></svg>',
      text: '<svg viewBox="0 0 24 24" aria-hidden="true" focusable="false"><path d="M4 7V5h16v2"/><path d="M9 19h6"/><path d="M12 5v14"/></svg>',
      minus: '<svg viewBox="0 0 24 24" aria-hidden="true" focusable="false"><path d="M5 12h14"/></svg>',
      marker: '<svg viewBox="0 0 24 24" aria-hidden="true" focusable="false"><path d="M4 20h16"/><path d="M6 16l8-8 4 4-8 8H6z"/><path d="M14 8l2-2 4 4-2 2"/></svg>',
      guide: '<svg viewBox="0 0 24 24" aria-hidden="true" focusable="false"><path d="M3 12h18"/><path d="M7 8l-4 4 4 4"/><path d="M17 8l4 4-4 4"/></svg>',
      reset: '<svg viewBox="0 0 24 24" aria-hidden="true" focusable="false"><path d="M4 4v6h6"/><path d="M20 12a8 8 0 1 1-2.34-5.66L4 10"/></svg>'
    };
    return icons[name] || '';
  }

  function ensurePanel() {
    var existing = document.getElementById('educaAccessibilityPanel');
    if (existing) {
      return existing;
    }

    var panel = document.createElement('section');
    panel.id = 'educaAccessibilityPanel';
    panel.className = 'educa-accessibility-panel';
    panel.setAttribute('aria-hidden', 'true');
    panel.setAttribute('aria-label', 'Menu de acessibilidade');
    panel.innerHTML =
      '<div class="educa-accessibility-head">' +
        '<h2>Menu de acessibilidade</h2>' +
        '<button type="button" class="educa-accessibility-close" aria-label="Fechar">' + icon('close') + '</button>' +
      '</div>' +
      '<div class="educa-accessibility-actions">' +
        action('dark', 'Modo escuro', icon('moon')) +
        action('increase', 'Aumentar texto', icon('plus')) +
        action('original', 'Texto original', icon('text')) +
        action('decrease', 'Diminuir texto', icon('minus')) +
        action('marker', 'Marcador', icon('marker')) +
        action('guide', 'Linha guia', icon('guide')) +
        action('reset', 'Redefinir', icon('reset')) +
      '</div>';
    document.body.appendChild(panel);
    panel.querySelector('.educa-accessibility-close').addEventListener('click', closePanel);
    panel.addEventListener('click', function (event) {
      var control = event.target.closest('[data-educa-a11y]');
      if (!control) {
        return;
      }
      runAction(control.getAttribute('data-educa-a11y'));
    });
    return panel;
  }

  function action(key, label, svg) {
    return '<button type="button" class="educa-accessibility-action" data-educa-a11y="' + key + '">' +
      '<span class="educa-accessibility-action-icon">' + svg + '</span>' +
      '<span>' + label + '</span>' +
    '</button>';
  }

  function openPanel(event) {
    if (event) {
      event.preventDefault();
    }
    var panel = ensurePanel();
    panel.classList.add('is-open');
    panel.setAttribute('aria-hidden', 'false');
    var first = panel.querySelector('button');
    if (first) {
      first.focus();
    }
  }

  function closePanel() {
    var panel = ensurePanel();
    panel.classList.remove('is-open');
    panel.setAttribute('aria-hidden', 'true');
  }

  function ensureOverlays() {
    if (!document.querySelector('.educa-reading-marker')) {
      var marker = document.createElement('div');
      marker.className = 'educa-reading-marker';
      document.body.appendChild(marker);
    }
    if (!document.querySelector('.educa-reading-guide')) {
      var guide = document.createElement('div');
      guide.className = 'educa-reading-guide';
      document.body.appendChild(guide);
    }
  }

  function applyState() {
    ensureOverlays();
    document.body.classList.toggle('educa-a11y-dark', state.dark);
    document.body.classList.toggle('educa-a11y-marker', state.marker);
    document.body.classList.toggle('educa-a11y-guide', state.guide);
    document.body.classList.toggle('educa-a11y-text-up-1', state.text === 1);
    document.body.classList.toggle('educa-a11y-text-up-2', state.text === 2);
    document.body.classList.toggle('educa-a11y-text-down-1', state.text === -1);
  }

  function runAction(actionName) {
    if (actionName === 'dark') {
      state.dark = !state.dark;
    } else if (actionName === 'increase') {
      state.text = Math.min(2, state.text + 1);
    } else if (actionName === 'decrease') {
      state.text = Math.max(-1, state.text - 1);
    } else if (actionName === 'original') {
      state.text = 0;
    } else if (actionName === 'marker') {
      state.marker = !state.marker;
    } else if (actionName === 'guide') {
      state.guide = !state.guide;
    } else if (actionName === 'reset') {
      state.dark = false;
      state.text = 0;
      state.marker = false;
      state.guide = false;
    }
    applyState();
  }

  function updateGuide(event) {
    document.documentElement.style.setProperty('--educa-guide-y', event.clientY + 'px');
    document.documentElement.style.setProperty('--educa-marker-y', event.clientY + 'px');
  }

  function enhanceButtons() {
    var buttons = document.querySelectorAll(buttonSelector);
    Array.prototype.forEach.call(buttons, function (button) {
      button.setAttribute('role', 'button');
      button.setAttribute('aria-label', 'Abrir menu de acessibilidade');
      button.setAttribute('href', '#educaAccessibilityPanel');
      button.innerHTML = icon('access') + '<span class="visually-hidden">Acessibilidade</span>';
      button.addEventListener('click', openPanel);
    });
  }

  function removeLegacyEmptyCenteredParagraphs() {
    var paragraphs = document.querySelectorAll('.journal-about-legacy p');
    Array.prototype.forEach.call(paragraphs, function (paragraph) {
      if (paragraph.querySelector('img, a, table, object, iframe, embed, video, audio')) {
        return;
      }
      var text = (paragraph.textContent || '').replace(/\u00a0/g, ' ').trim();
      if (text === '') {
        paragraph.remove();
      }
    });
  }

  function parseShareHref(href) {
    var data = {
      title: document.title || 'Educ@',
      url: window.location.href
    };
    if (!href || href.indexOf('mailto:') !== 0) {
      return data;
    }
    var query = href.split('?')[1] || '';
    var params = new URLSearchParams(query.replace(/&amp;/g, '&'));
    var subject = params.get('subject');
    var body = params.get('body');
    if (subject) {
      data.title = subject;
    }
    if (body) {
      data.url = body;
    }
    return data;
  }

  function shareIcon() {
    return '<svg class="serial-share-icon" viewBox="0 0 24 24" aria-hidden="true" focusable="false">' +
      '<circle cx="18" cy="5" r="2.4"></circle>' +
      '<circle cx="6" cy="12" r="2.4"></circle>' +
      '<circle cx="18" cy="19" r="2.4"></circle>' +
      '<path d="M8.2 11l7.6-4.4"></path>' +
      '<path d="M8.2 13l7.6 4.4"></path>' +
    '</svg><span class="serial-share-caret">▾</span>';
  }

  function buildShareLinks(data) {
    var encodedUrl = encodeURIComponent(data.url);
    var encodedTitle = encodeURIComponent(data.title);
    var encodedText = encodeURIComponent(data.title + ' ' + data.url);
    return [
      ['whatsapp', 'WhatsApp', 'https://api.whatsapp.com/send?text=' + encodedText],
      ['telegram', 'Telegram', 'https://t.me/share/url?url=' + encodedUrl + '&text=' + encodedTitle],
      ['facebook', 'Facebook', 'https://www.facebook.com/sharer/sharer.php?u=' + encodedUrl],
      ['x', 'X', 'https://twitter.com/intent/tweet?url=' + encodedUrl + '&text=' + encodedTitle],
      ['instagram', 'Instagram', 'https://www.instagram.com/']
    ];
  }

  function socialIcon(name) {
    var icons = {
      whatsapp: '<svg viewBox="0 0 24 24" aria-hidden="true" focusable="false"><path d="M5.4 19.1l.9-3.2A7.6 7.6 0 1 1 9.5 19l-4.1.1z"/><path d="M9 8.8c.2-.5.4-.5.7-.5h.5c.2 0 .4.1.5.4l.7 1.5c.1.3.1.5-.1.7l-.4.5c.7 1.2 1.6 2 2.8 2.6l.5-.6c.2-.2.4-.3.7-.2l1.5.7c.3.1.4.3.4.6v.5c0 .4-.2.7-.6.9-.6.3-1.4.4-2.4.1-2.4-.6-5-3.1-5.7-5.5-.3-.8-.1-1.4.3-1.7z"/></svg>',
      telegram: '<svg viewBox="0 0 24 24" aria-hidden="true" focusable="false"><path d="M20.5 4.6L3.8 11.2c-.8.3-.8 1.3.1 1.5l4.2 1.3 1.6 5c.2.7 1.1.9 1.6.3l2.3-2.7 4.3 3.2c.6.4 1.4.1 1.5-.6l2.4-13.4c.2-.8-.5-1.4-1.3-1.2z"/><path d="M8.2 14l9-6.1-6.7 7.8"/></svg>',
      facebook: '<svg viewBox="0 0 24 24" aria-hidden="true" focusable="false"><path d="M14 8.3h2.2V5.1c-.4-.1-1.7-.2-3.2-.2-3.1 0-5.2 1.9-5.2 5.4v3H4.5V17h3.3v7h4v-7h3.3l.5-3.7h-3.8v-2.6c0-1.1.3-2.4 2.2-2.4z"/></svg>',
      x: '<svg viewBox="0 0 24 24" aria-hidden="true" focusable="false"><path d="M4.5 4.5l11.9 15h3.1L7.6 4.5H4.5z"/><path d="M4.8 19.5l6.7-7.1"/><path d="M12.9 11.8l6.2-7.3"/></svg>',
      instagram: '<svg viewBox="0 0 24 24" aria-hidden="true" focusable="false"><rect x="4.5" y="4.5" width="15" height="15" rx="4"/><circle cx="12" cy="12" r="3.4"/><circle cx="16.7" cy="7.4" r=".8"/></svg>'
    };
    return icons[name] || '';
  }

  function closeShareMenus(except) {
    var menus = document.querySelectorAll('.educa-share-menu.is-open');
    Array.prototype.forEach.call(menus, function (menu) {
      if (menu !== except) {
        menu.classList.remove('is-open');
        var trigger = menu.querySelector('.serial-share-btn');
        if (trigger) {
          trigger.setAttribute('aria-expanded', 'false');
        }
      }
    });
  }

  function closeDetailsMenus(event) {
    var openMenus = document.querySelectorAll('details.home-main-menu[open], details.serials-lang-menu[open], details.arttext-tool-menu[open]');
    Array.prototype.forEach.call(openMenus, function (menu) {
      if (event && menu.contains(event.target)) {
        return;
      }
      menu.removeAttribute('open');
    });
  }

  function enhanceShareButtons() {
    var buttons = document.querySelectorAll('.serial-share-btn');
    Array.prototype.forEach.call(buttons, function (button, index) {
      if (button.closest('.educa-share-menu')) {
        return;
      }
      var data = parseShareHref(button.getAttribute('href'));
      var links = buildShareLinks(data);
      var menu = document.createElement('div');
      var menuId = 'educaShareMenu' + index;
      menu.className = 'educa-share-menu';
      button.parentNode.insertBefore(menu, button);
      menu.appendChild(button);
      button.setAttribute('href', '#');
      button.setAttribute('role', 'button');
      button.setAttribute('aria-haspopup', 'true');
      button.setAttribute('aria-expanded', 'false');
      button.setAttribute('aria-controls', menuId);
      button.innerHTML = shareIcon();

      var list = document.createElement('div');
      list.id = menuId;
      list.className = 'educa-share-dropdown';
      list.setAttribute('role', 'menu');
      links.forEach(function (item) {
        var link = document.createElement('a');
        link.href = item[2];
        link.target = '_blank';
        link.rel = 'noopener noreferrer';
        link.setAttribute('role', 'menuitem');
        link.innerHTML = '<span class="educa-share-service-icon educa-share-service-' + item[0] + '">' + socialIcon(item[0]) + '</span><span>' + item[1] + '</span>';
        list.appendChild(link);
      });
      menu.appendChild(list);

      button.addEventListener('click', function (event) {
        event.preventDefault();
        var isOpen = menu.classList.toggle('is-open');
        button.setAttribute('aria-expanded', isOpen ? 'true' : 'false');
        closeShareMenus(menu);
      });
    });
  }

  function init() {
    removeLegacyEmptyCenteredParagraphs();
    enhanceButtons();
    enhanceShareButtons();
    ensurePanel();
    ensureOverlays();
    document.addEventListener('click', function (event) {
      if (!event.target.closest('.educa-share-menu')) {
        closeShareMenus(null);
      }
      closeDetailsMenus(event);
    });
    document.addEventListener('mousemove', updateGuide);
    document.addEventListener('keydown', function (event) {
      if (event.key === 'Escape') {
        closePanel();
        closeShareMenus(null);
        closeDetailsMenus(null);
      }
    });
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
  } else {
    init();
  }
}());
