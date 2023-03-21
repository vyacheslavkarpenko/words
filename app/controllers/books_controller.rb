class BooksController < ApplicationController

  # GET /users/:user_id/books
  def user_books
    books_by_user ||= Book.where(user_id: current_user._id)
    # Hide if not binded to translation
    user_books = books_by_user.to_a.map do|book|
      language_ids = book.book_translations.map{|book_translation| book_translation.translation.words.map{|word| word.language_id}}.flatten.uniq()
      # binding.pry

      if book.is_multi_language == false
        # binding.pry
        if language_ids.include?(BSON::ObjectId.from_string(user_to_learn_language[:id])) && language_ids.include?(BSON::ObjectId.from_string(user_native_language[:id])) then
        # if language_ids.include?(BSON::ObjectId.from_string(user_to_learn_language[:id])) == false && language_ids.include?(BSON::ObjectId.from_string(user_native_language[:id])) == false then
          # binding.pry
            next
          end
        end
      book
    end
# binding.pry
    @user_books = user_books.compact()

    @books = build_books_tree(@user_books)
# binding.pry

  end

  # GET /users/:user_id/books/:book_id
  def show
    # binding.pry
    @book ||= Book.find_by(user_id: current_user._id, id: params[:books_id])
  end

  # GET /users/:user_id/books/new
  def new
    # binding.pry
    @book = Book.new
  end

  # GET /users/:user_id/books/:book_id/edit
  def edit
    @book = Book.find_by(user_id: current_user._id, id: params[:books_id])
  end

  # POST /users/:user_id/books
  def create
    # binding.pry
    @book = Book.new(name: params[:book][:name], is_multi_language: params[:book][:is_multi_language], user_id: current_user.id, parent_id: params[:book][:parent_id])
    respond_to do |format|
      if @book.save
        format.html { redirect_to user_books_path(user_id: @current_user.id), notice: "Book was successfully created." }
        format.json { render :show, status: :created, location: @book }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /users/:user_id/books/:book_id
  def update
    # binding.pry
    @book = Book.find_by(user_id: current_user._id, id: params[:book][:books_id])
    respond_to do |format|
      if @book.update(name: params[:book][:name], is_multi_language: params[:book][:is_multi_language], parent_id: params[:book][:parent_id])
        format.html { redirect_to user_books_path(user_id: @current_user.id), notice: "Book was successfully updated." }
        format.json { render :show, status: :created, location: @book }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/:user_id/books/:book_id
  def destroy
    # binding.pry
    book = Book.find_by(user_id: current_user._id, id: params[:books_id])

    respond_to do |format|
      if book.destroy
        format.html { redirect_to user_books_path(user_id: @current_user.id), notice: "Book was successfully destroyed." }
        format.json { render :show, status: :deleted }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: book.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  # Only allow a list of trusted parameters through.
  def book_params
    params.require(:book).permit(:name, :user_id, :books_id, :is_multi_language, :parent_id)
  end

  def build_books_tree(books)
    # books  = [
    #   {id: 1, name: '1',  parent_id: nil },
    #   {id: 2, name: '2',  parent_id: nil },
    #   {id: 3, name: '3',  parent_id: nil },
    #   {id: 4, name: '1.1',  parent_id: 1 },
    #   {id: 5, name: '1.1.1',  parent_id: 4 },
    #   {id: 6, name: '2.1',  parent_id: 2 },
    #   {id: 7, name: '1.1.1.1.',  parent_id: 5 },
    #   {id: 8, name: '2.1.1.',  parent_id: 6 },
    #   {id: 9, name: '2.1.2',  parent_id: 6 },
    # ]

    # tree = [
    #   { :id: 1, :name: '1', :parent_id: nil,:children: [
    #     { :id: 4, :name: '1.1', :parent_id: 1, :children: [
    #       { :id: 5, :name: '1.1.1', :parent_id: 4, :children: [
    #         { :id: 7, :name: '1.1.1.1.', :parent_id: 5, :children: [] }
    #       ] }
    #     ] }
    #   ] },
    #   { :id: 2, :name: '2',:parent_id: nil, :children: [
    #     { :id: 6, :name: '2.1', :parent_id: 2, :children: [
    #       { :id: 8, :name: '2.1.1.', :parent_id: 6, :children: [] },
    #       { :id: 9, :name: '2.1.2', :parent_id: 6, :children: [] }
    #     ] }
    #   ] },
    #   { :id: 3, :name: '3', :parent_id: nil, :children: [] }
    # ]
    records_with_empty_children = books.select{|e| e[:parent_id] == nil }

    tree = records_with_empty_children.each do |record|
      # binding.pry
      record[:children] = find_children(record, books)
    end

    # binding.pry
    tree
  end

  def find_children(record, books)
    children = books.select do |data|
      # binding.pry
      data[:parent_id].to_s == record[:id].to_s
    end

    children.map do | child|
      if books.map{ |e| e[:id] }.include?(child[:parent_id])
        child[:children] = find_children(child, books)
      end
    end
    children
  end
end