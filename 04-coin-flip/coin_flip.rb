module CoinFlip
  class Round
    attr_accessor :game, :l_toss, :m_toss, :n_toss, :winner

    def initialize(game)
      @game = game
      @winner = nil
    end

    def play
      toss_all
      @winner = get_odd_toss
    end

    private

    def toss_all
      @l_toss = toss
      @m_toss = toss
      @n_toss = toss
    end

    def get_odd_toss
      if l_toss == m_toss && l_toss == n_toss
        return nil
      elsif l_toss == m_toss
        return 'n'
      elsif l_toss == n_toss
        return 'm'
      elsif m_toss == n_toss
        return 'l'
      else
        raise 'Invalid state'
      end
    end

    def toss
      return Random.rand > @game.p ? :h : :t
    end
  end

  class Game
    attr_accessor :rounds_played, :p

    def initialize(opts={:p => 0.5, :l => 1, :m => 2, :n => 3})
      @p = opts[:p]
      @l = opts[:l]
      @m = opts[:m]
      @n = opts[:n]
      @rounds_played = 0
    end

    def play_round
      round = CoinFlip::Round.new(self)
      round.play
      if round.winner == 'l'
        @l += 2
        @m -= 1
        @n -= 1
      elsif round.winner == 'm'
        @l -= 1
        @m += 2
        @n -= 1
      elsif round.winner == 'n'
        @l -= 1
        @m -= 1
        @n += 2
      else
        nil
      end
    end

    def play_until_someone_is_ruined
      until @l == 0 || @m == 0 || @n == 0 do
        play_round
        @rounds_played += 1
      end
    end
  end
end

runs = 100000
total_rounds = 0

runs.times do |run|
  game = CoinFlip::Game.new(:p => 0.5, :l => 1, :m => 2, :n => 3)
  game.play_until_someone_is_ruined
  total_rounds += game.rounds_played
end

avg = total_rounds.to_f / runs.to_f
puts
puts "Average rounds until one player is ruined: #{avg}"
puts
