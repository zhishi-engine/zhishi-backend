module Notifications
  class NewAnswerSerializer < AnswerSerializer
    attributes :type
    has_many :subscribers

    private
      def root
        :notification
      end

      def type
        'new.answer'
      end
  end
end
