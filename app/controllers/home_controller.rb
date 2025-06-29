class HomeController < InertiaController
  def index
    render inertia: "Home"
  end
end
