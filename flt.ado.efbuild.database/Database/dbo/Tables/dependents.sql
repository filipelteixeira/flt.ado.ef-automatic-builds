CREATE TABLE [dbo].[dependents] (
    [dependent_id] INT          IDENTITY (1, 1) NOT NULL,
    [first_name]   VARCHAR (50) NOT NULL,
    [last_name]    VARCHAR (50) NOT NULL,
    [relationship] VARCHAR (25) NOT NULL,
    [employee_id]  INT          NOT NULL,
    PRIMARY KEY CLUSTERED ([dependent_id] ASC),
    FOREIGN KEY ([employee_id]) REFERENCES [dbo].[employees] ([employee_id]) ON DELETE CASCADE ON UPDATE CASCADE
);

