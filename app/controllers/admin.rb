class Admin < Application

  def index
    if session.user.admin
      render
    else
      redirect "/summary"
    end
  end

  def user_create
    create = false
    user   = User.new

    if not params["password"].blank? and params["password"].eql?(params["password_confirm"])
      user.password = user.password_confirmation = params["password"]
    else
      return redirect "/admin", :message => { :notice => "Passwords don't match!" }
    end

    [:email, :name, :login].each do |f|
      user.send("#{f}=", params[f.to_s])
    end

    # Validation will happen on save.
    unless user.save
      return redirect "/admin", :message => { :notice => user.errors.values.join("\n") }
    end

    redirect "/admin", :message => { :notice => "User #{user.name} created!" }
  end

  def round_create
    round = Round.new(
      :weeks  => params["weeks"],
      :target => params["target"],
      :start  => (Date.parse(params["start"]) rescue nil),
      :ante   => params["ante"]
    )

    unless round.save
      return redirect "/admin", :message => { :notice => round.errors.values.join("\n") }
    end

    redirect "/admin", :message => { :notice => "Round #{round.id} created!" }
  end

  def round_select
    cr = CurrentRound.first
    cr.round = params["round"]

    unless cr.save
      return redirect "/admin", :message => { :notice => cr.errors.values.join("\n") }
    end

    redirect "/admin", :message => { :notice => "Round #{cr.round} selected!" }
  end
end
