CREATE TABLE [dbo].[departments] (
    [department_id]   INT          IDENTITY (1, 1) NOT NULL,
    [department_name] VARCHAR (30) NOT NULL,
    [location_id]     INT          DEFAULT (NULL) NULL,
    PRIMARY KEY CLUSTERED ([department_id] ASC),
    FOREIGN KEY ([location_id]) REFERENCES [dbo].[locations] ([location_id]) ON DELETE CASCADE ON UPDATE CASCADE
);

