function Shogi() {
}

Shogi.movable = function () {
  $('.cell').sortable({
    connectWith: '.cell',
    update: function (event, ui) {
      Shogi.escape(ui.item);
    }
  });
  $('.cell').disableSelection();
}

Shogi.escape = function (piece) {
  piece = $(piece);
  var x = piece.attr('x');
  var y = piece.attr('y');
  $("#board .cell[x='" + x + "'][y='" + y + "']").append(piece);
}

Shogi.prototype = {
}
