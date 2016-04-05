require "rails_helper"
require "requests/shared/shared_authenticated_endpoint"
require "requests/shared/shared_authenticate_parent_resource_exists"

def accept_answer_path_helper(question=nil, answer=nil)
  question ||= FactoryGirl.create(:question_with_answers)
  answer ||= FactoryGirl.create(:answer, question: question)
  "/questions/#{question.id}/answers/#{answer.id}/accept"
end

RSpec.describe "Accepting an answer", type: :request do
  let(:user) { create(:active_user) }
  let(:user2) { create(:active_user) }
  let(:question) { create(:question_with_answers, user: user) }
  let(:answer) { create(:answer, question: question, user: user2) }
  let(:header) { generate_valid_token(user) }


  it_behaves_like "authenticated endpoint", accept_answer_path_helper, 'get'
  # it_behaves_like "authenticated parent resource", accept_answer_path_helper, 'post'

  describe "validates that question belongs to user" do
    it "returns unauthorized_access if question doesn't belong to user" do
      post accept_answer_path_helper(question, answer), {}, generate_valid_token(user2)
      expect(response.status).to be 403
      expect(response).to match_response_schema("error/unauthorized")
    end

    it "allows user if question belongs to user" do
      post accept_answer_path_helper(question, answer), {}, header
      expect(response.status).to be 201
      expect(response).to match_response_schema('answer/accept')
    end
  end

  describe "sets answer as accepted" do
    it "sets answer as accepted" do
      expect(answer.accepted).to eql false
      post accept_answer_path_helper(question, answer), {}, header
      expect(response).to match_response_schema('answer/accept')
      expect(answer.reload.accepted).to eql true
    end

    it "increase user reputation by 20 points" do
      expect{ post accept_answer_path_helper(question, answer), {}, header }.to change{ user2.reload.points }.by 20
    end
  end
end