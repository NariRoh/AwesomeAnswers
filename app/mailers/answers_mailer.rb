class AnswersMailer < ApplicationMailer

  def notify_question_owner(answer)
    @answer  = answer
    @question = answer.question
    @owner    = @question.user
    if @owner.present?
      mail(to: @owner.email, subject: 'test')
    end
    # mail(to: 'nari.rohh@gmail.com', subject: 'test')
  end

end
