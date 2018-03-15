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
		
		g.start	# Calls start method
		
		begin # Outer game loop start
			
			g.resetgame				# calls resetgame method
			g.displayStartMenu
			g.assignvaluestoboxes
				
			@output.puts "Starting Game... \n"
						
			begin
				g.showboxes
				@output.puts "\n"
				g.displaychosenboxprompt				
				userInput = @input.gets.chomp
				
				case g.boxvalid userInput
					when 0
					g.setchosenbox userInput.to_i
					g.selectedboxes.push userInput.to_i 
					break
					else
					g.clearScreen
					g.displaychosenboxerror
				end
			end while true
			
			g.clearScreen
			g.displaychosenbox
			@output.puts "Press Enter to Continue."
			@input.gets.chomp			
			g.clearScreen
								
			begin # Inner game loop starts.
				begin
					g.showamounts
					#g.showboxes
					@output.puts "\n"
					@output.puts "Debugging array: #{g.selectedboxes.length}" 
					g.displayselectboxprompt
					userInput = @input.gets
					case userInput
						when "\n"							
							g.clearScreen
							begin
							@output.puts "\n" + '-------------------------------------------------------------------------' + "\n"
							g.displaymenu
							@output.puts '-------------------------------------------------------------------------' + "\n"
							case @input.gets.chomp
								when "1" # Play
									g.clearScreen
									break
								when "2" # New
									g.clearScreen
									# Needs to break out of inner loop
								when "3" # Analysis
									g.clearScreen
									g.showboxes
									#@output.puts "Invalid Input"
								when "9" # Exit
									g.clearScreen
									g.finish
									exit
								else
									g.clearScreen
									@output.puts "Invalid Input"					
								end
							end while true							
							@output.puts "\n"						
						else						
							case g.boxvalid userInput
								when 0
									if g.selectedboxes.include?(userInput.to_i)
										g.clearScreen
										@output.puts "Box already selected. Try Again"
									else
										g.clearScreen
										g.selectedboxes.push userInput.to_i
										@output.puts "Box Successfully Selected."
										# logic to select box.
										break
									end
								else
									g.clearScreen
									@output.puts "Not a valid box number. Press enter to show menu or select valid box number"
							end					
					end
				end while true
				
					
		#		
		#		if # more than 2 boxes remainign				
		#			# Display Table.
		#			# Display Offer.
		#			# Ask player to take offer or continue playing.
		#			case @input
		#			when "Accept"
		#				# Run finish game logic. Set offer to win amount and show amount in players box.
		#				# break
		#			when "Deny"
		#				# break
		#			else
		#				@output.puts "Invalid Input"
		#				# Display Table.
		#				# Display Offer.
		#				# Ask player to take offer or continue playing.
		#			end					
		#		else				
		#			# Run finish game logic. Open players box and set that to amount won.
		#		end
				
			end while true # Inner game loop ends.
		#	
		#	# Diplay End Game Message. How much the player won.
		#
		@output.puts "Ending Game... \n"
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