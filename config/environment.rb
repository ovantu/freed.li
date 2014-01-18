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