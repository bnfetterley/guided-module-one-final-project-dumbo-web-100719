require 'tty-prompt'
require 'pry'

class CommandLineInterface
  def welcome
    puts "Welcome to MoodHacker!"
    puts "Take charge of your life by looking inward."
  end

  def get_name
    prompt = TTY::Prompt.new
    @name = prompt.ask("What is your name?")
    # if User.all.include?(@name)  
    #   @user = User.id
    # else
    # if User.find_by(name: @name)
    #   puts "already exists"
    #   @user = User.id
    # else
      # puts "doesnt exist"
      # unless
    @user = User.create(name: @name)  #User.all.name.include? (@name)
    # end
  end

  def feeling_attributes
    prompt = TTY::Prompt.new
    @mood = prompt.select("How are you feeling today, #{@user.name}?") do |menu|
    # binding.pry
    menu.choice 'Good'
    menu.choice 'Not so great'
    end
    
    if @mood == 'Good' then @feeling = prompt.select("What is your feeling?") do |menu|
      menu.choice 'Excited'
      menu.choice 'Grateful'
      menu.choice 'Inspired'
      menu.choice 'Loved'
      menu.choice 'Calm'
    end
    elsif @mood == 'Not so great' then @feeling = prompt.select("What is your feeling?") do |menu|
      menu.choice 'Depressed'
      menu.choice 'Lonely'
      menu.choice 'Disappointed'
      menu.choice 'Jealous'
      menu.choice 'Hungry'
      menu.choice 'Anxious'
      end
    end
    @feeling_intensity = prompt.select("How strong is this feeling on a scale of 1-5 (5 being the strongest)?") do |menu|
      menu.choice '1'
      menu.choice '2'
      menu.choice '3'
      menu.choice '4'
      menu.choice '5'
    end
  end

def event_categories
  prompt = TTY::Prompt.new
  @event_category = prompt.select("What part of your life is this related to?") do |menu|
  menu.choice 'Love'
  menu.choice 'Career'
  menu.choice 'Family'
  menu.choice 'Social'
  menu.choice 'Food'
end
@event_description = prompt.ask("What happened?")
@event_description
@event = Event.create(category: @event_category,description: @event_description)
end

def create_feeling
  @feelings = Feeling.create(name: @feeling, intensity: @feeling_intensity, user_id: @user.id, event_id: @event.id)
end


def display_feeling_history
  prompt = TTY::Prompt.new
   @feelings_array = Feeling.all.map {|feeling| feeling.name}
   @feeling = prompt.select("Which feeling do you want to see?", @feelings_array)
   @feeling_instance = Feeling.find_by(name: @feeling)
   @this_event_id = @feeling_instance.event_id
   @event_instance = Event.find_by(id: @this_event_id)
  #  binding.pry
   puts "I feel #{@feeling_instance.intensity} #{@feeling_instance.name} when #{@event_instance.description}"
end

def display_event_history
   prompt = TTY::Prompt.new
   @events_array = Event.all.map {|event| event.category}
   @event_choice = prompt.select("Which event do you want to see?", @events_array)
   @event_instance2 = Event.find_by(category: @event_choice)
  #  this_feeling_id = event_instance.id
   @feeling_instance = Feeling.find_by(event_id: @event_instance2.id)
   puts "When #{@event_instance.description}, I felt #{@feeling_instance.name}"
end

def delete_feeling
  prompt = TTY::Prompt.new
  @feelings_array = Feeling.all.map {|feeling| feeling.name}
  @feeling = prompt.select("Which feeling do you want to delete?", @feelings_array)
  @feeling_instance = Feeling.find_by(name: @feeling)
  @feeling_instance.destroy
end


def delete_event
  prompt = TTY::Prompt.new
   @events_array = Event.all.map {|event| event.category}
   @event_choice = prompt.select("Which event do you want to see?", @events_array)
   @event_instance2 = Event.find_by(category: @event_choice)
   @event_instance.destroy
end


# # end

# def display_logger
#   display_events
#   display_feelings
# end
# def describe_event
#   prompt = TTY::Prompt.new
# event_description = prompt.ask("What happened?")
# event_description
# end


end

# 'Not so great' then prompt.select("What is your feeling?") do |menu|
