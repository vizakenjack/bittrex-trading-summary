// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require select2
//= require jquery_ujs
//= require jquery-ui/effect-highlight
//= require jquery-ui/effect-shake
//= require turbolinks
//= require twitter/bootstrap
//= require editable/bootstrap-editable
//= require editable/rails
//= require_tree .

function slide_row(object) {
  object.closest('tr')
      .children('td')
      .animate({ padding: 0 })
      .wrapInner('<div />')
      .children()
      .slideUp("normal", function() { object.closest('tr').remove(); });
}
