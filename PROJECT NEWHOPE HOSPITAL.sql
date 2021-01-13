CREATE SCHEMA Facilities;
go

CREATE SCHEMA Management;
go

CREATE SCHEMA HumanResources;
go
 
CREATE SCHEMA Patients;
go



CREATE TABLE Facilities.Ward_Details
(Ward_ID int Primary Key Identity (100,1),
WardName Varchar(30) CHECK(WardName IN('OPD', 'ICU','CCU','Spl_Ward','General_Ward','Emergency')), 
TotalBed Varchar(10) Not Null,
Ward_Charge int  Not Null,
AvailBed Varchar (10) Not Null,
);

INSERT INTO Facilities.Ward_Details
Values('OPR','15','4000','4'),
      ('ICU','8','5000','3'),
	  ('CCU','10','6000','2'),
	  ('Spl_Ward','10','4500','3'),
	  ('General_Ward','50','3000','5'),
	  ('Emergency','35','2500','2')

    
	  
CREATE TABLE HumanResources.DoctorDetails
(DoctorID int Primary Key Identity(200,1),
FirstName Varchar(20) Not Null,
LastName Varchar(20) Not Null,
Address Varchar (80) Not Null,
Phone_Num Varchar(20) CHECK(Phone_Num LIKE '[0-9][0-9]-[0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]-[0-9][0-9][0-9]-[0-9][0-9][0-9]') NOT NULL,
Employment_Type Varchar(20) CHECK(Employment_Type IN('Residence', 'Visiting')),
Ward_ID int FOREIGN KEY REFERENCES Facilities.Ward_Details(Ward_ID),
Specialization varchar(40) 
);



INSERT INTO HumanResources.DoctorDetails
Values('James', 'John', 'plot 34 wilson street NewYork', '11-222-3333-444-555', 'Visiting','104','Pediatrician'), 
      ('Chris', 'Abraham',' 3111 Doctors Drive Los Angeles Califonia','12-123-2222-232-312','Residence','102','Cardiologist'),
	  ('Sarah','Scofield','No 22 Obama way  NewYork','33-456-4567-555-432','Visiting','101','Oncologist'),
	  ('Meredith','Grey','3110 Doctors Drive Los Angeles Califonia','32-432-2743-677-200','Residence','100','Plastic Surgeon'),
	  ('Alex','Karev','3112 Doctors Drive Los Angeles Califonia','00-103-2007-355-222','Residence','103','Neurologist'),
	  ('Mark', 'Sloan','3114 Doctors Drive Los Angeles Califonia','22-122-8007-376-107','Residence','105','Pathologist')

 

CREATE TABLE Patients.PatientDetails
(PatientID int Primary Key Identity (300,1),
FirstName Varchar(30) ,
LastName Varchar(30),
Address Varchar (50),
Weight int,
Height int,
Age int,
Blood_Grp Varchar(5)CHECK(Blood_Grp IN( 'A' , 'B' ,'AB','O')) ,
Admit_Date date,  
Discharge_Date date,
Treatment_Type Varchar(25) Not Null,
DoctorID int  FOREIGN KEY REFERENCES HumanResources.DoctorDetails(DoctorID),
Ward_ID int FOREIGN KEY REFERENCES Facilities.Ward_Details(Ward_ID),
Phone_Num  Varchar(20)CHECK (Phone_Num LIKE '[0-9][0-9]-[0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]-[0-9][0-9][0-9]-[0-9][0-9][0-9]'),
 ); 




INSERT INTO Patients.PatientDetails
Values('Abraham','Cole','245 Tin MaryLand ','15','70',datediff(yy,'06/29/2015',getdate()),
	  'A','02/22/2018','02/26/2018','Flu shot','200','104','03-243-2351-886-090')
	  ,
      ('Venus','Anthony', '3322 Bill Clinton Drive Maryland','60','155',datediff(yy,'10/20/1985',getdate()),
	  'B','09/21/2018','10/14/2018','Corticosteroids drugs','204','103','02-243-4212-886-070'),
	  
	  ('Marcus','Rashford','200 E MAIN ST Pheonix Arizona','84','167',datediff(yy,'11/02/1990',getdate()),
	   'AB','03/12/2018','03/14/2018','Iron Supplements','203','100','33-212-0976-365-222'),

	  ('Micheal','Owen','100 MAIN ST SEATTLE WA USA','76','70',datediff(yy,'09/12/2009',getdate()),'A',
	  '09/15/2018','09/18/2018','allergy shots','205','105','21-298-2309-990-125'),

	  ('Jane','Roe','300 BOYLSTON AVENUE SEATTLE WA USA','66','166',datediff(yy,'08/30/1992',getdate()),
	  'O','05/24/2018','06/15/2018','Surgical treatment','202','101','01-745-4321-666-832'),


	  ('James','Robert','380 BOYLSTON AVENUE SEATTLE WA USA','24','103',datediff(yy,'07/07/2012',getdate()),
	  'O','08/04/2018','08/30/2018','Heart Transplant','201','102','01-473-4311-636-800'),

      ('Larry','Adam','380 BOYLSTON AVENUE SEATTLE WA USA','60','160',datediff(yy,'07/03/1986',getdate()),
	  'O','03/04/2019','03/30/2018','Heart Transplant','201','102','01-000-4221-493-598')


CREATE TABLE Patients.MedicalHistory
(RecordID int Primary Key Identity (1000,1),
PatientID  int  FOREIGN KEY REFERENCES Patients.PatientDetails(PatientID),
DoctorID int  FOREIGN KEY REFERENCES HumanResources.DoctorDetails(DoctorID),
Disease Varchar (20) Not Null,
Original_Ward int FOREIGN KEY REFERENCES Facilities.Ward_Details(Ward_ID)Not Null,
Discharge_Ward int FOREIGN KEY REFERENCES Facilities.Ward_Details(Ward_ID)Not Null,
);

 --alter table patients.MedicalHistory
 --check constraint FK__MedicalHi__Disch__30F848ED
 --sp_help 'Patients.MedicalHistory'

INSERT INTO Patients.MedicalHistory
Values('300','200','Flu','104','103'),
      ('301','204','Autoimmune','103','104'),
	  ('302','203','Anemia','100','104'),
	  ('303','205','Asthma attack','105','101'),
	  ('304','202','Fractured Arm','101','100'),
	  ('305','201','Heart Disease','102','101')



CREATE TABLE Management.PaymentDetails
(PaymentID int Primary Key Identity (2000,1),
PatientID  int  FOREIGN KEY REFERENCES Patients.PatientDetails(PatientID),
PaymentDate date, 
Payment_Method Varchar(30) CHECK(Payment_Method IN ('Cash','Cheque','Credit_Card')) ,
CreditCard_Num char(20),
AdvancePayment int not null,
CardHolders_Name Varchar(30),
Cheque_Num int,
FinalPayment int,
Payment_status Varchar(10) CHECK(Payment_status IN('Paid','Pending')) Not Null,
Check((Payment_Method = 'Cash'and CreditCard_Num is null and CardHolders_Name is null and Cheque_Num is null)
or(Payment_Method ='Credit_Card'and CreditCard_Num is not null and CardHolders_Name is not null and Cheque_Num is null)
or (Payment_Method ='Cheque' and CreditCard_Num is null and CardHolders_Name is null and Cheque_Num is not null)) 
);



INSERT INTO Management.PaymentDetails
VALUES(300,'06/20/2018','Cash',null,10000,null,null,null,'Paid'),
      (301,'10/14/2018','Cash',null,20000,null,null,null,'Paid'),
	  (302,'03/14/2018','Cheque',null,7000,null,002345,null,'Pending'),
	  (303,'09/18/2018','Credit_Card','123456789056',6000,'Micheal Owen',null,null,'Paid'),
	  (304,'06/15/2018','Cheque',null,60000,null,223432,null,'Pending'),
	  (305,'08/30/2018','Credit_Card','223468905432',60000,'Eva Robert',null,null,'Paid');

	  
	  

	
--UPDATE Management.PaymentDetails
--SET AdvancePayment= 60000
--WHERE PatientID='304'	
	
	 

CREATE TRIGGER PaymentAmount ON Management.PaymentDetails
after INSERT, UPDATE
AS
  BEGIN
        update Management.PaymentDetails
		set FinalPayment = (select w.Ward_Charge	* datediff(dd, p.Admit_Date, p.Discharge_Date)) - pm.AdvancePayment
		from inserted i join Management.PaymentDetails pm 
		on i.patientid = pm.patientid
		join Patients.PatientDetails p
		on pm.PatientID = p.PatientID
		join Facilities.Ward_Details w
		on w.Ward_ID = p.Ward_ID
  END


  SELECT d.FirstName + ' ' + d.LastName AS DoctorName, 
  W.WardName Ward, P.Admit_Date Admission_Date FROM 
  Facilities.Ward_Details W JOIN  HumanResources.DoctorDetails d On W.Ward_ID = d.Ward_ID
  JOIN Patients.PatientDetails p on d.DoctorID = d.DoctorID
  WHERE datepart(mm, p.Admit_Date)= datepart(mm,getdate())
  
   --and datepart(yy, p.Admit_Date)= datepart(yy,getdate())


  Create Index Admit_Date ON Patients.PatientDetails(Admit_Date,Discharge_Date)

  Create Index Payment_status ON Management.PaymentDetails(Payment_status)

   Select WardName,AvailBed,FirstName + ' ' + LastName AS DoctorName FROM Facilities.Ward_Details w
   join HumanResources.DoctorDetails d on w.Ward_ID= d.Ward_ID

    