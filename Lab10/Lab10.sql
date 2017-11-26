-- function PreReqsFor(courseNum) - Returns the immediate prerequisites for the
-- passed-in course number.
create or replace function prereqsfor(int, REFCURSOR) returns refcursor as
$$
declare
   course_num int       := $1;
   resultset   REFCURSOR := $2;
begin
   open resultset for
      select prereqnum
      from   prerequisites
      where  coursenum = course_num;
   return resultset;
end;
$$
language plpgsql;

SELECT prereqsfor(499, 'results');
FETCH ALL FROM results;


-- function IsPreReqFor(courseNum) - Returns the courses for which the passed-in course
-- number is an immediate pre-requisite.
create or replace function isprereqfor(int, REFCURSOR) returns refcursor as
$$
declare
   course_num int       := $1;
   resultset   REFCURSOR := $2;
begin
   open resultset for
      select coursenum
      from   prerequisites
      where  prereqnum = course_num;
   return resultset;
end;
$$
language plpgsql;

SELECT isprereqfor(499, 'results');
FETCH ALL FROM results;
