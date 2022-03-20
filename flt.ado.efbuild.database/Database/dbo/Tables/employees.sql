CREATE TABLE [dbo].[employees] (
    [employee_id]   INT            IDENTITY (1, 1) NOT NULL,
    [first_name]    VARCHAR (20)   DEFAULT (NULL) NULL,
    [last_name]     VARCHAR (25)   NOT NULL,
    [email]         VARCHAR (100)  NOT NULL,
    [phone_number]  VARCHAR (20)   DEFAULT (NULL) NULL,
    [hire_date]     DATE           NOT NULL,
    [job_id]        INT            NOT NULL,
    [salary]        DECIMAL (8, 2) NOT NULL,
    [manager_id]    INT            DEFAULT (NULL) NULL,
    [department_id] INT            DEFAULT (NULL) NULL,
    PRIMARY KEY CLUSTERED ([employee_id] ASC),
    FOREIGN KEY ([department_id]) REFERENCES [dbo].[departments] ([department_id]) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY ([job_id]) REFERENCES [dbo].[jobs] ([job_id]) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY ([manager_id]) REFERENCES [dbo].[employees] ([employee_id])
);

