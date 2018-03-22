# Ruby code file - All your code should be located between the comments provided.

# Main class module
module DOND_Game
	# Input and output constants processed by subprocesses. MUST NOT change.
	GOES = 5

	class Game
		attr_reader :sequence, :selectedboxes, :openedboxes, :chosenbox, :selectedbox, :turn, :input, :output, :winner, :played, :wins, :losses, :guess, :values, :amounts
		attr_writer :sequence, :selectedboxes, :openedboxes, :chosenbox, :selectedbox, :turn, :input, :output, :winner, :played, :wins, :losses, :guess, :values, :amounts

		def initialize(input, output)
			@input = input
			@output = output
		end
		
		def getinput
			@input.gets.chomp.upcase
		end
		
		def storeguess(guess)
			if guess != ""
				@selectedboxes = @selectedboxes.to_a.push "#{guess}"
			end
		end
		
		# Any code/methods aimed at passing the RSpect tests should be added below.
			
		def start
			@output.puts "Welcome to Deal or No Deal!"
			@output.puts "Designed by: #{created_by}"
			@output.puts "StudentID: #{student_id}"
			@output.puts "Starting game..."
		end
		
		def created_by
			return "Artur Jaakman and Md Nazmus Sakib"
		end
		
		def student_id
			return "51773211 and 51773617"
		end
		
		def displaymenu
			@output.puts "Menu: (1) Play | (2) New | (3) Analysis | (9) Exit"			
		end
		def resetgame
			@output.puts "New game..."
			@sequence = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
			@selectedboxes = []
			@openedboxes= [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
			@chosenbox = 0
			@selectedbox = 0
			@turn = 0
			@winner = 0
			@played = 0
			@wins = 0
			@losses = 0
			@guess = ""
			@values = [0.01,0.10,0.50,1.00,5.00,10.00,50.00,100.00,250.00,500.00,750.00,1000.00,3000.00,5000.00,10000.00,15000.00,20000.00,35000.00,50000.00,75000.00,100000.00,250000.00]
			@amounts = @values.dup
		end
		
		def assignvaluestoboxes			
			@sequence = @values.dup
			@sequence.shuffle!			
		end
		
		def showboxes
			# run a loop that loops through the @openedboxes array and prints Closed for 0 and Opened for 1.
			# need to print box like this "Box #{b}: [#{b}] Status: #{@game.openedboxes[i]}"
			@openedboxes.length.times do | i |				
				if i == @chosenbox-1 and @chosenbox != 0
					box = "*#{i+1}*"
				else
					if @openedboxes[i] == 0					
						box = "[#{i+1}]"
					else  @openedboxes[i] 					
						box = "|#{i+1}|"				
					end
				end
				@output.print "#{box} "
			end		
		end
		
		def showamounts
			# Loop through @amounts array and print them in two colums.
			#@output.puts "#{c1}   #{c2}"
			(@amounts.length/2).times do | i |
				@output.puts "#{@amounts[i]}   #{@amounts[i+11]}"
			end			
		end
		
		def removeamount value
			# when this is called take the argument (value) find it in the @amounts array and replace it with "    "
			@amounts.length.times do | i |
				if @amounts[i] == value
					@amounts[i] = "    "
				end
			end
		end
		
		def setchosenbox box
			@chosenbox = box
		end
		
		def getchosenbox
			return @chosenbox
		end
		
		def displaychosenbox
			@output.puts "Chosen box: [#{@chosenbox}]"
		end
		
		def displaychosenboxvalue
			# take the @chosenbox variable diplay its number. Then use that number to find the corresponding value from the @sequence array?
			box = @chosenbox
			value = @sequence[box-1]
			@output.puts "Chosen box: [#{box}] contains: #{value}"
		end
		
		def displaychosenboxprompt			
			@output.puts "Enter the number of the box you wish to keep."			
		end
				
		def displaychosenboxerror
			@output.puts "Error: Box number must be 1 to 22."
		end
		
		def displayanalysis
			# loop through @ opened boxes array and print index number and "Closed if value is 0 and Open if value is 1. "#{g} Status: #{s}"
			@output.puts "Game analysis..."
			
			@openedboxes.length.times do | i |				
				if @openedboxes[i] == 0
					status = "Closed"
					box = "[#{i+1}]"
				else if @openedboxes[i] == 1
					status = "Opened"
					box = "|#{i+1}|"
					end
				end
				@output.puts "#{box} Status: #{status}"				
			end
		end
		
		def boxvalid guess
			if guess.to_i > 0 and guess.to_i <= 22
				return 0
			else
				return 1
			end			
		end
		
		def showselectedboxes
			# print @selectedboxes array. test has some function naming mistakes.
			@output.puts "Log: #{@selectedboxes.inspect}"			
		end
	
		def displayselectboxprompt
			@output.puts "Enter the number of the box you wish to open. Enter returns to menu."
		end
		
		def openbox guess			
			# based on the function argument find box in @openedboxes array and set it to 1.
			# box = box number based on guess
			# status = "Open" if 1 "Closed" if 0
			@openedboxes[guess.to_i - 1] = 1			
			@output.puts ("#{@openedboxes[guess.to_i - 1]} Status: Opened")			
		end
		
		def bankerphoneswithvalue offer			
			@output.puts "Banker offers you for your chosen box: #{offer}"
		end
		
		def bankercalcsvalue turn			
			# Loop through and add all values of unopened boxes. Divide by number of closed boxes using the numberofboxesclosed function and set var offer to that value.			
			total = 0.0
			count = 0
			if @amounts == nil
			  @amounts = [0]
			end
			@amounts.length.times do | i |
				if @amounts[i] != "    "
					total += @amounts[i].to_f
					count += 1
				end
			end			
			return ((total/count.to_f)*((22-count.to_f)/22)).round(2)
		end
		
		def numberofboxesclosed
			#loop through opened @openedboxes array. return number of 0 values array
			count = 0
			@openedboxes.length.times do | i |
				if openedboxes[i] == 0
				count += 1							
				end
			end			
			return count
		end
	
		def incrementturn
			@turn += 1			
		end
		
		def getturnsleft
			return GOES - @turn
		end
		
		def finish
			@output.puts "... game finished."
		end
		
		#-------------Additional game logic methods that were not tested.------------------------------------------
		
		def menu
			clearScreen
			begin
				@output.puts "\n" + '-------------------------------------------------------------------------' + "\n"
				displaymenu
				@output.puts '-------------------------------------------------------------------------' + "\n"
				case @input.gets.chomp
					when "1" # Play
						clearScreen
						@output.puts "Continuing Game."
						break
					when "2" # New
						clearScreen
						@output.puts "Restarting Game. Press Enter to Continue."
						@input.gets.chomp
						throw :restart
					when "3" # Analysis
						clearScreen
						@output.puts "Remaining boxes. Enter 1 to continue playing."
						showboxes									
					when "9" # Exit
						clearScreen
						finish
						exit
					else
						clearScreen
						@output.puts "Invalid Input"					
				end
			end while true
			@output.puts "\n"
		end
		
		def clearScreen # Ross, S (2016) How to clear terminal in Ruby [stackoverflow post]. https://stackoverflow.com/questions/3170553/how-can-i-clear-the-terminal-in-ruby
			if RUBY_PLATFORM =~ /win32|win64|\.NET|windows|cygwin|mingw32/i
				system('cls')
			else
				system('clear')
			end
		end
		
		def displayStartMenu
			begin
				@output.puts "\n" + '-------------------------------------------------------------------------' + "\n"
				@output.puts "Menu: (1) Play | (2) Instructions | (9) Exit"
				@output.puts '-------------------------------------------------------------------------' + "\n"
				case @input.gets.chomp
					when "1"
						clearScreen
						break
					when "2" # Instructions
						clearScreen					
						@output.puts "When you start a new game you will be asked to select your box."
						@output.puts "After this you will be asked to continue opening boxes until you've opened all of them."
						@output.puts "The banker will give you an offer every time you open a box."
						@output.puts "You can accept the offer by entering y or deny it by entering n."
						@output.puts "If you don't accept the bankers offer and only 1 box is left, you automatically open your box."
						@output.puts "Follow the on screen instructions and press enter to open the menu."
						@output.puts "Enjoy."
					when "9" # Exit
						clearScreen
						finish
						exit
					else
						clearScreen
						@output.puts "Invalid Input"					
				end
			end while true
		end
		
		def answerbanker
			begin
				showamounts
				bankerphoneswithvalue bankercalcsvalue @turn
				@output.puts "Do you accept the bankers offer? Input y or n."							
				case @input.gets.chomp
					when "y" 									
						clearScreen
						@output.puts "CONGRATULATIONS! YOU WON #{bankerphoneswithvalue bankercalcsvalue @turn}!"
						@output.puts "You could have won #{sequence[chosenbox-1]}"
						@output.puts "Press Enter to try again."
						@input.gets.chomp
						throw :restart
					when "n"
						clearScreen
						break
					else
						clearScreen
						@output.puts "Invalid Input"					
				end
			end while true
		end
		
		def lastbox
			clearScreen
			showamounts
			@output.puts "Last Box. Press Enter to open your box."
			@input.gets.chomp
			clearScreen						
			@output.puts "CONGRATULATIONS! YOU WON #{sequence[chosenbox-1]}"
			@output.puts "Press Enter to try again."
			@input.gets.chomp
			throw :restart
		end
		
		def innergameloop
			begin
				showamounts				
				@output.puts "\n"					 
				displayselectboxprompt
				userInput = @input.gets
				case userInput
				when "\n"					
					menu												
				else						
					case boxvalid userInput
						when 0
							if selectedboxes.include?(userInput.to_i)
								clearScreen
								@output.puts "Box already selected. Try Again"
							else
								openbox userInput.to_i
								clearScreen
								selectedboxes.push userInput.to_i
								showselectedbox userInput.to_i
								removeamount selectedbox										
								break
							end
						else
							clearScreen
							@output.puts "Not a valid box number. Press enter to show menu or select valid box number"
					end					
				end
			end while true
		end
		
		def outergameloop			
			resetgame				
			displayStartMenu
			assignvaluestoboxes						
			begin
				showboxes
				@output.puts "\n"
				displaychosenboxprompt				
				userInput = @input.gets.chomp
				
				case boxvalid userInput
					when 0
					setchosenbox userInput.to_i
					selectedboxes.push userInput.to_i 
					break
					else
					clearScreen
					displaychosenboxerror
				end
			end while true			
			clearScreen
			displaychosenbox
			@output.puts "Press Enter to Continue."
			@input.gets.chomp			
			clearScreen			
		end
				
		def showselectedbox guess
			@selectedbox = @sequence[guess-1]
			@output.puts "Selected box: |#{guess}| Amount: #{@sequence[guess-1]} \n"
		end
	
		# Any code/methods aimed at passing the RSpect tests should be added above.

	end
end


