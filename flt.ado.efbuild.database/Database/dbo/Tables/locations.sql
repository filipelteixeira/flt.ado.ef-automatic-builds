CREATE TABLE [dbo].[locations] (
    [location_id]    INT          IDENTITY (1, 1) NOT NULL,
    [street_address] VARCHAR (40) DEFAULT (NULL) NULL,
    [postal_code]    VARCHAR (12) DEFAULT (NULL) NULL,
    [city]           VARCHAR (30) NOT NULL,
    [state_province] VARCHAR (25) DEFAULT (NULL) NULL,
    [country_id]     CHAR (2)     NOT NULL,
    PRIMARY KEY CLUSTERED ([location_id] ASC),
    FOREIGN KEY ([country_id]) REFERENCES [dbo].[countries] ([country_id]) ON DELETE CASCADE ON UPDATE CASCADE
);

