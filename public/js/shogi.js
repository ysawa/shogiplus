/*
 * class Shogi
 */
function Shogi() {
}

Shogi.cell = function (piece) {
  var piece = $(piece);
  return piece.parent('.cell');
}

Shogi.escape = function (piece) {
  var piece = $(piece);
  var x = piece.attr('x');
  var y = piece.attr('y');
  $("#board .cell[x='" + x + "'][y='" + y + "']").append(piece);
}

Shogi.movable = function () {
  $('.cell').sortable({
    connectWith: '.cell',
    update: function (event, ui) {
      var piece = ui.item;
      if (Shogi.cell_have_same_side_of_piece(piece)) {
        alert('その動きはできません');
        Shogi.escape(piece);
      }
    }
  });
  $('.cell').disableSelection();
}

Shogi.cell_have_same_side_of_piece = function (piece) {
  var cell = Shogi.cell(piece);
  var black = null;
  var result = false;
  cell.children('.piece').each(function () {
    var piece = $(this);
    if (piece.hasClass('black')) {
      if (black == 'black') {
        result = true;
        return false;
      }
      black = 'black';
    } else {
      if (black == 'white') {
        result = true;
        return false;
      }
      black = 'white';
    }
  });
  return result;
}

Shogi.prototype = {
}
