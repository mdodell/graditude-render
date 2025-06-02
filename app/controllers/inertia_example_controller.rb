# frozen_string_literal: true

class InertiaExampleController < InertiaController
  def index
    flash[:alert] = 'This is an alert'
    render inertia: 'InertiaExample', props: {
      name: params.fetch(:name, 'World'),
    }
  end
end
