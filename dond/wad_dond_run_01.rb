# Ruby code file - All your code should be located between the comments provided.

# Add any additional gems and global variables here
require 'sinatra'		

# The file where you are to write code to pass the tests must be present in the same folder.
# See http://rspec.codeschool.com/levels/1 for help about RSpec
require "#{File.dirname(__FILE__)}/wad_dond_gen_01"

# Main program
module DOND_Game
	@input = STDIN
	@output = STDOUT
	g = Game.new(@input, @output)
	playing = true
	input = ""
	menu = ""
	guess = ""
	box = 0
	turn = 0
	win = 0
	deal = 0
	@output.puts "\n" + '-------------------------------------------------------------------------' + "\n"
	@output.puts "\n" + 'Enter "1" runs game in command-line window or "2" runs it in web browser.' + "\n"
	@output.puts "\n" + '-------------------------------------------------------------------------' + "\n"
	game = @input.gets.chomp
	if game == "1"
		@output.puts "\nCommand line game.\n"
	elsif game == "2"
		@output.puts "\nWeb-based game.\n"
	else
		@output.puts "\nInvalid input! No game selected.\n"
		exit
	end
		
	if game == "1"
		
		# Any code added to command line game should be added below.

		g.start				# calls start method
		
		# Outer Loop Starts. 
			
			g.resetgame				# calls resetgame method
			@output.puts "\n"			# outputs newline to terminal command line window
		
			# Show StartMenu()
			
			case @input
			when "New Game"
				#break case.
			when "Exit Game"
				#break outer Loop.
			when "Leaderboards"
				# Print Leaderboards. Show StartMenu()
			else
				@output.puts "Invalid Input"
				# Show StartMenu()
			end			
		
			# Present boxes. Have Player select their box.
			
			# Inner Loop Starts.
				
				# Show Menu()
				
				case @input					
				when "New"
					# Break inner loop.
				when "Analysis"
					# Diplay Boxes.
					# Show Menu()
				when "Exit"
					# Display Table
					# Tell player to choose box
					case @input
					when #valid box number
						# remove box from array
						# break
					else
						@output.puts "Invalid Input"
						# Display Table
						# Tell player to choose box
					end
				else
					@output.puts "Invalid Input"
					# Show Menu()
				end				
				
				if # more than 2 boxes remainign				
					# Display offer.
					# Ask player to take offer or continue playing.
					case @input
					when "Accept"
						# Run finish game logic. Set offer to win amount and show amount in players box.
						# break
					when "Deny"
						# break
					else
						@output.puts "Invalid Input"
						# Display offer.
						# Ask player to take offer or continue playing.
					end					
				else				
					# Run finish game logic. Open players box and set that to amount won.
				end
				
			#Inner Loop  ends
			
			# Diplay End Game Message. How much the player won.
		
		# Outer Loop Ends.
		g.finish				# calls finish method
						
	# Any code added to command line game should be added above.
	
		exit	# Does not allow command-line game to run code below relating to web-based version
	end
end
# End modules

# Sinatra routes

	# Any code added to web-based game should be added below.



	# Any code added to web-based game should be added above.

# End program