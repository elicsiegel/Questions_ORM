
class Question < ModelBase
  attr_accessor :title, :body, :author_id

  def self.table_name
    'questions'
  end

  def self.find_by_author_id(author_id)
    question = QuestionDatabase.instance.execute(<<-SQL, author_id)
    SELECT
      *
    FROM
      questions
    WHERE
      author_id = ?
    SQL
    Question.new(question.first)
  end

  def self.most_followed(n)
    QuestionFollows.most_followed_questions(n)
  end

  def self.most_liked(n)
    QuestionsLikes.most_liked_questions(n)
  end

  def initialize(options)
    @title = options['title']
    @body = options['body']
    @author_id = options['author_id']
    @id = options['id']
  end

  def save
    if @id.nil?
      QuestionDatabase.instance.execute(<<-SQL, @author_id, @title, @body)
      INSERT INTO
        questions (author_id, title, body)
      VALUES
        (?, ?, ?)
      SQL
    else

      QuestionDatabase.instance.execute(<<-SQL, @author_id, @title, @body, @id)
      UPDATE
        questions
      SET
        author_id = ?, title = ?, body = ?
      WHERE
        id = ?
      SQL
    end
  end

  def author
    User.find_by_id(@author_id)
  end

  def replies
    Reply.find_by_question_id(@id)
  end

  def followers
    QuestionFollows.followers_for_question_id(@id)
  end

  def likers
    QuestionsLikes.likers_for_question_id(@id)
  end

  def num_likes
    QuestionsLikes.num_likes_for_question_id(@id)
  end
end
