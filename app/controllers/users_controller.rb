class UsersController < ApplicationController
  before_action :check_registration, except: %i[create]
  before_action :set_user, only: %i[ show edit update destroy ]

  # GET /users or /users.json
  def index
    @users = User.all
  end

  # GET /users/1 or /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)
    
    respond_to do |format|
      if @user.save
        books = Book.create_user_books(@user)
        account = Account.create!(user_id: @user.id)
        account.init_setting
        # binding.pry
        if books && account
          p 'Books created'
          p 'Account created'
        else
          binding.pry
          @user.destroy
          account.destroy
        end

        format.html { redirect_to user_url(@user), notice: "User was successfully created." }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to user_url(@user), notice: "User was successfully updated." }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url, notice: "User was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def roadmap; end

  def user_vocabularies
    # language_pairs = @current_user.books.map{|b| b.book_translations.map{ |bt| bt.translation.words.map{|w| w.language_id }.uniq()}}.flatten.uniq()
    # language_pairs = @current_user.books.map{|b| b.book_translations.map{ |bt| bt.translation.words.map{|w| w.language_id }} if b.book_translations.size > 0 }
    language_pairs = @current_user.books.map{|b| b.book_translations.map{ |bt| bt.translation.words.map{|w| w.language_id }} if b.book_translations.size > 0 }.compact()
    
    # [
      #   [BSON::ObjectId('63dd872b755f857cdd026f5f'), BSON::ObjectId('63dd872b755f857cdd026f60')],
      #   [BSON::ObjectId('63dd872b755f857cdd026f5f'), BSON::ObjectId('63dd872b755f857cdd026f60')],
      #   [BSON::ObjectId('63dd872b755f857cdd026f5e'), BSON::ObjectId('63dd872b755f857cdd026f60')],
      #   [BSON::ObjectId('63dd872b755f857cdd026f61'), BSON::ObjectId('63dd872b755f857cdd026f60')]
      # ],
      @user_vocabularies = language_pairs.map{ |pair| p pair.first.map{ |e| Language.find(e) } }
      # binding.pry


  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:email, :password)
    end
end
