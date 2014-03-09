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

# How many posts are analysed for trustworthiness; needs balancing
TRUST_POST_NUMBER = 30.to_f
# The number divided by TRUST_POST_NUMBER is the amounts of wrong posts allowed on this stage
TRUST_1 = 1.0-(10.0/TRUST_POST_NUMBER)
TRUST_2 = 1.0-(7.0/TRUST_POST_NUMBER)
TRUST_3 = 1.0-(5.0/TRUST_POST_NUMBER)
TRUST_4 = 1.0-(3.0/TRUST_POST_NUMBER)
TRUST_5 = 1.0-(1.0/TRUST_POST_NUMBER)
TRUST_STAGE = [0, TRUST_1, TRUST_2, TRUST_3, TRUST_4, TRUST_5]


# Parameters for the evaluators calculation
EVALUATOR_QUOTE = 1.5
ACCEPT_QUOTE = 2.0/3.0