\! clear
DROP FUNCTION AvgRating() CASCADE;
CREATE FUNCTION AvgRating () RETURNS trigger AS $$
BEGIN
	if EXISTS (SELECT studentID
				 FROM Ratings
				WHERE studentID = NEW.studentID)
	then UPDATE Ratings SET
			    averageRating=sub.averageRating
		   FROM (SELECT studentID, AVG(rating) AS averageRating
				   FROM Student
				  WHERE Student.studentID=NEW.studentID
				  GROUP BY studentID) AS sub
		  WHERE sub.studentID=Ratings.studentID;
	else INSERT INTO Ratings
		 SELECT studentID, AVG(rating)
		   FROM Student
		  WHERE Student.studentID=NEW.studentID
		  GROUP BY studentID;
	end if;
	return NEW;
END; $$
LANGUAGE plpgsql;
CREATE TRIGGER computeAvg AFTER INSERT
    ON Student
       FOR EACH ROW
       EXECUTE PROCEDURE AvgRating();

DELETE FROM Student;
DELETE FROM Ratings;
INSERT INTO Student VALUES ( 1,  3,  5),
						   ( 7,  3, 10),
						   (12,  3,  3),
						   ( 1,  1,  4),
						   ( 1,  2,  1),
						   ( 2,  1,  4);
INSERT INTO Student VALUES ( 2,  2,  1);
INSERT INTO Student VALUES ( 3,  1,  4);
INSERT INTO Student VALUES ( 3,  2,  1);
INSERT INTO Student VALUES ( 5,  1,  2);
INSERT INTO Student VALUES ( 9,  2,  8);
							

SELECT * FROM Student;
SELECT StudentID AS "ID", round(AVG(rating), 2) AS "Rating" FROM Student GROUP BY StudentID ORDER BY StudentID;					
SELECT studentid AS "ID", averageRating AS "Rating" FROM Ratings ORDER BY StudentID;



\! clear
DROP FUNCTION AvgRating() CASCADE;
CREATE FUNCTION AvgRating () RETURNS trigger AS $$
BEGIN
	INSERT INTO Ratings
	SELECT studentID, AVG(rating)
	  FROM Student
	 WHERE NEW.studentID=Student.studentID
	 GROUP BY studentID;
	return NEW;
END; $$
LANGUAGE plpgsql;


-- http://stackoverflow.com/questions/37402761/sql-trigger-for-average

CREATE TABLE Student (
	teacherID INTEGER, 
	studentID INTEGER,
	rating	  INTEGER,
			  UNIQUE(studentID, teacherID) );
CREATE TABLE Ratings (
	studentID 	  INTEGER,
	averageRating NUMERIC(4, 2) );

INSERT INTO Ratings VALUES  (3, 7.5);
INSERT INTO Ratings 
	SELECT StudentID, round(AVG(rating), 2)
	  FROM Student
	 GROUP BY StudentID;
