
CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname TEXT NOT NULL,
  lname TEXT NOT NULL
);

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title TEXT NOT NULL,
  body TEXT NOT NULL,
  author_id INTEGER NOT NULL,
  FOREIGN KEY(author_id) REFERENCES users(id)
);

CREATE TABLE question_follows (
  id INTEGER PRIMARY KEY,
  author_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,
  FOREIGN KEY(author_id) REFERENCES users(id),
  FOREIGN KEY(question_id) REFERENCES questions(id)
);

CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  question_id INTEGER NOT NULL,
  author_id INTEGER NOT NULL,
  reply_id INTEGER,
  body TEXT NOT NULL,
  FOREIGN KEY(question_id) REFERENCES questions(id),
  FOREIGN KEY(reply_id) REFERENCES replies(id),
  FOREIGN KEY(author_id) REFERENCES users(id)
);

CREATE TABLE question_likes (
  id INTEGER PRIMARY KEY,
  author_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,

  FOREIGN KEY(question_id) REFERENCES questions(id),
  FOREIGN KEY(author_id) REFERENCES users(id)
);

INSERT INTO
  users (fname, lname)
VALUES
  ('Eli', 'Siegel'),
  ('Matthew', 'Duek');

INSERT INTO
  questions (title, body, author_id)
VALUES
  ('first question', 'how are you?', (SELECT id FROM users WHERE fname = 'Eli')),
  ('second', 'good, you?', (SELECT id FROM users WHERE fname = 'Matthew')),
  ('Eli second question', 'what?', (SELECT id FROM users WHERE fname = 'Eli'));

INSERT INTO
  question_follows (author_id, question_id)
VALUES
  ((SELECT id FROM users WHERE fname = 'Eli'), (SELECT id from questions WHERE title = 'first question')),
  (2, 1),
  ((SELECT id FROM users WHERE fname = 'Matthew'), (SELECT id from questions WHERE title = 'second')),
  ((SELECT id FROM users WHERE fname = 'Eli'), (SELECT id from questions WHERE title = 'Eli second question'));

INSERT INTO
  replies (question_id, author_id, reply_id, body)
VALUES
  (1, 1, null, "I am well"),
  (2, 2, null, "I am too"),
  (1, 2, 1, "I am glad you are well");

INSERT INTO
  question_likes (author_id, question_id)
VALUES
  (1, 1),
  (2, 2),
  (2, 1),
  (1, 3);

-- INSERT INTO
--   playwrights (name, birth_year)
-- VALUES
--   ('Arthur Miller', 1915),
--   ('Eugene O''Neill', 1888);
--
-- INSERT INTO
--   plays (title, year, playwright_id)
-- VALUES
--   ('All My Sons', 1947, (SELECT id FROM playwrights WHERE name = 'Arthur Miller')),
--   ('Long Day''s Journey Into Night', 1956, (SELECT id FROM playwrights WHERE name = 'Eugene O''Neill'));
