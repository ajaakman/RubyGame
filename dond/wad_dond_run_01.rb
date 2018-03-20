# Ruby code file - All your code should be located between the comments provided.

# Add any additional gems and global variables here
require 'sinatra'		
require 'sinatra/activerecord'

 ActiveRecord::Base.establish_connection(
	  :adapter => 'sqlite3',
	  :database => 'dond.db'
	) 

class User < ActiveRecord::Base
	validates :username, presence: true, uniqueness: true
	validates :password, presence: true
	#validates :isAdmin, presence: true
	validates :gamesPlayed, presence: true
	validates :totalWinnings, presence: true
	validates :gamesWon, presence: true
	validates :lastGameSession, presence: true
end


class Session < ActiveRecord::Base
# validates :user, presence: true
#	validates :sequence,
#	validates :selectedboxes, presence: true
#	validates :openedboxes, presence: true
#	validates :amounts, presence: true
#	validates :chosenbox, presence: true
#	validates :selectedbox, presence: true
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

def test
	puts "test"
end
  
helpers do # Helpers used to validate user access level, 3 levels of access: visitor, user, admin. Set up by Artur Jaakman, with Nazmus Sakib providing debugging support.
 
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


def logDbChanges(event) # Method called with the event as parameter for Database Log. Written by Nazmus Sakib.

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

post '/reset' do # Admin control for resetting database. Made by Artur Jaakman.
 
	restricted!
	
	$credentials = ['','']	
	User.delete_all
	User.create(username: "Admin", password: "admin", isAdmin: true, gamesPlayed: 0, totalWinnings: 0.0, gamesWon: 0, lastGameSession: 0) # Creating an Admin account.
	redirect "/"
	 
	event="Datebase Reset"
	logDbChanges(event)  
end

post '/login' do # Login feature, set up by Artur Jaakman.
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
	erb :home
end
   
   
  def showStartButtons
	  if $credentials == nil #user is not logged in
      html='<form action= "/newgame" method= "post" id= "new_game">'		
      html+='<input type= "submit" class= "start_button" value= "Start"></input>'
      html+='</form>'
	  else
      @Users = User.where(:username => $credentials[0]).to_a.first 
      if(@Users.lastGameSession==0)  #user doesn't have a saved game
         html='<form action="/newgame" method="post" id="new_game">'
         #html=+'<input type="hidden" name="_method" value="put">'
         html+='<input type= "submit" class= "start_button" value= "Start"></input>'
         html+='</form>' 
      else
         html='<form action="/newgame" method="post" id="new_game">'
         html+='<input type= "submit" class= "start_button" value= "Start"></input>'
         html+='</form>'

         html+='<form action="/resumegame" method="post" id="new_game">'
         html+='<input type= "submit" class= "start_button" value= "Resume"></input>'
         html+='</form>'
      end 		
	  end
	  return html
  end
  
post '/newgame' do
	myvalues = "0.01,0.10,0.50,1.00,5.00,10.00,50.00,100.00,250.00,500.00,750.00,1000.00,3000.00,5000.00,10000.00,15000.00,20000.00,35000.00,50000.00,75000.00,100000.00,250000.00"
	mysequence = (myvalues.split(",").shuffle!).join(",")
	
  if $credentials==nil
     myuser="Guest"
   		Session.create(user: myuser, sequence: mysequence, selectedboxes: "", amounts: myvalues, chosenbox: 0, selectedbox: 0)
  else
     myuser=$credentials[0]
   		Session.create(user: myuser, sequence: mysequence, selectedboxes: "", amounts: myvalues, chosenbox: 0, selectedbox: 0)

     @Users = User.where(:username => $credentials[0]).to_a.first
     id=Session.order("created_at").last.id
     @Users.lastGameSession= id
     @Users.save
  end
    @session = Session.order("created_at").last 
	   erb :play,  :locals => { :session =>  @session} 
	end
 
 post '/resumegame' do
	puts "resumed"
	@Users=User.where(:username => $credentials[0]).to_a.first
	myLastGameSession=@Users.lastGameSession
	@session=Session.where(:id => myLastGameSession).to_a.first
	
	erb :play,  :locals => { :session =>  @session} 
 end
 
 
 
 post '/setchosenbox' do #runs when a box is chosen to keep
     
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
   @sequence=@session.sequence
   @mychosenamount= @sequence[mychosenbox-1]
   @session.selectedboxes="1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1"
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
   end   
   
   erb :play, :locals => { :session =>  @session, :offer => @myoffer}
 end
 

 
	#get '/play/:id' do # Edit article page. Creates a new create page and loads parameters from old article. Made my Nazmus Sakib. 
	#  
	#  #@session = Session.order("created_at").last
	#end   
       
  #def showboxes
  #   if $flag=="Game Started"
  #      #show boxes to choose to keep
  #      boxHtml=""
  #      for i in 1..22
  #        line1='<input type="button" value ="Choose">  </input>'
  #        boxHtml+=line1
  #      end
  #      $flag=""
  #   else
  #      #show boxes to reveal amount
  #      boxHtml=""
  #      for i in 1..22
  #        line1='<input type="button" value ="Open">  </input>'
  #        boxHtml+=line1
  #      end
  #      
  #   end
  #   return boxHtml
  # end
    
    
    
#  def createBoxesView  #creates html strings to create buttons to open boxes
#   
#    boxHtml=""
#    for i in 1..22
#       
#		line1='<div class="closedBox" id="boxDiv'+i.to_s+'">'
#		line2='<input type="button" class = "eachBox" onclick ="showBox('+i.to_s+')" value =" Open">  </input>'
#		line3='</div>'
#		if i==12
#			boxHtml+="<br><br><br>"+line1+line2+line3
#		else
#			boxHtml+=line1+line2+line3
#		end
#    end
#    return boxHtml
#end

#def showAmounts   
#    myAmounts=""
#    ($amounts.length/2).times do |i|
#        line="<br>"+"#{$amounts[i]}     #{$amounts[11+i]}"
#        myAmounts+=line
#    end   
#    return myAmounts
#end

get '/about' do	
	erb :about	
end

get '/login' do
	erb :login 
end

get '/rankings' do
	@list4 = User.all.sort_by { |u| [-u.totalWinnings] } # Sorting list of users by points. Made by Artur Jaakman and Nazmus Sakib.
	erb :rankings
end

get '/createaccount' do
   erb :createaccount
end

post '/createaccount' do # Create Account. Set up by Artur Jaakman
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

get '/userlist' do # Creating user list made by Artur Jaakman.
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

put '/user/:uzer' do # Admin can promote Users to Admin. Created by Artur Jaakman.
	restricted! 
	n = User.where(:username => params[:uzer]).to_a.first
	n.isAdmin = params[:isAdmin] ? 1 : 0  
	n.save   
	event="User promoted to admin with user id: "+params[:uzer]
	logDbChanges(event) 
	redirect '/userlist'
end

get '/user/delete/:uzer' do # Deleting user. Made by Artur Jaakman, debugging aid provided by Nazmus Sakib.
	restricted!
	n = User.where(:username => params[:uzer]).to_a.first
	if n.isAdmin == false
		erb :denied 
	else
		n.destroy          
		@list2 = User.all.sort_by { |u| [u.id] }      
		redirect '/userlist'
	end  
	event = "User deleted "+params[:uzer]
	logDbChanges(event)  
	redirect '/userlist'
end

not_found do # Redirect if directory does not exist.
	status 404	
	redirect '/notfound'
end

	# Any code added to web-based game should be added above.

# End program