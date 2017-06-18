class PeopleController < ApplicationController
  before_action :set_person, only: [:show, :edit, :update, :destroy]

  # GET /people
  # GET /people.json
  def index
    @people = Person.all
  end

  # GET /people/1
  # GET /people/1.json
  def show
  end

  # GET /people/new
  def new
    @person = Person.new
  end

  # GET /people/1/edit
  def edit
  end

  # POST /people
  # POST /people.json
  def create

    params["person"]["missing_date"] = DateTime.strptime(params["person"]["missing_date"], "%m/%d/%Y %l:%M %p")
    avatar = params["person"]["avatar"]
    params["person"].delete :avatar
    @person = Person.new(person_params)
    @person.avatar = avatar

    respond_to do |format|
      if @person.save
        if !session[:fb_user].nil?
          send_message_to_fb_user(session[:fb_user], "Thank you! We will send an Amber Alert in Mumbai City shortly. You can also share our post about the same.")
        end
        format.html { redirect_to @person, notice: 'Person was successfully created.' }
        format.json { render :show, status: :created, location: @person }
      else
        format.html { render :new }
        format.json { render json: @person.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /people/1
  # PATCH/PUT /people/1.json
  def update
    respond_to do |format|
      if @person.update(person_params)
        format.html { redirect_to @person, notice: 'Person was successfully updated.' }
        format.json { render :show, status: :ok, location: @person }
      else
        format.html { render :edit }
        format.json { render json: @person.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /people/1
  # DELETE /people/1.json
  def destroy
    @person.destroy
    respond_to do |format|
      format.html { redirect_to people_url, notice: 'Person was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def confirm
    psid = params["psid"]
    logger.info "Facebook Messenger psid : #{psid}"
    session[:fb_user] = psid
    render json: 200
  end

  private
    def send_message_to_fb_user(sender, text)
      # Send confirmation through Fb Messenger
      body = {
        recipient: {
          id: sender
        },
        message: {
          text: text
        }
      }

      url = "https://graph.facebook.com/v2.6/me/messages?access_token=#{Rails.application.secrets.MY_APP_ACCESS_TOKEN}"
      response = HTTParty.post(url, body: body)
      logger.info "Messenger response: #{response.code} : #{response.body}"
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_person
      @person = Person.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def person_params
      params.require(:person).permit(:name, :age, :height, :remarks, :missing_date, :police_station, :police_reg_no, :reporter, :avatar)
    end
end
