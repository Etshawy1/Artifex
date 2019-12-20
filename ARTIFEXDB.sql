CREATE DATABASE ARTIFEX
GO 
USE ARTIFEX

CREATE TABLE [dbo].[USER] 
(
[USER_NAME] VARCHAR(20) UNIQUE NOT NULL,
 EMAIL VARCHAR(50) UNIQUE NOT NULL,
[PASSWORD] VARCHAR(70) NOT NULL,
[FNAME] VARCHAR(10) NOT NULL,
[MINIT] CHAR(1) NOT NULL,
[LNAME] VARCHAR(20) NOT NULL,
[PHONE] VARCHAR(13) NOT NULL,
[PROFILE_PIC] VARCHAR(max) DEFAULT '~/Images/def.png',
PRIMARY KEY ([USER_NAME])   
)

CREATE TABLE ARTIST 
(
ARTIST_UNAME VARCHAR(20) NOT NULL UNIQUE, 
BIO VARCHAR(200) ,
BYEAR INT CHECK (BYEAR>1930 AND BYEAR<2000),
START_SALARY INT NOT NULL ,
END_SALARY INT NOT NULL,
PRIMARY KEY (ARTIST_UNAME),
FOREIGN KEY (ARTIST_UNAME) REFERENCES [dbo].[USER] 
)

CREATE TABLE EXPERT
(
EXPERT_UNAME VARCHAR(20) NOT NULL UNIQUE,
BIO VARCHAR(200) ,
BYEAR INT CHECK (BYEAR>1930 AND BYEAR<2000),
PRIMARY KEY (EXPERT_UNAME),
FOREIGN KEY (EXPERT_UNAME) REFERENCES [dbo].[USER] 
)

CREATE TABLE ADMIN 
(
ADMIN_ID INT UNIQUE IDENTITY(1,1) NOT NULL,
EMAIL VARCHAR(50) UNIQUE NOT NULL,
PASSWORD VARCHAR(20) NOT NULL,
SALARY INT NOT NULL
PRIMARY KEY (ADMIN_ID)
)

CREATE TABLE CATEGORY 
(
NAME VARCHAR(10)UNIQUE NOT NULL,
PRIMARY KEY (NAME)
)

CREATE TABLE ARTWORK
(
AW_CODE INT UNIQUE IDENTITY(1,1) NOT NULL ,
CATEGORY_NAME VARCHAR(10) NOT NULL ,
ARTIST_UNAME VARCHAR(20) NOT NULL,
ADMIN_ID INT,
TITLE VARCHAR(20) UNIQUE NOT NULL,
ACCEPTED BIT  ,
PRIVACY BIT NOT NULL,
[STATUS] BIT NOT NULL DEFAULT 1,  /*1-Available, 0-Unavailable*/
[DESCRIPTION] VARCHAR(100)  ,
WIDTH INT NOT NULL CHECK (WIDTH>0),
HEIGHT INT NOT NULL CHECK (HEIGHT>0),
DEPTH INT NOT NULL CHECK (DEPTH>0), 
PRICE INT NOT NULL CHECK (PRICE >0),
MATERIAL VARCHAR(10) NOT NULL,
MEDIUM VARCHAR(10) NOT NULL ,
[SUBJECT] VARCHAR(10) ,
PHOTO VARCHAR(max) ,
[YEAR] INT  CHECK (YEAR >1950),
PRIMARY KEY (AW_CODE),
FOREIGN KEY (CATEGORY_NAME) REFERENCES CATEGORY,
FOREIGN KEY (ARTIST_UNAME) REFERENCES ARTIST,
FOREIGN KEY (ADMIN_ID) REFERENCES [dbo].[ADMIN] 
)

CREATE TABLE BILLING_INFO
(
CARD_NUM varchar(18) UNIQUE NOT NULL,
[USER_NAME] VARCHAR(20) UNIQUE NOT NULL,
STREET VARCHAR(20) NOT NULL,
CITY VARCHAR(10) NOT NULL,
CARD_HOLDER_NAME VARCHAR(20) NOT NULL,
CVV INT NOT NULL,
EXPIRY_DATE DATE NOT NULL,
PRIMARY KEY (CARD_NUM),
FOREIGN KEY ([USER_NAME]) REFERENCES [dbo].[USER] 
)

CREATE TABLE [dbo].[ORDER]
(
ORDER_ID INT UNIQUE IDENTITY(1,1) NOT NULL,
[STATUS] BIT NOT NULL /*1-Incart , 0-Requested*/,
ORDER_DATE DATE NOT NULL,
DELIVERY_DATE DATE ,
PRIMARY KEY (ORDER_ID) 
)

CREATE TABLE SHIPPING_COMPANY
(
NAME VARCHAR(20) UNIQUE NOT NULL,
EMAIL VARCHAR(50) UNIQUE NOT NULL,
PHONE VARCHAR(13) UNIQUE NOT NULL,
SHIPPING_FEES INT NOT NULL,
PRIMARY KEY (NAME)
)

CREATE TABLE [dbo].[EVENT]
(
TITLE VARCHAR(20) UNIQUE NOT NULL,
ADMIN_ID INT NOT NULL,
[IMAGE] VARCHAR(MAX) NOT NULL,
TICKET_PRICE INT NOT NULL CHECK(TICKET_PRICE>=20),
EVENTDATE DATE NOT NULL,
LOCATION VARCHAR(20) NOT NULL,
TICKETS_NUM INT NOT NULL,
INFO VARCHAR(200) NOT NULL,
PRIMARY KEY(TITLE),
FOREIGN KEY (ADMIN_ID) REFERENCES [dbo].[ADMIN] 
)

CREATE TABLE REPORT
(
REPORT_ID INT UNIQUE IDENTITY(1,1) NOT NULL,
[USER_NAME] VARCHAR(20) NOT NULL,
ADMIN_ID INT ,
ORDER_ID INT NOT NULL UNIQUE,
[TEXT] VARCHAR(200) NOT NULL,
PRIMARY KEY (REPORT_ID),
FOREIGN KEY ([USER_NAME]) REFERENCES [dbo].[USER],
FOREIGN KEY (ADMIN_ID) REFERENCES [dbo].[ADMIN] ,
FOREIGN KEY (ORDER_ID) REFERENCES [dbo].[ORDER]
)

CREATE TABLE SURVEY
(
SURVEY_ID INT UNIQUE IDENTITY(1,1) NOT NULL,
EXPERT_UNAME VARCHAR(20) ,
[USER_NAME] VARCHAR(20) NOT NULL ,
BUDGET INT NOT NULL CHECK (BUDGET>100),
ORIENTATION VARCHAR(20) NOT NULL CHECK(ORIENTATION = 'PORTRAIT' OR ORIENTATION = 'LANDSCAPE'),
MORE_INFO VARCHAR(200),
RATING INT CHECK(RATING >= 0 AND RATING <= 5),
PRIMARY KEY(SURVEY_ID),
FOREIGN KEY ([USER_NAME]) REFERENCES [dbo].[USER],
FOREIGN KEY (EXPERT_UNAME) REFERENCES EXPERT
)
/*****************/
/*Relations */

/*****************/
CREATE TABLE ATTEND 
(
TITLE VARCHAR(20) NOT NULL,
[USER_NAME] VARCHAR(20) NOT NULL ,
FOREIGN KEY ([USER_NAME]) REFERENCES [dbo].[USER],
FOREIGN KEY (TITLE) REFERENCES [dbo].[EVENT],
PRIMARY KEY (TITLE,[USER_NAME])
)

CREATE TABLE INVITED
(
TITLE VARCHAR(20) NOT NULL,
ARTIST_UNAME VARCHAR(20) NOT NULL,
FOREIGN KEY (ARTIST_UNAME) REFERENCES ARTIST,
FOREIGN KEY (TITLE) REFERENCES [dbo].[EVENT],
PRIMARY KEY (TITLE,ARTIST_UNAME)
)

CREATE TABLE ORDER_INFO
(
ORDER_ID INT UNIQUE NOT NULL,
ADMIN_ID INT ,
SHIPPING_NAME VARCHAR(20),
[USER_NAME] VARCHAR(20) NOT NULL,
AW_CODE INT NOT NULL,
PRIMARY KEY (ORDER_ID,ADMIN_ID,SHIPPING_NAME,[USER_NAME],AW_CODE),
FOREIGN KEY (ORDER_ID) REFERENCES [dbo].[ORDER],
FOREIGN KEY (ADMIN_ID) REFERENCES [dbo].[ADMIN],
FOREIGN KEY (SHIPPING_NAME) REFERENCES SHIPPING_COMPANY,
FOREIGN KEY ([USER_NAME]) REFERENCES [dbo].[USER],
FOREIGN KEY (AW_CODE) REFERENCES ARTWORK
)

CREATE TABLE PREF_CATEGORY
(
NAME VARCHAR(10) NOT NULL,
SURVEY_ID INT NOT NULL,
PRIMARY KEY (NAME ,SURVEY_ID),
FOREIGN KEY (NAME) REFERENCES CATEGORY,
FOREIGN KEY (SURVEY_ID) REFERENCES SURVEY
)

CREATE TABLE RECOMMEND 
(
SURVEY_ID INT NOT NULL,
AW_CODE INT NOT NULL,
FOREIGN KEY (SURVEY_ID) REFERENCES SURVEY,
FOREIGN KEY (AW_CODE) REFERENCES ARTWORK,
PRIMARY KEY (AW_CODE ,SURVEY_ID)
)

CREATE TABLE SELECT_AW
(
SURVEY_ID INT NOT NULL,
AW_CODE INT NOT NULL,
FOREIGN KEY (SURVEY_ID) REFERENCES SURVEY,
FOREIGN KEY (AW_CODE) REFERENCES ARTWORK,
PRIMARY KEY (AW_CODE ,SURVEY_ID)
)

CREATE TABLE RATE_AW
(
[USER_NAME] VARCHAR(20)  NOT NULL,
AW_CODE INT NOT NULL,
RATING INT NOT NULL CHECK(RATING >= 0 AND RATING <= 5),
FOREIGN KEY ([USER_NAME]) REFERENCES [USER],
FOREIGN KEY (AW_CODE) REFERENCES ARTWORK,
PRIMARY KEY (AW_CODE ,[USER_NAME])
)

CREATE TABLE INCLUDE_AW
(
TITLE VARCHAR(20) NOT NULL,
AW_CODE INT NOT NULL,
FOREIGN KEY (TITLE) REFERENCES [dbo].[EVENT],
FOREIGN KEY (AW_CODE) REFERENCES ARTWORK,
PRIMARY KEY (AW_CODE ,TITLE)
)

CREATE TABLE FAV_AW
(
AW_CODE INT NOT NULL,
[USER_NAME] VARCHAR(20) NOT NULL,
FOREIGN KEY (AW_CODE) REFERENCES ARTWORK,
FOREIGN KEY ([USER_NAME]) REFERENCES [USER],
PRIMARY KEY (AW_CODE ,[USER_NAME])
)

CREATE TABLE AW_KEYWORDS
(
AW_CODE INT NOT NULL,
KEYWORD VARCHAR(20) NOT NULL,
FOREIGN KEY (AW_CODE) REFERENCES ARTWORK,
PRIMARY KEY (AW_CODE ,KEYWORD)
)

CREATE TABLE EXP_QUALIFICATIONS
(
EXPERT_UNAME VARCHAR(20) NOT NULL,
QUALIFICATIONS VARCHAR(20)NOT NULL,
FOREIGN KEY (EXPERT_UNAME) REFERENCES EXPERT,
PRIMARY KEY (EXPERT_UNAME,QUALIFICATIONS)
)
