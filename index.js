require('material-design-lite/material.css');
require('./styles/base.css');
require('./styles/card.css');
require('./styles/page-container.css');

var Elm = require('./Main.elm');
Elm.fullscreen(Elm.Main);
