CREATE TABLE [dbo].[regions] (
    [region_id]   INT          IDENTITY (1, 1) NOT NULL,
    [region_name] VARCHAR (25) DEFAULT (NULL) NULL,
    PRIMARY KEY CLUSTERED ([region_id] ASC)
);

