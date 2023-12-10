Rails.application.routes.draw do
  # Define the root route to be the new password form
  root 'passwords#new'

  # Define a route for the new password form
  get 'passwords/new', to: 'passwords#new', as: 'new_password'

  # Define a route for the password creation (validation) action
  post 'passwords', to: 'passwords#create'
end
