// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import "bootstrap";
import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"
import "chartkick/chart.js"

Rails.start()
Turbolinks.start()
ActiveStorage.start()

import { changeLinkColor } from '../components/change_link_color.js'
import { timelineInit } from '../components/timeline.js';


document.addEventListener('turbolinks:load', () => {
	timelineInit();
  changeLinkColor();
});
