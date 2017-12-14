require 'sqlite3'
require 'singleton'
require_relative 'modelbaseclass'
require_relative 'question_class'
require_relative 'user_class'
require_relative 'replies_class'
require_relative 'questions_likes_class'
require_relative 'question_follows'


class QuestionDatabase < SQLite3::Database
  include Singleton

  def initialize
    super('questions.db')
    self.type_translation = true
    self.results_as_hash = true
  end
end
