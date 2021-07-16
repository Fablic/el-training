//= require jquery3
//= require popper
//= require bootstrap-sprockets
//= require bootstrap-select
//= require bootstrap
//= require_tree .

$(document).on('turbolinks:load', function() {
  $(window).trigger('load.bs.select.data-api');
});