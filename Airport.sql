--create database AirportSalfordDB

--create table employee
create table Employee (
EmployeeID int identity(1,1) primary key,
Username nvarchar(50) not null unique,
[Role] varchar(50) not null check ([Role] in ('Ticketing Staff', 'Ticketing Supervisor')),
FirstName nvarchar(50) not null,
LastName nvarchar(50) not null,
Email nvarchar(100) not null check (Email like '%_@__%.%' ),
[Password] varchar(250) not null check (
        len([Password]) >= 8 and
        [Password] like '%[A-Z]%' and
        [Password] like '%[a-z]%' and
        [Password] like '%[0-9]%'
    )
)

--insert values to employee table
insert into Employee (Username, [Password], [Role], FirstName, LastName, Email)
values
('1371ali', 'aA224340', 'Ticketing Staff', 'Ali','Sohrabi','alisohrabi1371@gmail.com'),
('1366cina', '501A650B', 'Ticketing Staff', 'Cina','Sarkhosh','cinask1366@gmail.com'),
('1380rez', 'R95P43N5','Ticketing Supervisor','Pouyan','Rezaee','PouyanRezaee1380@gmail.com'),
('1375reza', 'rRJb3478', 'Ticketing Staff','Reza','Jenab','RezaJenab1375@gmail.com'),
('1356amir', '32vaRz87','Ticketing Staff', 'Amir','Varzani','AmirVarzani1356@gmail.com'),
('1344aryan', 'AN4379ai','Ticketing Staff','Aryan','Asadi','AryanAsadi1344@gmail.com'),
('1377kasra',  'Ka5476Ni','Ticketing Staff','Kasra','Naseri','KasraNaseri1377@gmail.com');

--show table contains
select * from Employee
go

--create table passanger
create table Passenger (
PassengerID int identity(1,1) primary key,
Meal nvarchar(50) check (Meal in ('vegetarian', 'non-vegetarian')) not null,
DOB date not null check (DOB <= getdate()),
Firstname nvarchar(50) not null,
Lastname nvarchar(50) not null,
Email nvarchar(100) unique not null check (Email like '%_@%.__%' ),
EmergencyNumber varchar(20) check (EmergencyNumber is null or 
        (EmergencyNumber like '0%' and len(EmergencyNumber) >= 10) ) 
    )

insert into Passenger (Email, Meal, DOB, Firstname,Lastname,EmergencyNumber)
values
('Mitramdi1376@gmail.com','non-vegetarian','1976/03/04','Mitra','Mahmoudi','09174805016'),
('anahitamdiiii1831@gmail.com','non-vegetarian','2002/05/26','Ana','Mahmoudi','09359570750'),
('aidamoslemi20@gmail.com','vegetarian','2002/12/10','Aida','Moslemi',null),
('farnooshrzvi2903@gmail.com','vegetarian','1998/06/15','Farnoosh','Razavi',null),
('kimiafriii7791@gmail.com','non-vegetarian','1977/07/05','Kimia','Faramarzi','09164866850'),
('ilunnasrin2345@gmail.com','vegetarian','1980/09/18','Nasrin','Ilun',null),
('nazebrahimi6870@gmail.com','non-vegetarian','1969/07/21','Nazanin','Ebrahimi','09177165016');

select * from Passenger
go

--create table flight
create table Flight (
    FlightID int identity(1,1) primary key ,
    FlightNumber varchar(20) not null unique,
  Origin nvarchar(100) not null,
    Destination nvarchar(100) not null,
    DepartureTime datetime not null,
    ArrivalTime datetime not null,
    check (ArrivalTime > DepartureTime)
)

insert into Flight (FlightNumber,Origin,Destination,DepartureTime,ArrivalTime)
values
('IR720','Shiraz','Manchester','2024-08-10 08:00:00', '2024-08-10 09:30:00'),
('IR721','Istanbul ','Tabriz','2024-12-10 01:00:00', '2024-12-10 05:30:00'),
('IR722','Tehran ','Kish','2024-02-13 16:15:00', '2024-02-13 22:45:00' ),
('IR723','Frankfurt','Isfahan','2024-04-22 12:00:00', '2024-04-22 16:20:00'),
('IR724','Tehran','Shiraz' ,'2024-11-09 08:30:00', '2024-11-09 10:00:00'),
('IR725','Paris', 'Kish ', '2024-05-10 08:00:00', '2024-05-10 14:30:00'),
('IR726','Shiraz','Sydney','2024-08-13 04:20:00', '2024-08-13 23:50:00')

select * from Flight
go

--create table Seat
create table Seat (
    SeatID int identity(1,1) primary key not null,
    SeatNumber varchar(20) not null , 
    SeatType varchar(20) check (SeatType in ('Window', 'Aisle')),
    [Status] varchar(20) check ([Status]in ('Available', 'Reserved', 'Occupied')),
  FlightID int not null foreign key(FlightID) references Flight(FlightID),
  unique(SeatNumber , FlightID)
)
insert into Seat(SeatNumber, SeatType, [Status], FlightID)
values
('A10', 'Aisle', 'Reserved',1 ),
('B10', 'Aisle','Reserved',2),
('C10','Window','Reserved',3),
('A11', 'Aisle','Available',4),
('B11', 'Aisle', 'Occupied',5),
('C11','Window','Reserved',6),
('A12', 'Aisle','Available',7)


select * from Seat
go

--create table reservation
create table Reservation (
  PNR  int identity(7000,1) primary key,
    PreferredSeat varchar(20), --check (PreferredSeat in ('Aisle','Window')or PreferredSeat is null), 
    Bookingdate date not null ,
    [Status] varchar(50) not null check ([Status] in ('cancelled','confirmed', 'pending','rebooked')),
  PassengerID int not null foreign key(PassengerID) references Passenger(PassengerID),
  FlightID int not null foreign key(FlightID) references Flight(FlightID),
  unique(PassengerID, FlightID)
)

insert into Reservation ( PreferredSeat, [Status], Bookingdate, PassengerID, FlightID)
values
('Aisle'    ,  'confirmed' , '2025-08-10' ,   1 , 1 ),
('Window' , 'pending'  ,    '2025-08-11' ,   2 , 2 ),
('Aisle'  ,  'confirmed' , '2025-08-12'  ,  3 , 3 ),
('Window' , 'confirmed' ,  '2025-08-13' ,  4 , 4 ),
('Window' , 'cancelled' ,   '2025-08-14' ,  5 , 5 ),
('Aisle'   ,   'confirmed' ,  '2025-08-15' ,  6 , 6 ),
(null    ,     'pending'  ,   '2025-08-16' ,  7 , 7 );

select * from Reservation
go


--create table ticket
create table Ticket (
    TicketID int identity(1,1) primary key,
    Issuedate date not null default cast(getdate() as date),
  IssueTime time not null default cast(getdate() as time(0)),
    Fare decimal(10, 2) not null check (Fare>0),
    Class varchar(50) not null check (Class in ('Business', 'Firstclass', 'Economy')),
    eBoardingnumber varchar(20) null ,
  PNR int not null foreign key(PNR) references Reservation(PNR),
  EmployeeID int not null foreign key(EmployeeID) references Employee(EmployeeID),
  SeatID int  not null foreign key (SeatID) references Seat(SeatID),
  FlightID int not null foreign key(FlightID) references Flight(FlightID)
)
go
create trigger Generate_eBoardingnumber
on Ticket
after insert
as
begin
    update T
    set eBoardingnumber =  F.FlightNumber + '-' +  cast(T.TicketID as  varchar) + '-' + S.SeatNumber
    from Ticket T
    inner join inserted I on I.TicketID = T.TicketID
  inner join Reservation R on R.PNR = T.PNR
    inner join Flight F on F.FlightID = R.FlightID
    inner join Seat S on S.SeatID = T.SeatID;
end;
go

insert into Ticket( Issuedate, Issuetime, Fare ,Class, EmployeeID, SeatID, PNR, FlightID)
values
--flight 1
(cast(getdate() as date), cast(getdate() as time(0)), 650.00 , 'Firstclass', 1 , 1, 7000 , 1),
(cast(getdate() as date), cast(getdate() as time(0)), 400.00,  'Business', 2 ,  2, 7001 , 1),
--flight 3
(cast(getdate() as date), cast(getdate() as time(0)), 220.00,  'Economy', 5 ,  3, 7002, 3),
(cast(getdate() as date), cast(getdate() as time(0)), 430.00,   'Firstclass',7 ,  4, 7003, 3),
-- flight 5
(cast(getdate() as date), cast(getdate() as time(0)), 250.00, 'Economy',1  ,5 , 7004 , 5),
(cast(getdate() as date), cast(getdate() as time(0)), 200.00, 'Economy', 3  ,6 , 7005 , 5),
--flight 7
(cast(getdate() as date), cast(getdate() as time(0)), 500.00, 'Business', 4  , 7, 7006 , 7)

select * from Ticket
go

--create table baggage 
create table Baggage (
    BaggageID int identity(1,1) primary key not null,
    Weightkg decimal(5, 2) not null check (WeightKG > 0),
  NumberOfBags int not null check (NumberOfBags >= 1),
    [Status] nvarchar(50) not null check ([Status] in ('Checkedin', 'Loaded')),
  TicketID int not null foreign key(TicketID) references Ticket(TicketID)
  )

 insert into Baggage(Weightkg, NumberOfBags,[Status], TicketID)
 values
    (23.50, 1, 'Checkedin', 1),
    (29.00, 5, 'Checkedin', 2),
    (30.00, 2 ,'Checkedin', 3),
    (18.50, 1, 'Loaded'     , 4),
    (26.50,7 , 'Checkedin', 5),
    (40.00, 5, 'Loaded'    , 6),
    (13.50, 3, 'Loaded'     , 7)

select * from Baggage
go

-- create table additional services 
create table [Service] (
    ServiceID int identity(1,1) primary key,
    ExtraBaggage decimal(5,2) default 0.00 check (ExtraBaggage >= 0)null,
    UpgradedMeal bit default 0  null,
    PreferredSeat bit default 0  null,
  TotalServiceFee as ( 
  (isnull(ExtraBaggage,0) * 100) + 
        (case 
           when UpgradedMeal = 1  then 20
         else 0
      end) + 
        (case when PreferredSeat = 1  then 30 
    else 0 
     end)
    ) persisted,
  TicketID int foreign key (TicketID) references Ticket(TicketID) not null)

insert into[Service] (ExtraBaggage, UpgradedMeal, PreferredSeat, TicketID)
values
(2.50, 1 ,    1    , 1 ),       --   300 = 250 + 20 + 30 
(1.00, null, null, 2 ), --   100 = 100 + 0 + 0  
(null, 1   ,   1   ,   3 ),        -- 50 = 0 + 20 + 30
(3.00, 1,  null,    4 ),     --  320 = 300 + 20 + 0
(null, null , null , 5 ), --  0 = 0 + 0 + 0
(1.50, null , 1 ,    6 ),    -- 180 = 150 + 0 + 30
(null,   1 ,  null ,   7)      --20 = 0 + 20 + 0

select * from [Service]
go


--2) Add the constraint to check that the reservation date is not in the past.
alter table Reservation
add constraint ReservationDateNotPast
check (Bookingdate >=cast(getdate() as date));
go

 -- Test 
insert into Reservation ( PreferredSeat, [Status], Bookingdate, PassengerID, FlightID)
values('successful test', 'confirmed', '2025-09-10', 2, 1);

--insert into Reservation ( PreferredSeat, [Status], Bookingdate, PassengerID, FlightID)
--values('failed test', 'confirmed', '2024-09-10', 3, 1)
select * from Reservation
go


--3 Identify Passengers with Pending Reservations and Passengers with age more than 40 years.
select P.Firstname, P.Lastname, P.DOB, R.[Status]
from Passenger P
inner join Reservation R on P.PassengerID = R.PassengerID
where (R.[Status] = 'pending' and datediff(year , P.DOB, getdate()) > 40)
        
go


--4)stored procedures or user-defined functions
-- part a-4 : matching character strings by last name of passenger. Results should be sorted with most recent issued ticket first.
create procedure FindPassengerByLastname
   @SearchLastname nvarchar(50)
as begin 
  select P.Firstname, P.Lastname, T.Issuedate, T.Issuetime
  from Passenger P
  join Reservation R on P.PassengerID = R.PassengerID
  join Ticket T on R.PNR = T.PNR 
  where P.Lastname like '%' + @SearchLastname + '%'
  order by T.Issuedate desc, T.Issuetime desc;
end;
go

--test
exec FindPassengerByLastname @SearchLastname = 'Mahmoudi';
go


--part b-4: Return a full list of passengers and his/her specific meal requirement in business class who has a reservation today 
create procedure TodayBusinessMeal
as
begin
    select 
        P.FirstName, P.LastName, P.Meal, T.Class, R.BookingDate
    from 
        Passenger P
   inner join 
        Reservation R on P.PassengerID = R.PassengerID
  inner  join 
        Ticket T on R.PNR = T.PNR
    where 
        R.BookingDate  = cast(getdate() as date) and T.Class = 'Business' and R.Status = 'confirmed';
end


--test
insert into Passenger (Email, Meal, DOB, Firstname,Lastname,EmergencyNumber)
values ('test@gmail.com', 'non-vegetarian', '2001/04/15', 'Ehsan', 'Azmoun', '09174885216')
select * from Passenger
insert into Reservation ( PreferredSeat, [Status], Bookingdate, PassengerID, FlightID)
values('test', 'confirmed', cast(getdate() as date), 8, 1)
select * from Reservation
insert into Seat(SeatNumber, SeatType, [Status], FlightID)
values('B12', 'Aisle', 'Available',1)
select * from Seat
insert into Flight (FlightNumber, Origin, Destination, DepartureTime, ArrivalTime)
values ('IR727', 'Tehran', 'Dubai', '2025-05-01 14:00:00', '2025-05-01 16:30:00')
select * from Flight
insert into Ticket( Issuedate, Issuetime, Fare,Class, EmployeeID, SeatID, FlightID, PNR)
values(cast(getdate() as date), cast(getdate() as time(0)), 750.00 , 'Business', 1 , 8, 8, 7008)
select * from Ticket
go

select * from Reservation as R inner join Passenger as P on P.PassengerID=R.PassengerID
exec TodayBusinessMeal;
go

--part c-4: Insert a new employee
create procedure InsertEmployee
   @Username nvarchar(50),
   @Password varchar(50),
   @Role nvarchar(20),
   @Firstname nvarchar(50), 
   @Lastname nvarchar(50),
   @Email nvarchar(100)
as
begin
   if @Role not in ('Ticketing Staff', 'Ticketing Supervisor')
    begin
        print 'Error: Invalid role. "Ticketing Staff" or "Ticketing Supervisor".';
        return;
  end
    if @Email not like '%@%.%'
    begin
        print 'Invalid Email';
        return;
  end
  if exists (select 1 from Employee where Username = @Username)
    begin
        print' Invalid Username';
        return;
  end
    if exists (select 1 from Employee where [Password] = @Password)
    begin
        print'Invalid Password ';
        return;
  end
  insert into Employee (Username, [Password], [Role], Firstname, Lastname, Email)
    values (@Username, @Password, @Role, @Firstname, @Lastname, @Email);
end

--test
--exec InsertEmployee 
 --   @Username = 'faildTest',
--    @Password = '5050',
--    @Role = 'Ticketing Staff',
 --   @FirstName = 'naser',
 --   @LastName = 'Parastui',
 --   @Email = 'nasertest@google.com'

exec InsertEmployee 
    @Username = 'Test',
    @Password = '6642TtPp',
    @Role = 'Ticketing Staff',
    @FirstName = 'Parviz',
    @LastName = 'Parastui',
    @Email = 'parvizparastuiii@google.com'

go
select * from Employee
go


-- part d-4: Update the details for a passenger that has booked a flight before.
create procedure UpdatePassenger 
   @PassengerID int,
    @Firstname nvarchar(50),
    @Lastname nvarchar(50),
   @Email nvarchar (50),
   @Meal nvarchar  (50),
   @EmergencyNumber nvarchar (50) 
as 
begin 
  if not exists (select 1 from Reservation where PassengerID = @PassengerID)
    begin
        print'Passenger has no reservation'
        return;
    end
    if @Meal not in ('vegetarian', 'non-vegetarian')
    begin
        print'Invalid meal.'
        return;
    end
    if @Email not like '%@%.%'
    begin
        print'Invalid Email '
        return;
    end
  update Passenger
  set 
       Firstname = @Firstname,
       Lastname = @Lastname,
       Email = @Email,
       Meal = @Meal, 
       EmergencyNumber = @EmergencyNumber
  where PassengerID = @PassengerID;
  end;
  go

  --test
exec UpdatePassenger  -- PassengerID = 1, meal: 'non-vegetarian', emergencynumber: '09174805016'
    @PassengerID = 1,
  @Firstname = 'Mitra',
    @Lastname='Mahmoudi',
    @Email = 'mitra.updated@gmail.com',
    @Meal = 'vegetarian',
    @EmergencyNumber = '0000000000';
  

exec UpdatePassenger --PassengerID = 2,  name = ana
    @PassengerID = 2,
  @Lastname='Mahmoudi',
  @Firstname= 'Anahita',
    @Email = 'anahitamdiiii1831@gmail.com',
    @Meal = 'non-vegetarian',
    @EmergencyNumber = '09177164850';

select * from Passenger
go

--5: view all e-boarding numbersIssued by a Specific Employee /showing the overall revenue generated by that employee on a particular flight/include  fare, additional baggage fees, upgraded meal , preferred seat
create view EmployeeRevenue as
select 
    E.EmployeeID, E.FirstName + ' ' + E.LastName as EmployeeName,  E.[Role],
    T.TicketID, T.eBoardingnumber, T.Issuedate, T.Issuetime, T.Fare as BaseFare, T.Class,S.SeatNumber, 
  (T.Fare + isnull(Srv.TotalServiceFee, 0)) as TotalRevenue,
  F.FlightNumber, F.Origin, F.Destination, F.DepartureTime,F.FlightID, 
    isnull(Srv.TotalServiceFee, 0) as AdditionalServicesFee,
    P.Firstname + ' ' + P.Lastname as PassengerName,
    case 
        when Srv.ExtraBaggage > 0 then 'Yes' + cast(Srv.ExtraBaggage as varchar) + ' kg'
        else 'No'
    end as HasExtraBaggage,
    case 
        when Srv.UpgradedMeal = 1 then 'Yes'
        else 'No'
    end as HasUpgradedMeal,
    case 
        when Srv.PreferredSeat = 1 then 'Yes'
        else 'No'
    end as HasPreferredSeat
from 
    Employee E
inner join 
    Ticket T on E.EmployeeID = T.EmployeeID
inner join 
    Reservation R on T.PNR = R.PNR  
inner join 
    Passenger P on R.PassengerID = P.PassengerID
inner join
    Flight F on R.FlightID = F.FlightID
inner join
    Seat S on T.SeatID = S.SeatID
left join 
    [Service] Srv on T.TicketID = Srv.TicketID;

go
create procedure GeteBoardingnumberByEmployee
      @EmployeeID int 
as 
begin 
   select 
        eBoardingnumber, FlightNumber, Origin, Destination, DepartureTime, BaseFare, AdditionalServicesFee,
        TotalRevenue, Class, Seatnumber, PassengerName, HasExtraBaggage, HasUpgradedMeal, HasPreferredSeat,
        Issuedate, Issuetime
   from EmployeeRevenue 
   where EmployeeID = @EmployeeID 
   order by Issuedate desc, Issuetime desc; 
end;
go

--test
exec GeteBoardingnumberByEmployee @EmployeeID = 1;
go


--6)Create a trigger so that the current seat allotment of a passenger automatically updates to reserved when the ticket is issued.
Create trigger UpdateSeatToReserved
on Ticket
after insert
as
begin
    begin try
        begin transaction;
        update S
        set S.[Status] = 'Reserved'
        from Seat S
        inner join inserted I on S.SeatID = I.SeatID
        where  S.[Status] = 'Available';
        commit transaction;
    end try
    begin catch
        if @@TRANCOUNT > 0
            rollback transaction;
        throw;
    end catch
end;
go

--test
insert into Passenger (Email, Meal, DOB, Firstname,Lastname,EmergencyNumber)
values ('test66@gmail.com', 'vegetarian', '2000/04/15', 'Asra', 'Mirzaie', '09174881216')
select * from Passenger
insert into Reservation ( PreferredSeat, [Status], Bookingdate, PassengerID, FlightID)
values('test6', 'confirmed', cast(getdate() as date), 9, 1)
select * from Reservation
insert into Seat(SeatNumber, SeatType, [Status], FlightID)
values('A13', 'Aisle', 'Available',1)
select * from Seat
insert into Flight (FlightNumber, Origin, Destination, DepartureTime, ArrivalTime)
values ('IR729', 'Shiraz', 'Dubai', '2025-05-10 14:00:00', '2025-05-10 16:30:00')
select * from Flight
insert into Ticket( Issuedate, Issuetime, Fare,Class, EmployeeID, SeatID, FlightID, PNR)
values(cast(getdate() as date), cast(getdate() as time(0)), 550.00 , 'Business', 1 , 9, 1, 7009)
select * from Ticket
go

select SeatID, SeatNumber,[Status] from Seat where SeatID = 9
go

--7)You should provide a function or view which allows the ticketing system to identify the total number of baggage’s (which are checkedin) made on a specified date for a specific flight.
create function countcheckedinbaggage(
    @FlightID int,
    @Date date
)
returns int
as
begin
    declare @totalBags int;
    select @totalBags = sum(B.NumberOfBags)
    from Baggage B
    inner join Ticket T on T.TicketID = B.TicketID
    inner join Flight F on F.FlightID = T.FlightID
    where T.FlightID = @FlightID
        and B.[Status] = 'checkedin'
        and cast(F.DepartureTime as date) = @Date;
    
    return @totalBags;
end;
go

select dbo.countcheckedinbaggage(1, '2024-08-10')  as TotalBags ;
go

--question 8
--a-8) avoid reserve at the same time
create procedure AutoReserveSeatForPassenger
    @PreferredSeatType varchar(20), 
    @Status varchar(50),     
    @PassengerID int,
    @FlightID int
as
begin
    declare @SeatID int;
    begin try
        begin transaction;
        select top 1 @SeatID = SeatID
        from Seat with (rowlock, updlock)
        where [Status] = 'Available' and FlightID = @FlightID and SeatType = @PreferredSeatType;
        if @SeatID is null
        begin
            rollback transaction;
            print ' No available seat.';
            return;
        end;
        update Seat
        set [Status] = 'Reserved'
        where SeatID = @SeatID;
        insert into Reservation (PreferredSeat, [Status], Bookingdate, PassengerID, FlightID)
        values (@PreferredSeatType, @Status, getdate(), @PassengerID, @FlightID);
        commit transaction;
        print ' Reservation completed';
    end try
    begin catch
        if @@TRANCOUNT > 0
            rollback transaction;
        print ' Error occurred';
        throw;
    end catch
end;
go

--test 
insert into Passenger (Email, Meal, DOB, Firstname,Lastname,EmergencyNumber)
values('test8a@gmail.com','non-vegetarian','1986/03/04','test8a','test8a','09179354016')
select * from Passenger
insert into Flight (FlightNumber, Origin, Destination, DepartureTime, ArrivalTime)
values ('IR888', 'Tehran', 'Shiraz', '2025-06-01 10:00:00', '2025-06-01 11:15:00');
select * from Flight
insert into Seat (SeatNumber, SeatType, [Status], FlightID)
values ('W10', 'Window', 'Available', 10); 
select * from Seat
go

exec AutoReserveSeatForPassenger 
    @PreferredSeatType = 'Window',
    @Status = 'confirmed',
    @PassengerID = 10, 
    @FlightID = 10;

select * from Seat where FlightID = 10; 
select * from Reservation where PassengerID = 10; 

go

--8)b
alter table Flight
add Capacity int;
go
update Flight
set Capacity= 5
where FlightID = 3;
go

create procedure IssueTicketbyCheckingcapacity
    @PassengerID int,
    @FlightID int,
    @Class varchar(50),
    @Fare decimal(10,2),
    @EmployeeID int,
    @PreferredSeatType varchar(20) = null 
as
begin
    declare @IssuedCount int, @Capacity int, @AvailableSeatID int, @PNR int;
    select @Capacity = Capacity from Flight where FlightID = @FlightID;
    select @IssuedCount = count(*) from Ticket where FlightID = @FlightID;
   if @IssuedCount >= @Capacity
    begin
        print 'Flight is fully booked. No ticket issued.';
        return;
    end
  select top 1 @AvailableSeatID = SeatID
    from Seat
    where FlightID = @FlightID
      and [Status] = 'Available'
      and (@PreferredSeatType is null or SeatType = @PreferredSeatType)
    order by newid(); 
    if @AvailableSeatID is null
    begin
        print ' All seats for this flight are sold out';
        return;
    end
    insert into Reservation (PreferredSeat, [Status], Bookingdate, PassengerID, FlightID)
    values (@PreferredSeatType, 'confirmed', getdate(), @PassengerID, @FlightID);
    set @PNR = scope_identity();
   insert into Ticket (Issuedate, Issuetime, Fare, Class, EmployeeID, SeatID, PNR, FlightID)
    values (cast(getdate() as date), cast(getdate() as time), @Fare, @Class, @EmployeeID, @AvailableSeatID, @PNR, @FlightID);
    update Seat
    set [Status] = 'Reserved'
    where SeatID = @AvailableSeatID;
    print ' Ticket issued successfully.';
end;
go

-- test
exec IssueTicketbyCheckingcapacity
    @PassengerID = 2,
    @FlightID = 3,
    @Class = 'Economy',
    @Fare = 250.00,
    @EmployeeID = 1,
    @PreferredSeatType = 'Window'; --out put :  All seats for this flight are sold out.
  go

  --c-8) Freeing a Seat After Reservation Cancellation
create trigger FreeSeatOnReservationCancel
on Reservation
after update
as
begin
    begin try
        begin transaction;
        update S
        set S.[Status] = 'Available'
        from Seat S
        inner join Ticket T on T.SeatID = S.SeatID
        inner join inserted I on T.PNR = I.PNR
        inner join deleted D on D.PNR = I.PNR
        where 
            I.[Status] = 'cancelled'
            and D.[Status] <> 'cancelled';
        commit transaction;
    end try
    begin catch
        if @@TRANCOUNT > 0
            rollback transaction;
        throw;
    end catch
end;
go
update S
set S.[Status] = 'Available'
from Seat S
where S.[Status] in ('Reserved', 'Occupied') 
  and S.SeatID in (
      select T.SeatID
      from Ticket T
      inner join Reservation R on R.PNR = T.PNR
      where R.[Status] = 'cancelled'
  );
go
update R
set R.[Status] = 'Rebooked' 
from Reservation R
where R.[Status] = 'cancelled'
  and exists(
      select 1
      from Ticket T
      where T.PNR = R.PNR
        and T.SeatID in (
            select T.SeatID
            from Ticket T
            where T.PNR = R.PNR
        )
  );
  go

select PNR, [Status] from Reservation; -- PNR = 7004 was cancelled and it will be changed to Rebooked

select S.SeatID, S.[Status] from Ticket T    -- seatid = 5 was Occupied and it will be changed to Available
 inner join Seat S on S.SeatID = T.SeatID 
 where T.PNR = 7004;