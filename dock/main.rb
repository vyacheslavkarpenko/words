current_user = User.find_by(email: '1')
user_book_for_translation = Book.find_by(user_id: current_user, name:  'Translation')
book_translation = BookTranslation.find_by(book_id: user_book_for_translation)
translation = Word.where(translation_id:  book_translation.translation_id).to_a

jj current_user.as_json
jj user_book_for_translation.as_json
jj book_translation.as_json
jj translation.as_json
###########################################

jj current_user.as_json
{
  "_id": {
    "$oid": "635997e4755f85b43cb10d68"
  },
  "created_at": "2022-10-26T20:26:12.465Z",
  "email": "1",
  "password": "1",
  "updated_at": "2022-10-26T20:26:12.465Z"
}
 => nil 
3.1.2 :237 > jj user_book_for_translation.as_json
{
  "_id": {
    "$oid": "635997e4755f85b43cb10d69"
  },
  "created_at": "2022-10-26T20:26:12.518Z",
  "name": "Translation",
  "updated_at": "2022-10-26T20:26:12.518Z",
  "user_id": {
    "$oid": "635997e4755f85b43cb10d68"
  }
}
 => nil 
3.1.2 :238 > jj book_translation.as_json
{
  "_id": {
    "$oid": "635997e4755f85b43cb10d6e"
  },
  "book_id": {
    "$oid": "635997e4755f85b43cb10d69"
  },
  "created_at": "2022-10-26T20:26:12.654Z",
  "learned": false,
  "translation_id": {
    "$oid": "635997e4755f85b43cb10d6b"
  },
  "updated_at": "2022-10-26T20:26:12.654Z"
}
 => nil 
3.1.2 :239 > jj translation.as_json
[
  {
    "_id": {
      "$oid": "635997e4755f85b43cb10d6c"
    },
    "created_at": "2022-10-26T20:26:12.618Z",
    "expression": "шукати",
    "language": "Українська",
    "translation_id": {
      "$oid": "635997e4755f85b43cb10d6b"
    },
    "updated_at": "2022-10-26T20:26:12.618Z"
  },
  {
    "_id": {
      "$oid": "635997e4755f85b43cb10d6d"
    },
    "created_at": "2022-10-26T20:26:12.642Z",
    "expression": "look for",
    "language": "English",
    "translation_id": {
      "$oid": "635997e4755f85b43cb10d6b"
    },
    "updated_at": "2022-10-26T20:26:12.642Z"
  }
]
 => nil 
