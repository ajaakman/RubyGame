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
		
		def displayStartMenu
			@output.puts "Menu: (1) Play | (2) LeaderBoards | (9) Exit"
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
			@amounts = @values
		end
		
		def assignvaluestoboxes
			# not sure if this is correct.
			@sequence = @values
			@sequence.shuffle			
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
			@amounts.length.times do | i |
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
		
		def bankercalcsvalue value			
			# Loop through and add all values of unopened boxes. Divide by number of closed boxes using the numberofboxesclosed function and set var offer to that value.			
			return value/2
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
	
		# Any code/methods aimed at passing the RSpect tests should be added above.

	end
end


