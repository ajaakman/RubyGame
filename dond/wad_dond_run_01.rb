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
		
		catch :restart do # Used to restart the game.		
		g.clearScreen
		g.start	# Calls start method.
		
		begin # Outer game loop start.
								
			g.outergameloop # Restarts game, shows start menu, asks player to choose their box.
								
			begin # Inner game loop starts.
				
				g.innergameloop	# This is responsible for allowing the player to open boxes and enter the menu.					
				
				if g.selectedboxes.length.to_i < 21	# This is responsible for giving the player an offer if there is more than 2 box left.			
					g.answerbanker
				else				
					g.lastbox # If one box is left finish the game.											
				end
				
			end while true # Inner game loop ends.			
		end # End of :restart loop.		
		end while true # Outer game loop end.
		
		g.finish
				
	# Any code added to command line game should be added above.
	
		exit	# Does not allow command-line game to run code below relating to web-based version
	end
end
# End modules

# Sinatra routes

	# Any code added to web-based game should be added below.



	# Any code added to web-based game should be added above.

# End program