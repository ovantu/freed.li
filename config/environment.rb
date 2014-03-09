# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Wispper::Application.initialize!

# AVAILABLE LANGAUAGES
# for the forms
LANGUAGES_HASH = { de: "deutsch", en: "english", es: "español"}
# for http_accept
LANGUAGES_STRING = %w(en de es)
# DON'T FORGET TO CHANGE THE AVAILABLE LANGUAGES IN ROUTES!!!





# APP PARAMETERS ------------------------------------------
# stages up to the value e.g. STAGE_2 goes from 7 up to 30
STAGE_0_1 = 7
STAGE_2 = 30
STAGE_3 = 100
STAGE_4 = 300
# STAGE 5 goes to infinity
# Parameters for the evaluators calculation
EVALUATOR_QUOTE = 1.5
ACCEPT_QUOTE = 2.0/3.0