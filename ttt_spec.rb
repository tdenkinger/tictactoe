class BoardEvaluator
  def self.check_for_winner(board)
    status = check_rows(board)
    status = check_cols(board)      if status[:has_winner] == false
    status = check_diagonals(board) if status[:has_winner] == false

    status[:message]
  end

  def self.check_diagonals(board)
    status = check_top_left_diagonal(board)
    return status if status[:has_winner] == true

    check_bottom_left_diagonal(board)
  end

  def self.check_cols(board)
    check_rows(board.transpose)
  end

  def self.check_rows(board)
    board.each do | row |
      next if row_contains_nil?(row)
      return format_outcome(true, row[0]) if row.uniq.count == 1
    end

    format_outcome(false, "none")
  end

  private

  def self.row_contains_nil?(row)
    row.any?{|cell| cell.nil?}
  end

  def self.format_outcome(has_winner, winner)
    {has_winner: has_winner, message: {winner: winner}}
  end

  def self.check_bottom_left_diagonal(board)
    shifted_board = [board[0].rotate(2), board[1].rotate(1), board[2]]
    check_cols(shifted_board)
  end

  def self.check_top_left_diagonal(board)
    shifted_board = [board[0], board[1].rotate(1), board[2].rotate(2)]
    check_cols(shifted_board)
  end
end



describe BoardEvaluator do
  it "knows an empty board has no winner" do
    board = [[nil, nil, nil], [nil, nil, nil], [nil, nil, nil]]
    status = BoardEvaluator.check_for_winner(board)
    expect(status[:winner]).to eq "none"
  end

  it "knows a board without a winner has no winner" do
    board = [["x", "x", "o"], [nil, "o", nil], [nil, nil, nil]]
    status = BoardEvaluator.check_for_winner(board)
    expect(status[:winner]).to eq "none"
  end

  it "identifies a horizontal winner" do
    board = [["o", "x", "x"], ["o", "o", "o"], [nil, "x", nil]]
    status = BoardEvaluator.check_for_winner(board)
    expect(status[:winner]).to eq "o"
  end

  it "identifies a vertical winner" do
    board = [[nil, "o", "x"],
             [nil, "o", "x"],
             ["x", "o", nil]]

    status = BoardEvaluator.check_for_winner(board)
    expect(status[:winner]).to eq "o"
  end

  it "identifies a top-left diagonal winner" do
    board = [["o", nil, nil],
             [nil, "o", nil],
             [nil, nil, "o"]]

    status = BoardEvaluator.check_for_winner(board)
    expect(status[:winner]).to eq "o"
  end

  it "identifies a bottom-left diagonal winner" do
    board = [[nil, nil, "o"],
             [nil, "o", nil],
             ["o", nil, nil]]

    status = BoardEvaluator.check_for_winner(board)
    expect(status[:winner]).to eq "o"
  end

end
