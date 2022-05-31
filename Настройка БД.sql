ALTER DATABASE CarService6 SET ENABLE_BROKER

-- For SQL Express
ALTER AUTHORIZATION ON DATABASE::CarService6 TO [sa]

SELECT is_broker_enabled FROM sys.databases WHERE name = 'CarService6';

use CarService
select * from [dbo].[Search_Component_Type] ('212;')
use master

select * from [dbo].[OrderOutfit_Information](76)

ALTER DATABASE CarService4 SET ENABLE_BROKER WITH ROLLBACK IMMEDIATE;
Go

ALTER ROLE db_owner ADD MEMBER sa
GO

ALTER AUTHORIZATION ON DATABASE::CarService4 TO sa;