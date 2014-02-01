# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Wispper::Application.initialize!

# AVAILABLE LANGAUAGES
# for the forms
LANGUAGES_HASH = { de: "deutsch", en: "english", es: "espanol"}
# for http_accept
LANGUAGES_STRING = %w(en de es)
# DON'T FORGET TO CHANGE THE AVAILABLE LANGUAGES IN ROUTES!!!





# APP PARAMETERS ------------------------------------------
MIN_CONTR_LVL1 = 5
EVALUATOR_QUOTE = 3.0/2.0