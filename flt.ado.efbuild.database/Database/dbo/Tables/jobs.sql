CREATE TABLE [dbo].[jobs] (
    [job_id]     INT            IDENTITY (1, 1) NOT NULL,
    [job_title]  VARCHAR (35)   NOT NULL,
    [min_salary] DECIMAL (8, 2) DEFAULT (NULL) NULL,
    [max_salary] DECIMAL (8, 2) DEFAULT (NULL) NULL,
    PRIMARY KEY CLUSTERED ([job_id] ASC)
);

