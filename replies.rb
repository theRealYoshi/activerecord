require_relative 'questionsdatabase'

class Replies

  TABLE_NAME = "replies"
  attr_accessor :id, :body, :parent_reply_id, :user_id, :question_id

  def self.find_by_id(id)
    data = QuestionsDatabase.instance.execute(<<-SQL, id).first
      SELECT
        *
      FROM
        #{TABLE_NAME}
      WHERE
        id = ?
    SQL
    return nil unless data
    Replies.new(data)
  end

  def self.find_by_user_id(id)
    data = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        #{TABLE_NAME}
      WHERE
        user_id = ?
    SQL
    return nil unless data

    data.map do |attributes|
      Replies.new(attributes)
    end

  end

  def self.find_by_question_id(id)
    data = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        #{TABLE_NAME}
      WHERE
        question_id = ?
    SQL
    return nil unless data

    data.map do |attributes|
      Replies.new(attributes)
    end

  end

  def author
    data = Users.find_by_id(@user_id)
    return nil unless data
    data
  end

  def question
    data = Questions.find_by_id(@question_id)
    return nil unless data
    data
  end

  def parent_reply
    data = Replies.find_by_id(@parent_reply_id)
    return nil unless data
    data
  end

  def child_reply
    data = QuestionsDatabase.instance.execute(<<-SQL).first
      SELECT
        *
      FROM
        #{TABLE_NAME}
      WHERE
        parent_reply_id = #{@id}
    SQL
    return nil unless data
    data
  end


  def initialize(attributes)
    @id = attributes["id"]
    @body = attributes["body"]
    @question_id = attributes["question_id"]
    @parent_reply_id = attributes["parent_reply_id"]
    @user_id = attributes["user_id"]
  end

end
