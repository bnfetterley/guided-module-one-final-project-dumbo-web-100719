require_relative '../config/environment'



new_cli = CommandLineInterface.new
new_cli.welcome
new_cli.get_name
new_cli.feeling_attributes
new_cli.event_categories
new_cli.create_feeling
new_cli.display_feeling_history
new_cli.display_event_history
new_cli.update_feeling
new_cli.delete_feeling
new_cli.delete_event
