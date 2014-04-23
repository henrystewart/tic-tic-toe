class TicTacToe.Models.Opponent extends Backbone.Model
  MAX_DEPTH : 3
  initialize: ->
    @nextMoves = []




  nextBestMove: (board) ->
    console.log "finding the next best move"
    nextBoards = board.getAvailableBoards()
    max = -9001
    move_scores = []
    possible_moves = []
    for newboard in nextBoards
      val = -1 * @_solve(newboard, 1, @MAX_DEPTH)

      if val >= 0
        max = val
        move_scores.push max
        possible_moves.push newboard

    for ms in [0..move_scores.length-1]
      if move_scores[ms] == max
        @nextMoves.push possible_moves[ms]

    rand = Math.floor(Math.random() * @nextMoves.length)
    newboard = @nextMoves[rand]
    @nextMoves = []
    return newboard

  _solve: (board, currentPlayer, depth) ->

    if board.gameOver() || depth == 0
      if board.whichWinner() == 'o'
        return currentPlayer * 9001
      else if board.whichWinner() == 'x'
        return currentPlayer * 9001
      else
        return 0
    
    for boards in board.getAvailableBoards()
      return -1 * @_solve(boards, -1 * currentPlayer, depth - 1)

  # nextBestMove: (board) ->
  #   console.log "time to find next move..."
  #   nextMoves = @_solve(board, 1, @MAX_DEPTH)
  #   #TODO: get the max
  #   rand = Math.floor(Math.random() * @nextMoves.length)
  #   newboard = @nextMoves[rand]
  #   #@nextMoves = []
  #   return newboard




  # _solve: (board, currentPlayer , depth) ->
  #   console.log "AI attempting to find the next move!"
  #   console.log board
  #   #if depth == 0 #|| board.gameOver()
  #   #  return currentPlayer * board.heuristicValue()

  #   if board.gameOver() || depth == 0
  #     if board.whichWinner() == 'o'
  #       return currentPlayer * board.heuristicValue()
  #     else if board.whichWinner() == 'x'
  #       return currentPlayer * board.heuristicValue()
  #     else
  #       return 0

  #   bestValue = -9001

  #   nextAvailableMoves = board.getAvailableMoves()
  #   nextAvailableBoards = board.getAvailableBoards()
  #   console.log "next available boards: " + nextAvailableBoards
  #   for board in nextAvailableBoards
  #     val = -1 * @_solve(board, -1 * currentPlayer, depth - 1)
  #     #bestValue = Math.max(bestValue, val)
  #     if val > bestValue && depth == @MAX_DEPTH 
  #       @nextMoves.push board
  #   #return @nextMoves



  # _solve: (board, currentPlayer, depth) ->
    

  #   if board.gameOver() || depth == 0 
  #     if board.whichWinner() == 'o'
  #       return 9001
  #     else if board.whichWinner() == 'x'
  #       return -9001
  #     else
  #       return 0

  #   bestValue = -9001
  #   nextAvailableBoards = board.getAvailableBoards()
  #   for next_board in nextAvailableBoards
  #     val = -@_solve(next_board, -1 * currentPlayer, depth - 1)
  #     if depth == @MAX_DEPTH && val > bestValue
  #       @nextMoves.push next_board





class TicTacToe.Models.Board extends Backbone.Model

  MAX_HEURISTIC : 9001 
  MIN_HEURISTIC : 0

  initialize: ->
    # console.log "initializing Board model"
    @board = {}
    
    # win_configurations = [
    # @ROW_0 :        [0,1,2],
    # @ROW_1 :        [3,4,5],
    # @ROW_2 :        [6,7,8],
    # @DIAG_DOWN :    [0,4,8],
    # @DIAG_UP :      [6,4,2],
    # @COL_0 :        [0,3,6],
    # @COL_1 :        [1,4,7],
    # @COL_2 :        [2,5,8]
    # ]

    @win_configurations = [
      [0,1,2],
      [3,4,5],
      [6,7,8],
      [0,4,8],
      [6,4,2],
      [0,3,6],
      [1,4,7],
      [2,5,8]
    ]

  # copy: (board) ->
  #   copyBoard = new TicTacToe.Models.Backbone
  #   copyBoard.board = board

  updateBoard: (squareClicked) ->

    @board[squareClicked] = "x"
    #console.log "updating board"
    console.log @board

    # if @gameOver()
    #   return

  updateBoard_o: (newSquare) ->
    @board[newSquare] = "o"

  # We only find heuristic values of terminal boards (leaves on tree)
  heuristicValue: ->
    if @hasWinner()
      return @MAX_HEURISTIC 
    if !@hasWinner()
      return @MIN_HEURISTIC 
     
  # Determines whether the game is over
  gameOver: ->

    # You have a winner OR the board is full
    if @hasWinner() || @isFull()
      return true 
    else
      return false

  isFull: ->
    if Object.keys(@board).length == 9
      return true
    else
      return false

  hasWinner: ->
    # console.log 'in hasWinner()'
    # console.log @win_configurations
    for x in @win_configurations
      # console.log win_config
      # for x in win_config
      #   console.log x
      try
        if @board[x[0]] == @board[x[1]] && @board[x[0]] == @board[x[2]] && (@board[x[0]] == "x" || @board[x[0]] == "o")
          console.log "winner found"
          #return [true, @board[x[0]]]
          return true
      catch
        console.log "will continue looking for winner"
        continue
    return false

  whichWinner: ->
    for x in @win_configurations
      # console.log win_config
      # for x in win_config
      #   console.log x
      try
        if @board[x[0]] == @board[x[1]] && @board[x[0]] == @board[x[2]] && (@board[x[0]] == "x" || @board[x[0]] == "o")
          console.log "winner found"
          #return [true, @board[x[0]]]
          return @board[x[0]]
      catch
        console.log "will continue looking for winner"
        continue
    
      

  getAvailableMoves: ->
    taken_keys = Object.keys(@board)
    taken = []
    all = [0..8]
    available = []
    for x in taken_keys
      taken.push Number(x)
    
    for x in all
      if x not in taken
        available.push x

    available

  getAvailableBoards: -> 
    console.log "NEW BOARDS"
    newboards = []
    for x in @getAvailableMoves()
      newboard = new TicTacToe.Models.Board
      newboard.board = _.clone(@board)
      newboard.board[x] = @getNextAppropriateMark()
      newboards.push newboard
    console.log newboards
    return newboards

  # Determines whether to place 'o' or 'x'
  getNextAppropriateMark: ->
    keys = Object.keys(@board)
    x_c = 0
    o_c = 0
    for x in keys by 1
      if @board[x] == "o"
        o_c++
      if @board[x] == "x"
        x_c++
    if x_c == o_c 
      return 'x'
    if x_c > o_c
      return 'o'

class TicTacToe.Views.Game extends Backbone.View
  
  el: '#entire_board'

  initialize: ->
    # console.log "initializing board"

    @board = new TicTacToe.Models.Board
    @opponent = new TicTacToe.Models.Opponent

  events: {
    'click' : 'squareClicked'
  }

  squareClicked: (square)->
    # console.log "square clicked"
    # console.log square.target.id
    
    # TODO: check if valid move, if so update board, otherwise ERROR
    # result = @boardState.updateBoard(square.target.id)
    @board.updateBoard(square.target.id)
    $(square.target).text("x")
    @board.hasWinner()
    @board.getAvailableMoves()
    #AI moves
    newboard = @opponent.nextBestMove(@board)
    oldkeys = Object.keys(@board.board)
    newkeys = Object.keys(newboard.board)
    
    for x in newkeys
      if x not in oldkeys
        newkey = x
    @board.updateBoard_o(Number(newkey))

    console.log "newkey: " + newkey
    console.log "oldkey: " + oldkeys
    console.log "newkeys: " + newkeys

    $("##{newkey}").text("o")
    #console.log "board: " + board
    console.log "@board: " + @board



