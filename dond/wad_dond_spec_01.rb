# Ruby assignment
# Change the following tests with your own name and student ID.
# NB. Failure to do so will result in marks being deducted.
# IMPORTANT: Ensure you save the file after making the changes. 
# DO notchange the names of the files. Just ensure you backup the files often.

# The file where you are to write code to pass the tests must be present in the same folder.
# See http://rspec.codeschool.com/levels/1 for help about RSpec
# https://en.wikipedia.org/wiki/Wheel_of_Fortune_(UK_game_show)
require "#{File.dirname(__FILE__)}/wad_dond_gen_01"

# predefined method - NOT to be removed
def check_valid(secret)
	@game.secret = secret
	sarray = []
	i = 0
	secret.split('').each do|c| 
		sarray[i] = c
		i=i+1
	end
end

module DOND_Game
	# RSpec Tests 
	describe Game do
		describe "Deal or no deal game" do
			before(:each) do
				@input = double('input').as_null_object
				@output = double('output').as_null_object
				@game = Game.new(@input, @output)
			end
			it "should create a method called start" do
				@game.start
			end
			it "should display a welcome message when method start called" do
				@output.should_receive(:puts).with('Welcome to Deal or No Deal!')
				@game.start
			end
			it "should contain a method created_by which returns the students name" do
				studentname = "Artur Jaakman and Nazmus Sakib"			# -----Change text to your own name-----
				@game.created_by.should == studentname		
			end
			it "should display a message showing who designed the game when the method start called" do
				@output.should_receive(:puts).with("Designed by: #{@game.created_by}")	
				@game.start
			end
			it "should contain a method student_id which returns the students ID number" do
				studentid = "51773211 and 51773617"				# -----Change text to your own student ID-----
				@game.student_id.should == studentid
			end
			it "should display a message showing the id of the student when the method start called" do
				@output.should_receive(:puts).with("StudentID: #{@game.student_id}")	
				@game.start				
			end
			it "should display a starting message when the method start called" do
				@output.should_receive(:puts).with('Starting game...')
				@game.start			
			end
			it "should display menu when method displaymenu called" do
				@output.should_receive(:puts).with("Menu: (1) Play | (2) New | (3) Analysis | (9) Exit")
				@game.displaymenu
			end
			it "should create a method called resetgame" do
				@game.resetgame
			end
			it "should display new game message when method resetgame called" do
				@output.should_receive(:puts).with("New game...")
				@game.resetgame
			end
			it "should set object variables to correct value when resetgame method called" do
				@game.resetgame
				@game.sequence.should == [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
				@game.selectedboxes.should == []
				@game.openedboxes.should == [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
				@game.chosenbox.should == 0
				@game.selectedbox.should == 0
				@game.turn.should == 0
				@game.winner.should == 0
				@game.played.should == 0
				@game.wins.should == 0
				@game.losses.should == 0
				@game.guess.should == ""
				@game.values.should == [0.01,0.10,0.50,1.00,5.00,10.00,50.00,100.00,250.00,500.00,750.00,1000.00,3000.00,5000.00,10000.00,15000.00,20000.00,35000.00,50000.00,75000.00,100000.00,250000.00]
				@game.amounts.should == @game.values
			end
			it "should create a method called assignvaluestoboxes" do
				@game.resetgame
				@game.assignvaluestoboxes
			end
			it "should provide 22 boxes (represented by the @sequence[] array) containing amounts between 0.01 and 250000.00 when method assignvaluestoboxes called" do
				@game.resetgame
				@game.assignvaluestoboxes
				sequencelen = @game.sequence.length
				sequencelen.should == 22
				for i in (0..21) do
					item = @game.sequence[i]
					item.should > 0 and item.should <= 250000.00
				end
			end
			it "should place each predefined amount (contained in the @values[] array) ramdomly into one empty box (represented by the @sequence[] array) when method assignvaluestoboxes called" do
				@game.resetgame
				@game.assignvaluestoboxes
				for v in (0..21) do	# for each value
					f = 0			# reset frequency
					for b in (0..21) do	# for each box check value in box
						if @game.sequence[b] == @game.values[v]	# if box is same as value
							f = f + 1	# increase frequency
						end
					end
					f.should == 1	# frequency should only be 1 for each box
				end
			end
			it "should create a method showboxes" do
				@game.resetgame
				@game.assignvaluestoboxes
				@game.showboxes
			end
			it "should list each box and its status (|Opened|/[Closed]) when showboxes method called" do
				@game.resetgame
				@game.assignvaluestoboxes
				for i in (0..21) do
					s = "_"
					g = "_"
					b = i + 1
#					@output.should_receive(:puts).with("Box #{b}: [#{b}] Status: #{@game.openedboxes[i]}")
					if @game.openedboxes[i] == 0
						s = "Closed"
						g = "[#{b}]"
					else
						s = "Opened"
						g = "|#{b}|"
					end
					@output.should_receive(:print).with("#{g} ")					
				end
				@game.showboxes
			end
			it "should create a method showamounts" do
				@game.resetgame
				@game.assignvaluestoboxes
				@game.showamounts
			end
			it "should show amounts in asending order as two columns when method showamounts called" do
				@game.resetgame
				@game.assignvaluestoboxes
				col1 = 0
				col2 = 11
				for i in (0..10)
					c1 = @game.amounts[col1 + i]
					c2 = @game.amounts[col2 + i]
					@output.should_receive(:puts).with("#{c1}   #{c2}")
				end
				@game.showamounts
			end
			it "should create a method removeamount that accepts parameter value" do
				@game.resetgame
				@game.assignvaluestoboxes
				r = rand(0..21)
				value = @game.values[r]
				@game.removeamount(value)
				@game.amounts[r].should == "    "
			end

			it "should create a method called setchosenbox that receives and stores a box number (contained in @chosenbox)" do
				@game.resetgame
				b = rand(1..22)
				@game.setchosenbox(b)
				box = @game.chosenbox
				box.should > 0 and box.should <= 22
			end
			it "should create a method called getchosenbox that returns the box number (contained in @chosenbox)" do
				@game.resetgame
				b = rand(1..22)
				@game.setchosenbox(b)
				box = @game.getchosenbox
				box.should == b
			end
			it "should display a message representing the chosen box when method displaychosenbox called" do
				@game.resetgame
				b = rand(1..22)
				@game.setchosenbox(b)
				box = @game.getchosenbox
				@output.should_receive(:puts).with("Chosen box: [#{box}]")	
				@game.displaychosenbox
			end
			it "should display a message containing the value stored in a chosen box when method displaychosenboxvalue called" do
				@game.resetgame
				@game.assignvaluestoboxes
				b = rand(1..22)
				@game.setchosenbox(b)
				box = @game.getchosenbox
				value = @game.sequence[box-1]
				@output.should_receive(:puts).with("Chosen box: [#{box}] contains: #{value}")	
				@game.displaychosenboxvalue
			end
			it "should display a prompt requesting the user choose a box to keep until the end when method displaychosenboxprompt called" do
				@output.should_receive(:puts).with("Enter the number of the box you wish to keep.")
				@game.displaychosenboxprompt
			end
			it "should display chosen box error when method displaychosenboxerror called" do
				@output.should_receive(:puts).with("Error: Box number must be 1 to 22.")
				@game.displaychosenboxerror
			end			
#			it "should display an analysis message within method displayanalysis" do
#				@output.should_receive(:puts).with("Game analysis")
#				@game.displayanalysis			
#			end
			it "should display a message and show the status (Opened or Closed) of each box when method displayanalysis called" do
				@output.should_receive(:puts).with("Game analysis...")
				@game.resetgame
				@game.assignvaluestoboxes
				for i in (0..21) do
					s = "_"
					g = "_"
					b = i + 1
					if @game.openedboxes[i] == 0
						s = "Closed"
						g = "[#{b}]"
					else
						s = "Opened"
						g = "|#{b}|"
					end
					@output.should_receive(:puts).with("#{g} Status: #{s}")
#					puts "\ni: #{i} Status: #{@game.openedboxes[i]} s: #{s}"
				end
				@game.displayanalysis
			end
			it "should check that entered box number is between 1..22 when guess received by method boxvalid" do
				@game.resetgame
				@game.assignvaluestoboxes
				for i in (0..22) do
					guess = i
					valid = @game.boxvalid	("#{guess.to_s}")
					if guess > 0 && guess <= 22
						valid.should == 0
					else
						valid.should == 1
					end
				end
				
			end
			it "should display log of boxes selected when method showboxesselected called" do
				@game.resetgame
				@game.assignvaluestoboxes
				@output.should_receive(:puts).with("Log: #{@game.selectedboxes.inspect}")
				@game.showselectedboxes			
			end
			it "should display message requesting user to select box to open when method displayselectboxprompt called" do
				@output.should_receive(:puts).with("Enter the number of the box you wish to open. Enter returns to menu.")
				@game.displayselectboxprompt
			end
			it "should display the status of a box (as Opened) when method openbox receives its associated box number" do
				@game.resetgame
				@game.assignvaluestoboxes
				guess = 1
				@game.openbox(guess)
				for i in (0..21) do
					s = "_"
					g = "_"
					b = i + 1
					if @game.openedboxes[i] == 0
						s = "Closed"
						g = "[#{b}]"
					else
						s = "Opened"
						g = "|#{b}|"
					end
					@output.should_receive(:puts).with("#{g} Status: #{s}")
#					puts "\ni: #{i} Status: #{@game.openedboxes[i]} Status: #{s}"
				end
				@game.displayanalysis
#				@game.showboxes
			end
			it "should display the status of a box (as Opened) when method openbox receives its associated box number" do
				@game.resetgame
				@game.assignvaluestoboxes
				guess = 1
				@game.openbox(guess)
				for i in (0..21) do
					s = "_"
					g = "_"
					b = i + 1
					if @game.openedboxes[i] == 0
						s = "Closed"
						g = "[#{b}]"
					else
						s = "Opened"
						g = "|#{b}|"
					end
					@output.should_receive(:print).with("#{g} ")
#					puts "\ni: #{i} Status: #{@game.openedboxes[i]} Status: #{s}"
				end
#				@game.displayanalysis
				@game.showboxes
			end
			it "should show chosen box when method showboxes called" do
				@game.resetgame
				@game.assignvaluestoboxes
				c = rand(1..22)
				for i in (0..21) do
					b = i + 1
					g = "_"
					@game.setchosenbox(c)
					if @game.chosenbox == c
						g = "*#{c}*"
						@output.should_receive(:print).with("#{g} ")						
					else
						g = "[#{b}]"
						@output.should_receive(:print).with("#{g} ")
					end
					@game.showboxes
				end
			end
			it "should display offer from banker when value received by method bankerphoneswithvalue" do
				offer = rand(0..100000)
				@output.should_receive(:puts).with("Banker offers you for your chosen box: #{offer}")
				@game.bankerphoneswithvalue(offer)
			end
			it "should calculate and return offer from banker when value in box received by method bankercalcsvalue" do
				value = rand(2..100000)
				offer = @game.bankercalcsvalue(value)
				offer.should == value / 2
			end
			it "should return the number of boxes still closed when method numberofboxesclosed called" do
				@game.resetgame
				@game.assignvaluestoboxes
				o = rand(0..21)		# number of boxes to open
				c = 21 - o			# number of boxes to remain closed
				for i in (0..o) do
					@game.openedboxes[i] = 1
				end
				num = @game.numberofboxesclosed
				num.should == c
			end
			it "should create a method incrementturn which increases @turn by 1" do
				@game.resetgame
				@game.incrementturn
				@game.turn.should == 1
				@game.incrementturn
				@game.turn.should == 2
			end
			it "should create a method getturnsleft which returns @turnsleft containing goes left" do
				@game.resetgame
				@game.incrementturn
				turnsleft = @game.getturnsleft
				turnsleft.should == GOES - 1
				@game.incrementturn
				turnsleft = @game.getturnsleft
				turnsleft.should == GOES - 2				
			end
			it "should display an exit message when method finish called" do
				@output.should_receive(:puts).with("... game finished.")
				@game.finish
			end			
		end
	end
end