DROP TABLE IF EXISTS users;

CREATE TABLE users (
  id INTEGER PRIMARY_KEY NOT NULL,
  fname VARCHAR(255) NOT NULL,
  lname VARCHAR(255) NOT NULL
);

DROP TABLE IF EXISTS questions;

CREATE TABLE questions (
  id INTEGER PRIMARY_KEY NOT NULL,
  title VARCHAR(255) NOT NULL,
  body VARCHAR(255) NOT NULL,
  author INTEGER REFERENCES users(id)
);

DROP TABLE IF EXISTS question_follows;

CREATE TABLE question_follows (
  id INTEGER PRIMARY_KEY NOT NULL,
  user_id INTEGER REFERENCES users(id),
  question_id INTEGER REFERENCES questions(id)
);

DROP TABLE IF EXISTS replies;

CREATE TABLE replies (
  id INTEGER PRIMARY_KEY NOT NULL,
  body VARCHAR(255) NOT NULL,
  question_id INTEGER REFERENCES questions(id),
  parent_reply_id INTEGER REFERENCES replies(id) DEFAULT NULL,
  user_id INTEGER REFERENCES users(id)
);

DROP TABLE IF EXISTS question_likes;

CREATE TABLE question_likes (
  id INTEGER PRIMARY_KEY NOT NULL,
  question_id INTEGER REFERENCES questions(id),
  user_id INTEGER REFERENCES users(id)
);

INSERT INTO
  users (id, fname, lname)
VALUES
  (1, 'Jason', 'Bourne'),
  (2, 'Michelle', 'Bourne'),
  (3, 'Michael', 'Jordan'),
  (4, 'Jordan', 'Mike'),
  (5, 'Javier', 'Castro'),
  (6, 'Yoshi', 'Luk');

INSERT INTO
  questions (id, title, body, author)
VALUES
  (1, "How do you do sql?", "fjdaklfjdsaklgjkal", 2),
  (2, "How many moons?", "fjdaklfjdsaklgjkal", 3),
  (3, "Why?", "fjdaklfjdsaklgjkal", 1),
  (4, "Who?", "fjdaklfjdsaklgjkal", 1),
  (5, "Where?", "fjdaklfjdsaklgjkal", 2);

INSERT INTO
  question_follows (id, user_id, question_id)
VALUES
  (1, 1, 3),
  (2, 2, 3),
  (3, 3, 1),
  (4, 2, 2),
  (5, 3, 2),
  (6, 4, 2),
  (7, 5, 2),
  (8, 6, 2);

INSERT INTO
  replies (id, body, question_id, parent_reply_id, user_id)
VALUES
  (1, "Parent1", 2, NULL, 2 ),
  (2, "Child1 of Parent1", 2, 1, 1 ),
  (3, "Parent2", 4, NULL, 3 ),
  (4, "Child of Parent2", 4, 3, 1 );

  INSERT INTO
  question_likes(id, question_id, user_id)
  VALUES
  (1, 2, 1),
  (2, 3, 3),
  (3, 2, 3),
  (4, 2, 4),
  (5, 2, 5),
  (6, 2, 6),
  (7, 2, 2),
  (8, 1, 1),
  (9, 3, 5),
  (10, 4, 6);
