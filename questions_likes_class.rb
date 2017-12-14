class QuestionsLikes < ModelBase
  
  def self.table_name
    'question_likes'
  end

  def self.likers_for_question_id(question_id)
    likers = QuestionDatabase.instance.execute(<<-SQL, question_id)
    SELECT
      *
    FROM
      users
    JOIN
      question_likes ON users.id = question_likes.author_id
    WHERE
      question_likes.question_id = ?
    SQL
    likers.map { |options| User.new(options) }
  end

  def self.num_likes_for_question_id(question_id)
    likers = QuestionDatabase.instance.execute(<<-SQL, question_id)
    SELECT
      count(question_likes.question_id) as like_count
    FROM
      users
    JOIN
      question_likes ON users.id = question_likes.author_id
    WHERE
      question_likes.question_id = ?
    SQL
    likers.first['like_count']
  end

  def self.liked_questions_for_user_id(user_id)
    questions = QuestionDatabase.instance.execute(<<-SQL, user_id)
    SELECT
      *
    FROM
      questions
    JOIN
      question_likes ON questions.id = question_likes.question_id
    WHERE
      question_likes.author_id = ?
    SQL
    questions.map { |options| Question.new(options) }
  end

  def self.most_liked_questions(n)
    questions = QuestionDatabase.instance.execute(<<-SQL)
    SELECT
      questions.*, COUNT(question_likes.question_id)
    FROM
      questions
    JOIN
      question_likes ON questions.id = question_likes.question_id
    GROUP BY
      question_likes.question_id
    SQL

    questions.map { |options| Question.new(options) }[0...n]
  end

  def initialize(options)
    @id = options['id']
    @author_id = options['author_id']
    @question_id = options['question_id']
  end

end
