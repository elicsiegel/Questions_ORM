class User < ModelBase
  attr_accessor :fname, :lname

  def self.find_by_name(fname, lname)
    user = QuestionDatabase.instance.execute(<<-SQL, fname, lname)
    SELECT
      *
    FROM
      users
    WHERE
      fname = ? and lname = ?
    SQL
    return nil unless user.length > 0
    User.new(user.first)
  end

  def self.table_name
    'users'
  end

  def initialize(options)
    @fname = options['fname']
    @lname = options['lname']
    @id = options['id']
  end

  def average_karma
    avg_num_likes = QuestionDatabase.instance.execute(<<-SQL, @id)
    SELECT
      count(question_likes.id) / cast(count(distinct(questions.id)) as float) as avg_num_likes
    FROM
      questions
    LEFT OUTER JOIN
      question_likes ON question_likes.question_id = questions.id
    WHERE
      questions.author_id = ?
    SQL
    avg_num_likes.first['avg_num_likes']
  end

  def save
    if @id.nil?
      QuestionDatabase.instance.execute(<<-SQL, @fname, @lname)
      INSERT INTO
        users (fname, lname)
      VALUES
        (?, ?)
      SQL
    else

      QuestionDatabase.instance.execute(<<-SQL, @fname, @lname, @id)
      UPDATE
        users
      SET
        fname = ?, lname = ?
      WHERE
        id = ?
      SQL
    end

  end

  def authored_questions
    Question.find_by_author_id(@id)
  end

  def authored_replies
    Reply.find_by_user_id(@id)
  end

  def followed_questions
    QuestionFollows.followed_questions_for_user_id(@id)
  end

  def liked_questions
    QuestionsLikes.liked_questions_for_user_id(@id)
  end
end
