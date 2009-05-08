class Application < Merb::Controller

  # All controllers get authentication by default.
  before :ensure_authenticated
end
