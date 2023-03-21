class AccountsController < ApplicationController
  before_action :check_registration, except: %i[create]
  before_action :set_account, only: %i[ show edit update destroy ]

  # # GET /accounts or /accounts.json
  # def index
  #   @accounts = Account.all
  # end

  # GET /accounts/1 or /accounts/1.json
  def show
  end

  # # GET /accounts/new
  # def new
  #   @user = User.new
  # end

  # GET /accounts/1/edit
  def edit
  end

  # # POST /accounts or /accounts.json
  # def create
  #   @user = User.new(user_params)
    
  #   respond_to do |format|
  #     if @user.save
  #       books = Book.create_user_books(@user)
  #       # binding.pry
  #       if books
  #         p 'Books created'
  #       else
  #         # binding.pry
  #         @user.destroy
  #       end

  #       format.html { redirect_to user_url(@user), notice: "User was successfully created." }
  #       format.json { render :show, status: :created, location: @user }
  #     else
  #       format.html { render :new, status: :unprocessable_entity }
  #       format.json { render json: @user.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # PATCH/PUT /accounts/1 or /accounts/1.json
  def update
    # binding.pry
    params_to_update = {
      languages: { native: BSON::ObjectId(params[:account][:nativeLanguage]),
      to_learn: BSON::ObjectId(params[:account][:learnedLanguage]) },
      redirect_ater_translation_update: params[:account][:redirect_ater_translation_update],
      translations_per_page: params[:account][:translations_per_page]
    }
    respond_to do |format|
      if @account.update!(params_to_update)
        format.html { redirect_to show_account_path(user_id: @current_user, account_id: @current_account), notice: "Account was successfully updated." }
        # format.json { render :show, status: :ok, location: @user }
      else
        format.html { render edit_account_path(user_id: @current_user, account_id: @current_account), status: :unprocessable_entity }
      #   # format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # # DELETE /accounts/1 or /accounts/1.json
  # def destroy
  #   # @user.destroy

  #   # respond_to do |format|
  #   #   format.html { redirect_to accounts_url, notice: "User was successfully destroyed." }
  #   #   format.json { head :no_content }
  #   end
  # end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_account
      @account = Account.find(params[:account_id])
    end

    # Only allow a list of trusted parameters through.
    def account_params
      params.require(:account).permit(:learnedLanguage, :nativeLanguage, :redirect_ater_translation_update, :translations_per_page)
    end
end


# {"_method"=>"patch",
#   "authenticity_token"=>"[FILTERED]",
#   "account"=>{"learnedLanguage"=>"63d3ecfe755f8565f4cedc5c", "nativeLanguage"=>"63d3ecfe755f8565f4cedc5c"},
#   "commit"=>"Update Account",
#   "user_id"=>"63b427c2755f855992858d60",
#   "account_id"=>"63dd3b47755f852502742135"}


