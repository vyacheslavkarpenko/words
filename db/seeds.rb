# ## Create Users
# user = User.create(email: '1@1', password: '11')

# ## Create Account
# account = Account.create(user_id: user)

# ## Create Book
# book = Book.create(user_id: user)

# ## Create Translation
# translation = Translation.new()
# book_translation = BookTranslation.create(book_id: book, translation_id: translation)

# record = Record.create(word: 'food', translation_id: translation )
# record2 = Record.create(word: 'їжа', translation_id: translation )
# translation.save if record && record2
