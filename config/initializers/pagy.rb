require "pagy/extras/bootstrap"
require "pagy/extras/overflow"

# Pagy configuration
Pagy::DEFAULT[:items] = 10
Pagy::DEFAULT[:size] = 7
Pagy::DEFAULT[:overflow] = :last_page
