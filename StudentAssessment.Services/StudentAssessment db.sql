/*
 *  1) Create Database 
 */
DECLARE @DbName NVARCHAR(128) = N'StudentAssessment'


IF NOT EXISTS (	SELECT	name  
				FROM	master.dbo.sysdatabases  
				WHERE	('[' + name + ']' = @DbName 
				OR		name = @DbName))
BEGIN
	CREATE DATABASE StudentAssessment;
END
GO

USE [StudentAssessment]
GO

/*
 *  2) Drop Foreign Key Constraints
 */
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_student_university_id]') AND parent_object_id = OBJECT_ID(N'[dbo].[student]'))
	ALTER TABLE [dbo].[student] DROP CONSTRAINT [FK_student_university_id]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_student_country_id]') AND parent_object_id = OBJECT_ID(N'[dbo].[student]'))
	ALTER TABLE [dbo].[student] DROP CONSTRAINT [FK_student_country_id]
GO

/*
 *  3) Drop Tables
 */
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[university]') AND type in (N'U'))
	DROP TABLE [dbo].[university]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[country]') AND type in (N'U'))
	DROP TABLE [dbo].[country]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[student]') AND type in (N'U'))
	DROP TABLE [dbo].[student]
GO

/*
 *  4) Create Tables
 */
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[university](
	[university_id] [int] IDENTITY(1,1) NOT NULL,
	[university] [nvarchar](100) NOT NULL,
	[updated_utc] [datetime2](7) NOT NULL
 CONSTRAINT [PK_university_id] PRIMARY KEY CLUSTERED 
(
	[university_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

CREATE TABLE [dbo].[country](
	[country_id] [int] IDENTITY(1,1) NOT NULL,
	[country] [nvarchar](100) NOT NULL,
	[updated_utc] [datetime2](7) NOT NULL
 CONSTRAINT [PK_country_id] PRIMARY KEY CLUSTERED 
(
	[country_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

CREATE TABLE [dbo].[student](
	[student_id] [int] IDENTITY(1,1) NOT NULL,
	[first_name] [nvarchar](100) NOT NULL,
	[last_name] [nvarchar](100) NOT NULL,
	[university_id] int NOT NULL,
	[country_id] int NOT NULL,
	[sex] char NOT NULL,
	[age] int NOT NULL,
	[start_date] datetime NOT NULL,
	[degree] [nvarchar](100) NOT NULL,
	[updated_utc] [datetime2](7) NOT NULL
 CONSTRAINT [PK_student_id] PRIMARY KEY CLUSTERED 
(
	[student_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

/*
 *  4) Create Foreign Keys
 */
ALTER TABLE [dbo].[student]  WITH CHECK ADD  CONSTRAINT [FK_student_university_id] FOREIGN KEY([university_id])
REFERENCES [dbo].[university] ([university_id])
GO

ALTER TABLE [dbo].[student] CHECK CONSTRAINT [FK_student_university_id]
GO

ALTER TABLE [dbo].[student]  WITH CHECK ADD  CONSTRAINT [FK_student_country_id] FOREIGN KEY([country_id])
REFERENCES [dbo].[country] ([country_id])
GO

ALTER TABLE [dbo].[student] CHECK CONSTRAINT [FK_student_country_id]
GO

SET ANSI_PADDING OFF
GO

/*
 *  5) Create Stored Procedures
 */
IF OBJECT_ID('dbo.GetStudents','P') IS NOT NULL
	DROP PROCEDURE dbo.GetStudents
GO

CREATE PROCEDURE [dbo].[GetStudents]
AS
	SET NOCOUNT ON;
	
	SELECT		s.student_Id AS [Id]
				,s.first_name AS [FirstName]
				,s.last_name AS [LastName]
				,u.university AS [University]
				,c.country AS [Country]
				,s.sex AS [Sex]
				,s.age AS [Age]
				,s.[start_date] AS [StartDate]
				,s.degree AS [Degree]
	FROM		[dbo].[student] s
	INNER JOIN	[dbo].[university] u
		ON		s.university_id = u.university_id
	INNER JOIN	[dbo].[country] c
		ON		s.country_id = c.country_id
	
GO

IF OBJECT_ID('dbo.GetStudentCountPerCountry','P') IS NOT NULL
	DROP PROCEDURE dbo.GetStudentCountPerCountry
GO

CREATE PROCEDURE [dbo].[GetStudentCountPerCountry]
AS
	SET NOCOUNT ON;
	
	SELECT		c.country AS [Key]
				,COUNT(s.student_id) AS [Value]
	FROM		[dbo].[student] s
	INNER JOIN	[dbo].[country] c
		ON		s.country_id = c.country_id
	GROUP BY    c.country

GO


IF OBJECT_ID('dbo.GetStudentCountPerYear','P') IS NOT NULL
	DROP PROCEDURE dbo.GetStudentCountPerYear
GO

CREATE PROCEDURE [dbo].[GetStudentCountPerYear]
AS
	SET NOCOUNT ON;

	SELECT		DATEPART(YEAR, a.[start_date]) AS [Key]
				,(SELECT COUNT(b.student_id) 
                 FROM	dbo.student b
                 WHERE DATEPART(YEAR, b.[start_date]) <= DATEPART(YEAR, a.[start_date])) AS [Value]
	FROM		dbo.student a
	GROUP BY	DATEPART(YEAR, a.[start_date]) 
	ORDER BY	DATEPART(YEAR, a.[start_date]) 

GO


IF OBJECT_ID('dbo.GetDashboardSetting','P') IS NOT NULL
	DROP PROCEDURE dbo.GetDashboardSetting
GO

CREATE PROCEDURE [dbo].[GetDashboardSetting]
AS
	SET NOCOUNT ON;

	SELECT	COUNT(university_id) AS TotalUniversities
	FROM	[dbo].[university]

	SELECT	COUNT(country_id) AS TotalCountries
	FROM	[dbo].[country]

	SELECT	COUNT(student_id) AS TotalStudents
	FROM	[dbo].[student]

	EXEC [dbo].[GetStudentCountPerYear]

	EXEC [dbo].[GetStudentCountPerCountry]
	
GO

/*
 *  6) Populate Data
 */
DECLARE @TodayUtc AS DATETIME2 = SYSUTCDATETIME()
		,@SpainId INT
		,@IndiaId INT
		,@USAId INT
		,@CroatiaId INT
		,@TurkeyId INT
		,@NetherlandsId INT
		,@CanadaId INT

INSERT INTO dbo.country (country, updated_utc) VALUES ('Spain', @TodayUtc)
SET @SpainId = SCOPE_IDENTITY()

INSERT INTO dbo.country (country, updated_utc) VALUES ('India', @TodayUtc)
SET @IndiaId = SCOPE_IDENTITY()

INSERT INTO dbo.country (country, updated_utc) VALUES ('USA', @TodayUtc)
SET @USAId = SCOPE_IDENTITY()

INSERT INTO dbo.country (country, updated_utc) VALUES ('Croatia', @TodayUtc)
SET @CroatiaId = SCOPE_IDENTITY()

INSERT INTO dbo.country (country, updated_utc) VALUES ('Turkey', @TodayUtc)
SET @TurkeyId = SCOPE_IDENTITY()

INSERT INTO dbo.country (country, updated_utc) VALUES ('Netherlands', @TodayUtc)
SET @NetherlandsId = SCOPE_IDENTITY()

INSERT INTO dbo.country (country, updated_utc) VALUES ('Canada', @TodayUtc)
SET @CanadaId = SCOPE_IDENTITY()

/* University Of Illinois Chicago */
DECLARE @UICId INT

INSERT INTO dbo.university (university, updated_utc) VALUES ('University of Illinois Chicago', @TodayUtc)
SET @UICId = SCOPE_IDENTITY()

INSERT INTO dbo.student(first_name, last_name, university_id, country_id, sex, age, [start_date], degree, updated_utc)
VALUES ('Ceri', 'Sokia', @UICId, @CanadaId, 'M', 21, '2012-08-26', 'Computer Science', @TodayUtc)

INSERT INTO dbo.student(first_name, last_name, university_id, country_id, sex, age, [start_date], degree, updated_utc)
VALUES ('Nino', 'Pena', @UICId, @CanadaId, 'F', 22, '2009-12-29', 'Computer Science', @TodayUtc)

/* Georgia State University */
DECLARE @GSUId INT

INSERT INTO dbo.university (university, updated_utc) VALUES ('Georgia State University', @TodayUtc)
SET @GSUId = SCOPE_IDENTITY()

INSERT INTO dbo.student(first_name, last_name, university_id, country_id, sex, age, [start_date], degree, updated_utc)
VALUES ('Sri', 'Ram', @GSUId, @IndiaId, 'M', 24, '2010-11-10', 'Biology', @TodayUtc)

/* Georgia Tech University */
DECLARE @GTUId INT

INSERT INTO dbo.university (university, updated_utc) VALUES ('Georgia Tech University', @TodayUtc)
SET @GTUId = SCOPE_IDENTITY()

INSERT INTO dbo.student(first_name, last_name, university_id, country_id, sex, age, [start_date], degree, updated_utc)
VALUES ('Peter', 'Byrd', @GTUId, @USAId, 'M', 23, '2011-07-10', 'Data Analytics', @TodayUtc)

/* Southern Illinois University */
DECLARE @SIUId INT

INSERT INTO dbo.university (university, updated_utc) VALUES ('Southern Illinois University', @TodayUtc)
SET @SIUId = SCOPE_IDENTITY()

INSERT INTO dbo.student(first_name, last_name, university_id, country_id, sex, age, [start_date], degree, updated_utc)
VALUES ('Mary', 'Berry', @SIUId, @USAId, 'F', 27, '2010-07-26', 'Finance', @TodayUtc)

/* University of Pennsylvania */
DECLARE @UPENNId INT

INSERT INTO dbo.university (university, updated_utc) VALUES ('University of Pennsylvania', @TodayUtc)
SET @UPENNId = SCOPE_IDENTITY()

INSERT INTO dbo.student(first_name, last_name, university_id, country_id, sex, age, [start_date], degree, updated_utc)
VALUES ('Tracy', 'Green', @UPENNId, @CroatiaId, 'F', 25, '2011-04-12', 'Communication', @TodayUtc)

/* Arizona State University */
DECLARE @ASUId INT

INSERT INTO dbo.university (university, updated_utc) VALUES ('Arizona State University', @TodayUtc)
SET @ASUId = SCOPE_IDENTITY()

INSERT INTO dbo.student(first_name, last_name, university_id, country_id, sex, age, [start_date], degree, updated_utc)
VALUES ('Adam', 'Joyce', @ASUId, @SpainId, 'M', 23, '2011-01-23', 'Community Planning', @TodayUtc)

INSERT INTO dbo.student(first_name, last_name, university_id, country_id, sex, age, [start_date], degree, updated_utc)
VALUES ('Sashi', 'Kumari', @ASUId, @IndiaId, 'F', 19, '2010-11-23', 'Computer Science', @TodayUtc)

/* University of Texas */
DECLARE @UTAId INT

INSERT INTO dbo.university (university, updated_utc) VALUES ('University of Texas', @TodayUtc)
SET @UTAId = SCOPE_IDENTITY()

INSERT INTO dbo.student(first_name, last_name, university_id, country_id, sex, age, [start_date], degree, updated_utc)
VALUES ('Judy', 'Caldwell', @UTAId, @USAId, 'F', 25, '2012-10-04', 'Computer Science', @TodayUtc)

/* California State University */
DECLARE @CSUId INT

INSERT INTO dbo.university (university, updated_utc) VALUES ('California State University', @TodayUtc)
SET @CSUId = SCOPE_IDENTITY()

INSERT INTO dbo.student(first_name, last_name, university_id, country_id, sex, age, [start_date], degree, updated_utc)
VALUES ('Blake', 'Bradshaw', @CSUId, @USAId, 'M', 22, '2009-10-27', 'Data Analytics', @TodayUtc)

/* Delaware University */
DECLARE @DUId INT

INSERT INTO dbo.university (university, updated_utc) VALUES ('Delaware University', @TodayUtc)
SET @DUId = SCOPE_IDENTITY()

INSERT INTO dbo.student(first_name, last_name, university_id, country_id, sex, age, [start_date], degree, updated_utc)
VALUES ('Jenette', 'Harrell', @DUId, @CroatiaId, 'F', 24, '2010-03-15', 'Computer Science', @TodayUtc)

/* Florida International University */
DECLARE @FIUId INT

INSERT INTO dbo.university (university, updated_utc) VALUES ('Florida International University', @TodayUtc)
SET @FIUId = SCOPE_IDENTITY()

INSERT INTO dbo.student(first_name, last_name, university_id, country_id, sex, age, [start_date], degree, updated_utc)
VALUES ('Michelle', 'Williamson', @FIUId, @USAId, 'F', 22, '2013-01-03','Biology', @TodayUtc)

INSERT INTO dbo.student(first_name, last_name, university_id, country_id, sex, age, [start_date], degree, updated_utc)
VALUES ('Brielle', 'Davidson', @FIUId, @CanadaId, 'F', 24, '2011-11-15', 'Communications', @TodayUtc)

INSERT INTO dbo.student(first_name, last_name, university_id, country_id, sex, age, [start_date], degree, updated_utc)
VALUES ('Colleen', 'House', @FIUId, @TurkeyId, 'F', 26, '2012-07-03', 'Data Analytics', @TodayUtc)

/* George Mason University */
DECLARE @GMUId INT

INSERT INTO dbo.university (university, updated_utc) VALUES ('George Mason University', @TodayUtc)
SET @GMUId = SCOPE_IDENTITY()

INSERT INTO dbo.student(first_name, last_name, university_id, country_id, sex, age, [start_date], degree, updated_utc)
VALUES ('Vivian', 'Hurst', @GMUId, @CroatiaId, 'F', 28, '2010-10-16', 'Community Planning', @TodayUtc)

/* Illinois State University */
DECLARE @ISUId INT

INSERT INTO dbo.university (university, updated_utc) VALUES ('Illinois State University', @TodayUtc)
SET @ISUId = SCOPE_IDENTITY()

INSERT INTO dbo.student(first_name, last_name, university_id, country_id, sex, age, [start_date], degree, updated_utc)
VALUES ('Carlson', 'Cox', @ISUId, @CroatiaId, 'M', 25, '2010-02-13','Computer Science', @TodayUtc)

/* Maine State University */
DECLARE @MSUId INT

INSERT INTO dbo.university (university, updated_utc) VALUES ('Maine State University', @TodayUtc)
SET @MSUId = SCOPE_IDENTITY()

INSERT INTO dbo.student(first_name, last_name, university_id, country_id, sex, age, [start_date], degree, updated_utc)
VALUES ('Aron', 'Silva', @MSUId, @IndiaId, 'M', 25, '2013-12-28', 'Information Security', @TodayUtc)

INSERT INTO dbo.student(first_name, last_name, university_id, country_id, sex, age, [start_date], degree, updated_utc)
VALUES ('Michael', 'Butler', @MSUId, @CroatiaId, 'M', 26, '2010-01-10', 'Information Security', @TodayUtc)

/* New York State University */
DECLARE @NYSUId INT

INSERT INTO dbo.university (university, updated_utc) VALUES ('New York State University', @TodayUtc)
SET @NYSUId = SCOPE_IDENTITY()

INSERT INTO dbo.student(first_name, last_name, university_id, country_id, sex, age, [start_date], degree, updated_utc)
VALUES ('Prem', 'Kumar', @NYSUId, @IndiaId, 'M', 22, '2009-01-20', 'Political Science', @TodayUtc)

INSERT INTO dbo.student(first_name, last_name, university_id, country_id, sex, age, [start_date], degree, updated_utc)
VALUES ('Garrett', 'Hatfield', @NYSUId, @CroatiaId, 'M', 20, '2009-01-17', 'Political Science', @TodayUtc)

INSERT INTO dbo.student(first_name, last_name, university_id, country_id, sex, age, [start_date], degree, updated_utc)
VALUES ('Harish', 'Rao', @NYSUId, @IndiaId, 'M', 26, '2009-01-10', 'Biology', @TodayUtc)

/* Connecticut State College */
DECLARE @CSCId INT

INSERT INTO dbo.university (university, updated_utc) VALUES ('Connecticut State College', @TodayUtc)
SET @CSCId = SCOPE_IDENTITY()

INSERT INTO dbo.student(first_name, last_name, university_id, country_id, sex, age, [start_date], degree, updated_utc)
VALUES ('Tim', 'Rios', @CSCId, @SpainId, 'F', 24, '2013-10-27', 'Computer Science', @TodayUtc)

/* Illinois Community College */
DECLARE @ICCId INT

INSERT INTO dbo.university (university, updated_utc) VALUES ('Illinois Community College', @TodayUtc)
SET @ICCId = SCOPE_IDENTITY()

INSERT INTO dbo.student(first_name, last_name, university_id, country_id, sex, age, [start_date], degree, updated_utc)
VALUES ('James', 'Boom', @ICCId, @SpainId, 'M', 25, '2012-04-10', 'Political Science', @TodayUtc)

INSERT INTO dbo.student(first_name, last_name, university_id, country_id, sex, age, [start_date], degree, updated_utc)
VALUES ('Ken', 'Vance', @ICCId, @USAId, 'M', 25, '2009-11-17','Computer Science', @TodayUtc)

