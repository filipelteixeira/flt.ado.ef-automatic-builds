CREATE TABLE [dbo].[countries] (
    [country_id]   CHAR (2)     NOT NULL,
    [country_name] VARCHAR (40) DEFAULT (NULL) NULL,
    [region_id]    INT          NOT NULL,
    PRIMARY KEY CLUSTERED ([country_id] ASC),
    FOREIGN KEY ([region_id]) REFERENCES [dbo].[regions] ([region_id]) ON DELETE CASCADE ON UPDATE CASCADE
);

