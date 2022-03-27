CREATE TABLE [dbo].[jobTitles]
(
	[jobTitle_id] INT IDENTITY (1, 1) NOT NULL, 
    [title] NVARCHAR(50) NOT NULL, 
    [description] NVARCHAR(500) NOT NULL,
    PRIMARY KEY CLUSTERED ([jobTitle_id] ASC)
)
