# Ruby code file - All your code should be located between the comments provided.

# Add any additional gems and global variables here
require 'sinatra'		
require 'sinatra/activerecord'

ActiveRecord::Base.establish_connection(
	:adapter => 'sqlite3',
	:database => 'dond.db'
) 

class User < ActiveRecord::Base
	validates :username, presence: true, exclusion: { in: %w(Guest)}
	validates :password, presence: true
	#validates :isAdmin, presence: true
	validates :gamesPlayed, presence: true
	validates :totalWinnings, presence: true
	validates :gamesWon, presence: true
	validates :lastGameSession, presence: true
end

class Session < ActiveRecord::Base # Storing game sessions here.
end

# The file where you are to write code to pass the tests must be present in the same folder.
# See http://rspec.codeschool.com/levels/1 for help about RSpec
require "#{File.dirname(__FILE__)}/wad_dond_gen_01"

# Main program
module DOND_Game
	@input = STDIN
	@output = STDOUT
	g = Game.new(@input, @output)
	@g=Game.new(@input, @output)
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
		
		# All game logic code written from scrach in collaboraion by Artur Jaakman and Md Nazmus Sakib, except where specified.
		
		catch :restart do # Used to restart the game.		
		g.clearScreen # Tested on Windows. Might not work in all command lines. 
		g.start	# Calls start method.
		
		begin # Outer game loop start.
								
			g.outergameloop # Restarts game, shows start menu, asks player to choose their box.
								
			begin # Inner game loop starts.
				
				g.incrementturn
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
  
# All code based on WAD practicals and written in collaboration by Artur Jaakman and Md Nazmus Sakib.
helpers do # Helpers used to validate user access level, 3 levels of access: visitor, user, admin. 
	
	def restricted! # Only admins.
		if authorizedadmin?
			return
		end
	   redirect '/denied'
	end
	
	def authorizedadmin?
		if $credentials != nil
		 @Userz = User.where(:username => $credentials[0]).to_a.first      
			if @Userz          
				if @Userz.username == "Admin"          
					return true          
				else              
					return false         
				end          
			else          
				return false      
			end       
		end   
	end
	  
	def registered! # Only Logged In users.
		if authorizeduser?
			return
		end
		redirect '/pleaselogin'
	end
	
	def authorizeduser?
		if $credentials != nil
		@Userz = User.where(:username => $credentials[0]).to_a.first      
			if @Userz          
				if @Userz.username != ""          
				   return true          
				else              
				   return false         
				end          
			else          
				return false      
			end       
		end   
	end
end


def logDbChanges(event) # Method called with the event as parameter for Database Log.	
	file = File.open("log.txt")  # Read the log text file and get current content.
	currentText="";
	file.each do |line|	
		currentText= currentText + line			
	end
    
	timeStamp=Time.now.strftime("%d %m %Y at %I:%M%p") # Get current time stamp and format the time as string.
  
	user="Unknow"
  
	if $credentials!=nil       # If the user is not logged in, keep the user as unknow otherwise get the user id.
		user=$credentials[0]    
	end
 
	newText=timeStamp+"\t"+user+"\t"+event    # Concateate existing text and new text to be logged.
	logText=currentText+"\n"+newText
	
	file = File.open("log.txt", "w")  # Write to file.
	file.puts logText
	file.close	
end

post '/reset' do # Admin control for resetting database.	
	restricted!
	
	$credentials = ['','']	
	User.delete_all
	Session.delete_all
	User.create(username: "Admin", password: "admin", isAdmin: true, gamesPlayed: 0, totalWinnings: 0.0, gamesWon: 0, lastGameSession: 0) # Creating an Admin account.
	redirect "/"
	event="Datebase Reset"
	logDbChanges(event)  
end

post '/login' do	
	$credentials = [params[:username],params[:password]]
 
	@Users = User.where(:username => $credentials[0]).to_a.first
 
	if @Users

    if @Users.password == $credentials[1]
		event="User Logged in with user id: "+ params[:username]
		logDbChanges(event);  
		redirect '/'  
    else  
		$credentials = ['','']
		event="Logging attempt failed: "+ params[:username]
		logDbChanges(event);
		redirect '/wrongaccount'
    end
    else
        $credentials = ['','']
        event="Logging attempt failed: "+ params[:username]
        logDbChanges(event);
        redirect '/wrongaccount'
	end
end
  
get '/' do
	@totalGames = Session.count
	erb :home,  :locals => { :totalGames =>  @totalGames}
end   
   
  def showStartButtons # Show start button if player is not logged in. And Start and Resume if they are.
	if $credentials == nil || $credentials == ["",""] # User is not logged in.
	html='<form action= "/newgame" method= "post" id= "new_game">'		
	html+='<input type= "submit" class= "start_button" value= "Start"></input>'
	html+='</form>'
	html+= 'Log in to have the ability to resume last played game.'
	else
		@Users = User.where(:username => $credentials[0]).to_a.first 
		if(@Users.lastGameSession==0) # User doesn't have a saved game
			html='<form action="/newgame" method="post" id="new_game">'
			html+='<input type= "submit" class= "start_button" value= "Start"></input>'
			html+='</form>' 
			html+= 'You have no saved games.'
		else
			html='<form action="/newgame" method="post" id="new_game">'
			html+='<input type= "submit" class= "start_button" value= "Start"></input>'
			html+='</form><br>'
   
			html+='<form action="/resumegame" method="post" id="new_game">'
			html+='<input type= "submit" class= "start_button" value= "Resume"></input>'
			html+='</form>'
		end 		
	end
	return html
  end
  
post '/newgame' do # Crearing a new game session.
	myvalues = "0.01,0.10,0.50,1.00,5.00,10.00,50.00,100.00,250.00,500.00,750.00,1000.00,3000.00,5000.00,10000.00,15000.00,20000.00,35000.00,50000.00,75000.00,100000.00,250000.00"
	mysequence = (myvalues.split(",").shuffle!).join(",")
	
	if $credentials == nil || $credentials == ["",""] # Set player as guest if they are not logged in.
		myuser="Guest"
		Session.create(user: myuser, sequence: mysequence, selectedboxes: "", amounts: myvalues, chosenbox: 0, selectedbox: 0)
		event="Guest started a new game"
		logDbChanges(event)
	else
    myuser=$credentials[0]
   	Session.create(user: myuser, sequence: mysequence, selectedboxes: "", amounts: myvalues, chosenbox: 0, selectedbox: 0)
     
	@Users = User.where(:username => $credentials[0]).to_a.first
	id=Session.order("created_at").last.id
	@Users.lastGameSession= id
	@Users.save
	event=myuser+" started a new game"
	logDbChanges(event)
	end
    @session = Session.order("created_at").last 
		erb :play,  :locals => { :session =>  @session} 
end
 
post '/resumegame' do # Loading last saved game session.	
	@Users=User.where(:username => $credentials[0]).to_a.first
	myLastGameSession=@Users.lastGameSession
	@session=Session.where(:id => myLastGameSession).to_a.first
	myamounts=@session.amounts.split(",")
    
	total=0.0
    count=0
     
    myamounts.length.times do | i | #calculate offer
		if myamounts[i] != "----"
			total+=myamounts[i].to_f
			count+=1
		end
    end
     
    @offer=((total/count.to_f)*((22-count.to_f)/22)).round(2)
	    event =$credentials[0]+" resumed a game with id: "+myLastGameSession.to_s
	    logDbChanges(event)
	erb :play,  :locals => { :session =>  @session, :offer => @offer} 
end
  
post '/setchosenbox' do # Runs when a box is chosen to keep.     
	myid=params[:thisid]
	@session=Session.where(:id => myid).to_a.first
	@session.chosenbox=params[:chooseboxdd]
	@session.selectedboxes=@session.chosenbox.to_s
	@session.save
	erb :play,  :locals => { :session =>  @session}   
end
 
post '/openbox' do  
	myid=params[:thisid]
	@session=Session.where(:id => myid).to_a.first
	@session.selectedbox=params[:openboxdd]
	@session.selectedboxes=@session.selectedboxes.to_s+","+(params[:openboxdd]).to_s
	mysequence=@session.sequence.split(",")
	value=mysequence[@session.selectedbox-1]
	indx=@session.amounts.split(",").index(value)
	myamounts=@session.amounts.split(",")
	myamounts[indx]="----"
	@session.amounts=myamounts.join(",")
	
	
	total=0.0
	count=0
     
    myamounts.length.times do | i | #calculate offer
		if myamounts[i] != "----"
			total+=myamounts[i].to_f
			count+=1
		end
    end
     
	@offer=((total/count.to_f)*((22-count.to_f)/22)).round(2)
	@session.save
	
	erb :play,  :locals => { :session =>  @session, :offer => @offer} 
 end
    
post '/acceptoffer' do
	@myoffer=params[:offer]
	myid=params[:thisid]
	@session=Session.where(:id => myid).to_a.first
 
	mychosenbox=@session.chosenbox
	@sequence=@session.sequence.split(",")
	@mychosenamount= @sequence[mychosenbox-1]
	@session.selectedboxes="1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1"
	@session.save
	user=@session.user
	if user != "Guest"
		@user = User.where(:username => $credentials[0]).to_a.first
		@user.gamesPlayed = @user.gamesPlayed+1
		@user.totalWinnings = @user.totalWinnings + @myoffer.to_f
	  
		if @myoffer.to_f >= @mychosenamount.to_f
			@user.gamesWon+=1
		end
	@user.save
	event =$credentials[0]+" accpeted an offer and finshed a game"
	logDbChanges(event)    
	else
		event ="Guest accpeted an offer and finshed a game"
		logDbChanges(event)   
	end   
	erb :play, :locals => { :session =>  @session, :offer => @myoffer}
end	

get '/about' do	
	erb :about	
end

get '/login' do
	erb :login 
end

get '/rankings' do
	@list4 = User.all.sort_by { |u| [-u.gamesWon] } # Sorting list of users by total games won.
	erb :rankings
end

get '/createaccount' do
   erb :createaccount
end

post '/createaccount' do
	n = User.new    
	n.username = params[:username] 
	n.password = params[:password]   
	n.isAdmin = false 	
	n.gamesPlayed = 0
	n.totalWinnings = 0.0
	n.gamesWon = 0
	n.lastGameSession = 0
	if n.username == "Admin" and n.password == "Password"	
		n.isAdmin = true 
	end
	n.save    
	event="New user signed up with user id "+params[:username]
	logDbChanges(event)
	redirect "/"
end

get '/logout' do
	$credentials = ['','']
	redirect '/'
end

get '/wrongaccount' do
	erb :wrongaccount
end

get '/admincontrols' do
	restricted!
	erb :admincontrols
end

get '/userlist' do 
	restricted!
	@list2 = User.all.sort_by { |u| [u.id] }   
	erb :userlist
end

get '/noaccount' do
	erb :noaccount
end

get '/denied' do  
	erb :denied 
end

get '/user/:uzer' do 
	erb :profile
end

get '/pleaselogin' do  
	erb :pleaselogin
end

get '/notfound' do
	erb :notfound 
end

put '/user/:uzer' do # Admin can promote Users to Admin.
	restricted! 
	n = User.where(:username => params[:uzer]).to_a.first
	n.isAdmin = params[:isAdmin] ? 1 : 0  
	n.save   
	event="User promoted to admin with user id: "+params[:uzer]
	logDbChanges(event) 
	redirect '/userlist'
end

get '/user/delete/:uzer' do # Deleting user.
	restricted!
	n = User.where(:username => params[:uzer]).to_a.first	
	n.destroy          
	@list2 = User.all.sort_by { |u| [u.id] }      
	redirect '/userlist'	  
	event = "User deleted "+params[:uzer]
	logDbChanges(event)  
	redirect '/userlist'
end

post '/archivetext' do # Admin feature for archiving articles in a .txt file.
	archiveText=""
   
	Session.order(updated_at: :desc).each do |session|
		archiveText+="User: "+session.user
		archiveText+="\tSequence: "+session.sequence
		archiveText+="\tSelected Boxes: "+session.selectedboxes
		archiveText+="\tAmounts: "+session.amounts
		archiveText+="\tChosen Box: "+session.chosenbox.to_s
		archiveText+="\tSelected Box: "+session.selectedbox.to_s
		archiveText+="\tCreated At: "+session.created_at.strftime("%d %m %Y at %I:%M%p")
		archiveText+="\tUpdated At: "+session.updated_at.strftime("%d %m %Y at %I:%M%p")
		archiveText+="\n\n\n"
	end
	
	file = File.open("archive.txt", "w")
	file.puts archiveText
	file.close
	redirect "/admincontrols"
end

not_found do # Redirect if directory does not exist.
	status 404	
	redirect '/notfound'
end

	# Any code added to web-based game should be added above.

# End program