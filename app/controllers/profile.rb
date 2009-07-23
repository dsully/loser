class Profile < Application

  def index
    @user = session.user
    render
  end

  def view
    # Allow other users to see read only data.
    if params["id"] and params["id"] != session.user.id
      @user = User.get(params["id"])
    end

    @user ||= session.user

    render :template => 'profile/index'
  end

  def update
    changed = false

    unless params["password"].blank?
      if params["password"].eql?(params["password_confirm"])

        session.user.password = session.user.password_confirmation = params["password"]
        changed = true
      else
        return redirect "/profile", :message => { :notice => "Passwords don't match!" }
      end
    end

    unless params["email"].blank?
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

  def join
    p = Participant.new(:user_id => session.user.id, :round_id => @round.id)
    p.paid  = true
    p.start = params["start"]

    unless p.save
      return redirect "/profile", :message => { :notice => p.errors.values.join("\n") }
    end

    redirect "/profile", :message => { :notice => "Joined round #{@round.id}!" }
  end

  def export
    provides :yaml, :json

    @user ||= session.user
    @data = @user.export

    display @data, :layout => false, :disposition => :inline
  end
end
