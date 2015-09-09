require_relative 'questionsdatabase.rb'
require_relative 'users.rb'
require_relative 'questionlikes.rb'

class Questions
  TABLE_NAME = "questions"

  attr_accessor :id, :title, :body, :author

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
    Questions.new(data)
  end

  def self.find_by_author_id(author_id)
    data = QuestionsDatabase.instance.execute(<<-SQL, author_id)
      SELECT
        *
      FROM
        #{TABLE_NAME}
      WHERE
        author = ?
    SQL
    return nil unless data
    data.map do |attributes|
      Questions.new(attributes)
    end
  end

  def author
    data = Users.find_by_id(@author)
    return nil unless data
    data
  end

  def replies
    data = Replies.find_by_question_id(@id)
    return nil unless data
    data
  end

  def followers
    data = QuestionFollows.followers_for_question_id(@id)
    return nil unless data
    data
  end

  def self.most_followed
    data = QuestionFollows.most_followed_questions(1)
    return nil unless data
    data
  end

  def likers
    data = QuestionLikes.likers_for_question_id(@id)
    return nil unless data
    data
  end

  def num_likes
    data = QuestionLikes.num_likes_for_question_id(@id)
    return nil unless data
    data
  end

  def self.most_liked(n)
    data = QuestionLikes.most_liked_questions(n)
    return nil unless data
    data
  end

  def save(title, body, author)
    if @id.nil?
      id = SQLite3::Database.last_insert_row_id
      insert_into_database(id, title, body, author)
    else
      update_database(@id, title, body, author)
    end
  end

  def insert_into_database(title, body, author)
    data = QuestionsDatabase.instance.execute(<<-SQL)
      INSERT INTO
        #{TABLE_NAME}
        ('id', 'title', 'body', 'author')
      VALUES
        (

        )

    SQL
  end

  def update_database
    data = QuestionsDatabase.instance.execute(<<-SQL)
    SQL
  end

  def initialize(attributes)
    @id = attributes["id"]
    @title = attributes["title"]
    @body = attributes["body"]
    @author = attributes["author"]
  end

end
