class ModelBase

  def self.find_by_id(id)
    class_name = self.table_name

    user = QuestionDatabase.instance.execute(<<-SQL, id)
    SELECT
      *
    FROM
      #{class_name}
    WHERE
      id = ?

    SQL
    return nil unless user.length > 0
    self.new(user.first)
  end

  def self.all
    class_name = self.table_name

    all = QuestionDatabase.instance.execute(<<-SQL)
    SELECT
      *
    FROM
      #{class_name}
    SQL
    all.map { |options| self.new(options) }
  end

  def save
    class_name = self.table_name
    instance_variables = self.instance_variables

    string = ''
    instance_variables.length.times do
      string += '?,'
    end

    string = string[0...-1]

    if @id.nil?
      QuestionDatabase.instance.execute(<<-SQL, *instance_variables)
      INSERT INTO
        #{class_name} (*instance_variables)
      VALUES
        (#{string})
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
end
