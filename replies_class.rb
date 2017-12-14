class Reply < ModelBase

  def self.table_name
    'replies'
  end

  def self.find_by_user_id(user_id)
    reply = QuestionDatabase.instance.execute(<<-SQL, user_id)
    SELECT
      *
    FROM
      replies
    WHERE
      author_id = ?
    SQL

    Reply.new(reply.first)
  end

  def self.find_by_question_id(question_id)

    reply = QuestionDatabase.instance.execute(<<-SQL, question_id)
    SELECT
      *
    FROM
      replies
    WHERE
      question_id = ?
    SQL

    Reply.new(reply.first)

  end

  def self.find_by_reply_id(reply_id)
    reply = QuestionDatabase.instance.execute(<<-SQL, reply_id)
    SELECT
      *
    FROM
      replies
    WHERE
      reply_id = ?
    SQL

    Reply.new(reply.first)
  end

  attr_accessor :body, :author_id, :reply_id, :question_id

  def initialize(options)
    @id = options['id']
    @author_id = options['author_id']
    @reply_id = options['reply_id']
    @body = options['body']
    @question_id = options ['question_id']
  end

  def save
    if @id.nil?
      QuestionDatabase.instance.execute(<<-SQL, @author_id, @reply_id, @body, @question_id)
      INSERT INTO
        replies (author_id, reply_id, body, question_id)
      VALUES
        (?, ?, ?, ?)
      SQL
    else

      QuestionDatabase.instance.execute(<<-SQL, @author_id, @reply_id, @body, @question_id, @id)
      UPDATE
        replies
      SET
        author_id = ?, reply_id = ?, body = ?, question_id = ?
      WHERE
        id = ?
      SQL
    end
  end

  def author
    User.find_by_id(@author_id)
  end

  def question
    Question.find_by_id(@question_id)
  end

  def parent_reply
    Reply.find_by_id(@reply_id)
  end

  def child_replies
    Reply.find_by_reply_id(@id)
  end
end
