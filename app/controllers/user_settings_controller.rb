class UserSettingsController < InertiaController
  def show
    render inertia: "Settings/Show"
  end
end
