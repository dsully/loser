class Profile < Application

  def index
    render
  end

  def update
    changed = false

    if params["password"] and not params["password"].empty?
      if params["password"].eql?(params["password_confirm"])

        session.user.password = session.user.password_confirmation = params["password"]
        changed = true
      else
        return redirect "/profile", :message => { :notice => "Passwords don't match!" }
      end
    end

    if params["email"] and not params["email"].empty?
      if session.user.email != params["email"]
        session.user.email = params["email"]
        changed = true
      end
    end

    if changed
      unless session.user.save
        return redirect "/profile", :message => { :notice => session.user.errors.values.join("\n") }
      end

      redirect "/profile", :message => { :notice => "Profile updated!" }
    else
      redirect "/profile", :message => { :notice => "No changes." }
    end
  end
end