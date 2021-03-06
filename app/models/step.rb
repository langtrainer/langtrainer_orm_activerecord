class Step < ActiveRecord::Base
  validates :ru_answers, :en_answers, presence: true

  has_many :steps_units, dependent: :destroy
  has_many :units, through: :steps_units

  def question(language_slug)
    question = send("#{language_slug}_question")
    question.present? ? question : answers(language_slug).first
  end

  def title
    question(:en)
  end

  def sanitize_text(text)
    text.squish.downcase
  end

  def right_answer?(language_slug, answer)
    sanitizedAnswer = sanitize_text(answer)
    answers(language_slug).find do |rightAnswer|
      sanitizedAnswer == sanitize_text(rightAnswer)
    end.present?
  end

  def answers(language_slug)
    answers = send("#{language_slug}_answers").to_s
    answers.split('|').map(&:strip)
  end

  def to_s
    "#{id}: #{title}"
  end
end
