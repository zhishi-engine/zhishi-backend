json.partial! "user", user: @user
json.partial! 'tags/tag', tags: @user.tags
json.extract! @user, :email, :active, :created_at, :updated_at,:member_since, :questions_asked, :answers_given
json.renewal { json.partial! 'tokens/renewal', token: @token, user: @current_user } if @token
