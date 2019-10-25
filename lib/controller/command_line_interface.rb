require 'tty-prompt'
require 'pry'


class CommandLineInterface
  # include module
  # Opening pic


include MoodHackers

  def sam_say(text)
	  system("say -v samantha '#{text}'")
  end
  def alex_say(text)
	  system("say -v alex '#{text}'")
  end

def pastel
  @pastel = Pastel.new
end 

  def welcome
    system 'clear'
    puts @pastel.red.bold("#{IMAGE_TITLE}")
    puts @pastel.cyan.bold("#{MAIN_IMAGE}")
    puts "Welcome to MoodHacker![audio announcement playing, text will proceed]"
    self.sam_say('Welcome to MoodHacker!')
    sleep (0.03)
    self.alex_say("Take charge of your life by looking inward.")
  end
  
  def get_name
    prompt = TTY::Prompt.new
    @name = prompt.ask("What is your name?")
    @user = User.create(name: @name) 
  end
  # system "clear" cmd v
  def main_menu
    prompt = TTY::Prompt.new
    menu_screen = prompt.select('What do you want to do?',[
        { name: 'Log a feeling', value: 1 },
        { name: 'See my feelings', value: 2 },
        { name: 'See my events', value: 3 },
        { name: 'Update a feeling', value: 4 }, 
        { name: 'Update an event', value: 5 },
        { name: 'Delete a feeling', value: 6 },
        { name: 'Delete an event', value: 7 },
        { name: 'Exit', value: 8 }])
        case menu_screen
        when 1
          feeling_attributes
          event_categories
          create_feeling
        when 2
          display_feeling_history
        when 3
          display_event_history
        when 4
          update_feeling
        when 5
          update_event
        when 6
          delete_feeling
        when 7
          delete_event
        when 
          exit_out
        end
    end

  def exit_out
      puts "Goodbye and stay healthy!".red
      Feeling.destroy_all
      Event.destroy_all
      exit
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
    @feeling_intensity = prompt.select("How strong is this feeling?") do |menu|
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
    puts "Feeling logged! ~ I feel level #{@pastel.red.bold@feeling_intensity} #{@pastel.yellow.bold@feeling} when #{@pastel.green.bold@event_description}"
    sleep 3 
    main_menu
  end

  def update_feeling
    prompt = TTY::Prompt.new
    if Feeling.all.empty?
      puts "No feelings to show"
      sleep 5
      main_menu
    else
      @feelings_array = Feeling.all.map {|feeling| feeling.name}
      @feeling = prompt.select("Which feeling do you want to update", @feelings_array)
      @feeling_instance_update = Feeling.find_by(name: @feeling)
      @updated_feeling = prompt.ask("What do you want to update this feeling to?")
      @feeling_instance_update.update(name: @updated_feeling)
      puts "Updated: You feel level #{@feeling_intensity} #{@updated_feeling} when #{@event_description}"
      sleep 5
      main_menu
    end
  end

  def update_event
      prompt = TTY::Prompt.new
      if Event.all.empty?
      puts "No events to show"
      sleep 5
      main_menu
      else
      @events_array = Event.all.map {|event| event.category}
      @event2 = prompt.select("Which event do you want to update?", @events_array)
      @event_instance_update = Event.find_by(category: @event2)
      @updated_event = prompt.ask("What do you want to update this event to?")
      @event_instance_update.update(description: @updated_event)
      puts "Updated: I feel #{@updated_feeling} when #{@updated_event}"
      sleep 5
      main_menu
    end
  end

  def display_feeling_history
    prompt = TTY::Prompt.new
      if Feeling.all.empty?
        puts "No feelings to show"
        sleep 5
        main_menu
      else
      @feelings_array = Feeling.all.map {|feeling| feeling.name}
      @feeling = prompt.select("Which feeling do you want to see?", @feelings_array)
      @feeling_instance = Feeling.find_by(name: @feeling)
      @this_event_id = @feeling_instance.event_id
      @event_instance = Event.find_by(id: @this_event_id)
      #  binding.pry
      puts "I feel level #{@feeling_instance.intensity} #{@feeling_instance.name} when #{@event_instance.description}"
    end
    sleep 5
    main_menu
  end

  def display_event_history
    if Event.all.empty?
      puts "No events to show"
      sleep 5
      main_menu
    else
      prompt = TTY::Prompt.new
      @events_array = Event.all.map {|event| event.category}
      @event_choice = prompt.select("Which event do you want to see?", @events_array)
      @event_instance2 = Event.find_by(category: @event_choice)
      #  this_feeling_id = event_instance.id
      @feeling_instance = Feeling.find_by(event_id: @event_instance2.id)
      puts "When #{@event_instance2.description}, I feel #{@feeling_instance.name}"
    end
      sleep 5
      main_menu
  end

  def delete_feeling
    prompt = TTY::Prompt.new
    if Feeling.all.empty?
      puts "No feelings to show"
      sleep 5
      main_menu
    else
      @feelings_array = Feeling.all.map {|feeling| feeling.name}
      @feeling = prompt.select("Which feeling do you want to delete?", @feelings_array)
      @feeling_instance = Feeling.find_by(name: @feeling)
      @feeling_instance.destroy
    puts "Feeling deleted"
    sleep 4
      main_menu
    end
  end


  def delete_event
    prompt = TTY::Prompt.new
    if Event.all.empty?
      puts "No feelings to show"
      sleep 5
      main_menu
    else
      @events_array = Event.all.map {|event| event.category}
      @event_choice = prompt.select("Which event do you want to see?", @events_array)
      @event_instance2 = Event.find_by(category: @event_choice)
      @event_instance.destroy
      puts "Event deleted"
    sleep 4
      main_menu
    end
  end
end
