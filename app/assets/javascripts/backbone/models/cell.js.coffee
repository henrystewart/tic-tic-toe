class TicTacToe.Models.Cell extends Backbone.Model
  defaults:
    id: ""
    value: "-"

class TicTacToe.Collections.Board extends Backbone.Collection
  model: TicTacToe.Models.Cell

  