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
			@sequence = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
			selectedboxes = []
			openedboxes= [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
			chosenbox = 0
			selectedbox = 0
			turn = 0
			winner = 0
			played = 0
			wins = 0
			losses = 0
			guess = ""
			@values = [0.01,0.10,0.50,1.00,5.00,10.00,50.00,100.00,250.00,500.00,750.00,1000.00,3000.00,5000.00,10000.00,15000.00,20000.00,35000.00,50000.00,75000.00,100000.00,250000.00]
			amounts = values
		end
		
		def assignvaluestoboxes
			@sequence = @values
			@sequence.shuffle			
		end
		
		def showboxes
		
		end
		
		def showamounts
		end
		
		def removeamount
		end
		
		def setchosenbox
		end
		
		def getchosenbox
			return @chosenbox
		end
		
		def diplaychosenbox
			
		end
		
		def displaychosenboxerror
			
		end
		
		def displayanalysis
			
		end
		
		def boxvalid
			
		end
		
		def showboxesselected
		
		end
	
		def displayselectedboxprompt
			
		end
		
		def openbox
			
		end
		
		def bankerphoneswithvalue
			
		end
		
		def bankercalcsvalue
			
		end
		
		def numberofboxesclosed
		
		end
	
		def incrementturn
			@turn += 1
		end
		
		def getturnsleft
			return @turnsleft
		end
		
		def finish
			
		end
	
		# Any code/methods aimed at passing the RSpect tests should be added above.

	end
end


