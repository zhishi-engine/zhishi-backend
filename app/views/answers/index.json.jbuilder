json.answers do
  json.array!(@answers) do |answer|
    json.partial! 'answer', answer: answer
  end
end

# json.renewal { json.partial! 'tokens/renewal', token: @token, user: @current_user } if @token
