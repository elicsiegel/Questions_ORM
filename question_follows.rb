require 'byebug'
class QuestionFollows < ModelBase

  def self.table_name
    'question_follows'
  end

  def self.followers_for_question_id(question_id)
    question_follow = QuestionDatabase.instance.execute(<<-SQL, question_id)
    SELECT
      *
    FROM
      users
    JOIN question_follows ON question_follows.author_id = users.id
    WHERE
      question_follows.question_id = ?
    SQL

    question_follow.map do |options|
      User.new(options)
    end
  end

  def self.followed_questions_for_user_id(user_id)
    question_follow = QuestionDatabase.instance.execute(<<-SQL, user_id)
    SELECT
      *
    FROM
      questions
    JOIN question_follows ON question_follows.question_id = questions.id
    WHERE
      question_follows.author_id = ?
    SQL

    question_follow.map { |options| Question.new(options) }
  end

  def self.most_followed_questions(n)
    questions = QuestionDatabase.instance.execute(<<-SQL)
    SELECT
      questions.*, count(question_follows.question_id) as num_followers
    FROM
      questions
    JOIN question_follows ON question_follows.question_id = questions.id
    GROUP BY
      question_follows.question_id
    SQL
    questions.map { |options| Question.new(options) }[0...n]
  end




  def initialize(options)
    @id = options['id']
    @author_id = options['author_id']
    @question_id = options['question_id']
  end
end
