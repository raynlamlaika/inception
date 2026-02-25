how sql is actully works

first the exec flow is gets by:
    atabase Management System (DBMS) where we call the base that we want
    PostgreSQL -> MySQL -> Oracle Database -> Microsoft SQL Server

we send the query -> nex is the parsing 'synax stuff' -> Query Planner optimization phase -> execution engine -> Storage Layer
                -> Transactions & ACID


are coded
    PostgreSQL → C
    MySQL → C/C++
    SQLite → C

SQL text
   ↓
Parser
   ↓
Planner (optimizer)
   ↓
Execution plan
   ↓
Storage engine
   ↓
Disk / Memory