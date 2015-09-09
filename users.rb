require_relative 'questionsdatabase'
require_relative 'questions'
require_relative 'replies'
require 'byebug'
require_relative 'questionfollows'

class User
  TABLE_NAME = "users"
  attr_accessor :id, :fname, :lname

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
    User.new(data)
  end

  def self.find_by_name(fname, lname)
    data = QuestionsDatabase.instance.execute(<<-SQL, fname: fname, lname: lname).first
      SELECT
        *
      FROM
        #{TABLE_NAME}
      WHERE
        fname = :fname AND lname = :lname
    SQL
    return nil unless data
    User.new(data)
  end

  def self.authored_questions(author_id)
    data = Questions.find_by_author_id(author_id)
    return nil unless data
    data.map do |question|
      question
    end
  end

  def self.authored_replies(user_id)
    data = Replies.find_by_user_id(user_id)
    return nil unless data
    data.map do |reply|
      reply
    end
  end

  def followed_questions
    data = QuestionFollows.followed_questions_for_user_id(@id)
    return nil unless data
    data
  end

  def liked_questions
    data = QuestionLikes.liked_questions_for_user_id(@id)
    return nil unless data
    data
  end

#   I used a LEFT OUTER JOIN to combine the questions and question_likes table.
# You need questions so you can filter by the author, and you need question_likes so you can count the number of likes.

  def average_karma
    data = QuestionsDatabase.instance.execute(<<-SQL)

      SELECT
        COUNT(question_likes.id) / CAST(COUNT(DISTINCT(questions.id)) AS FLOAT)
      FROM
        questions
      LEFT OUTER JOIN
        question_likes ON question_likes.question_id = questions.id
      WHERE
        questions.author = #{@id}
    SQL
  end

  def initialize(attributes)
    @id = attributes["id"]
    @fname = attributes["fname"]
    @lname = attributes["lname"]
  end

end
