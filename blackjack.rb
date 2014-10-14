# simple console game of blackjack in Ruby

# player data
player = {name:'Player', score: 0, hand:[]}
# dealer data
dealer = {name:'Dealer', score: 0, hand:[]}
# number of decks of cards. defaults to 1
num_decks = 1
# holds all of the decks in this game
game_deck = []

# gets and sets the player's name
# defaults to 'Player'
def set_player_name(player)
	puts "Greetings Player. What's your name?"
	name = gets.chomp
	if(name.empty?)
		player[:name] = 'Player'
	else
		player[:name] = name
	end
end

# gets and sets the number of decks of cards to
# use in this game. defaults to 1
def set_num_decks(num_decks)
	num_decks = nil
	done = false
	begin
		puts "How many decks would you like to use for this game? Hit [Enter] to use 1 deck."
		num_decks = gets.chomp
		if(num_decks.empty?)
			num_decks = 1
			done = true
		elsif (num_decks.to_i.to_s == num_decks && num_decks.to_i >= 1)
				num_decks = num_decks.to_i
				done = true
		else
			puts "Invalid input. Please try again."
		end
	end while !done
end

# basic deck of cards
cards = [ 
	{face:'AS', val: 0}, {face:'2S', val:2}, {face:'3S', val:3}, 
	{face:'4S', val: 4}, {face:'5S', val:5}, {face:'6S', val:6},
	{face:'7S', val: 7}, {face:'8S', val:8}, {face:'9S', val:9},
	{face:'10S', val: 10}, {face:'JS', val:10}, {face:'QS', val:10},
	{face:'KS', val:10},
	{face:'AH', val: 0}, {face:'2H', val:2}, {face:'3H', val:3}, 
	{face:'4H', val: 4}, {face:'5H', val:5}, {face:'6H', val:6},
	{face:'7H', val: 7}, {face:'8H', val:8}, {face:'9H', val:9},
	{face:'10H', val: 10}, {face:'JH', val:10}, {face:'QH', val:10},
	{face:'KH', val:10},
	{face:'AD', val: 0}, {face:'2D', val:2}, {face:'3D', val:3}, 
	{face:'4D', val: 4}, {face:'5D', val:5}, {face:'6D', val:6},
	{face:'7D', val: 7}, {face:'8D', val:8}, {face:'9D', val:9},
	{face:'10D', val: 10}, {face:'JD', val:10}, {face:'QD', val:10},
	{face:'KD', val:10},
	{face:'AC', val: 0}, {face:'2C', val:2}, {face:'3C', val:3}, 
	{face:'4C', val: 4}, {face:'5C', val:5}, {face:'6C', val:6},
	{face:'7C', val: 7}, {face:'8C', val:8}, {face:'9C', val:9},
	{face:'10C', val: 10}, {face:'JC', val:10}, {face:'QC', val:10}, 
	{face:'KC', val:10}
]

# simple shuffle algorithm. Loop through all cards and exchange
# it with a card at a random location in the deck
# uses Fisher-Yates algorithm http://en.wikipedia.org/wiki/Fisher%E2%80%93Yates_shuffle
def shuffle(c)
	c.each_with_index do |card, index|
		rnd_card_pos = rand(c.size)
		temp_card = c[rnd_card_pos]
		c[rnd_card_pos] = card
		c[index] = temp_card
	end
end

# creates the game deck by combining the appropriate number
# of decks together
def set_game_deck(game_deck, num_decks, cards)
	num_decks.times { game_deck.concat(cards) }
	game_deck.flatten
end

# deals initial hand of cards, player first
def init_deal_cards(game_deck, player, dealer, num_decks, cards)
	deal_card(game_deck, player, num_decks, cards)
	deal_card(game_deck, dealer, num_decks, cards)
	deal_card(game_deck, player, num_decks, cards)
	deal_card(game_deck, dealer, num_decks, cards)
end

# deals a card and updates score. if the deck runs out then
# it automatically recreates and reshuffles the entire game deck 
def deal_card(game_deck, deal_to, num_decks, cards)
  if(game_deck.empty?)
    set_game_deck(game_deck, num_decks, cards)
    shuffle(game_deck)
  end

	card = game_deck.pop
	deal_to[:hand].push(card)
	update_player_score(deal_to)
end

# updates the player score. automatically accounts for aces
def update_player_score(dealt_to)
	num_aces = 0
	sum =0
	dealt_to[:hand].each do |card| 
		sum += card[:val]
		if card[:val] == 0
			num_aces += 1 
		end
	end

	if(num_aces == 0)
		dealt_to[:score] = sum
	else
		for i in 1..num_aces #only ever 1 ace = 11
		   if(i == num_aces && sum <= 10)
		   		sum += 11
		   	else
		   		sum += 1
			end
		end
		dealt_to[:score] = sum
	end
end

# displays the player and dealer hands
def display_hands(player, dealer)
	system 'cls'
	puts "\nCurrent hands"
	puts "-----------------------------------"
	print "Dealer (#{dealer[:score]}):".rjust(20)
	dealer[:hand].each { |card| print " [#{card[:face]}]"}
	puts""
  pname = player[:name] + " (#{player[:score]}):"
	print pname.rjust(20)
	player[:hand].each { |card| print " [#{card[:face]}]"}
	puts"\n\n"	
end

# resets the various game variables for a new round
def reset_game(game_deck, player, dealer)
  system 'cls'
  game_deck = []
  player[:score] = 0
  player[:hand] = []
  dealer[:score] = 0
  dealer[:hand] = []
end

# setup the game
set_player_name(player)
set_num_decks(num_decks)
set_game_deck(game_deck, num_decks, cards)
shuffle(game_deck)

#main game loop
begin

  init_deal_cards(game_deck, player, dealer, num_decks, cards)

  display_hands(player, dealer)

  update_player_score(player)

  #if someone or both gets blackjack then skip everything else
  got_blackjack_or_tie = false 
  if(player[:score] == 21 && dealer[:score] == 21)
    puts "TIE!"
    got_blackjack_or_tie = true
  elsif(player[:score] == 21)
    puts "BLACKJACK! " + player[:name] + " wins!"
    got_blackjack_or_tie = true
  elsif(dealer[:score] == 21)
    puts "BLACKJACK! Dealer wins!"
    got_blackjack_or_tie = true
  else
    #player goes first
    player_stay = false
    player_bust = false
    begin
      print "You may hit [h] or stay [s] "
      input = gets.chomp
      if(input =~ /^[Ss]$/)
        player_stay = true
      elsif(input =~ /^[Hh]$/)
        deal_card(game_deck, player, num_decks, cards)
        display_hands(player, dealer)
      else
        puts "Invalid entry. Please try again."
      end
      if(player[:score] > 21)
        player_bust = true
        puts player[:name] + " busted! Dealer wins!"
      end
    end until player_stay or player_bust
    
    #dealer's turn
    dealer_stay = false
    dealer_bust = false
    if(!player_bust) #if player busted then don't bother
      begin
        sleep(0.5) #slow things down a tad
        if(dealer[:score] > 16 && dealer[:score] >= player[:score])
          dealer_stay = true
        else
          deal_card(game_deck, dealer,num_decks, cards)
          display_hands(player, dealer)
        end
        if(dealer[:score] > 21)
          dealer_bust = true
          puts "Dealer busted! " + player[:name] + " wins!"
        end
      end until dealer_stay or dealer_bust
    end
  end

  #if no one has won or lost yet then figure out who won
  if(!player_bust && !dealer_bust && !got_blackjack_or_tie)
    if(dealer[:score] == player[:score])
      puts "It's a draw!"
    elsif(dealer[:score] >= player[:score])
      puts "Dealer wins!"
    else
      puts player[:name] + " wins!"
    end
  end
  
  quit = true
  begin
    print "Play again [y/n]? "
    input = gets.chomp
      if(input =~ /^[Yy]$/)
        quit =false
        reset_game(game_deck, player, dealer)
      end
  end until input =~ /^[Yy]$/ || input =~ /^[Nn]$/
  
end until quit == true