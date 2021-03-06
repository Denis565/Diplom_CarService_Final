/*USE [master]
GO

drop database [CarService]*/
/****** Object:  Database [CarService]    Script Date: 11.05.2022 9:03:34 ******/
/*CREATE DATABASE [CarService]
GO

USE [CarService]
GO
/****** Object:  UserDefinedFunction [dbo].[Analiz_WorkerCountService2]    Script Date: 11.05.2022 9:03:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

------------------
create   function [dbo].[Analiz_WorkerCountService2] (@startDate [nvarchar] (20),@endDate [nvarchar] (20),@idWorker [nvarchar] (max))--Вывод колличества выполненых услуг
returns @tableMain TABLE (
	ID_Worker [int],
    Count_Completed_Order [int],
	Time_Workerd [int],
	Sum_Count_Component [int],
	Sum_Count_Service [int]
)
as
	begin
	DECLARE @TableTime TABLE (idWorker int,Time_Workerd int)
	DECLARE @TableCompletedOrder TABLE (idWorker int,Count_Completed_Order int)
	DECLARE @TableCountComponent TABLE (idWorker int,Sum_Count_Component int)
	DECLARE @TableCountService TABLE (idWorker int,Sum_Count_Service int)

	INSERT INTO @TableTime
	select 
		worker.[ID_Worker] as 'Номер работника',
		CEILING(CAST(SUM(DATEDIFF(MINUTE, carServOrd.[Start_Date], carServOrd.[End_Date])) as float) / CAST(60 as float)) as 'Отработанное время'
		from [dbo].[Worker] worker
		inner join [dbo].[Car_Services_Provided] carServOrd on [Worker_ID]=[ID_Worker]
		where carServOrd.[Worker_ID] IN (select value from STRING_SPLIT('5;7;', ';'))
		and carServOrd.[End_Date] != ''
		and (carServOrd.[Start_Date]>=cast(@startDate as datetime) 
		or carServOrd.[End_Date] <=cast(@endDate as datetime))
		GROUP BY  worker.[ID_Worker],carServOrd.[Worker_ID]

	INSERT INTO @TableCompletedOrder
	select 
		worker.[ID_Worker] as 'Номер работника',
		COUNT(DISTINCT carServOrd.[Order_ID]) as 'Количество выполненых заказ нарядов'
		from [dbo].[Worker] worker
		inner join [dbo].[Car_Services_Provided] carServOrd on carServOrd.[Worker_ID]=[ID_Worker]
		where carServOrd.[Worker_ID] IN (select value from STRING_SPLIT(@idWorker, ';'))  
		and (carServOrd.[Start_Date]>=cast(@startDate as datetime) 
		or carServOrd.[End_Date] <=cast(@endDate as datetime))
		GROUP BY worker.[ID_Worker]

	INSERT INTO @TableCountComponent
	select 
		worker.[ID_Worker] as 'Номер работника',
		SUM(compOrder.Quantity_Component) as 'Количество назначенных компонентов'
		from [Worker] worker
		inner join [dbo].[Component_Order] compOrder on compOrder.[Worker_ID] = worker.[ID_Worker]
		where compOrder.[Worker_ID] IN (select value from STRING_SPLIT(@idWorker, ';')) 
		and compOrder.[Date_Enrollment] >=@startDate and compOrder.[Date_Enrollment] <=@endDate
		GROUP BY compOrder.[Worker_ID],worker.[ID_Worker]

	INSERT INTO @TableCountService
	select 
		 worker.[ID_Worker] as 'Номер работника',
		 COUNT(carServOrd.Worker_ID) as 'Количество выполненных услуг'
		 from [dbo].[Worker] worker
		 inner join [dbo].[Car_Services_Provided] carServOrd on carServOrd.[Worker_ID]=[ID_Worker]
		 where carServOrd.[Worker_ID] IN (select value from STRING_SPLIT(@idWorker, ';'))  
		 and (carServOrd.[End_Date]>=cast(@startDate as datetime) 
		 or carServOrd.[End_Date] <=cast(@endDate as datetime))
		 GROUP BY carServOrd.[Worker_ID],worker.[ID_Worker]

	INSERT INTO @tableMain
	select
	 cco.[idWorker] as 'Номер работника',
	 ISNULL(cco.Count_Completed_Order,0) as 'Количество отработанных заказ нарядов',
	 dc3.Time_Workerd as 'Отработанное время',
	 ISNULL(dc1.Sum_Count_Component,0) as 'Количество использованных компонентов',
	 ISNULL(dc2.Sum_Count_Service,0) as 'Количество исполненых услуг'
	 from @TableCompletedOrder cco
	 full join @TableCountComponent dc1 on cco.idWorker=dc1.idWorker 
	 full join @TableCountService dc2 on cco.idWorker=dc2.idWorker 
	 full join @TableTime dc3 on cco.idWorker=dc3.idWorker 

	RETURN;
	end;

GO*/
/****** Object:  Table [dbo].[Brand_Model_Compliance]    Script Date: 11.05.2022 9:03:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Brand_Model_Compliance](
	[ID_Brand_Model_Compliance] [int] IDENTITY(1,1) NOT NULL,
	[Car_Brand_ID] [int] NOT NULL,
	[Car_Model_ID] [int] NOT NULL,
 CONSTRAINT [PK_Brand_Model_Compliance] PRIMARY KEY CLUSTERED 
(
	[ID_Brand_Model_Compliance] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Car_Brand]    Script Date: 11.05.2022 9:03:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Car_Brand](
	[ID_Car_Brand] [int] IDENTITY(1,1) NOT NULL,
	[Name_Car_Brand] [nvarchar](30) NOT NULL,
 CONSTRAINT [PK_Car_Brand] PRIMARY KEY CLUSTERED 
(
	[ID_Car_Brand] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Car_Model]    Script Date: 11.05.2022 9:03:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Car_Model](
	[ID_Car_Model] [int] IDENTITY(1,1) NOT NULL,
	[Name_Car_Model] [nvarchar](30) NOT NULL,
 CONSTRAINT [PK_Car_Model] PRIMARY KEY CLUSTERED 
(
	[ID_Car_Model] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[BrandModelCompliance_List]    Script Date: 11.05.2022 9:03:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create   view [dbo].[BrandModelCompliance_List] ("Название марки","Название модели","Номер распределения","Номер марки","Номер модели")--Вывод списка сопоставления марок и моделей машин
as
	select 
	cb.[Name_Car_Brand],
	cm.[Name_Car_Model],
	bmc.[ID_Brand_Model_Compliance],
	cb.[ID_Car_Brand],
	cm.[ID_Car_Model]
	from [dbo].[Brand_Model_Compliance] bmc
	inner join [dbo].[Car_Brand] cb on bmc.[Car_Brand_ID] = cb.[ID_Car_Brand]
	inner join [dbo].[Car_Model] cm on bmc.[Car_Model_ID] = cm.[ID_Car_Model]
GO
/****** Object:  Table [dbo].[Warehouse]    Script Date: 11.05.2022 9:03:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Warehouse](
	[ID_Warehouse] [int] IDENTITY(1,1) NOT NULL,
	[Component_ID] [int] NOT NULL,
	[Quantity_Warehouse] [float] NOT NULL,
	[Price] [decimal](38, 2) NOT NULL,
	[Branch_ID] [int] NOT NULL,
 CONSTRAINT [PK_Warehouse] PRIMARY KEY CLUSTERED 
(
	[ID_Warehouse] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Component]    Script Date: 11.05.2022 9:03:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Component](
	[ID_Component] [int] IDENTITY(1,1) NOT NULL,
	[Name_Component] [nvarchar](50) NOT NULL,
	[Minimum_Quantity] [float] NULL,
	[Type_Сonsumable] [bit] NOT NULL,
 CONSTRAINT [PK_Component] PRIMARY KEY CLUSTERED 
(
	[ID_Component] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[Warehouse_View]    Script Date: 11.05.2022 9:03:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
use CarService
go
create or alter  function [dbo].[Warehouse_View] (@idBranch [int])--Вывод списка компонентов на складе
returns table
as
	return(
		select 
		w.[ID_Warehouse] as 'Номер позиции',
		c.[Name_Component] as 'Наименование материала',
		w.[Quantity_Warehouse] as 'Колличество',
		CAST(w.[Price] as [nvarchar]) + CAST(N' руб'as [nvarchar]) as 'Цена',
		c.[Minimum_Quantity] as 'Минимальное число',
		c.[ID_Component] as 'Номер компонента'
		from [dbo].[Warehouse] w
		inner join [dbo].[Component] c on [Component_ID]=[ID_Component]
		where w.[Branch_ID] = @idBranch
	)

GO

/****** Object:  UserDefinedFunction [dbo].[Warehouse_Component_View]    Script Date: 11.05.2022 9:03:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create or alter  function [dbo].[Warehouse_Component_View] (@idBranch [int])--Вывод списка компонентов на складе
returns table
as
	return(
		select 
		c.[ID_Component] as 'Номер компонента на складе',
		c.[Name_Component] as 'Наименование материала',
		ISNULL(SUM(w.[Quantity_Warehouse]),0) as 'Количество',
		ISNULL(w.[Price],0) as 'Цена',
		ISNULL(c.[Minimum_Quantity],0) as 'Минимальное количество',
		c.[Type_Сonsumable] as 'Тип расходник'
		from [dbo].[Warehouse] w
		inner join [dbo].[Component] c on w.[Component_ID]=c.[ID_Component]
		where w.[Branch_ID] = @idBranch
		GROUP BY c.[ID_Component],c.[Name_Component], w.[Price],c.[Minimum_Quantity],c.[Type_Сonsumable]
	)
GO
/****** Object:  Table [dbo].[Employee]    Script Date: 11.05.2022 9:03:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Employee](
	[ID_Employee] [int] IDENTITY(1,1) NOT NULL,
	[Surname] [nvarchar](50) NOT NULL,
	[Name_Employee] [nvarchar](50) NOT NULL,
	[Patronymic] [nvarchar](50) NULL,
 CONSTRAINT [PK_Employee] PRIMARY KEY CLUSTERED 
(
	[ID_Employee] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Worker]    Script Date: 11.05.2022 9:03:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Worker](
	[ID_Worker] [int] IDENTITY(1,1) NOT NULL,
	[Employee_ID] [int] NULL,
	[Post_ID] [int] NOT NULL,
	[Login] [nvarchar](50) NOT NULL,
	[Password] [nvarchar](50) NOT NULL,
	[Date_Employment] [nvarchar](20) NULL,
	[Branch_ID] [int] NOT NULL,
 CONSTRAINT [PK_Worker] PRIMARY KEY CLUSTERED 
(
	[ID_Worker] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Customers_Machines]    Script Date: 11.05.2022 9:03:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Customers_Machines](
	[VIN] [nvarchar](17) NOT NULL,
	[Registration_Mark] [nvarchar](9) NOT NULL,
	[Year_Release] [nvarchar](4) NOT NULL,
	[Mileage] [int] NOT NULL,
	[Brand_Model_Compliance_ID] [int] NULL,
	[Client_ID] [int] NULL,
 CONSTRAINT [PK_Customers_Machines] PRIMARY KEY CLUSTERED 
(
	[VIN] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Order]    Script Date: 11.05.2022 9:03:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Order](
	[ID_Order] [int] IDENTITY(1,1) NOT NULL,
	[VIN] [nvarchar](17) NULL,
	[Date_Receipt] [nvarchar](20) NOT NULL,
	[List_Status_ID] [int] NOT NULL,
	[Branch_ID] [int] NOT NULL,
	[Worker_ID] [int] NULL,
 CONSTRAINT [PK_Order] PRIMARY KEY CLUSTERED 
(
	[ID_Order] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[List_Status]    Script Date: 11.05.2022 9:03:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[List_Status](
	[ID_List_Status] [int] IDENTITY(1,1) NOT NULL,
	[Name_Status] [nvarchar](30) NOT NULL,
 CONSTRAINT [PK_List_Status] PRIMARY KEY CLUSTERED 
(
	[ID_List_Status] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[Order_List_Engineers]    Script Date: 11.05.2022 9:03:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   function [dbo].[Order_List_Engineers] (@idBranch [int])--Вывод заказ нарядов работникам
returns table
as
	return(
		select
		top(
			select count([ID_Order])
			from [dbo].[Order] ord
			inner join [dbo].[List_Status] ls on ord.[List_Status_ID] = ls.[ID_List_Status]
			where ord.[Branch_ID] = @idBranch
		)
		[dbo].[Order].[ID_Order] as 'Номер ЗН',
		[dbo].[Car_Brand].[Name_Car_Brand] + ' ' + [dbo].[Car_Model].[Name_Car_Model] + ' ' +cm.[Year_Release] + ' - ' + cm.[Registration_Mark]  as 'Машина',
		[dbo].[Order].[Date_Receipt] as 'Дата зачисления',
		[dbo].[List_Status].[Name_Status] as 'Статус заказа',
		[dbo].[Employee].[Surname]+' '+ SUBSTRING ([dbo].[Employee].[Name_Employee],1,1)+'.'+ SUBSTRING ([dbo].[Employee].[Patronymic],1,1)+'.' as 'Исполнитель'
		from [dbo].[Order]
		inner join [dbo].[Worker] on [dbo].[Order].[Worker_ID] = [dbo].[Worker].[ID_Worker]
		inner join [dbo].[Employee] on [Employee_ID]=[ID_Employee]
		inner join [dbo].[Customers_Machines] cm on [dbo].[Order].[VIN]=cm.[VIN]
		inner join [dbo].[Brand_Model_Compliance] on [Brand_Model_Compliance_ID]=[ID_Brand_Model_Compliance]
		inner join [dbo].[List_Status] on [List_Status_ID]=[ID_List_Status]
		left join [dbo].[Car_Brand] on [Car_Brand_ID]=[ID_Car_Brand]
		left join [dbo].[Car_Model] on [Car_Model_ID]=[ID_Car_Model]
		where [dbo].[Order].[Branch_ID] = @idBranch
		order by [List_Status_ID]
	)

GO
/****** Object:  UserDefinedFunction [dbo].[Car_Model_View]    Script Date: 11.05.2022 9:03:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create   function [dbo].[Car_Model_View] (@nameBrand [nvarchar] (max))-- Вывод модели машины в зависемости от марки
returns table
as
	return(
	select
	[Name_Car_Model]
	from 
	[dbo].[Brand_Model_Compliance]
	inner join [dbo].[Car_Model] on [Car_Model_ID]=[ID_Car_Model]
	inner join [dbo].[Car_Brand] on [Car_Brand_ID]=[ID_Car_Brand]
	where [dbo].[Car_Brand].[Name_Car_Brand] = @nameBrand
	)
GO
/****** Object:  Table [dbo].[Post]    Script Date: 11.05.2022 9:03:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Post](
	[ID_Post] [int] IDENTITY(1,1) NOT NULL,
	[Name_Post] [nvarchar](30) NOT NULL,
 CONSTRAINT [PK_Post] PRIMARY KEY CLUSTERED 
(
	[ID_Post] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[Autarization]    Script Date: 11.05.2022 9:03:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create   function [dbo].[Autarization] (@login [varchar] (max),@password [varchar] (max))--Функция авторизации
returns table
as
	return(
		select
		[dbo].[Worker].[Login],
		[dbo].[Worker].[Password],
		[dbo].[Post].[Name_Post],
		[dbo].[Employee].[Surname]+' '+ SUBSTRING ([dbo].[Employee].[Name_Employee],1,1)+'.'+ SUBSTRING ([dbo].[Employee].[Patronymic],1,1)+'.' as "FIO",
		[dbo].[Worker].[ID_Worker],
		[dbo].[Worker].[Branch_ID]
		from 
		[dbo].[Worker] 
		inner join [dbo].[Employee] on [Employee_ID]=[ID_Employee]
	    inner join [dbo].[Post] on [Post_ID]=[ID_Post]
		where [Login] = @login and [Password] = @password
	)
GO
/****** Object:  Table [dbo].[Branch]    Script Date: 11.05.2022 9:03:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Branch](
	[ID_Branch] [int] IDENTITY(1,1) NOT NULL,
	[Address] [nvarchar](100) NOT NULL,
 CONSTRAINT [PK_Branch] PRIMARY KEY CLUSTERED 
(
	[ID_Branch] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[Worker_View]    Script Date: 11.05.2022 9:03:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create   function [dbo].[Worker_View] (@login [nvarchar] (max),@idBranch [int])--Вывод реестра сотрудников
returns table
as
	return(
	select
	emp.[ID_Employee] as 'Номер сотрудника',
	worker.[ID_Worker] as 'Номер работника',
	emp.[Surname] as 'Фамилия',
	emp.[Name_Employee] as 'Имя', 
	emp.[Patronymic] as 'Отчество', 
	[dbo].[Post].[Name_Post] as 'Должность', 
	worker.[Login] as 'Логин', 
	worker.[Password] as 'Пароль', 
	[dbo].[Branch].[Address] as 'Адрес филиала в котром работает сотрудник'
	from 
	[dbo].[Worker] worker
	inner join [dbo].[Employee] emp on [Employee_ID]=[ID_Employee]
	inner join [dbo].[Post] on [Post_ID]=[ID_Post]
	inner join [dbo].[Branch] on [Branch_ID]=[ID_Branch]
	where worker.[Login] != @login and worker.[Branch_ID] = @idBranch
	)
GO
/****** Object:  UserDefinedFunction [dbo].[Search_Post]    Script Date: 11.05.2022 9:03:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create   function [dbo].[Search_Post] (@name [nvarchar] (max))--Функция поиска должности
returns table
as
	return(
		select * from [dbo].[Post] 
		where [dbo].[Post].[Name_Post] = @name
	)
GO
/****** Object:  UserDefinedFunction [dbo].[Search_Branch]    Script Date: 11.05.2022 9:03:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create   function [dbo].[Search_Branch] (@address [nvarchar] (max))--Функция поиска адресса
returns table
as
	return(
		select * from [dbo].[Branch] 
		where [dbo].[Branch].[Address] = @address
	)
GO
/****** Object:  UserDefinedFunction [dbo].[Search_Login_Worker]    Script Date: 11.05.2022 9:03:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create   function [dbo].[Search_Login_Worker] (@login [nvarchar] (max))--Функция работника по логину
returns table
as
	return(
		select * from [dbo].[Worker] 
		where [dbo].[Worker].[Login] = @login
	)
GO
/****** Object:  UserDefinedFunction [dbo].[Search_Employee]    Script Date: 11.05.2022 9:03:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create   function [dbo].[Search_Employee] (@fio [nvarchar] (max)) -- Поиск сотрудника
returns table
as
	return(
		select * from [dbo].[Employee] 
		where [dbo].[Employee].[Surname] + '.' + [dbo].[Employee].[Name_Employee]+ '.' + [dbo].[Employee].[Patronymic] = @fio
	)
GO
/****** Object:  UserDefinedFunction [dbo].[Search_Car_Brand_Model]    Script Date: 11.05.2022 9:03:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create   function [dbo].[Search_Car_Brand_Model] (@brand [nvarchar] (max),@model [nvarchar] (max)) -- Поиск номера в реестре по марке и модели
returns table
as
	return(
		select * from [dbo].[Brand_Model_Compliance] 
		inner join [dbo].[Car_Brand] on [Car_Brand_ID]=[ID_Car_Brand]
		inner join [dbo].[Car_Model] on [Car_Model_ID]=[ID_Car_Model]
		where [dbo].[Car_Brand].[Name_Car_Brand] = @brand and [dbo].[Car_Model].[Name_Car_Model] = @model
	)
GO
/****** Object:  Table [dbo].[Client]    Script Date: 11.05.2022 9:03:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Client](
	[ID_Client] [int] IDENTITY(1,1) NOT NULL,
	[Surname] [nvarchar](50) NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[Middle_Name] [nvarchar](50) NULL,
	[Phone] [nvarchar](20) NOT NULL,
	[Date_Birth] [date] NOT NULL,
 CONSTRAINT [PK_Client] PRIMARY KEY CLUSTERED 
(
	[ID_Client] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[Search_Car_Client]    Script Date: 11.05.2022 9:03:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   function [dbo].[Search_Car_Client] (@vin [nvarchar] (17),@idClient [int]) -- Поиск автомобиля и клиента
returns table
as
	return(
		select
		CASE
             WHEN @idClient = (select [Client_ID] from [dbo].[Customers_Machines] cm where cm.[VIN] = @vin)
             THEN 'Yes'
             ELSE 'No'
             END AS status,
		cl.[Surname]+' '+ SUBSTRING (cl.[Name],1,1)+'.'+ SUBSTRING (cl.[Middle_Name],1,1)+'.' as 'Клиент',
		cl.[Phone]
		from [dbo].[Customers_Machines] 
		inner join [dbo].[Client] cl on [Client_ID]=[ID_Client]
		where [VIN] = @vin
	)

GO
/****** Object:  UserDefinedFunction [dbo].[Search_Order_Car_Admin]    Script Date: 11.05.2022 9:03:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   function [dbo].[Search_Order_Car_Admin] (@vin [nvarchar] (17),@branch_id [int]) -- Поиск заказов по машине из под админестратора
returns table
as
return(
		select
		top(
		select count([ID_Order]) from [dbo].[Order]
		where [dbo].[Order].[VIN] = @vin and [dbo].[Order].[Branch_ID] = @branch_id
		)
		[dbo].[Order].[ID_Order] as 'Номер ЗН',
		[dbo].[Car_Brand].[Name_Car_Brand] + ' ' + [dbo].[Car_Model].[Name_Car_Model] + ' ' +[dbo].[Customers_Machines].[Year_Release] as 'Машина',
		[dbo].[Order].[Date_Receipt] as 'Дата зачисления' ,
		[dbo].[List_Status].[Name_Status] 'Статус заказа',
		[dbo].[Employee].[Surname]+' '+ SUBSTRING ([dbo].[Employee].[Name_Employee],1,1)+'.'+ SUBSTRING ([dbo].[Employee].[Patronymic],1,1)+'.' as 'Исполнитель'
		from [dbo].[Order]
		left join [dbo].[Worker] on [dbo].[Order].[Worker_ID] = [dbo].[Worker].[ID_Worker]
		left join [dbo].[Employee] on [Employee_ID]=[ID_Employee]
		inner join [dbo].[Customers_Machines] on [dbo].[Order].[VIN]=[dbo].[Customers_Machines].[VIN]
		inner join [dbo].[Brand_Model_Compliance] on [Brand_Model_Compliance_ID]=[ID_Brand_Model_Compliance]
		inner join [dbo].[List_Status] on [List_Status_ID]=[ID_List_Status]
		left join [dbo].[Car_Brand] on [Car_Brand_ID]=[ID_Car_Brand]
		left join [dbo].[Car_Model] on [Car_Model_ID]=[ID_Car_Model]
		where [dbo].[Order].[VIN] = @vin and [dbo].[Order].[Branch_ID] = @branch_id
		order by [List_Status_ID]
	)

GO
/****** Object:  UserDefinedFunction [dbo].[Search_Order_Car_Filter_Admin]    Script Date: 11.05.2022 9:03:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create   function [dbo].[Search_Order_Car_Filter_Admin] (@vin [nvarchar] (17), @statusOrder [nvarchar] (20),@branch_id [int]) -- Поиск заказов по машине из под админестратора по статусу заказа 
returns table
as
return(
	select
		[dbo].[Order].[ID_Order] as 'Номер ЗН',
		[dbo].[Car_Brand].[Name_Car_Brand] + ' ' + [dbo].[Car_Model].[Name_Car_Model] + ' ' +[dbo].[Customers_Machines].[Year_Release] as 'Машина',
		[dbo].[Order].[Date_Receipt] as 'Дата зачисления' ,
		[dbo].[List_Status].[Name_Status] 'Статус заказа',
		[dbo].[Employee].[Surname]+' '+ SUBSTRING ([dbo].[Employee].[Name_Employee],1,1)+'.'+ SUBSTRING ([dbo].[Employee].[Patronymic],1,1)+'.' as 'Исполнитель'
		from [dbo].[Order]
		left join [dbo].[Worker] on [dbo].[Order].[Worker_ID] = [dbo].[Worker].[ID_Worker]
		left join [dbo].[Employee] on [Employee_ID]=[ID_Employee]
		inner join [dbo].[Customers_Machines] on [dbo].[Order].[VIN]=[dbo].[Customers_Machines].[VIN]
		inner join [dbo].[Brand_Model_Compliance] on [Brand_Model_Compliance_ID]=[ID_Brand_Model_Compliance]
		inner join [dbo].[List_Status] on [List_Status_ID]=[ID_List_Status]
		left join [dbo].[Car_Brand] on [Car_Brand_ID]=[ID_Car_Brand]
		left join [dbo].[Car_Model] on [Car_Model_ID]=[ID_Car_Model]
		where [dbo].[Order].[VIN] = @vin and [Name_Status] = @statusOrder and [dbo].[Order].[Branch_ID] = @branch_id
	)

GO
/****** Object:  UserDefinedFunction [dbo].[Search_Order_View_Filter]    Script Date: 11.05.2022 9:03:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   function [dbo].[Search_Order_View_Filter] (@statusOrder [nvarchar] (20),@idBranch [int]) -- Вывод заказ нарядов по их статусу
returns table
as
return(
	select
	top(
	select count([ID_Order]) from [dbo].[Order] ord
	inner join [dbo].[List_Status] ls on [List_Status_ID]=[ID_List_Status]
	where ls.[Name_Status] = @statusOrder and ord.[Branch_ID] = @idBranch
	)
		ord.[ID_Order] as 'Номер ЗН',
		[dbo].[Car_Brand].[Name_Car_Brand] + ' ' + [dbo].[Car_Model].[Name_Car_Model] + ' ' +cm.[Year_Release] + ' - ' + cm.[Registration_Mark] as 'Машина',
		ord.[Date_Receipt] as 'Дата зачисления' ,
		[dbo].[List_Status].[Name_Status] 'Статус заказа',
		[dbo].[Employee].[Surname]+' '+ SUBSTRING ([dbo].[Employee].[Name_Employee],1,1)+'.'+ SUBSTRING ([dbo].[Employee].[Patronymic],1,1)+'.' as 'Исполнитель'
		from [dbo].[Order] ord
		left join [dbo].[Worker] on ord.[Worker_ID] = [dbo].[Worker].[ID_Worker]
		left join [dbo].[Employee] on [Employee_ID]=[ID_Employee]
		inner join [dbo].[Customers_Machines] cm on ord.[VIN]=cm.[VIN]
		inner join [dbo].[Brand_Model_Compliance] on [Brand_Model_Compliance_ID]=[ID_Brand_Model_Compliance]
		inner join [dbo].[List_Status] on [List_Status_ID]=[ID_List_Status]
		left join [dbo].[Car_Brand] on [Car_Brand_ID]=[ID_Car_Brand]
		left join [dbo].[Car_Model] on [Car_Model_ID]=[ID_Car_Model]
		where [Name_Status] = @statusOrder and ord.[Branch_ID] = @idBranch
		order by [ID_Order] desc
	)

GO
/****** Object:  Table [dbo].[Car_Services_Provided]    Script Date: 11.05.2022 9:03:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Car_Services_Provided](
	[ID_Car_Services_Provided] [int] IDENTITY(1,1) NOT NULL,
	[List_Services_ID] [int] NOT NULL,
	[Start_Date] [nvarchar](20) NULL,
	[End_Date] [nvarchar](20) NULL,
	[Order_ID] [int] NULL,
	[Worker_ID] [int] NULL,
 CONSTRAINT [PK_Car_Services_Provided] PRIMARY KEY CLUSTERED 
(
	[ID_Car_Services_Provided] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Service_Group]    Script Date: 11.05.2022 9:03:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Service_Group](
	[ID_Service_Group] [int] IDENTITY(1,1) NOT NULL,
	[Name_Group_Service] [nvarchar](30) NOT NULL,
 CONSTRAINT [PK_Service_Group] PRIMARY KEY CLUSTERED 
(
	[ID_Service_Group] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[List_Services]    Script Date: 11.05.2022 9:03:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[List_Services](
	[ID_List_Services] [int] IDENTITY(1,1) NOT NULL,
	[Name_Services] [nvarchar](50) NOT NULL,
	[Norm_Hour] [float] NOT NULL,
	[Price] [decimal](38, 2) NOT NULL,
	[Service_Group_ID] [int] NOT NULL,
 CONSTRAINT [PK_List_Services] PRIMARY KEY CLUSTERED 
(
	[ID_List_Services] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[Search_Car_Services_Provided_Order]    Script Date: 11.05.2022 9:03:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*select * from [dbo].[Search_Order_Car_Filter_Admin]  ('WDWDWDDW33RFFWFWW','Открыт')
select * from [dbo].[Search_Order_Car_Admin]  ('WDWDWDDW33RFFWFWW') go*/

create   function [dbo].[Search_Car_Services_Provided_Order] (@order_id [int]) -- Поиск услуг по номеру заказа
returns table
as
	return(
		select
		[ID_List_Services] as 'Номер сервиса',
		[ID_Car_Services_Provided] as 'Номер в заказ наряде',
		[Name_Services] as 'Наименование услуги',
		[Norm_Hour] as 'Норма-часа',
		[Start_Date] as 'Дата начала выполнения',
		[End_Date] as 'Дата завершения выполнения',
		[Price] as 'Стоисмость'
		from [dbo].[Car_Services_Provided]
		inner join [dbo].[List_Services] on [List_Services_ID]=[ID_List_Services]
		inner join [dbo].[Service_Group] on [Service_Group_ID]=[ID_Service_Group]
		where [dbo].[Car_Services_Provided].[Order_ID] = @order_id
	)
GO
/****** Object:  Table [dbo].[Component_Order]    Script Date: 11.05.2022 9:03:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Component_Order](
	[ID_Component_Order] [int] IDENTITY(1,1) NOT NULL,
	[Component_ID] [int] NOT NULL,
	[Quantity_Component] [float] NOT NULL,
	[Order_ID] [int] NULL,
	[Worker_ID] [int] NULL,
	[Date_Enrollment] [date] NOT NULL,
	[Price] [decimal](38, 2) NOT NULL,
 CONSTRAINT [PK_Component_Order] PRIMARY KEY CLUSTERED 
(
	[ID_Component_Order] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[Search_Component_Order_Order]    Script Date: 11.05.2022 9:03:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create   function [dbo].[Search_Component_Order_Order] (@order_id [int]) -- Поиск компонентов по номеру заказа
returns table
as
	return(
		select
		DISTINCT
		c.[ID_Component] as 'Номер компонента',
		co.[ID_Component_Order] as 'Номер компонента в списке с израсходуемыми компанентами',
		c.[Name_Component] as 'Наименование компонента',
		co.[Quantity_Component] as 'Количество',
		co.[Price]  as 'Стоимость',
		c.[Minimum_Quantity] as 'Минимальное количество',
		c.[Type_Сonsumable] as 'Тип расходник'
		from [dbo].[Component] c
		inner join [dbo].[Component_Order] co on [Component_ID]=[ID_Component]
		where [Order_ID] = @order_id
	)
GO
/****** Object:  UserDefinedFunction [dbo].[Car_Client_View]    Script Date: 11.05.2022 9:03:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create   function [dbo].[Car_Client_View] (@idClient [int]) -- Вывод списка машин автовладельца
returns table
as
	return(
		select
		[VIN] as 'VIN номер',
		SUBSTRING([Registration_Mark],0,7) + ' ' +SUBSTRING([Registration_Mark],7,9)  as 'Госномер',
		[dbo].[Car_Brand].[Name_Car_Brand] as 'Марка',
		[dbo].[Car_Model].[Name_Car_Model] as 'Модель',
		[Year_Release] as 'Год выпуска',
		STR([Mileage]) + ' км' as 'Пробег'
		from [Customers_Machines]
		inner join [dbo].[Brand_Model_Compliance] on [Brand_Model_Compliance_ID]=[ID_Brand_Model_Compliance]
		inner join [dbo].[Car_Brand] on [Car_Brand_ID]=[ID_Car_Brand]
		inner join [dbo].[Car_Model] on [Car_Model_ID]=[ID_Car_Model]
		where [Client_ID] = @idClient
	)
GO
/****** Object:  UserDefinedFunction [dbo].[Search_Component_Warehouse]    Script Date: 11.05.2022 9:03:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   function [dbo].[Search_Component_Warehouse] (@nameComponent [nvarchar] (max))--Функция поиска компонента на складе
returns table
as
	return(
		select top (1) * from [dbo].[Warehouse] 
		inner join [dbo].[Component] on [Component_ID] = [ID_Component]
		where [dbo].[Component].[Name_Component] = @nameComponent
	)
GO
/****** Object:  UserDefinedFunction [dbo].[Search_ServiceName_ServiceGroup]    Script Date: 11.05.2022 9:03:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create   function [dbo].[Search_ServiceName_ServiceGroup] (@nameGroup [nvarchar] (30))--Функция поиска сервисов по их группам
returns table
as
	return(
		select 
		TOP(
			select count([Name_Group_Service]) 
			from [dbo].[List_Services]
			inner join [dbo].[Service_Group] on [Service_Group_ID]=[ID_Service_Group]
			where [Name_Group_Service] = @nameGroup
		)
		ls.[ID_List_Services] as 'Номер услуги',
		ls.[Name_Services] as 'Наименование услуги',
		ls.[Norm_Hour] as 'Нормо-час',
		ls.[Price] as 'Стоимость'
		from [dbo].[List_Services] ls
		inner join [dbo].[Service_Group] sg on ls.[Service_Group_ID] = sg.[ID_Service_Group]
		where [Name_Group_Service] = @nameGroup
		ORDER BY [Service_Group_ID]
	)
GO
/****** Object:  UserDefinedFunction [dbo].[OrderOutfit_Information]    Script Date: 11.05.2022 9:03:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create   function [dbo].[OrderOutfit_Information] (@idOrder [int])--Информация для заказ наряда по номеру заказа
returns table
as
	return(
		select top(1)
		cl.[Surname],cl.[Name],cl.[Middle_Name],
		cb.[Name_Car_Brand],cm.[Name_Car_Model],
		cusM.[Registration_Mark],cusM.[Year_Release],cusM.[VIN],cusM.[Mileage],
		FORMAT(cl.[Date_Birth],'dd.MM.yyyy') as 'Date'
		from [dbo].[Order]
		inner join [dbo].[Customers_Machines] cusM on [dbo].[Order].[VIN]=cusM.[VIN]
		inner join [dbo].[Client] cl on [Client_ID] = [ID_Client]
		inner join [dbo].[Brand_Model_Compliance] on [Brand_Model_Compliance_ID]=[ID_Brand_Model_Compliance]
		inner join [dbo].[Car_Brand]  cb on [Car_Brand_ID]=[ID_Car_Brand]
		inner join [dbo].[Car_Model] cm on [Car_Model_ID]=[ID_Car_Model]
		where [ID_Order] = @idOrder
	)
GO
/****** Object:  UserDefinedFunction [dbo].[Whatsapp_Order]    Script Date: 11.05.2022 9:03:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create   function [dbo].[Whatsapp_Order] (@idOrder [int])--Информация для whatsapp
returns table
as
	return(
		select top(1)
		cl.[Surname],cl.[Name],cl.[Middle_Name],
		cb.[Name_Car_Brand],cm.[Name_Car_Model]
		from [dbo].[Order]
		inner join [dbo].[Customers_Machines] cusM on [dbo].[Order].[VIN]=cusM.[VIN]
		inner join [dbo].[Client] cl on [Client_ID] = [ID_Client]
		inner join [dbo].[Brand_Model_Compliance] on [Brand_Model_Compliance_ID]=[ID_Brand_Model_Compliance]
		inner join [dbo].[Car_Brand]  cb on [Car_Brand_ID]=[ID_Car_Brand]
		inner join [dbo].[Car_Model] cm on [Car_Model_ID]=[ID_Car_Model]
		where [ID_Order] = @idOrder
	)
GO
/****** Object:  UserDefinedFunction [dbo].[Analiz_WorkerTimes]    Script Date: 11.05.2022 9:03:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create   function [dbo].[Analiz_WorkerTimes] (@startDate [nvarchar] (20),@endDate [nvarchar] (20),@idWorker [nvarchar] (max))--Вывод колличества отработанных часов
returns table
as
	return(
		select 
		worker.[ID_Worker] as 'Номер работника',
		CEILING(CAST(SUM(DATEDIFF(MINUTE, carServOrd.[Start_Date], carServOrd.[End_Date])) as float) / CAST(60 as float)) as 'Отработанное время'
		from [dbo].[Worker] worker
		inner join [dbo].[Car_Services_Provided] carServOrd on [Worker_ID]=[ID_Worker]
		where carServOrd.[Worker_ID] IN (select value from STRING_SPLIT(@idWorker, ';'))  
		and (carServOrd.[Start_Date]>=cast(@startDate as datetime) 
		or carServOrd.[End_Date] <=cast(@endDate as datetime))
		GROUP BY  worker.[ID_Worker],carServOrd.[Worker_ID]
	)
GO
/****** Object:  UserDefinedFunction [dbo].[Analiz_WorkerCountOrder]    Script Date: 11.05.2022 9:03:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create   function [dbo].[Analiz_WorkerCountOrder] (@startDate [nvarchar] (20),@endDate [nvarchar] (20),@idWorker [nvarchar] (max))--Вывод колличества выполненых заказ нарядов
returns table
as
	return(
		select 
		worker.[ID_Worker] as 'Номер работника',
		COUNT(DISTINCT carServOrd.[Order_ID]) as 'Количество выполненых заказ нарядов'
		from [dbo].[Worker] worker
		inner join [dbo].[Car_Services_Provided] carServOrd on carServOrd.[Worker_ID]=[ID_Worker]
		where carServOrd.[Worker_ID] IN (select value from STRING_SPLIT(@idWorker, ';'))  
		and (carServOrd.[Start_Date]>=cast(@startDate as datetime) 
		or carServOrd.[End_Date] <=cast(@endDate as datetime))
		GROUP BY worker.[ID_Worker]
	)
GO
/****** Object:  UserDefinedFunction [dbo].[Analiz_WorkerCountComponent]    Script Date: 11.05.2022 9:03:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create   function [dbo].[Analiz_WorkerCountComponent] (@startDate [nvarchar] (20),@endDate [nvarchar] (20),@idWorker [nvarchar] (max))--Вывод колличества назначеных компонентов
returns table
as
	return(
		select 
		worker.[ID_Worker] as 'Номер работника',
		SUM(compOrder.Quantity_Component) as 'Количество назначенных компонентов'
		from [Worker] worker
		inner join [dbo].[Component_Order] compOrder on compOrder.[Worker_ID] = worker.[ID_Worker]
		where compOrder.[Worker_ID] IN (select value from STRING_SPLIT(@idWorker, ';')) 
		and compOrder.[Date_Enrollment] >=@startDate and compOrder.[Date_Enrollment] <=@endDate
		GROUP BY compOrder.[Worker_ID],worker.[ID_Worker]
	)
GO
/****** Object:  UserDefinedFunction [dbo].[Analiz_WorkerCountService]    Script Date: 11.05.2022 9:03:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create   function [dbo].[Analiz_WorkerCountService] (@startDate [nvarchar] (20),@endDate [nvarchar] (20),@idWorker [nvarchar] (max))--Вывод колличества выполненых услуг
returns table
as
	return(
		 select 
		 worker.[ID_Worker] as 'Номер работника',
		 COUNT(carServOrd.Worker_ID) as 'Количество выполненных услуг'
		 from [dbo].[Worker] worker
		 inner join [dbo].[Car_Services_Provided] carServOrd on carServOrd.[Worker_ID]=[ID_Worker]
		 where carServOrd.[Worker_ID] IN (select value from STRING_SPLIT(@idWorker, ';'))  
		 and (carServOrd.[Start_Date]>=cast(@startDate as datetime) 
		 or carServOrd.[End_Date] <=cast(@endDate as datetime))
		 GROUP BY carServOrd.[Worker_ID],worker.[ID_Worker]
	)
GO
/****** Object:  Table [dbo].[Order_Log]    Script Date: 11.05.2022 9:03:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Order_Log](
	[ID_Order_Log] [int] IDENTITY(1,1) NOT NULL,
	[Quantity_Component] [float] NULL,
	[Component_Order_ID] [int] NULL,
	[Application_ID] [int] NULL,
	[Price] [decimal](38, 2) NOT NULL,
	[List_Status_ID] [int] NOT NULL,
 CONSTRAINT [PK_Order_Log] PRIMARY KEY CLUSTERED 
(
	[ID_Order_Log] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[Search_Component_Type]    Script Date: 11.05.2022 9:03:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   function [dbo].[Search_Component_Type] (@idComponentOrder [nvarchar] (max))--Функция поиска компонента для заказа
returns table
as
	return(
		select 
		component.[Name_Component]
		from [dbo].[Component] component
		inner join [dbo].[Component_Order] co on co.[Component_ID] = component.[ID_Component]
		inner join [dbo].[Order_Log] ol on ol.[Component_Order_ID] = co.[ID_Component_Order]
		where component.[Type_Сonsumable] = 1 and ol.[Component_Order_ID] IN (select value from STRING_SPLIT(@idComponentOrder, ';'))
		Group BY component.[Name_Component]
	)

GO
/****** Object:  UserDefinedFunction [dbo].[Warehouse_Component_View_FuncUpdateUser]    Script Date: 11.05.2022 9:03:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   function [dbo].[Warehouse_Component_View_FuncUpdateUser] (@idBranch [int])--Вывод списка компонентов на складе
returns table
as
	return(
		select
		c.[Name_Component] as 'Наименование компанента',
		ISNULL(SUM(w.[Quantity_Warehouse]),0) as 'Количество'
		from [dbo].[Warehouse] w
		inner join [dbo].[Component] c on w.[Component_ID]=c.[ID_Component]
		where w.[Branch_ID] = @idBranch
		GROUP BY c.[Name_Component]
	)
GO
/****** Object:  View [dbo].[Component_View]    Script Date: 11.05.2022 9:03:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create or alter  view [dbo].[Component_View] ("Номер компонента","Наименование материала","Минимальное количество","Тип расходник")--Вывод списка компонентов
as
	select * from [dbo].[Component]
GO
/****** Object:  View [dbo].[Warehouse_Component_List_View]    Script Date: 11.05.2022 9:03:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create  or alter view [dbo].[Warehouse_Component_List_View] ("Номер компонента на складе","Наименование материала","Количество","Цена","Минимальное количество","Тип расходник")--Вывод списка компонентов для выбора
as
	select 
		c.[ID_Component] as 'Номер компонента на складе',
		c.[Name_Component] as 'Наименование материала',
		'0' as 'Количество',
		'0' as 'Цена',
		ISNULL(c.[Minimum_Quantity],0) as 'Минимальное количество',
		c.[Type_Сonsumable] as 'Тип расходник'
		from [dbo].[Component] c
		where c.Type_Сonsumable = 0
GO
/****** Object:  Table [dbo].[Application]    Script Date: 11.05.2022 9:03:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Application](
	[ID_Application] [int] IDENTITY(1,1) NOT NULL,
	[Component_ID] [int] NOT NULL,
	[Branch_ID] [int] NOT NULL,
	[Worker_ID] [int] NULL,
	[Date_Creation] [nvarchar](20) NOT NULL,
 CONSTRAINT [PK_Application] PRIMARY KEY CLUSTERED 
(
	[ID_Application] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[Order_Log_View]    Script Date: 11.05.2022 9:03:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create or alter  view [dbo].[Order_Log_View] ("Номер в журнале заказов","Наименование матаериала","Количество","Стоимость за еденицу","Статус","Номер статуса","Тип компонента","Номер компонента", "Номер строки в списке с компанентами","Должность последнего сотрудника","Место создания")--Вывод списка Журнала заказаов
as
	select 
	TOP(select count(ID_Order_Log) from [dbo].[Order_Log])
	ol.[ID_Order_Log],

	CASE ISNULL(ol.[Application_ID], 0)
		WHEN 0 THEN
			(CASE component.[Type_Сonsumable]
				WHEN 1 THEN component.[Name_Component]
				WHEN 0 THEN	component.[Name_Component] +' - '+ ord.[VIN]
			END)
		ELSE componentApp.[Name_Component]
	END,

	CASE ISNULL(ol.[Application_ID], 0)
		WHEN 0 THEN
			CASE component.[Type_Сonsumable]
				WHEN 1 THEN ol.[Quantity_Component]
				WHEN 0 THEN	co.[Quantity_Component]	
			END
		ELSE ol.[Quantity_Component]
	END,

	ol.[Price],
	ls.[Name_Status],
	ls.[ID_List_Status],

	CASE ISNULL(ol.[Application_ID], 0)
		WHEN 0 THEN component.[Type_Сonsumable]
		ELSE componentApp.[Type_Сonsumable]
	END,

	CASE ISNULL(ol.[Application_ID], 0)
		WHEN 0 THEN co.[Component_ID]
		ELSE app.[Component_ID]
	END,

	CASE ISNULL(ol.[Application_ID], 0)
		WHEN 0 THEN ol.[Component_Order_ID]
		ELSE ol.[Application_ID]
	END,

	post.[Name_Post],

	CASE ISNULL(ol.[Application_ID], 0)
		WHEN 0 THEN N'OrderComponent'
		ELSE N'Application'
	END

	from [dbo].[Order_Log] ol
	left join [dbo].[Component_Order] co on ol.[Component_Order_ID] = co.[ID_Component_Order]
	left join [dbo].[Order] ord on co.[Order_ID] = ord.[ID_Order]
	left join [dbo].[Worker] worker on ord.[Worker_ID] = worker.[ID_Worker]
	left join [dbo].[Post] post on worker.[Post_ID] = post.[ID_Post]
	left join [dbo].[List_Status] ls on ol.[List_Status_ID] = ls.[ID_List_Status]
	left join [dbo].[Component] component on co.[Component_ID] = component.[ID_Component]
	left join [dbo].[Application] app on ol.[Application_ID] = app.[ID_Application]
	left join [dbo].[Component] componentApp on app.[Component_ID] = componentApp.[ID_Component]
	ORDER BY ol.[List_Status_ID]
GO
/****** Object:  UserDefinedFunction [dbo].[Warehouse_Component_View_FuncUpdate]    Script Date: 11.05.2022 9:03:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   function [dbo].[Warehouse_Component_View_FuncUpdate] (@idBranch [int])--Вывод списка компонентов на складе
returns table
as
	return(
		select
		w.[ID_Warehouse] as 'Номер компонента на складе',
		c.[Name_Component] as 'Наименование компонента',
		ISNULL(w.[Quantity_Warehouse],0) as 'Количество'
		from [dbo].[Warehouse] w
		inner join [dbo].[Component] c on w.[Component_ID]=c.[ID_Component]
		where w.[Branch_ID] = @idBranch
	)

GO
/****** Object:  View [dbo].[Service_View]    Script Date: 11.05.2022 9:03:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   view [dbo].[Service_View] ("Номер услуги","Наименование услуги","Нормо-час","Стоимость","Номер группы услуги","Группа услуг")--Вывод списка услуг
as
	select
	ls.[ID_List_Services],
	ls.[Name_Services],
	ls.[Norm_Hour],
	ls.[Price],
	sg.[ID_Service_Group],
	sg.[Name_Group_Service]
	from [dbo].[List_Services] ls
	inner join [dbo].[Service_Group] sg on ls.[Service_Group_ID] = sg.[ID_Service_Group]

GO
/****** Object:  View [dbo].[List_Service_View_Guide]    Script Date: 11.05.2022 9:03:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create   view [dbo].[List_Service_View_Guide] ("Номер услуги","Наименование услуги","Нормо-час","Стоимость","Номер группы услуги","Группа услуг")--Вывод списка услуг в справонике
as
	select
	ls.[ID_List_Services],
	ls.[Name_Services],
	ls.[Norm_Hour],
	ls.[Price],
	sg.[ID_Service_Group],
	sg.[Name_Group_Service]
	from [dbo].[List_Services] ls
	inner join [dbo].[Service_Group] sg on ls.[Service_Group_ID] = sg.[ID_Service_Group]
GO
/****** Object:  UserDefinedFunction [dbo].[Search_Component_TypeNo]    Script Date: 11.05.2022 9:03:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   function [dbo].[Search_Component_TypeNo] (@idComponentOrder [nvarchar] (max))--Функция поиска компонента для заказа
returns table
as
	return(
		select 
		count(component.[Name_Component]) as 'count'
		from [dbo].[Component] component
		inner join [dbo].[Component_Order] co on co.[Component_ID] = component.[ID_Component]
		inner join [dbo].[Order_Log] ol on ol.[Component_Order_ID] = co.[ID_Component_Order]
		where component.[Type_Сonsumable] = 0 and ol.[Component_Order_ID] IN (select value from STRING_SPLIT(@idComponentOrder, ';'))
		Group BY component.[Name_Component]
	)

GO
/****** Object:  View [dbo].[Component_TypeConsumable_View]    Script Date: 11.05.2022 9:03:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create or alter  view [dbo].[Component_TypeConsumable_View] ("Номер материала","Наименование материала")--Вывод списка компонентов только расходники
as
	select [ID_Component],[Name_Component] from [dbo].[Component] where [Type_Сonsumable] = 1
GO
/****** Object:  View [dbo].[List_Service_View]    Script Date: 11.05.2022 9:03:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   view [dbo].[List_Service_View] ("Номер услуги","Наименование услуги","Норма-час","Стоимость")--Вывод списка услуг
as
	select 
	TOP(
		select count([Name_Group_Service]) 
		from [dbo].[List_Services]
		inner join [dbo].[Service_Group] on [Service_Group_ID]=[ID_Service_Group]
	)
	[ID_List_Services],
	[Name_Services],
	[Norm_Hour],
	[Price]
	from [dbo].[List_Services]
	inner join [dbo].[Service_Group] on [Service_Group_ID]=[ID_Service_Group]
	ORDER BY [Service_Group_ID]
GO
/****** Object:  View [dbo].[Client_View]    Script Date: 11.05.2022 9:03:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create   view [dbo].[Client_View] ("Номер клиента","Фамилия","Имя","Отчество","Телефон","Дата рождения")--Вывод списка клиентов
as
	select 
	[ID_Client],[Surname],[Name],[Middle_Name],[Phone],FORMAT([Date_Birth],'dd.MM.yyyy')
	from [dbo].[Client]
GO
/****** Object:  View [dbo].[Car_Brand_View]    Script Date: 11.05.2022 9:03:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create   view [dbo].[Car_Brand_View] ("Название марки") --Вывод марки машины
as
	select 
	[Name_Car_Brand]
	from [dbo].[Car_Brand]
GO
/****** Object:  View [dbo].[Car_Brand_List]    Script Date: 11.05.2022 9:03:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   view [dbo].[Car_Brand_List] ("Номер марки","Название марки") --Вывод всех машины
as
	select
	TOP(select count([Name_Car_Brand]) from [dbo].[Car_Brand]) 
	[ID_Car_Brand],
	[Name_Car_Brand]
	from [dbo].[Car_Brand]

GO
/****** Object:  View [dbo].[Order_Log_View_Filter]    Script Date: 11.05.2022 9:03:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   view [dbo].[Order_Log_View_Filter] ("Номер в журнале заказов","Наименование компонента","Количество","Стоимость за еденицу","Статус","Номер статуса","Тип компонента","Номер компонента", "Номер строки в списке с компанентами","Должность последнего сотрудника","Место создания")--Вывод списка Журнала заказаов
as
	select 
	TOP(select count(ID_Order_Log) from [dbo].[Order_Log])
	ol.[ID_Order_Log],

	CASE ISNULL(ol.[Application_ID], 0)
		WHEN 0 THEN
			(CASE component.[Type_Сonsumable]
				WHEN 1 THEN component.[Name_Component]
				WHEN 0 THEN	component.[Name_Component] +' - '+ ord.[VIN]
			END)
		ELSE componentApp.[Name_Component]
	END,

	CASE ISNULL(ol.[Application_ID], 0)
		WHEN 0 THEN
			CASE component.[Type_Сonsumable]
				WHEN 1 THEN ol.[Quantity_Component]
				WHEN 0 THEN	co.[Quantity_Component]	
			END
		ELSE ol.[Quantity_Component]
	END,

	ol.[Price],
	ls.[Name_Status],
	ls.[ID_List_Status],

	CASE ISNULL(ol.[Application_ID], 0)
		WHEN 0 THEN component.[Type_Сonsumable]
		ELSE componentApp.[Type_Сonsumable]
	END,

	CASE ISNULL(ol.[Application_ID], 0)
		WHEN 0 THEN co.[Component_ID]
		ELSE app.[Component_ID]
	END,

	CASE ISNULL(ol.[Application_ID], 0)
		WHEN 0 THEN ol.[Component_Order_ID]
		ELSE ol.[Application_ID]
	END,

	post.[Name_Post],

	CASE ISNULL(ol.[Application_ID], 0)
		WHEN 0 THEN 'OrderComponent'
		ELSE 'Application'
	END

	from [dbo].[Order_Log] ol
	left join [dbo].[Component_Order] co on ol.[Component_Order_ID] = co.[ID_Component_Order]
	left join [dbo].[Order] ord on co.[Order_ID] = ord.[ID_Order]
	left join [dbo].[Worker] worker on ord.[Worker_ID] = worker.[ID_Worker]
	left join [dbo].[Post] post on worker.[Post_ID] = post.[ID_Post]
	left join [dbo].[List_Status] ls on ol.[List_Status_ID] = ls.[ID_List_Status]
	left join [dbo].[Component] component on co.[Component_ID] = component.[ID_Component]
	left join [dbo].[Application] app on ol.[Application_ID] = app.[ID_Application]
	left join [dbo].[Component] componentApp on app.[Component_ID] = componentApp.[ID_Component]
	where ls.[Name_Status] != 'Закрыт'
	ORDER BY ol.[List_Status_ID]
GO
/****** Object:  View [dbo].[Order_Log_View_Filter_Alter]    Script Date: 11.05.2022 9:03:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create or alter   view [dbo].[Order_Log_View_Filter_Alter] ("Номер в журнале заказов","Наименование материала","Количество","Стоимость за еденицу","Статус","Номер статуса","Тип компонента","Номер компонента", "Номер строки в списке с компанентами","Должность последнего сотрудника","Место создания")--Вывод списка Журнала заказаов
as
	select 
	TOP(select count(ID_Order_Log) from [dbo].[Order_Log])
	ol.[ID_Order_Log],

	CASE ISNULL(ol.[Application_ID], 0)
		WHEN 0 THEN
			(CASE component.[Type_Сonsumable]
				WHEN 1 THEN component.[Name_Component]
				WHEN 0 THEN	component.[Name_Component] +' - '+ ord.[VIN]
			END)
		ELSE componentApp.[Name_Component]
	END,

	CASE ISNULL(ol.[Application_ID], 0)
		WHEN 0 THEN
			CASE component.[Type_Сonsumable]
				WHEN 1 THEN ol.[Quantity_Component]
				WHEN 0 THEN	co.[Quantity_Component]	
			END
		ELSE ol.[Quantity_Component]
	END,

	ol.[Price],
	ls.[Name_Status],
	ls.[ID_List_Status],

	CASE ISNULL(ol.[Application_ID], 0)
		WHEN 0 THEN component.[Type_Сonsumable]
		ELSE componentApp.[Type_Сonsumable]
	END,

	CASE ISNULL(ol.[Application_ID], 0)
		WHEN 0 THEN co.[Component_ID]
		ELSE app.[Component_ID]
	END,

	CASE ISNULL(ol.[Application_ID], 0)
		WHEN 0 THEN ol.[Component_Order_ID]
		ELSE ol.[Application_ID]
	END,

	post.[Name_Post],

	CASE ISNULL(ol.[Application_ID], 0)
		WHEN 0 THEN N'OrderComponent'
		ELSE N'Application'
	END

	from [dbo].[Order_Log] ol
	left join [dbo].[Component_Order] co on ol.[Component_Order_ID] = co.[ID_Component_Order]
	left join [dbo].[Order] ord on co.[Order_ID] = ord.[ID_Order]
	left join [dbo].[Worker] worker on ord.[Worker_ID] = worker.[ID_Worker]
	left join [dbo].[Post] post on worker.[Post_ID] = post.[ID_Post]
	left join [dbo].[List_Status] ls on ol.[List_Status_ID] = ls.[ID_List_Status]
	left join [dbo].[Component] component on co.[Component_ID] = component.[ID_Component]
	left join [dbo].[Application] app on ol.[Application_ID] = app.[ID_Application]
	left join [dbo].[Component] componentApp on app.[Component_ID] = componentApp.[ID_Component]
	where ls.[Name_Status] != 'Закрыт'
	ORDER BY ol.[List_Status_ID]
GO
/****** Object:  UserDefinedFunction [dbo].[Order_Log_View_FilterFunction]    Script Date: 11.05.2022 9:03:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create or alter  function [dbo].[Order_Log_View_FilterFunction] (@nameListStatus [nvarchar] (max))--Вывод списка Журнала заказаов
returns table
as
	return(
		select 
		TOP(select count(ID_Order_Log) from [dbo].[Order_Log])
		ol.[ID_Order_Log] as 'Номер в журнале заказов',

		CASE ISNULL(ol.[Application_ID], 0)
			WHEN 0 THEN
				(CASE component.[Type_Сonsumable]
					WHEN 1 THEN component.[Name_Component]
					WHEN 0 THEN	component.[Name_Component] +' - '+ ord.[VIN]
				END)
			ELSE componentApp.[Name_Component]
		END as 'Наименование материала',

		CASE ISNULL(ol.[Application_ID], 0)
			WHEN 0 THEN
				CASE component.[Type_Сonsumable]
					WHEN 1 THEN ol.[Quantity_Component]
					WHEN 0 THEN	co.[Quantity_Component]	
				END
			ELSE ol.[Quantity_Component]
		END as 'Количество',

		ol.[Price] as 'Стоимость за еденицу',
		ls.[Name_Status] as 'Статус',
		ls.[ID_List_Status] as 'Номер статуса',

		CASE ISNULL(ol.[Application_ID], 0)
			WHEN 0 THEN component.[Type_Сonsumable]
			ELSE componentApp.[Type_Сonsumable]
		END as 'Тип компонента',

		CASE ISNULL(ol.[Application_ID], 0)
			WHEN 0 THEN co.[Component_ID]
			ELSE app.[Component_ID]
		END as 'Номер компонента',

		CASE ISNULL(ol.[Application_ID], 0)
			WHEN 0 THEN ol.[Component_Order_ID]
			ELSE ol.[Application_ID]
		END as 'Номер строки в списке с компанентами',

		post.[Name_Post] as 'Должность последнего сотрудника',

		CASE ISNULL(ol.[Application_ID], 0)
			WHEN 0 THEN N'OrderComponent'
			ELSE N'Application'
		END as 'Место создания'

		from [dbo].[Order_Log] ol
		left join [dbo].[Component_Order] co on ol.[Component_Order_ID] = co.[ID_Component_Order]
		left join [dbo].[Order] ord on co.[Order_ID] = ord.[ID_Order]
		left join [dbo].[Worker] worker on ord.[Worker_ID] = worker.[ID_Worker]
		left join [dbo].[Post] post on worker.[Post_ID] = post.[ID_Post]
		left join [dbo].[List_Status] ls on ol.[List_Status_ID] = ls.[ID_List_Status]
		left join [dbo].[Component] component on co.[Component_ID] = component.[ID_Component]
		left join [dbo].[Application] app on ol.[Application_ID] = app.[ID_Application]
		left join [dbo].[Component] componentApp on app.[Component_ID] = componentApp.[ID_Component]
		where ls.[Name_Status] = @nameListStatus
	)
GO
/****** Object:  View [dbo].[OrderLog_View_FunUpdate]    Script Date: 11.05.2022 9:03:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   view [dbo].[OrderLog_View_FunUpdate] ("Номер ЖЗ","Номер компонента")--Вывод списка Журнала заказаов в функции обновления
as
	select 
	ol.[ID_Order_Log],
	CASE ISNULL(ol.[Application_ID],0)
	 WHEN 0 THEN co.[Component_ID]
	 ELSE app.[Component_ID]
	END
	from [dbo].[Order_Log] ol
	left join [dbo].[List_Status] ls on ol.[List_Status_ID] = ls.[ID_List_Status]
	left join [dbo].[Component_Order] co on ol.[Component_Order_ID] = co.[ID_Component_Order]
	left join [dbo].[Application] app on ol.[Application_ID] = app.[ID_Application]
	where ls.[Name_Status] != 'Закрыт'

GO
/****** Object:  View [dbo].[Car_Model_List]    Script Date: 11.05.2022 9:03:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create   view [dbo].[Car_Model_List] ("Номер модели","Название модели") --Вывод моделей машины
as
	select 
	TOP(select count([Name_Car_Model]) from [dbo].[Car_Model])
	[ID_Car_Model],
	[Name_Car_Model]
	from [dbo].[Car_Model]
	Order BY [Name_Car_Model]

GO
/****** Object:  View [dbo].[Service_Group_View]    Script Date: 11.05.2022 9:03:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create   view [dbo].[Service_Group_View] ("Номер группы","Наименование группы")--Вывод списка групп услуг
as
	select * from [dbo].[Service_Group]
GO
/****** Object:  View [dbo].[Information_Post]    Script Date: 11.05.2022 9:03:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create   view [dbo].[Information_Post] ("Название должности")--Создание представления для таблицы: "Должность".
as
	select 
	[Name_Post]
	from [dbo].[Post]
GO
/****** Object:  View [dbo].[Information_Branch]    Script Date: 11.05.2022 9:03:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create   view [dbo].[Information_Branch] ("Название адреса филиала")--Вывод списка адрессов
as
	select 
	[Address]
	from [dbo].[Branch]
GO
SET IDENTITY_INSERT [dbo].[Application] ON 

INSERT [dbo].[Application] ([ID_Application], [Component_ID], [Branch_ID], [Worker_ID], [Date_Creation]) VALUES (26, 5, 1, 32, N'06.05.2022')
INSERT [dbo].[Application] ([ID_Application], [Component_ID], [Branch_ID], [Worker_ID], [Date_Creation]) VALUES (27, 47, 1, 32, N'06.05.2022')
INSERT [dbo].[Application] ([ID_Application], [Component_ID], [Branch_ID], [Worker_ID], [Date_Creation]) VALUES (28, 52, 1, 32, N'06.05.2022')
INSERT [dbo].[Application] ([ID_Application], [Component_ID], [Branch_ID], [Worker_ID], [Date_Creation]) VALUES (29, 5, 1, 32, N'06.05.2022')
INSERT [dbo].[Application] ([ID_Application], [Component_ID], [Branch_ID], [Worker_ID], [Date_Creation]) VALUES (31, 51, 1, 32, N'06.05.2022')
INSERT [dbo].[Application] ([ID_Application], [Component_ID], [Branch_ID], [Worker_ID], [Date_Creation]) VALUES (32, 52, 1, 32, N'06.05.2022')
INSERT [dbo].[Application] ([ID_Application], [Component_ID], [Branch_ID], [Worker_ID], [Date_Creation]) VALUES (33, 51, 1, 32, N'10.05.2022')
SET IDENTITY_INSERT [dbo].[Application] OFF
SET IDENTITY_INSERT [dbo].[Branch] ON 

INSERT [dbo].[Branch] ([ID_Branch], [Address]) VALUES (1, N'гор. Москва 4-й Рощинский проезд, 20 ст11')
INSERT [dbo].[Branch] ([ID_Branch], [Address]) VALUES (2, N'гор. Москва Марксистская, 34 ст7')
SET IDENTITY_INSERT [dbo].[Branch] OFF
SET IDENTITY_INSERT [dbo].[Brand_Model_Compliance] ON 

INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1, 1, 1219)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (2, 1, 1220)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (3, 1, 3)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (4, 1, 4)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (5, 1, 5)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (6, 1, 6)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (7, 1, 7)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (8, 1, 8)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (9, 1, 9)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (10, 1, 10)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (11, 1, 11)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (12, 1, 12)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (13, 1, 13)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (14, 1, 14)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (15, 1, 15)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (16, 2, 16)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (17, 2, 17)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (18, 2, 18)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (19, 2, 19)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (20, 2, 20)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (21, 2, 21)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (22, 2, 22)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (23, 2, 23)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (24, 2, 24)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (25, 2, 25)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (26, 2, 26)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (27, 2, 27)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (28, 2, 28)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (29, 2, 29)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (30, 2, 30)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (31, 2, 31)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (32, 2, 32)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (33, 3, 33)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (34, 3, 34)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (35, 3, 35)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (36, 3, 36)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (37, 3, 37)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (38, 3, 38)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (39, 3, 39)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (40, 3, 40)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (41, 3, 41)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (42, 3, 42)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (43, 3, 43)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (44, 3, 44)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (45, 3, 45)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (46, 3, 46)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (47, 3, 47)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (48, 3, 48)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (49, 4, 49)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (50, 4, 50)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (51, 4, 51)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (52, 4, 52)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (53, 4, 53)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (54, 4, 54)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (55, 4, 55)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (56, 4, 56)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (57, 4, 57)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (58, 4, 58)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (59, 4, 59)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (60, 4, 60)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (61, 4, 61)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (62, 4, 62)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (63, 4, 63)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (64, 4, 64)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (65, 4, 65)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (66, 4, 66)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (67, 4, 67)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (68, 4, 68)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (69, 4, 69)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (70, 4, 70)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (71, 4, 71)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (72, 4, 72)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (73, 4, 73)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (74, 4, 74)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (75, 4, 75)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (76, 4, 76)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (77, 4, 77)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (78, 4, 78)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (79, 4, 79)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (80, 4, 80)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (81, 4, 81)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (82, 4, 82)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (83, 4, 83)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (84, 4, 84)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (85, 4, 85)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (86, 4, 86)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (87, 4, 87)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (88, 4, 88)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (89, 4, 89)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (90, 4, 90)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (91, 4, 91)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (92, 4, 92)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (93, 4, 93)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (94, 5, 94)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (95, 5, 95)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (96, 5, 96)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (97, 5, 97)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (98, 5, 98)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (99, 5, 99)
GO
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (100, 5, 100)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (101, 5, 101)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (102, 5, 102)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (103, 6, 103)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (104, 6, 104)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (105, 6, 105)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (106, 6, 106)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (107, 6, 107)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (108, 6, 108)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (109, 6, 109)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (110, 6, 110)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (111, 6, 111)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (112, 6, 112)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (113, 6, 113)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (114, 6, 114)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (115, 6, 115)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (116, 6, 116)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (117, 6, 117)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (118, 6, 118)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (119, 6, 119)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (120, 6, 120)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (121, 6, 121)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (122, 6, 122)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (123, 6, 123)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (124, 6, 124)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (125, 6, 125)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (126, 6, 126)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (127, 6, 127)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (128, 6, 128)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (129, 6, 129)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (130, 6, 130)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (131, 6, 131)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (132, 6, 132)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (133, 6, 133)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (134, 6, 134)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (135, 6, 135)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (136, 7, 136)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (137, 7, 137)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (138, 7, 138)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (139, 8, 139)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (140, 9, 140)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (141, 9, 141)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (142, 9, 142)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (143, 9, 143)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (144, 9, 144)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (145, 9, 145)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (146, 9, 146)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (147, 9, 147)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (148, 9, 148)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (149, 9, 149)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (150, 9, 150)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (151, 9, 151)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (152, 9, 152)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (153, 10, 153)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (154, 11, 154)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (155, 11, 155)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (156, 11, 156)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (157, 11, 157)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (158, 11, 158)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (159, 11, 159)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (160, 11, 160)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (161, 11, 161)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (162, 11, 162)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (163, 11, 163)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (164, 11, 164)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (165, 11, 165)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (166, 11, 166)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (167, 11, 167)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (168, 11, 168)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (169, 11, 169)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (170, 11, 170)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (171, 11, 171)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (172, 11, 172)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (173, 11, 173)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (174, 12, 174)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (175, 12, 175)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (176, 12, 176)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (177, 12, 177)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (178, 12, 178)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (179, 12, 179)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (180, 12, 180)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (181, 13, 181)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (182, 13, 182)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (183, 13, 183)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (184, 13, 184)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (185, 13, 185)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (186, 13, 186)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (187, 13, 187)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (188, 13, 188)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (189, 13, 189)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (190, 13, 190)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (191, 13, 191)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (192, 13, 192)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (193, 13, 193)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (194, 13, 194)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (195, 13, 195)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (196, 13, 196)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (197, 13, 197)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (198, 13, 198)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (199, 13, 199)
GO
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (200, 13, 200)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (201, 14, 201)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (202, 14, 202)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (203, 14, 203)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (204, 14, 204)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (205, 14, 205)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (206, 14, 206)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (207, 14, 207)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (208, 14, 208)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (209, 14, 209)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (210, 14, 210)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (211, 14, 211)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (212, 14, 212)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (213, 14, 213)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (214, 14, 214)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (215, 14, 215)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (216, 14, 216)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (217, 14, 217)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (218, 14, 218)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (219, 14, 219)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (220, 14, 220)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (221, 14, 221)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (222, 14, 222)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (223, 14, 223)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (224, 14, 224)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (225, 14, 225)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (226, 14, 226)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (227, 14, 227)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (228, 14, 228)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (229, 14, 229)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (230, 14, 230)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (231, 14, 231)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (232, 14, 232)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (233, 14, 233)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (234, 14, 234)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (235, 14, 235)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (236, 14, 236)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (237, 15, 237)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (238, 15, 238)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (239, 15, 239)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (240, 15, 240)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (241, 15, 241)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (242, 15, 242)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (243, 15, 243)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (244, 15, 244)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (245, 15, 245)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (246, 15, 246)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (247, 15, 247)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (248, 15, 248)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (249, 16, 249)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (250, 16, 250)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (251, 16, 251)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (252, 16, 252)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (253, 16, 253)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (254, 16, 254)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (255, 16, 255)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (256, 16, 256)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (257, 16, 257)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (258, 16, 258)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (259, 16, 259)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (260, 16, 260)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (261, 16, 261)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (262, 16, 262)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (263, 16, 263)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (264, 16, 264)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (265, 16, 265)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (266, 16, 266)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (267, 16, 267)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (268, 16, 268)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (269, 16, 269)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (270, 16, 270)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (271, 16, 271)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (272, 16, 272)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (273, 16, 273)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (274, 16, 274)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (275, 16, 275)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (276, 16, 276)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (277, 16, 277)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (278, 17, 278)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (279, 17, 279)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (280, 17, 280)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (281, 17, 281)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (282, 18, 282)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (283, 18, 283)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (284, 18, 284)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (285, 18, 285)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (286, 18, 286)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (287, 18, 287)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (288, 18, 288)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (289, 19, 289)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (290, 19, 290)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (291, 19, 291)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (292, 19, 292)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (293, 19, 293)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (294, 19, 294)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (295, 19, 295)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (296, 19, 296)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (297, 19, 297)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (298, 19, 298)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (299, 19, 299)
GO
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (300, 19, 300)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (301, 19, 301)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (302, 19, 302)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (303, 20, 303)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (304, 20, 304)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (305, 21, 305)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (306, 21, 306)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (307, 21, 307)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (308, 21, 308)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (309, 21, 309)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (310, 21, 310)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (311, 21, 311)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (312, 21, 312)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (313, 21, 313)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (314, 21, 314)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (315, 21, 315)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (316, 21, 316)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (317, 21, 317)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (318, 21, 318)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (319, 21, 319)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (320, 21, 320)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (321, 21, 321)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (322, 21, 322)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (323, 21, 323)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (324, 21, 324)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (325, 22, 325)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (326, 22, 326)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (327, 22, 327)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (328, 22, 328)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (329, 23, 329)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (330, 23, 330)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (331, 23, 331)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (332, 23, 332)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (333, 23, 333)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (334, 23, 334)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (335, 24, 335)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (336, 24, 336)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (337, 24, 337)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (338, 24, 338)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (339, 24, 339)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (340, 24, 340)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (341, 24, 341)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (342, 24, 342)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (343, 24, 343)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (344, 24, 344)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (345, 24, 345)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (346, 24, 346)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (347, 24, 347)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (348, 24, 348)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (349, 24, 349)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (350, 24, 350)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (351, 24, 351)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (352, 24, 352)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (353, 24, 353)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (354, 24, 354)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (355, 24, 355)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (356, 24, 356)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (357, 24, 357)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (358, 24, 358)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (359, 24, 359)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (360, 24, 360)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (361, 24, 361)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (362, 24, 362)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (363, 24, 363)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (364, 24, 364)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (365, 25, 365)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (366, 25, 366)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (367, 25, 367)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (368, 25, 368)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (369, 25, 369)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (370, 25, 370)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (371, 25, 371)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (372, 25, 372)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (373, 25, 373)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (374, 25, 374)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (375, 25, 375)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (376, 25, 376)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (377, 25, 377)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (378, 25, 378)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (379, 25, 379)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (380, 25, 380)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (381, 25, 381)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (382, 25, 382)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (383, 25, 383)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (384, 25, 384)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (385, 25, 385)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (386, 25, 386)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (387, 25, 387)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (388, 25, 388)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (389, 25, 389)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (390, 25, 390)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (391, 25, 391)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (392, 25, 392)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (393, 26, 393)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (394, 27, 394)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (395, 27, 395)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (396, 27, 396)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (397, 27, 397)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (398, 27, 398)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (399, 27, 399)
GO
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (400, 27, 400)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (401, 27, 401)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (402, 27, 402)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (403, 27, 403)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (404, 27, 404)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (405, 27, 405)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (406, 27, 406)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (407, 27, 407)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (408, 27, 408)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (409, 27, 409)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (410, 27, 410)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (411, 27, 411)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (412, 27, 412)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (413, 27, 413)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (414, 27, 414)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (415, 27, 415)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (416, 27, 416)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (417, 27, 417)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (418, 27, 418)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (419, 27, 419)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (420, 27, 420)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (421, 27, 421)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (422, 27, 422)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (423, 27, 423)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (424, 27, 424)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (425, 27, 425)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (426, 27, 426)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (427, 27, 427)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (428, 27, 428)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (429, 27, 429)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (430, 27, 430)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (431, 27, 431)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (432, 27, 432)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (433, 27, 433)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (434, 27, 434)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (435, 27, 435)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (436, 27, 436)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (437, 27, 437)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (438, 27, 438)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (439, 27, 439)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (440, 28, 440)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (441, 29, 441)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (442, 29, 442)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (443, 29, 443)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (444, 30, 444)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (445, 30, 445)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (446, 30, 446)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (447, 30, 447)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (448, 31, 448)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (449, 31, 449)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (450, 31, 450)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (451, 31, 451)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (452, 31, 452)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (453, 31, 453)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (454, 31, 454)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (455, 31, 455)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (456, 31, 456)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (457, 31, 457)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (458, 31, 458)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (459, 31, 459)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (460, 32, 460)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (461, 32, 461)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (462, 32, 462)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (463, 32, 463)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (464, 32, 464)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (465, 33, 465)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (466, 33, 466)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (467, 33, 467)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (468, 33, 468)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (469, 33, 469)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (470, 33, 470)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (471, 33, 471)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (472, 33, 472)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (473, 34, 473)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (474, 34, 474)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (475, 34, 475)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (476, 34, 476)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (477, 34, 477)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (478, 34, 478)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (479, 34, 479)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (480, 34, 480)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (481, 34, 481)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (482, 34, 482)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (483, 34, 483)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (484, 35, 484)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (485, 35, 485)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (486, 35, 486)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (487, 35, 487)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (488, 35, 488)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (489, 36, 489)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (490, 36, 490)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (491, 37, 491)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (492, 37, 492)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (493, 37, 493)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (494, 37, 494)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (495, 37, 495)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (496, 37, 496)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (497, 37, 497)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (498, 37, 498)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (499, 37, 499)
GO
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (500, 37, 500)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (501, 37, 501)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (502, 37, 502)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (503, 37, 503)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (504, 37, 504)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (505, 37, 505)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (506, 37, 506)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (507, 37, 507)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (508, 37, 508)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (509, 37, 509)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (510, 37, 510)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (511, 37, 511)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (512, 37, 512)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (513, 37, 513)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (514, 37, 514)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (515, 37, 515)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (516, 38, 516)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (517, 38, 517)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (518, 38, 518)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (519, 39, 519)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (520, 39, 520)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (521, 39, 521)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (522, 39, 522)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (523, 39, 523)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (524, 39, 524)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (525, 39, 525)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (526, 39, 526)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (527, 39, 527)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (528, 39, 528)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (529, 39, 529)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (530, 39, 530)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (531, 39, 531)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (532, 39, 532)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (533, 39, 533)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (534, 39, 534)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (535, 39, 535)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (536, 39, 536)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (537, 39, 537)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (538, 39, 538)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (539, 39, 539)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (540, 39, 540)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (541, 39, 541)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (542, 39, 542)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (543, 39, 543)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (544, 39, 544)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (545, 39, 545)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (546, 39, 546)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (547, 39, 547)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (548, 39, 548)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (549, 39, 549)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (550, 39, 550)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (551, 39, 551)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (552, 39, 552)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (553, 39, 553)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (554, 39, 554)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (555, 39, 555)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (556, 39, 556)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (557, 39, 557)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (558, 39, 558)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (559, 39, 559)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (560, 40, 560)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (561, 40, 561)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (562, 40, 562)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (563, 40, 563)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (564, 40, 564)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (565, 40, 565)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (566, 40, 566)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (567, 40, 567)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (568, 40, 568)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (569, 40, 569)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (570, 40, 570)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (571, 40, 571)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (572, 40, 572)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (573, 40, 573)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (574, 40, 574)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (575, 40, 575)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (576, 40, 576)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (577, 40, 577)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (578, 40, 578)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (579, 40, 579)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (580, 41, 580)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (581, 41, 581)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (582, 41, 582)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (583, 41, 583)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (584, 41, 584)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (585, 41, 585)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (586, 41, 586)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (587, 41, 587)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (588, 41, 588)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (589, 41, 589)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (590, 41, 590)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (591, 42, 591)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (592, 43, 592)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (593, 43, 593)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (594, 44, 594)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (595, 44, 595)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (596, 44, 596)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (597, 44, 597)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (598, 44, 598)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (599, 44, 599)
GO
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (600, 44, 600)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (601, 44, 601)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (602, 44, 602)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (603, 44, 603)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (604, 45, 604)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (605, 45, 605)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (606, 45, 606)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (607, 45, 607)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (608, 45, 608)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (609, 45, 609)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (610, 45, 610)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (611, 45, 611)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (612, 45, 612)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (613, 46, 613)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (614, 46, 614)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (615, 46, 615)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (616, 46, 616)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (617, 46, 617)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (618, 46, 618)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (619, 46, 619)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (620, 46, 620)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (621, 46, 621)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (622, 46, 622)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (623, 46, 623)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (624, 46, 624)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (625, 46, 625)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (626, 46, 626)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (627, 46, 627)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (628, 46, 628)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (629, 46, 629)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (630, 46, 630)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (631, 46, 631)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (632, 46, 632)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (633, 46, 633)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (634, 46, 634)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (635, 46, 635)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (636, 46, 636)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (637, 46, 637)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (638, 46, 638)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (639, 46, 639)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (640, 46, 640)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (641, 46, 641)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (642, 46, 642)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (643, 46, 643)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (644, 46, 644)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (645, 47, 645)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (646, 47, 646)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (647, 47, 647)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (648, 47, 648)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (649, 47, 649)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (650, 47, 650)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (651, 47, 651)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (652, 47, 652)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (653, 48, 653)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (654, 48, 654)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (655, 48, 655)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (656, 48, 656)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (657, 48, 657)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (658, 48, 658)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (659, 48, 659)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (660, 74, 660)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (661, 74, 661)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (662, 74, 662)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (663, 74, 663)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (664, 74, 664)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (665, 74, 665)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (666, 74, 666)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (667, 74, 667)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (668, 50, 668)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (669, 50, 669)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (670, 50, 670)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (671, 50, 671)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (672, 50, 672)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (673, 50, 673)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (674, 50, 674)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (675, 50, 675)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (676, 50, 676)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (677, 50, 677)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (678, 50, 678)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (679, 50, 679)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (680, 50, 680)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (681, 50, 681)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (682, 50, 682)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (683, 50, 683)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (684, 51, 684)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (685, 51, 685)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (686, 51, 686)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (687, 51, 687)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (688, 51, 688)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (689, 51, 689)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (690, 51, 690)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (691, 52, 691)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (692, 52, 692)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (693, 52, 693)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (694, 52, 694)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (695, 52, 695)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (696, 52, 696)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (697, 52, 697)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (698, 52, 698)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (699, 52, 699)
GO
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (700, 52, 700)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (701, 52, 701)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (702, 52, 702)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (703, 53, 703)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (704, 53, 704)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (705, 53, 705)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (706, 53, 706)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (707, 54, 707)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (708, 54, 708)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (709, 55, 709)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (710, 55, 710)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (711, 55, 711)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (712, 55, 712)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (713, 55, 713)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (714, 55, 714)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (715, 55, 715)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (716, 55, 716)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (717, 56, 717)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (718, 56, 718)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (719, 56, 719)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (720, 56, 720)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (721, 56, 721)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (722, 57, 722)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (723, 57, 723)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (724, 57, 724)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (725, 57, 725)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (726, 57, 726)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (727, 57, 727)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (728, 57, 728)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (729, 57, 729)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (730, 57, 730)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (731, 57, 731)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (732, 57, 732)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (733, 57, 733)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (734, 57, 734)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (735, 57, 735)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (736, 57, 736)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (737, 57, 737)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (738, 57, 738)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (739, 57, 739)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (740, 57, 740)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (741, 57, 741)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (742, 57, 742)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (743, 58, 743)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (744, 58, 744)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (745, 58, 745)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (746, 58, 746)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (747, 58, 747)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (748, 58, 748)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (749, 58, 749)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (750, 58, 750)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (751, 58, 751)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (752, 59, 752)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (753, 59, 753)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (754, 59, 754)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (755, 59, 755)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (756, 59, 756)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (757, 59, 757)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (758, 59, 758)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (759, 59, 759)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (760, 59, 760)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (761, 59, 761)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (762, 59, 762)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (763, 59, 763)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (764, 59, 764)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (765, 59, 765)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (766, 59, 766)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (767, 59, 767)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (768, 59, 768)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (769, 59, 769)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (770, 59, 770)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (771, 59, 771)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (772, 59, 772)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (773, 59, 773)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (774, 59, 774)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (775, 59, 775)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (776, 59, 776)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (777, 59, 777)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (778, 59, 778)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (779, 59, 779)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (780, 59, 780)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (781, 59, 781)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (782, 59, 782)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (783, 59, 783)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (784, 59, 784)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (785, 59, 785)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (786, 59, 786)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (787, 59, 787)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (788, 59, 788)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (789, 59, 789)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (790, 59, 790)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (791, 59, 791)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (792, 59, 792)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (793, 59, 793)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (794, 59, 794)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (795, 60, 795)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (796, 60, 796)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (797, 60, 797)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (798, 60, 798)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (799, 60, 799)
GO
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (800, 60, 800)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (801, 60, 801)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (802, 61, 802)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (803, 61, 803)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (804, 61, 804)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (805, 61, 805)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (806, 61, 806)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (807, 61, 807)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (808, 62, 808)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (809, 62, 809)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (810, 62, 810)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (811, 62, 811)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (812, 62, 812)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (813, 62, 813)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (814, 62, 814)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (815, 62, 815)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (816, 62, 816)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (817, 62, 817)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (818, 63, 818)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (819, 63, 819)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (820, 63, 820)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (821, 63, 821)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (822, 63, 822)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (823, 63, 823)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (824, 63, 824)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (825, 63, 825)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (826, 63, 826)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (827, 63, 827)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (828, 63, 828)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (829, 63, 829)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (830, 63, 830)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (831, 63, 831)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (832, 63, 832)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (833, 63, 833)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (834, 63, 834)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (835, 63, 835)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (836, 63, 836)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (837, 63, 837)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (838, 63, 838)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (839, 63, 839)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (840, 63, 840)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (841, 63, 841)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (842, 63, 842)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (843, 63, 843)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (844, 64, 844)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (845, 64, 845)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (846, 64, 846)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (847, 64, 847)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (848, 64, 848)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (849, 64, 849)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (850, 64, 850)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (851, 64, 851)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (852, 64, 852)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (853, 64, 853)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (854, 64, 854)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (855, 64, 855)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (856, 64, 856)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (857, 64, 857)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (858, 64, 858)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (859, 64, 859)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (860, 64, 860)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (861, 64, 861)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (862, 64, 862)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (863, 64, 863)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (864, 64, 864)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (865, 64, 865)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (866, 64, 866)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (867, 64, 867)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (868, 64, 868)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (869, 64, 869)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (870, 64, 870)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (871, 64, 871)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (872, 64, 872)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (873, 64, 873)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (874, 64, 874)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (875, 64, 875)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (876, 64, 876)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (877, 64, 877)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (878, 64, 878)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (879, 64, 879)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (880, 64, 880)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (881, 65, 881)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (882, 66, 882)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (883, 66, 883)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (884, 66, 884)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (885, 66, 885)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (886, 66, 886)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (887, 66, 887)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (888, 66, 888)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (889, 66, 889)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (890, 66, 890)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (891, 66, 891)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (892, 66, 892)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (893, 66, 893)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (894, 66, 894)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (895, 66, 895)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (896, 66, 896)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (897, 66, 897)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (898, 66, 898)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (899, 66, 899)
GO
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (900, 66, 900)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (901, 66, 901)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (902, 66, 902)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (903, 66, 903)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (904, 66, 904)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (905, 66, 905)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (906, 66, 906)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (907, 66, 907)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (908, 66, 908)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (909, 66, 909)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (910, 66, 910)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (911, 67, 911)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (912, 67, 912)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (913, 67, 913)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (914, 67, 914)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (915, 67, 915)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (916, 67, 916)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (917, 67, 917)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (918, 67, 918)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (919, 67, 919)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (920, 67, 920)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (921, 67, 921)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (922, 67, 922)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (923, 67, 923)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (924, 67, 924)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (925, 67, 925)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (926, 67, 926)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (927, 67, 927)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (928, 67, 928)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (929, 67, 929)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (930, 67, 930)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (931, 67, 931)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (932, 67, 932)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (933, 67, 933)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (934, 67, 934)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (935, 67, 935)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (936, 67, 936)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (937, 67, 937)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (938, 68, 938)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (939, 69, 939)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (940, 69, 940)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (941, 69, 941)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (942, 69, 942)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (943, 69, 943)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (944, 69, 944)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (945, 69, 945)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (946, 69, 946)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (947, 69, 947)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (948, 69, 948)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (949, 69, 949)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (950, 69, 950)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (951, 69, 951)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (952, 69, 952)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (953, 70, 953)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (954, 70, 954)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (955, 70, 955)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (956, 70, 956)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (957, 70, 957)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (958, 70, 958)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (959, 70, 959)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (960, 70, 960)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (961, 70, 961)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (962, 71, 962)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (963, 72, 963)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (964, 72, 964)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (965, 72, 965)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (966, 72, 966)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (967, 72, 967)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (968, 72, 968)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (969, 72, 969)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (970, 72, 970)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (971, 72, 971)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (972, 72, 972)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (973, 72, 973)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (974, 72, 974)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (975, 72, 975)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (976, 72, 976)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (977, 72, 977)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (978, 72, 978)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (979, 72, 979)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (980, 72, 980)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (981, 72, 981)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (982, 72, 982)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (983, 72, 983)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (984, 72, 984)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (985, 72, 985)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (986, 72, 986)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (987, 72, 987)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (988, 72, 988)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (989, 72, 989)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (990, 72, 990)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (991, 72, 991)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (992, 72, 992)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (993, 72, 993)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (994, 72, 994)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (995, 72, 995)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (996, 73, 996)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (997, 73, 997)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (998, 73, 998)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (999, 73, 999)
GO
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1000, 73, 1000)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1001, 74, 1001)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1002, 74, 1002)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1003, 74, 1003)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1004, 74, 1004)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1005, 74, 1005)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1006, 74, 1006)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1007, 75, 1007)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1008, 75, 1008)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1009, 75, 1009)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1010, 75, 1010)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1011, 75, 1011)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1012, 76, 1012)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1013, 76, 1013)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1014, 76, 1014)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1015, 76, 1015)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1016, 76, 1016)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1017, 76, 1017)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1018, 77, 1018)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1019, 77, 1019)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1020, 77, 1020)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1021, 77, 1021)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1022, 77, 1022)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1023, 78, 1023)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1024, 78, 1024)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1025, 78, 1025)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1026, 78, 1026)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1027, 78, 1027)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1028, 78, 1028)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1029, 78, 1029)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1030, 78, 1030)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1031, 78, 1031)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1032, 78, 1032)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1033, 78, 1033)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1034, 78, 1034)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1035, 78, 1035)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1036, 78, 1036)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1037, 79, 1037)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1038, 79, 1038)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1039, 79, 1039)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1040, 79, 1040)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1041, 79, 1041)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1042, 79, 1042)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1043, 79, 1043)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1044, 79, 1044)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1045, 79, 1045)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1046, 79, 1046)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1047, 79, 1047)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1048, 79, 1048)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1049, 79, 1049)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1050, 79, 1050)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1051, 79, 1051)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1052, 79, 1052)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1053, 79, 1053)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1054, 80, 1054)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1055, 80, 1055)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1056, 80, 1056)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1057, 81, 1057)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1058, 81, 1058)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1059, 81, 1059)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1060, 81, 1060)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1061, 81, 1061)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1062, 81, 1062)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1063, 81, 1063)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1064, 81, 1064)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1065, 81, 1065)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1066, 81, 1066)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1067, 81, 1067)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1068, 81, 1068)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1069, 82, 1069)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1070, 82, 1070)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1071, 82, 1071)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1072, 82, 1072)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1073, 82, 1073)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1074, 82, 1074)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1075, 82, 1075)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1076, 82, 1076)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1077, 82, 1077)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1078, 82, 1078)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1079, 82, 1079)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1080, 82, 1080)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1081, 82, 1081)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1082, 82, 1082)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1083, 82, 1083)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1084, 83, 1084)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1085, 83, 1085)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1086, 83, 1086)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1087, 83, 1087)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1088, 83, 1088)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1089, 83, 1089)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1090, 83, 1090)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1091, 83, 1091)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1092, 83, 1092)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1093, 83, 1093)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1094, 83, 1094)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1095, 83, 1095)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1096, 83, 1096)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1097, 83, 1097)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1098, 83, 1098)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1099, 83, 1099)
GO
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1100, 84, 1100)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1101, 84, 1101)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1102, 84, 1102)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1103, 84, 1103)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1104, 85, 1104)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1105, 85, 1105)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1106, 85, 1106)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1107, 85, 1107)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1108, 85, 1108)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1109, 85, 1109)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1110, 85, 1110)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1111, 85, 1111)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1112, 85, 1112)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1113, 85, 1113)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1114, 85, 1114)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1115, 85, 1115)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1116, 85, 1116)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1117, 85, 1117)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1118, 85, 1118)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1119, 85, 1119)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1120, 85, 1120)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1121, 85, 1121)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1122, 85, 1122)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1123, 85, 1123)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1124, 85, 1124)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1125, 85, 1125)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1126, 85, 1126)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1127, 85, 1127)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1128, 85, 1128)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1129, 85, 1129)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1130, 85, 1130)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1131, 85, 1131)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1132, 85, 1132)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1133, 85, 1133)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1134, 85, 1134)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1135, 85, 1135)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1136, 85, 1136)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1137, 85, 1137)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1138, 85, 1138)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1139, 85, 1139)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1140, 85, 1140)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1141, 85, 1141)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1142, 85, 1142)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1143, 85, 1143)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1144, 86, 1144)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1145, 86, 1145)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1146, 86, 1146)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1147, 87, 1147)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1148, 87, 1148)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1149, 87, 1149)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1150, 87, 1150)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1151, 87, 1151)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1152, 87, 1152)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1153, 87, 1153)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1154, 87, 1154)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1155, 87, 1155)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1156, 87, 1156)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1157, 87, 1157)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1158, 87, 1158)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1159, 87, 1159)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1160, 87, 1160)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1161, 87, 1161)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1162, 87, 1162)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1163, 87, 1163)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1164, 87, 1164)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1165, 88, 1165)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1166, 88, 1166)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1167, 88, 1167)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1168, 88, 1168)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1169, 88, 1169)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1170, 88, 1170)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1171, 88, 1171)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1172, 88, 1172)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1173, 88, 1173)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1174, 88, 1174)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1175, 88, 1175)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1176, 88, 1176)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1177, 88, 1177)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1178, 88, 1178)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1179, 88, 1179)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1180, 88, 1180)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1181, 88, 1181)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1182, 88, 1182)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1183, 88, 1183)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1184, 88, 1184)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1185, 88, 1185)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1186, 88, 1186)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1187, 88, 1187)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1188, 88, 1188)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1189, 88, 1189)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1190, 88, 1190)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1191, 88, 1191)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1192, 88, 1192)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1193, 88, 1193)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1194, 88, 1194)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1195, 88, 1195)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1196, 88, 1196)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1197, 88, 1197)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1198, 88, 1198)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1199, 89, 1199)
GO
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1200, 89, 1200)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1201, 89, 1201)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1202, 89, 1202)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1203, 89, 1203)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1204, 89, 1204)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1205, 89, 1205)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1206, 89, 1206)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1207, 89, 1207)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1208, 89, 1208)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1209, 89, 1209)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1210, 89, 1210)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1211, 89, 1211)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1212, 89, 1212)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1213, 89, 1213)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1214, 89, 1214)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1215, 89, 1215)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1216, 89, 1216)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1217, 89, 1217)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1218, 1, 1218)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1219, 1, 43)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1220, 1, 27)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1221, 1, 1)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1222, 6, 191)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1223, 5, 25)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1224, 30, 51)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1225, 24, 26)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1226, 49, 50)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1229, 25, 41)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1230, 89, 296)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1231, 27, 75)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1233, 29, 166)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1234, 78, 237)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1235, 1, 239)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1237, 30, 34)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1238, 56, 61)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1239, 27, 124)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1240, 55, 152)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1241, 29, 177)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1242, 58, 210)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1243, 86, 238)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1244, 101, 1226)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1245, 102, 1227)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1246, 29, 389)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1247, 57, 1)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1248, 57, 239)
INSERT [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance], [Car_Brand_ID], [Car_Model_ID]) VALUES (1249, 57, 184)
SET IDENTITY_INSERT [dbo].[Brand_Model_Compliance] OFF
SET IDENTITY_INSERT [dbo].[Car_Brand] ON 

INSERT [dbo].[Car_Brand] ([ID_Car_Brand], [Name_Car_Brand]) VALUES (1, N'Acura')
INSERT [dbo].[Car_Brand] ([ID_Car_Brand], [Name_Car_Brand]) VALUES (2, N'Alfa Romeo')
INSERT [dbo].[Car_Brand] ([ID_Car_Brand], [Name_Car_Brand]) VALUES (3, N'Aston Martin')
INSERT [dbo].[Car_Brand] ([ID_Car_Brand], [Name_Car_Brand]) VALUES (4, N'Audi')
INSERT [dbo].[Car_Brand] ([ID_Car_Brand], [Name_Car_Brand]) VALUES (5, N'Bentley')
INSERT [dbo].[Car_Brand] ([ID_Car_Brand], [Name_Car_Brand]) VALUES (6, N'BMW')
INSERT [dbo].[Car_Brand] ([ID_Car_Brand], [Name_Car_Brand]) VALUES (7, N'Brilliance')
INSERT [dbo].[Car_Brand] ([ID_Car_Brand], [Name_Car_Brand]) VALUES (8, N'Bugatti')
INSERT [dbo].[Car_Brand] ([ID_Car_Brand], [Name_Car_Brand]) VALUES (9, N'Buick')
INSERT [dbo].[Car_Brand] ([ID_Car_Brand], [Name_Car_Brand]) VALUES (10, N'BYD')
INSERT [dbo].[Car_Brand] ([ID_Car_Brand], [Name_Car_Brand]) VALUES (11, N'Cadillac')
INSERT [dbo].[Car_Brand] ([ID_Car_Brand], [Name_Car_Brand]) VALUES (12, N'Changan')
INSERT [dbo].[Car_Brand] ([ID_Car_Brand], [Name_Car_Brand]) VALUES (13, N'Chery')
INSERT [dbo].[Car_Brand] ([ID_Car_Brand], [Name_Car_Brand]) VALUES (14, N'Chevrolet')
INSERT [dbo].[Car_Brand] ([ID_Car_Brand], [Name_Car_Brand]) VALUES (15, N'Chrysler')
INSERT [dbo].[Car_Brand] ([ID_Car_Brand], [Name_Car_Brand]) VALUES (16, N'Citroen')
INSERT [dbo].[Car_Brand] ([ID_Car_Brand], [Name_Car_Brand]) VALUES (17, N'Dacia')
INSERT [dbo].[Car_Brand] ([ID_Car_Brand], [Name_Car_Brand]) VALUES (18, N'Daewoo')
INSERT [dbo].[Car_Brand] ([ID_Car_Brand], [Name_Car_Brand]) VALUES (19, N'Daihatsu')
INSERT [dbo].[Car_Brand] ([ID_Car_Brand], [Name_Car_Brand]) VALUES (20, N'Datsun')
INSERT [dbo].[Car_Brand] ([ID_Car_Brand], [Name_Car_Brand]) VALUES (21, N'Dodge')
INSERT [dbo].[Car_Brand] ([ID_Car_Brand], [Name_Car_Brand]) VALUES (22, N'Dongfeng')
INSERT [dbo].[Car_Brand] ([ID_Car_Brand], [Name_Car_Brand]) VALUES (23, N'FAW')
INSERT [dbo].[Car_Brand] ([ID_Car_Brand], [Name_Car_Brand]) VALUES (24, N'Ferrari')
INSERT [dbo].[Car_Brand] ([ID_Car_Brand], [Name_Car_Brand]) VALUES (25, N'Fiat')
INSERT [dbo].[Car_Brand] ([ID_Car_Brand], [Name_Car_Brand]) VALUES (26, N'Fisker')
INSERT [dbo].[Car_Brand] ([ID_Car_Brand], [Name_Car_Brand]) VALUES (27, N'Ford')
INSERT [dbo].[Car_Brand] ([ID_Car_Brand], [Name_Car_Brand]) VALUES (28, N'Foton')
INSERT [dbo].[Car_Brand] ([ID_Car_Brand], [Name_Car_Brand]) VALUES (29, N'GAC')
INSERT [dbo].[Car_Brand] ([ID_Car_Brand], [Name_Car_Brand]) VALUES (30, N'GAZ')
INSERT [dbo].[Car_Brand] ([ID_Car_Brand], [Name_Car_Brand]) VALUES (31, N'Geely')
INSERT [dbo].[Car_Brand] ([ID_Car_Brand], [Name_Car_Brand]) VALUES (32, N'Genesis')
INSERT [dbo].[Car_Brand] ([ID_Car_Brand], [Name_Car_Brand]) VALUES (33, N'GMC')
INSERT [dbo].[Car_Brand] ([ID_Car_Brand], [Name_Car_Brand]) VALUES (34, N'Great Wall')
INSERT [dbo].[Car_Brand] ([ID_Car_Brand], [Name_Car_Brand]) VALUES (35, N'Haval')
INSERT [dbo].[Car_Brand] ([ID_Car_Brand], [Name_Car_Brand]) VALUES (36, N'Holden')
INSERT [dbo].[Car_Brand] ([ID_Car_Brand], [Name_Car_Brand]) VALUES (37, N'Honda')
INSERT [dbo].[Car_Brand] ([ID_Car_Brand], [Name_Car_Brand]) VALUES (38, N'Hummer')
INSERT [dbo].[Car_Brand] ([ID_Car_Brand], [Name_Car_Brand]) VALUES (39, N'Hyundai')
INSERT [dbo].[Car_Brand] ([ID_Car_Brand], [Name_Car_Brand]) VALUES (40, N'Infiniti')
INSERT [dbo].[Car_Brand] ([ID_Car_Brand], [Name_Car_Brand]) VALUES (41, N'Isuzu')
INSERT [dbo].[Car_Brand] ([ID_Car_Brand], [Name_Car_Brand]) VALUES (42, N'Iveco')
INSERT [dbo].[Car_Brand] ([ID_Car_Brand], [Name_Car_Brand]) VALUES (43, N'Jac')
INSERT [dbo].[Car_Brand] ([ID_Car_Brand], [Name_Car_Brand]) VALUES (44, N'Jaguar')
INSERT [dbo].[Car_Brand] ([ID_Car_Brand], [Name_Car_Brand]) VALUES (45, N'Jeep')
INSERT [dbo].[Car_Brand] ([ID_Car_Brand], [Name_Car_Brand]) VALUES (46, N'Kia')
INSERT [dbo].[Car_Brand] ([ID_Car_Brand], [Name_Car_Brand]) VALUES (47, N'Lamborghini')
INSERT [dbo].[Car_Brand] ([ID_Car_Brand], [Name_Car_Brand]) VALUES (48, N'Lancia')
INSERT [dbo].[Car_Brand] ([ID_Car_Brand], [Name_Car_Brand]) VALUES (49, N'Land Rover')
INSERT [dbo].[Car_Brand] ([ID_Car_Brand], [Name_Car_Brand]) VALUES (50, N'Lexus')
INSERT [dbo].[Car_Brand] ([ID_Car_Brand], [Name_Car_Brand]) VALUES (51, N'Lifan')
INSERT [dbo].[Car_Brand] ([ID_Car_Brand], [Name_Car_Brand]) VALUES (52, N'Lincoln')
INSERT [dbo].[Car_Brand] ([ID_Car_Brand], [Name_Car_Brand]) VALUES (53, N'Lotus')
INSERT [dbo].[Car_Brand] ([ID_Car_Brand], [Name_Car_Brand]) VALUES (54, N'Marussia')
INSERT [dbo].[Car_Brand] ([ID_Car_Brand], [Name_Car_Brand]) VALUES (55, N'Maserati')
INSERT [dbo].[Car_Brand] ([ID_Car_Brand], [Name_Car_Brand]) VALUES (56, N'Maybach')
INSERT [dbo].[Car_Brand] ([ID_Car_Brand], [Name_Car_Brand]) VALUES (57, N'Mazda')
INSERT [dbo].[Car_Brand] ([ID_Car_Brand], [Name_Car_Brand]) VALUES (58, N'McLaren')
INSERT [dbo].[Car_Brand] ([ID_Car_Brand], [Name_Car_Brand]) VALUES (59, N'Mercedes')
INSERT [dbo].[Car_Brand] ([ID_Car_Brand], [Name_Car_Brand]) VALUES (60, N'Mercury')
INSERT [dbo].[Car_Brand] ([ID_Car_Brand], [Name_Car_Brand]) VALUES (61, N'MG')
INSERT [dbo].[Car_Brand] ([ID_Car_Brand], [Name_Car_Brand]) VALUES (62, N'Mini')
INSERT [dbo].[Car_Brand] ([ID_Car_Brand], [Name_Car_Brand]) VALUES (63, N'Mitsubishi')
INSERT [dbo].[Car_Brand] ([ID_Car_Brand], [Name_Car_Brand]) VALUES (64, N'Nissan')
INSERT [dbo].[Car_Brand] ([ID_Car_Brand], [Name_Car_Brand]) VALUES (65, N'Noble')
INSERT [dbo].[Car_Brand] ([ID_Car_Brand], [Name_Car_Brand]) VALUES (66, N'Opel')
INSERT [dbo].[Car_Brand] ([ID_Car_Brand], [Name_Car_Brand]) VALUES (67, N'Peugeot')
INSERT [dbo].[Car_Brand] ([ID_Car_Brand], [Name_Car_Brand]) VALUES (68, N'Plymouth')
INSERT [dbo].[Car_Brand] ([ID_Car_Brand], [Name_Car_Brand]) VALUES (69, N'Pontiac')
INSERT [dbo].[Car_Brand] ([ID_Car_Brand], [Name_Car_Brand]) VALUES (70, N'Porsche')
INSERT [dbo].[Car_Brand] ([ID_Car_Brand], [Name_Car_Brand]) VALUES (71, N'Ravon')
INSERT [dbo].[Car_Brand] ([ID_Car_Brand], [Name_Car_Brand]) VALUES (72, N'Renault')
INSERT [dbo].[Car_Brand] ([ID_Car_Brand], [Name_Car_Brand]) VALUES (73, N'Rolls-Royce')
INSERT [dbo].[Car_Brand] ([ID_Car_Brand], [Name_Car_Brand]) VALUES (74, N'Rover')
INSERT [dbo].[Car_Brand] ([ID_Car_Brand], [Name_Car_Brand]) VALUES (75, N'Saab')
INSERT [dbo].[Car_Brand] ([ID_Car_Brand], [Name_Car_Brand]) VALUES (76, N'Saturn')
INSERT [dbo].[Car_Brand] ([ID_Car_Brand], [Name_Car_Brand]) VALUES (77, N'Scion')
INSERT [dbo].[Car_Brand] ([ID_Car_Brand], [Name_Car_Brand]) VALUES (78, N'Seat')
INSERT [dbo].[Car_Brand] ([ID_Car_Brand], [Name_Car_Brand]) VALUES (79, N'Skoda')
INSERT [dbo].[Car_Brand] ([ID_Car_Brand], [Name_Car_Brand]) VALUES (80, N'Smart')
INSERT [dbo].[Car_Brand] ([ID_Car_Brand], [Name_Car_Brand]) VALUES (81, N'Ssang Yong')
INSERT [dbo].[Car_Brand] ([ID_Car_Brand], [Name_Car_Brand]) VALUES (82, N'Subaru')
INSERT [dbo].[Car_Brand] ([ID_Car_Brand], [Name_Car_Brand]) VALUES (83, N'Suzuki')
INSERT [dbo].[Car_Brand] ([ID_Car_Brand], [Name_Car_Brand]) VALUES (84, N'Tesla')
INSERT [dbo].[Car_Brand] ([ID_Car_Brand], [Name_Car_Brand]) VALUES (85, N'Toyota')
INSERT [dbo].[Car_Brand] ([ID_Car_Brand], [Name_Car_Brand]) VALUES (86, N'UAZ')
INSERT [dbo].[Car_Brand] ([ID_Car_Brand], [Name_Car_Brand]) VALUES (87, N'VAZ')
INSERT [dbo].[Car_Brand] ([ID_Car_Brand], [Name_Car_Brand]) VALUES (88, N'Volkswagen')
INSERT [dbo].[Car_Brand] ([ID_Car_Brand], [Name_Car_Brand]) VALUES (89, N'Volvo')
INSERT [dbo].[Car_Brand] ([ID_Car_Brand], [Name_Car_Brand]) VALUES (98, N'Gele')
INSERT [dbo].[Car_Brand] ([ID_Car_Brand], [Name_Car_Brand]) VALUES (99, N'CheryS')
INSERT [dbo].[Car_Brand] ([ID_Car_Brand], [Name_Car_Brand]) VALUES (100, N'Quntico')
INSERT [dbo].[Car_Brand] ([ID_Car_Brand], [Name_Car_Brand]) VALUES (101, N'Karver')
INSERT [dbo].[Car_Brand] ([ID_Car_Brand], [Name_Car_Brand]) VALUES (102, N'Humer')
SET IDENTITY_INSERT [dbo].[Car_Brand] OFF
SET IDENTITY_INSERT [dbo].[Car_Model] ON 

INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1, N'CDX h')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (2, N'CL')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (3, N'EL')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (4, N'ILX')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (5, N'Integra')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (6, N'MDX')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (7, N'NSX')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (8, N'RDX')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (9, N'RL')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (10, N'RLX')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (11, N'RSX')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (12, N'TL')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (13, N'TLX')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (14, N'TSX')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (15, N'ZDX')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (16, N'146')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (17, N'147')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (18, N'147 GTA')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (19, N'156')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (20, N'156 GTA')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (21, N'159')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (22, N'166')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (23, N'4C')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (24, N'8C Competizione')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (25, N'Brera')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (26, N'Giulia')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (27, N'Giulietta')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (28, N'GT')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (29, N'GTV')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (30, N'MiTo')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (31, N'Spider')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (32, N'Stelvio')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (33, N'Cygnet')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (34, N'DB11')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (35, N'DB9')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (36, N'DBS')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (37, N'DBS Superleggera')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (38, N'DBS Violante')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (39, N'DBX')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (40, N'Rapide')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (41, N'V12 Vanquish')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (42, N'V12 Vantage')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (43, N'V8 Vantage')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (44, N'Valkyrie')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (45, N'Vanquish')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (46, N'Vantage')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (47, N'Virage')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (48, N'Zagato Coupe')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (49, N'A1')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (50, N'A2')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (51, N'A3')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (52, N'A4')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (53, N'A4 Allroad Quattro')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (54, N'A5')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (55, N'A6')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (56, N'A7')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (57, N'A8')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (58, N'Allroad')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (59, N'e-tron')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (60, N'e-tron GT')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (61, N'e-tron Sportback')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (62, N'Q2')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (63, N'Q3')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (64, N'Q4')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (65, N'Q5')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (66, N'Q5 Sportback')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (67, N'Q7')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (68, N'Q8')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (69, N'R8')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (70, N'RS e-tron GT')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (71, N'RS Q3')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (72, N'RS Q3 Sportback')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (73, N'RS Q7')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (74, N'RS Q8')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (75, N'RS3')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (76, N'RS4')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (77, N'RS5')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (78, N'RS6')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (79, N'RS7')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (80, N'S1')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (81, N'S3')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (82, N'S4')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (83, N'S5')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (84, N'S6')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (85, N'S7')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (86, N'S8')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (87, N'SQ2')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (88, N'SQ5')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (89, N'SQ7')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (90, N'SQ8')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (91, N'TT')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (92, N'TT RS')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (93, N'TTS')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (94, N'Arnage')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (95, N'Azure')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (96, N'Bentayga')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (97, N'Brooklands')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (98, N'Continental')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (99, N'Continental Flying Spur')
GO
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (100, N'Continental GT')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (101, N'Flying Spur')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (102, N'Mulsanne')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (103, N'1 series')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (104, N'2 series')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (105, N'3 series')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (106, N'4 series')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (107, N'5 series')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (108, N'6 series')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (109, N'7 series')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (110, N'8 series')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (111, N'i3')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (112, N'i4')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (113, N'i8')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (114, N'iX')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (115, N'iX3')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (116, N'M2')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (117, N'M3')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (118, N'M4')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (119, N'M5')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (120, N'M6')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (121, N'M8')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (122, N'X1')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (123, N'X2')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (124, N'X3')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (125, N'X3 M')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (126, N'X4')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (127, N'X4 M')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (128, N'X5')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (129, N'X5 M')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (130, N'X6')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (131, N'X6 M')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (132, N'X7')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (133, N'Z3')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (134, N'Z4')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (135, N'Z8')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (136, N'H230')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (137, N'V3')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (138, N'V5')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (139, N'Veyron')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (140, N'Century')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (141, N'Enclave')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (142, N'Envision')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (143, N'La Crosse')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (144, N'LaCrosse')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (145, N'Le Sabre')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (146, N'Lucerne')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (147, N'Park Avenue')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (148, N'Rainier')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (149, N'Regal')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (150, N'Rendezvouz')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (151, N'Terraza')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (152, N'Verano')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (153, N'Qin')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (154, N'ATS')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (155, N'ATS-V')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (156, N'BLS')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (157, N'CT4')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (158, N'CT5')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (159, N'CT6')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (160, N'CTS')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (161, N'De Ville')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (162, N'DTS')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (163, N'Eldorado')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (164, N'ELR')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (165, N'Escalade')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (166, N'Seville')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (167, N'SRX')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (168, N'STS')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (169, N'XLR')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (170, N'XT4')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (171, N'XT5')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (172, N'XT6')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (173, N'XTS')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (174, N'CS35')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (175, N'CS35 Plus')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (176, N'CS55')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (177, N'CS75')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (178, N'CS95')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (179, N'Eado')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (180, N'Raeton')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (181, N'Amulet')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (182, N'Arrizo 7')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (183, N'Bonus')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (184, N'Bonus 3')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (185, N'CrossEastar')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (186, N'Eastar')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (187, N'Fora')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (188, N'IndiS')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (189, N'Kimo')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (190, N'M11')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (191, N'QQ')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (192, N'QQ6')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (193, N'Tiggo')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (194, N'Tiggo 3')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (195, N'Tiggo 4')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (196, N'Tiggo 5')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (197, N'Tiggo 7')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (198, N'Tiggo 8')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (199, N'Tiggo 8 Pro')
GO
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (200, N'Very')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (201, N'Astro')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (202, N'Avalanche')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (203, N'Aveo')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (204, N'Beat')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (205, N'Blazer')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (206, N'Camaro')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (207, N'Captiva')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (208, N'Cavalier')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (209, N'Cobalt')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (210, N'Colorado')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (211, N'Corvette')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (212, N'Cruze')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (213, N'Epica')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (214, N'Equinox')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (215, N'Express')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (216, N'HHR')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (217, N'Impala')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (218, N'Lacetti')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (219, N'Lanos')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (220, N'Malibu')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (221, N'Monte Carlo')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (222, N'Niva')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (223, N'Orlando')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (224, N'Rezzo')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (225, N'Silverado')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (226, N'Silverado 1500')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (227, N'Silverado 2500 HD')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (228, N'Spark')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (229, N'SSR')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (230, N'Suburban')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (231, N'Tahoe')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (232, N'TrailBlazer')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (233, N'Traverse')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (234, N'Trax')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (235, N'Uplander')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (236, N'Venture')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (237, N'200')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (238, N'300')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (239, N'300M')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (240, N'Aspen')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (241, N'Concorde')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (242, N'Crossfire')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (243, N'Grand Voyager')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (244, N'Pacifica')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (245, N'PT Cruiser')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (246, N'Sebring')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (247, N'Town & Country')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (248, N'Voyager')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (249, N'Berlingo')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (250, N'C-Crosser')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (251, N'C-Elysee')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (252, N'C1')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (253, N'C2')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (254, N'C3')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (255, N'C3 Aircross')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (256, N'C3 Picasso')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (257, N'C3 Pluriel')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (258, N'C4')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (259, N'C4 Aircross')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (260, N'C4 Cactus')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (261, N'C4 Picasso')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (262, N'C5')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (263, N'C5 Aircross')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (264, N'C6')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (265, N'C8')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (266, N'DS 7 Crossback')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (267, N'DS3')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (268, N'DS4')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (269, N'DS5')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (270, N'Grand C4 Picasso')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (271, N'Jumper')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (272, N'Jumpy')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (273, N'Nemo')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (274, N'Saxo')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (275, N'Spacetourer')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (276, N'Xsara')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (277, N'Xsara Picasso')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (278, N'Dokker')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (279, N'Lodgy')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (280, N'Solenza')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (281, N'SupeRNova')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (282, N'Evanda')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (283, N'Kalos')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (284, N'Leganza')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (285, N'Magnus')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (286, N'Matiz')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (287, N'Nexia')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (288, N'Nubira')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (289, N'Applause')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (290, N'Cast')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (291, N'Copen')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (292, N'Cuore')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (293, N'Gran Move')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (294, N'Luxio')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (295, N'Materia')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (296, N'Mebius')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (297, N'Move')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (298, N'Rocky')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (299, N'Sirion')
GO
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (300, N'Terios')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (301, N'Trevis')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (302, N'YRV')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (303, N'mi-DO')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (304, N'on-DO')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (305, N'Avenger')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (306, N'Caliber')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (307, N'Caliber SRT4')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (308, N'Caravan')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (309, N'Challenger')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (310, N'Charger')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (311, N'Dakota')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (312, N'Dart')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (313, N'Durango')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (314, N'Intrepid')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (315, N'Journey')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (316, N'Magnum')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (317, N'Neon')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (318, N'Nitro')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (319, N'Ram 1500')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (320, N'Ram 2500')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (321, N'Ram 3500')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (322, N'Ram SRT10')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (323, N'Stratus')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (324, N'Viper')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (325, N'580')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (326, N'A30')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (327, N'AX7')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (328, N'H30 Cross')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (329, N'Besturn B30')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (330, N'Besturn B50')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (331, N'Besturn X40')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (332, N'Besturn X80')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (333, N'Oley')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (334, N'Vita')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (335, N'348')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (336, N'360')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (337, N'456')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (338, N'458')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (339, N'488')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (340, N'512')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (341, N'550')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (342, N'575 M')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (343, N'599 GTB Fiorano')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (344, N'599 GTO')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (345, N'612')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (346, N'812')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (347, N'812 GTS')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (348, N'California')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (349, N'California T')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (350, N'Challenge Stradale')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (351, N'Enzo')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (352, N'F12')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (353, N'F355')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (354, N'F430')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (355, N'F50')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (356, N'F512 M')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (357, N'F8 Spider')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (358, N'F8 Tributo')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (359, N'FF')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (360, N'GTC4 Lusso')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (361, N'LaFerrari')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (362, N'Portofino')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (363, N'Roma')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (364, N'SF90 Stradale')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (365, N'124 Spider')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (366, N'500')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (367, N'500L')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (368, N'500X')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (369, N'Albea')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (370, N'Brava')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (371, N'Bravo')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (372, N'Coupe')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (373, N'Croma')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (374, N'Doblo')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (375, N'Ducato')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (376, N'Freemont')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (377, N'Grande Punto')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (378, N'Idea')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (379, N'Linea')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (380, N'Marea')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (381, N'Multipla')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (382, N'Palio')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (383, N'Panda')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (384, N'Panda 4x4')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (385, N'Punto')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (386, N'Qubo')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (387, N'Sedici')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (388, N'Siena')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (389, N'Stilo')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (390, N'Strada')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (391, N'Tipo')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (392, N'Ulysse')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (393, N'Karma')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (394, N'B-Max')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (395, N'Bronco')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (396, N'Bronco Sport')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (397, N'C-Max')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (398, N'Cougar')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (399, N'Crown Victoria')
GO
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (400, N'EcoSport')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (401, N'Edge')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (402, N'Endura')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (403, N'Equator')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (404, N'Escape')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (405, N'Excursion')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (406, N'Expedition')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (407, N'Explorer')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (408, N'Explorer Sport Trac')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (409, N'F-150')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (410, N'F-250')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (411, N'F-350')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (412, N'Falcon')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (413, N'Fiesta')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (414, N'Five Hundred')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (415, N'Flex')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (416, N'Focus')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (417, N'Focus Active')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (418, N'Focus Electric')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (419, N'Freestar')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (420, N'Freestyle')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (421, N'Fusion')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (422, N'Galaxy')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (423, N'Ka')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (424, N'Kuga')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (425, N'Maverick')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (426, N'Mondeo')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (427, N'Mustang')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (428, N'Mustang Mach-E')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (429, N'Mustang Shelby GT350')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (430, N'Mustang Shelby GT500')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (431, N'Puma')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (432, N'Ranger')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (433, N'S-Max')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (434, N'Taurus')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (435, N'Taurus X')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (436, N'Thunderbird')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (437, N'Tourneo Connect')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (438, N'Transit')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (439, N'Transit Connect')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (440, N'Sauvana')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (441, N'GS5')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (442, N'Trumpchi GM8')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (443, N'Trumpchi GS8')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (444, N'3102')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (445, N'31105')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (446, N'Siber')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (447, N'Sobol')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (448, N'Atlas')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (449, N'Coolray')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (450, N'Emgrand 7')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (451, N'Emgrand EC7')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (452, N'Emgrand GS')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (453, N'Emgrand X7')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (454, N'GC9')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (455, N'GРЎ6')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (456, N'MK')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (457, N'Otaka')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (458, N'Tugella')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (459, N'Vision')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (460, N'G70')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (461, N'G80')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (462, N'G90')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (463, N'GV70')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (464, N'GV80')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (465, N'Acadia')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (466, N'Canyon')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (467, N'Envoy')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (468, N'Sierra 1500')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (469, N'Sierra 2500')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (470, N'Sierra 3500')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (471, N'Terrain')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (472, N'Yukon')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (473, N'Cowry')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (474, N'Deer')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (475, N'Hover')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (476, N'Hover M2')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (477, N'Pegasus')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (478, N'Peri')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (479, N'Safe')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (480, N'Sailor')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (481, N'Sing')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (482, N'Socool')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (483, N'Wingle')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (484, N'F7')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (485, N'F7x')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (486, N'H4')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (487, N'H6')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (488, N'H9')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (489, N'Commodore')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (490, N'Corvette C8')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (491, N'Accord')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (492, N'Amaze')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (493, N'City')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (494, N'Civic')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (495, N'Civic Type R')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (496, N'CR-V')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (497, N'CR-Z')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (498, N'Crosstour')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (499, N'Element')
GO
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (500, N'Fit')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (501, N'FR-V')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (502, N'HR-V')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (503, N'HR-V II (GJ)')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (504, N'Insight')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (505, N'Jade')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (506, N'Jazz')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (507, N'Legend')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (508, N'Odyssey')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (509, N'Pilot')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (510, N'Prelude')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (511, N'Ridgeline')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (512, N'S2000')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (513, N'Shuttle')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (514, N'Stream')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (515, N'Vezel')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (516, N'H1')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (517, N'H2')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (518, N'H3')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (519, N'Accent')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (520, N'Atos Prime')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (521, N'Azera')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (522, N'Bayon')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (523, N'Centennial')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (524, N'Creta')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (525, N'Elantra')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (526, N'Entourage')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (527, N'Eon')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (528, N'Equus')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (529, N'Galloper')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (530, N'Genesis')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (531, N'Genesis Coupe')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (532, N'Getz')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (533, N'Grandeur')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (534, N'H-1')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (535, N'i10')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (536, N'i20')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (537, N'i30')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (538, N'i30 N')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (539, N'i40')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (540, N'Ioniq')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (541, N'Ioniq 5')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (542, N'ix20')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (543, N'ix35')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (544, N'Kona')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (545, N'Matrix')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (546, N'Palisade')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (547, N'Porter')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (548, N'Santa Fe')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (549, N'Solaris')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (550, N'Sonata')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (551, N'Terracan')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (552, N'Trajet')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (553, N'Tucson')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (554, N'Veloster')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (555, N'Venue')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (556, N'Veracruz')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (557, N'Verna')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (558, N'Xcent')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (559, N'XG')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (560, N'EX')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (561, N'FX')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (562, N'G')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (563, N'I35')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (564, N'JX')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (565, N'M')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (566, N'Q30')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (567, N'Q40')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (568, N'Q45')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (569, N'Q50')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (570, N'Q60')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (571, N'Q70')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (572, N'QX30')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (573, N'QX4')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (574, N'QX50')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (575, N'QX55')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (576, N'QX56')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (577, N'QX60')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (578, N'QX70')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (579, N'QX80')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (580, N'Ascender')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (581, N'Axiom')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (582, N'D-Max')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (583, N'D-Max Rodeo')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (584, N'I280')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (585, N'I290')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (586, N'I350')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (587, N'I370')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (588, N'Rodeo')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (589, N'Trooper')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (590, N'VehiCross')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (591, N'Daily')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (592, N'iEV7S')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (593, N'T6')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (594, N'E-Pace')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (595, N'F-Pace')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (596, N'F-Type')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (597, N'I-Pace')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (598, N'S-Type')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (599, N'X-Type')
GO
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (600, N'XE')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (601, N'XF')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (602, N'XJ')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (603, N'XK/XKR')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (604, N'Cherokee')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (605, N'Commander')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (606, N'Compass')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (607, N'Gladiator')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (608, N'Grand Cherokee')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (609, N'Liberty')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (610, N'Patriot')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (611, N'Renegade')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (612, N'Wrangler')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (613, N'Carens')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (614, N'Carnival')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (615, N'Ceed')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (616, N'Cerato')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (617, N'Clarus')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (618, N'Forte')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (619, N'K5')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (620, N'K8')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (621, N'K900')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (622, N'Magentis')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (623, N'Mohave')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (624, N'Niro')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (625, N'Opirus')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (626, N'Optima')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (627, N'Picanto')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (628, N'ProCeed')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (629, N'Quoris')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (630, N'Ray')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (631, N'Rio')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (632, N'Rio X-Line')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (633, N'Seltos')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (634, N'Shuma')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (635, N'Sonet')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (636, N'Sorento')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (637, N'Sorento Prime')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (638, N'Soul')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (639, N'Spectra')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (640, N'Sportage')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (641, N'Stinger')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (642, N'Stonic')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (643, N'Telluride')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (644, N'Venga')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (645, N'Aventador')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (646, N'Centenario')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (647, N'Diablo')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (648, N'Gallardo')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (649, N'Huracan')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (650, N'Murcielago')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (651, N'Reventon')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (652, N'Urus')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (653, N'Delta')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (654, N'Lybra')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (655, N'Musa')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (656, N'Phedra')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (657, N'Thema')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (658, N'Thesis')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (659, N'Ypsilon')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (660, N'Defender')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (661, N'Discovery')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (662, N'Discovery Sport')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (663, N'Evoque')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (664, N'Freelander')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (665, N'Range Rover')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (666, N'Range Rover Sport')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (667, N'Range Rover Velar')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (668, N'CT')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (669, N'ES')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (670, N'GS')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (671, N'GX')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (672, N'HS')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (673, N'IS')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (674, N'LC')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (675, N'LFA')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (676, N'LM')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (677, N'LS')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (678, N'LX')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (679, N'NX')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (680, N'RC')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (681, N'RX')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (682, N'SC')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (683, N'UX')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (684, N'Breez')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (685, N'Cebrium')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (686, N'Celliya')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (687, N'Smily')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (688, N'Solano')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (689, N'X50')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (690, N'X60')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (691, N'Aviator')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (692, N'Corsair')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (693, N'Mark LT')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (694, N'MKC')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (695, N'MKS')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (696, N'MKT')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (697, N'MKX')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (698, N'MKZ')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (699, N'Nautilus')
GO
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (700, N'Navigator')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (701, N'Town Car')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (702, N'Zephyr')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (703, N'Elise')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (704, N'Europa S')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (705, N'Evora')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (706, N'Exige')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (707, N'B1')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (708, N'B2')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (709, N'3200 GT')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (710, N'Ghibli')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (711, N'Gran Cabrio')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (712, N'Gran Turismo ')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (713, N'Gran Turismo S')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (714, N'Levante')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (715, N'Quattroporte')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (716, N'Quattroporte S')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (717, N'57')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (718, N'57 S')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (719, N'62')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (720, N'62 S')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (721, N'Landaulet')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (722, N'2')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (723, N'3')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (724, N'323')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (725, N'5')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (726, N'6')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (727, N'626')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (728, N'B-Series')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (729, N'BT-50')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (730, N'CX-3')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (731, N'CX-30')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (732, N'CX-5')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (733, N'CX-7')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (734, N'CX-8')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (735, N'CX-9')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (736, N'MPV')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (737, N'MX-30')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (738, N'MX-5')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (739, N'Premacy')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (740, N'RX-7')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (741, N'RX-8')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (742, N'Tribute')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (743, N'540C')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (744, N'570S')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (745, N'600LT')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (746, N'650S')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (747, N'675LT')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (748, N'720S')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (749, N'765LT')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (750, N'MP4-12C')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (751, N'P1')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (752, N'A-class')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (753, N'AMG GT')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (754, N'AMG GT 4-Door')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (755, N'B-class')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (756, N'C-class')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (757, N'C-class Sport Coupe')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (758, N'Citan')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (759, N'CL-class')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (760, N'CLA-class')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (761, N'CLC-class ')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (762, N'CLK-class')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (763, N'CLS-class')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (764, N'E-class')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (765, N'E-class Coupe')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (766, N'EQA')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (767, N'EQC')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (768, N'EQS')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (769, N'EQV')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (770, N'G-class')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (771, N'GL-class')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (772, N'GLA-class')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (773, N'GLB-class')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (774, N'GLC-class')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (775, N'GLC-class Coupe')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (776, N'GLE-class')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (777, N'GLE-class Coupe')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (778, N'GLK-class')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (779, N'GLS-class')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (780, N'M-class')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (781, N'R-class')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (782, N'S-class')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (783, N'S-class Cabrio')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (784, N'S-class Coupe')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (785, N'SL-class')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (786, N'SLC-class')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (787, N'SLK-class')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (788, N'SLR-class')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (789, N'SLS AMG')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (790, N'Sprinter')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (791, N'Vaneo')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (792, N'Viano')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (793, N'Vito')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (794, N'X-class')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (795, N'Grand Marquis')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (796, N'Mariner')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (797, N'Milan')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (798, N'Montego')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (799, N'Monterey')
GO
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (800, N'Mountaineer')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (801, N'Sable')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (802, N'TF')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (803, N'XPower SV')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (804, N'ZR')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (805, N'ZS')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (806, N'ZT')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (807, N'ZT-T')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (808, N'Clubman')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (809, N'Clubman S')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (810, N'Clubvan')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (811, N'Cooper')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (812, N'Cooper Cabrio')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (813, N'Cooper S')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (814, N'Cooper S Cabrio')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (815, N'Cooper S Countryman All4')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (816, N'Countryman')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (817, N'One')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (818, N'3000 GT')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (819, N'ASX')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (820, N'Carisma')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (821, N'Colt')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (822, N'Dignity')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (823, N'Eclipse')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (824, N'Eclipse Cross')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (825, N'Endeavor')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (826, N'Galant')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (827, N'Grandis')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (828, N'i-MiEV')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (829, N'L200')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (830, N'Lancer')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (831, N'Lancer Evo')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (832, N'Mirage')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (833, N'Outlander')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (834, N'Outlander Sport')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (835, N'Outlander XL')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (836, N'Pajero')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (837, N'Pajero Pinin')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (838, N'Pajero Sport')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (839, N'Raider')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (840, N'Space Gear')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (841, N'Space Runner')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (842, N'Space Star')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (843, N'Xpander')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (844, N'350Z')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (845, N'370Z')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (846, N'Almera')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (847, N'Almera Classic')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (848, N'Almera Tino')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (849, N'Altima')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (850, N'Ariya')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (851, N'Armada')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (852, N'Bluebird Sylphy')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (853, N'Frontier')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (854, N'GT-R')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (855, N'Juke')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (856, N'Leaf')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (857, N'Maxima')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (858, N'Micra')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (859, N'Murano')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (860, N'Navara')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (861, N'Note')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (862, N'NP300')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (863, N'Pathfinder')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (864, N'Patrol')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (865, N'Primera')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (866, N'Qashqai')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (867, N'Qashqai+2')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (868, N'Quest')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (869, N'Rogue')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (870, N'Sentra')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (871, N'Skyline')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (872, N'Sylphy')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (873, N'Teana')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (874, N'Terrano')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (875, N'Tiida')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (876, N'Titan')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (877, N'Titan XD')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (878, N'X-Trail')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (879, N'XTerra')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (880, N'Z')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (881, N'M600')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (882, N'Adam')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (883, N'Agila')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (884, N'Ampera-e')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (885, N'Antara')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (886, N'Astra')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (887, N'Astra GTC')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (888, N'Astra OPC')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (889, N'Cascada')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (890, N'Combo')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (891, N'Corsa')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (892, N'Corsa OPC')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (893, N'Crossland')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (894, N'Crossland X')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (895, N'Frontera')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (896, N'Grandland X')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (897, N'Insignia')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (898, N'Insignia OPC')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (899, N'Karl')
GO
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (900, N'Meriva')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (901, N'Mokka')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (902, N'Omega')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (903, N'Signum')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (904, N'Speedster')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (905, N'Tigra')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (906, N'Vectra')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (907, N'Vivaro')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (908, N'Zafira')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (909, N'Zafira Life')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (910, N'Zafira Tourer')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (911, N'1007')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (912, N'107')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (913, N'108')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (914, N'2008')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (915, N'206')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (916, N'207')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (917, N'208')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (918, N'3008')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (919, N'301')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (920, N'307')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (921, N'308')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (922, N'4007')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (923, N'4008')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (924, N'406')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (925, N'407')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (926, N'408')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (927, N'5008')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (928, N'508')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (929, N'607')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (930, N'807')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (931, N'Boxer')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (932, N'Expert')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (933, N'Landtrek')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (934, N'Partner')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (935, N'RCZ Sport')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (936, N'Rifter')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (937, N'Traveller')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (938, N'Road Runner')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (939, N'Aztec')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (940, N'Bonneville')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (941, N'Firebird')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (942, N'G5 Pursuit')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (943, N'G6')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (944, N'G8')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (945, N'Grand AM')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (946, N'Grand Prix')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (947, N'GTO')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (948, N'Montana')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (949, N'Solstice')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (950, N'Sunfire')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (951, N'Torrent')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (952, N'Vibe')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (953, N'718 Boxster')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (954, N'718 Cayman')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (955, N'911')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (956, N'Boxster')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (957, N'Cayenne')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (958, N'Cayman')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (959, N'Macan')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (960, N'Panamera')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (961, N'Taycan')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (962, N'Gentra')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (963, N'Alaskan')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (964, N'Arkana')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (965, N'Avantime')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (966, N'Captur')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (967, N'Clio')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (968, N'Duster')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (969, N'Duster Oroch')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (970, N'Espace')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (971, N'Fluence')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (972, N'Grand Scenic')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (973, N'Kadjar')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (974, N'Kangoo')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (975, N'Kaptur')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (976, N'Koleos')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (977, N'Laguna')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (978, N'Latitude')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (979, N'Logan')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (980, N'Master')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (981, N'Megane')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (982, N'Modus')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (983, N'Sandero')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (984, N'Sandero Stepway')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (985, N'Scenic')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (986, N'Symbol')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (987, N'Taliant')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (988, N'Talisman')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (989, N'Trafic')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (990, N'Triber')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (991, N'Twingo')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (992, N'Twizy')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (993, N'Vel Satis')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (994, N'Wind')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (995, N'Zoe')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (996, N'Cullinan')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (997, N'Dawn')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (998, N'Ghost')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (999, N'Phantom')
GO
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1000, N'Wraith')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1001, N'25')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1002, N'400')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1003, N'45')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1004, N'600')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1005, N'75')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1006, N'Streetwise')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1007, N'9-2x')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1008, N'44629')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1009, N'9-4x')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1010, N'44690')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1011, N'9-7x')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1012, N'Aura')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1013, N'Ion')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1014, N'LW')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1015, N'Outlook')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1016, N'Sky')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1017, N'Vue')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1018, N'FR-S')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1019, N'tC')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1020, N'xA')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1021, N'xB')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1022, N'xD')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1023, N'Alhambra')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1024, N'Altea')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1025, N'Altea Freetrack')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1026, N'Altea XL')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1027, N'Arona')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1028, N'Arosa')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1029, N'Ateca')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1030, N'Cordoba')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1031, N'Exeo')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1032, N'Ibiza')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1033, N'Leon')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1034, N'Mii')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1035, N'Tarraco')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1036, N'Toledo')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1037, N'Citigo')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1038, N'Enyaq iV')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1039, N'Fabia')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1040, N'Felicia')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1041, N'Kamiq')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1042, N'Karoq')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1043, N'Kodiaq')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1044, N'Octavia')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1045, N'Octavia Scout')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1046, N'Octavia Tour')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1047, N'Praktik')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1048, N'Rapid')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1049, N'Rapid Spaceback (NH1)')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1050, N'Roomster')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1051, N'Scala')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1052, N'Superb')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1053, N'Yeti')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1054, N'Forfour')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1055, N'Fortwo')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1056, N'Roadster')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1057, N'Actyon')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1058, N'Actyon Sports')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1059, N'Chairman')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1060, N'Korando')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1061, N'Kyron')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1062, N'Musso')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1063, N'Musso Sport')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1064, N'Rexton')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1065, N'Rodius')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1066, N'Stavic')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1067, N'Tivoli')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1068, N'XLV')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1069, N'Ascent')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1070, N'Baja')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1071, N'BRZ')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1072, N'Crosstrack')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1073, N'Exiga')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1074, N'Forester')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1075, N'Impreza')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1076, N'Justy')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1077, N'Legacy')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1078, N'Levorg')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1079, N'Outback')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1080, N'Traviq')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1081, N'Tribeca')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1082, N'WRX')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1083, N'XV')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1084, N'Alto')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1085, N'Baleno')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1086, N'Celerio')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1087, N'Ciaz')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1088, N'Grand Vitara')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1089, N'Grand Vitara XL7')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1090, N'Ignis')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1091, N'Jimny')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1092, N'Kizashi')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1093, N'Liana')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1094, N'Splash')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1095, N'Swift')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1096, N'SX4')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1097, N'Vitara')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1098, N'Wagon R')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1099, N'Wagon R+')
GO
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1100, N'Model 3')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1101, N'Model S')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1102, N'Model X')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1103, N'Model Y')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1104, N'4Runner')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1105, N'Alphard')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1106, N'Auris')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1107, N'Avalon')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1108, N'Avensis')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1109, N'Avensis Verso')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1110, N'Aygo')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1111, N'C-HR')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1112, N'Caldina')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1113, N'Camry')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1114, N'Celica')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1115, N'Corolla')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1116, N'Corolla Verso')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1117, N'FJ Cruiser')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1118, N'Fortuner')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1119, N'GT 86')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1120, N'Hiace')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1121, N'Highlander')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1122, N'Hilux')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1123, N'iQ')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1124, N'ist')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1125, N'Land Cruiser')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1126, N'Land Cruiser Prado')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1127, N'Mark II')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1128, N'Mirai')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1129, N'MR2')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1130, N'Picnic')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1131, N'Previa')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1132, N'Prius')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1133, N'RAV4')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1134, N'Sequoia')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1135, N'Sienna')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1136, N'Supra')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1137, N'Tacoma')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1138, N'Tundra')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1139, N'Venza')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1140, N'Verso')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1141, N'Vitz')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1142, N'Yaris')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1143, N'Yaris Verso')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1144, N'Pickup')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1145, N'B1')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1146, N'B2')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1147, N'2101-2107')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1148, N'2108, 2109, 21099')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1149, N'2110, 2111, 2112')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1150, N'2113, 2114, 2115')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1151, N'4x4 Urban')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1152, N'Granta')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1153, N'Largus')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1154, N'Largus Cross')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1155, N'Vesta Cross')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1156, N'Vesta Sport')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1157, N'Vesta SW')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1158, N'XRay')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1159, N'XRay Cross')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1160, N'А1')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1161, N'А2')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1162, N'А3')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1163, N'А4')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1164, N'А5')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1165, N'Amarok')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1166, N'Arteon')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1167, N'Beetle')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1168, N'Bora')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1169, N'Caddy')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1170, N'CC')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1171, N'Crafter')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1172, N'CrossGolf')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1173, N'CrossPolo')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1174, N'CrossTouran')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1175, N'Eos')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1176, N'Fox')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1177, N'Golf')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1178, N'ID.4')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1179, N'Jetta')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1180, N'Lupo')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1181, N'Multivan')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1182, N'New Beetle')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1183, N'Passat')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1184, N'Passat CC')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1185, N'Phaeton')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1186, N'Pointer')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1187, N'Polo')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1188, N'Routan')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1189, N'Scirocco')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1190, N'Sharan')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1191, N'T-Roc')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1192, N'Taos')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1193, N'Teramont')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1194, N'Tiguan')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1195, N'Touareg')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1196, N'Touran')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1197, N'Transporter')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1198, N'Up')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1199, N'C30')
GO
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1200, N'C40')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1201, N'C70')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1202, N'C70 Convertible')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1203, N'C70 Coupe')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1204, N'S40')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1205, N'S60')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1206, N'S70')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1207, N'S80')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1208, N'S90')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1209, N'V40')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1210, N'V50')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1211, N'V60')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1212, N'V70')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1213, N'V90')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1214, N'XC40')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1215, N'XC60')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1216, N'XC70')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1217, N'XC90')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1218, N'XC100')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1219, N'KLQ')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1220, N'KLQ2')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1221, N'QQ')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1222, N'QQ2')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1223, N'GG2')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1224, N'GG')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1225, N'EE')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1226, N'Каптюр 2')
INSERT [dbo].[Car_Model] ([ID_Car_Model], [Name_Car_Model]) VALUES (1227, N'E')
SET IDENTITY_INSERT [dbo].[Car_Model] OFF
SET IDENTITY_INSERT [dbo].[Car_Services_Provided] ON 

INSERT [dbo].[Car_Services_Provided] ([ID_Car_Services_Provided], [List_Services_ID], [Start_Date], [End_Date], [Order_ID], [Worker_ID]) VALUES (1, 4, N'15.03.2022 14:16:43', N'15.03.2022 14:18:17', 1, 7)
INSERT [dbo].[Car_Services_Provided] ([ID_Car_Services_Provided], [List_Services_ID], [Start_Date], [End_Date], [Order_ID], [Worker_ID]) VALUES (3, 5, N'15.03.2022 16:13:03', N'26.03.2022 14:18:17', 2, 5)
INSERT [dbo].[Car_Services_Provided] ([ID_Car_Services_Provided], [List_Services_ID], [Start_Date], [End_Date], [Order_ID], [Worker_ID]) VALUES (5, 8, N'15.03.2022 16:13:03', N'26.03.2022 14:18:17', 2, 5)
INSERT [dbo].[Car_Services_Provided] ([ID_Car_Services_Provided], [List_Services_ID], [Start_Date], [End_Date], [Order_ID], [Worker_ID]) VALUES (6, 4, N'17.03.2022 16:13:03', N'26.04.2022 10:48:03', 4, 5)
INSERT [dbo].[Car_Services_Provided] ([ID_Car_Services_Provided], [List_Services_ID], [Start_Date], [End_Date], [Order_ID], [Worker_ID]) VALUES (7, 4, N'17.03.2022 9:07:02', N'17.03.2022 10:08:04', 9, 5)
INSERT [dbo].[Car_Services_Provided] ([ID_Car_Services_Provided], [List_Services_ID], [Start_Date], [End_Date], [Order_ID], [Worker_ID]) VALUES (8, 5, N'17.03.2022 9:07:05', N'17.03.2022 11:07:15', 9, 5)
INSERT [dbo].[Car_Services_Provided] ([ID_Car_Services_Provided], [List_Services_ID], [Start_Date], [End_Date], [Order_ID], [Worker_ID]) VALUES (9, 4, N'16.03.2022 11:23:52', N'17.03.2022 9:08:47', 6, 5)
INSERT [dbo].[Car_Services_Provided] ([ID_Car_Services_Provided], [List_Services_ID], [Start_Date], [End_Date], [Order_ID], [Worker_ID]) VALUES (10, 6, N'16.03.2022 11:33:31', N'16.03.2022 11:33:36', 8, 7)
INSERT [dbo].[Car_Services_Provided] ([ID_Car_Services_Provided], [List_Services_ID], [Start_Date], [End_Date], [Order_ID], [Worker_ID]) VALUES (11, 6, N'17.03.2022 13:26:45', N'29.03.2022 14:18:17', 8, 5)
INSERT [dbo].[Car_Services_Provided] ([ID_Car_Services_Provided], [List_Services_ID], [Start_Date], [End_Date], [Order_ID], [Worker_ID]) VALUES (13, 4, N'17.03.2022 13:27:14', N'17.03.2022 13:27:42', 11, 5)
INSERT [dbo].[Car_Services_Provided] ([ID_Car_Services_Provided], [List_Services_ID], [Start_Date], [End_Date], [Order_ID], [Worker_ID]) VALUES (14, 6, N'17.03.2022 13:30:40', N'17.03.2022 13:30:40', 11, 5)
INSERT [dbo].[Car_Services_Provided] ([ID_Car_Services_Provided], [List_Services_ID], [Start_Date], [End_Date], [Order_ID], [Worker_ID]) VALUES (15, 5, N'17.03.2022 15:56:12', N'29.03.2022 14:18:17', 12, 5)
INSERT [dbo].[Car_Services_Provided] ([ID_Car_Services_Provided], [List_Services_ID], [Start_Date], [End_Date], [Order_ID], [Worker_ID]) VALUES (16, 8, N'17.03.2022 16:00:58', N'29.03.2022 14:18:17', 12, 5)
INSERT [dbo].[Car_Services_Provided] ([ID_Car_Services_Provided], [List_Services_ID], [Start_Date], [End_Date], [Order_ID], [Worker_ID]) VALUES (17, 6, NULL, NULL, 19, 2)
INSERT [dbo].[Car_Services_Provided] ([ID_Car_Services_Provided], [List_Services_ID], [Start_Date], [End_Date], [Order_ID], [Worker_ID]) VALUES (18, 5, N'24.04.2022 17:05:23', NULL, 1, 5)
INSERT [dbo].[Car_Services_Provided] ([ID_Car_Services_Provided], [List_Services_ID], [Start_Date], [End_Date], [Order_ID], [Worker_ID]) VALUES (20, 6, NULL, NULL, 1, 5)
INSERT [dbo].[Car_Services_Provided] ([ID_Car_Services_Provided], [List_Services_ID], [Start_Date], [End_Date], [Order_ID], [Worker_ID]) VALUES (21, 9, N'24.04.2022 17:09:20', NULL, 1, 5)
INSERT [dbo].[Car_Services_Provided] ([ID_Car_Services_Provided], [List_Services_ID], [Start_Date], [End_Date], [Order_ID], [Worker_ID]) VALUES (22, 14, NULL, NULL, 1, 5)
INSERT [dbo].[Car_Services_Provided] ([ID_Car_Services_Provided], [List_Services_ID], [Start_Date], [End_Date], [Order_ID], [Worker_ID]) VALUES (23, 4, N'26.04.2022 10:04:29', N'', 20, 5)
INSERT [dbo].[Car_Services_Provided] ([ID_Car_Services_Provided], [List_Services_ID], [Start_Date], [End_Date], [Order_ID], [Worker_ID]) VALUES (24, 3, N'26.04.2022 10:42:06', NULL, 21, 5)
INSERT [dbo].[Car_Services_Provided] ([ID_Car_Services_Provided], [List_Services_ID], [Start_Date], [End_Date], [Order_ID], [Worker_ID]) VALUES (25, 4, N'26.04.2022 10:45:36', NULL, 21, 5)
INSERT [dbo].[Car_Services_Provided] ([ID_Car_Services_Provided], [List_Services_ID], [Start_Date], [End_Date], [Order_ID], [Worker_ID]) VALUES (26, 8, NULL, NULL, 1, 5)
INSERT [dbo].[Car_Services_Provided] ([ID_Car_Services_Provided], [List_Services_ID], [Start_Date], [End_Date], [Order_ID], [Worker_ID]) VALUES (27, 6, NULL, NULL, 2, 5)
INSERT [dbo].[Car_Services_Provided] ([ID_Car_Services_Provided], [List_Services_ID], [Start_Date], [End_Date], [Order_ID], [Worker_ID]) VALUES (28, 1, N'26.04.2022 19:09:02', N'26.04.2022 19:09:04', 24, 5)
INSERT [dbo].[Car_Services_Provided] ([ID_Car_Services_Provided], [List_Services_ID], [Start_Date], [End_Date], [Order_ID], [Worker_ID]) VALUES (29, 2, N'27.04.2022 12:13:15', NULL, 26, 5)
INSERT [dbo].[Car_Services_Provided] ([ID_Car_Services_Provided], [List_Services_ID], [Start_Date], [End_Date], [Order_ID], [Worker_ID]) VALUES (30, 3, NULL, NULL, 42, 5)
INSERT [dbo].[Car_Services_Provided] ([ID_Car_Services_Provided], [List_Services_ID], [Start_Date], [End_Date], [Order_ID], [Worker_ID]) VALUES (31, 5, NULL, NULL, 43, 32)
INSERT [dbo].[Car_Services_Provided] ([ID_Car_Services_Provided], [List_Services_ID], [Start_Date], [End_Date], [Order_ID], [Worker_ID]) VALUES (32, 5, NULL, NULL, 44, 5)
INSERT [dbo].[Car_Services_Provided] ([ID_Car_Services_Provided], [List_Services_ID], [Start_Date], [End_Date], [Order_ID], [Worker_ID]) VALUES (33, 7, NULL, NULL, 44, 5)
INSERT [dbo].[Car_Services_Provided] ([ID_Car_Services_Provided], [List_Services_ID], [Start_Date], [End_Date], [Order_ID], [Worker_ID]) VALUES (34, 36, NULL, NULL, 44, 5)
INSERT [dbo].[Car_Services_Provided] ([ID_Car_Services_Provided], [List_Services_ID], [Start_Date], [End_Date], [Order_ID], [Worker_ID]) VALUES (35, 3, NULL, NULL, 3, 5)
INSERT [dbo].[Car_Services_Provided] ([ID_Car_Services_Provided], [List_Services_ID], [Start_Date], [End_Date], [Order_ID], [Worker_ID]) VALUES (36, 3, NULL, NULL, 47, 5)
INSERT [dbo].[Car_Services_Provided] ([ID_Car_Services_Provided], [List_Services_ID], [Start_Date], [End_Date], [Order_ID], [Worker_ID]) VALUES (37, 8, NULL, NULL, 47, 5)
INSERT [dbo].[Car_Services_Provided] ([ID_Car_Services_Provided], [List_Services_ID], [Start_Date], [End_Date], [Order_ID], [Worker_ID]) VALUES (38, 6, N'04.05.2022 13:52:27', N'04.05.2022 13:52:28', 50, 5)
INSERT [dbo].[Car_Services_Provided] ([ID_Car_Services_Provided], [List_Services_ID], [Start_Date], [End_Date], [Order_ID], [Worker_ID]) VALUES (39, 4, N'04.05.2022 13:52:33', N'04.05.2022 13:52:33', 50, 5)
INSERT [dbo].[Car_Services_Provided] ([ID_Car_Services_Provided], [List_Services_ID], [Start_Date], [End_Date], [Order_ID], [Worker_ID]) VALUES (40, 3, N'04.05.2022 13:52:30', N'04.05.2022 13:52:31', 50, 5)
INSERT [dbo].[Car_Services_Provided] ([ID_Car_Services_Provided], [List_Services_ID], [Start_Date], [End_Date], [Order_ID], [Worker_ID]) VALUES (41, 6, N'04.05.2022 15:09:35', N'04.05.2022 15:09:35', 51, 5)
INSERT [dbo].[Car_Services_Provided] ([ID_Car_Services_Provided], [List_Services_ID], [Start_Date], [End_Date], [Order_ID], [Worker_ID]) VALUES (42, 4, N'04.05.2022 15:09:39', N'04.05.2022 15:09:40', 51, 5)
INSERT [dbo].[Car_Services_Provided] ([ID_Car_Services_Provided], [List_Services_ID], [Start_Date], [End_Date], [Order_ID], [Worker_ID]) VALUES (43, 3, N'04.05.2022 15:09:37', N'04.05.2022 15:09:42', 51, 5)
INSERT [dbo].[Car_Services_Provided] ([ID_Car_Services_Provided], [List_Services_ID], [Start_Date], [End_Date], [Order_ID], [Worker_ID]) VALUES (44, 2, N'04.05.2022 15:16:26', N'04.05.2022 15:16:26', 52, 5)
INSERT [dbo].[Car_Services_Provided] ([ID_Car_Services_Provided], [List_Services_ID], [Start_Date], [End_Date], [Order_ID], [Worker_ID]) VALUES (45, 3, NULL, NULL, 59, 32)
INSERT [dbo].[Car_Services_Provided] ([ID_Car_Services_Provided], [List_Services_ID], [Start_Date], [End_Date], [Order_ID], [Worker_ID]) VALUES (46, 2, NULL, NULL, 59, 32)
INSERT [dbo].[Car_Services_Provided] ([ID_Car_Services_Provided], [List_Services_ID], [Start_Date], [End_Date], [Order_ID], [Worker_ID]) VALUES (47, 1, NULL, NULL, 59, 32)
INSERT [dbo].[Car_Services_Provided] ([ID_Car_Services_Provided], [List_Services_ID], [Start_Date], [End_Date], [Order_ID], [Worker_ID]) VALUES (48, 4, N'04.05.2022 19:10:22', N'04.05.2022 19:10:22', 61, 5)
INSERT [dbo].[Car_Services_Provided] ([ID_Car_Services_Provided], [List_Services_ID], [Start_Date], [End_Date], [Order_ID], [Worker_ID]) VALUES (49, 1, N'04.05.2022 19:10:24', N'04.05.2022 19:10:24', 61, 5)
INSERT [dbo].[Car_Services_Provided] ([ID_Car_Services_Provided], [List_Services_ID], [Start_Date], [End_Date], [Order_ID], [Worker_ID]) VALUES (50, 1, N'05.05.2022 15:12:57', N'05.05.2022 15:13:15', 68, 5)
INSERT [dbo].[Car_Services_Provided] ([ID_Car_Services_Provided], [List_Services_ID], [Start_Date], [End_Date], [Order_ID], [Worker_ID]) VALUES (51, 2, N'05.05.2022 15:13:16', N'05.05.2022 15:13:17', 68, 5)
INSERT [dbo].[Car_Services_Provided] ([ID_Car_Services_Provided], [List_Services_ID], [Start_Date], [End_Date], [Order_ID], [Worker_ID]) VALUES (52, 4, N'05.05.2022 15:13:18', N'05.05.2022 15:13:18', 68, 5)
INSERT [dbo].[Car_Services_Provided] ([ID_Car_Services_Provided], [List_Services_ID], [Start_Date], [End_Date], [Order_ID], [Worker_ID]) VALUES (54, 5, N'05.05.2022 17:37:17', N'05.05.2022 17:37:17', 67, 5)
INSERT [dbo].[Car_Services_Provided] ([ID_Car_Services_Provided], [List_Services_ID], [Start_Date], [End_Date], [Order_ID], [Worker_ID]) VALUES (55, 7, N'05.05.2022 17:37:19', N'05.05.2022 17:37:19', 67, 5)
INSERT [dbo].[Car_Services_Provided] ([ID_Car_Services_Provided], [List_Services_ID], [Start_Date], [End_Date], [Order_ID], [Worker_ID]) VALUES (56, 40, N'06.05.2022 10:50:32', NULL, 68, 5)
INSERT [dbo].[Car_Services_Provided] ([ID_Car_Services_Provided], [List_Services_ID], [Start_Date], [End_Date], [Order_ID], [Worker_ID]) VALUES (57, 33, NULL, NULL, 69, 32)
INSERT [dbo].[Car_Services_Provided] ([ID_Car_Services_Provided], [List_Services_ID], [Start_Date], [End_Date], [Order_ID], [Worker_ID]) VALUES (58, 3, NULL, NULL, 69, 32)
INSERT [dbo].[Car_Services_Provided] ([ID_Car_Services_Provided], [List_Services_ID], [Start_Date], [End_Date], [Order_ID], [Worker_ID]) VALUES (59, 2, NULL, NULL, 69, 32)
INSERT [dbo].[Car_Services_Provided] ([ID_Car_Services_Provided], [List_Services_ID], [Start_Date], [End_Date], [Order_ID], [Worker_ID]) VALUES (60, 1, NULL, NULL, 69, 32)
INSERT [dbo].[Car_Services_Provided] ([ID_Car_Services_Provided], [List_Services_ID], [Start_Date], [End_Date], [Order_ID], [Worker_ID]) VALUES (61, 4, NULL, NULL, 69, 32)
INSERT [dbo].[Car_Services_Provided] ([ID_Car_Services_Provided], [List_Services_ID], [Start_Date], [End_Date], [Order_ID], [Worker_ID]) VALUES (62, 7, NULL, NULL, 70, 32)
INSERT [dbo].[Car_Services_Provided] ([ID_Car_Services_Provided], [List_Services_ID], [Start_Date], [End_Date], [Order_ID], [Worker_ID]) VALUES (63, 4, NULL, NULL, 70, 32)
INSERT [dbo].[Car_Services_Provided] ([ID_Car_Services_Provided], [List_Services_ID], [Start_Date], [End_Date], [Order_ID], [Worker_ID]) VALUES (64, 33, NULL, NULL, 70, 32)
INSERT [dbo].[Car_Services_Provided] ([ID_Car_Services_Provided], [List_Services_ID], [Start_Date], [End_Date], [Order_ID], [Worker_ID]) VALUES (65, 3, N'06.05.2022 19:56:20', N'06.05.2022 19:56:23', 71, 5)
INSERT [dbo].[Car_Services_Provided] ([ID_Car_Services_Provided], [List_Services_ID], [Start_Date], [End_Date], [Order_ID], [Worker_ID]) VALUES (66, 5, N'06.05.2022 19:56:27', N'06.05.2022 19:56:27', 71, 5)
INSERT [dbo].[Car_Services_Provided] ([ID_Car_Services_Provided], [List_Services_ID], [Start_Date], [End_Date], [Order_ID], [Worker_ID]) VALUES (67, 7, N'06.05.2022 19:56:25', N'06.05.2022 19:56:25', 71, 5)
INSERT [dbo].[Car_Services_Provided] ([ID_Car_Services_Provided], [List_Services_ID], [Start_Date], [End_Date], [Order_ID], [Worker_ID]) VALUES (70, 3, N'06.05.2022 22:26:54', N'06.05.2022 22:27:29', 72, 5)
INSERT [dbo].[Car_Services_Provided] ([ID_Car_Services_Provided], [List_Services_ID], [Start_Date], [End_Date], [Order_ID], [Worker_ID]) VALUES (82, 3, NULL, NULL, 74, 32)
INSERT [dbo].[Car_Services_Provided] ([ID_Car_Services_Provided], [List_Services_ID], [Start_Date], [End_Date], [Order_ID], [Worker_ID]) VALUES (83, 33, NULL, NULL, 74, 32)
INSERT [dbo].[Car_Services_Provided] ([ID_Car_Services_Provided], [List_Services_ID], [Start_Date], [End_Date], [Order_ID], [Worker_ID]) VALUES (84, 40, N'07.05.2022 9:17:27', N'07.05.2022 9:17:28', 75, 5)
INSERT [dbo].[Car_Services_Provided] ([ID_Car_Services_Provided], [List_Services_ID], [Start_Date], [End_Date], [Order_ID], [Worker_ID]) VALUES (85, 4, N'07.05.2022 9:17:30', N'07.05.2022 9:17:30', 75, 5)
INSERT [dbo].[Car_Services_Provided] ([ID_Car_Services_Provided], [List_Services_ID], [Start_Date], [End_Date], [Order_ID], [Worker_ID]) VALUES (86, 44, N'07.05.2022 9:17:50', N'07.05.2022 9:17:50', 75, 5)
INSERT [dbo].[Car_Services_Provided] ([ID_Car_Services_Provided], [List_Services_ID], [Start_Date], [End_Date], [Order_ID], [Worker_ID]) VALUES (87, 6, N'07.05.2022 9:18:24', N'07.05.2022 9:18:25', 75, 5)
INSERT [dbo].[Car_Services_Provided] ([ID_Car_Services_Provided], [List_Services_ID], [Start_Date], [End_Date], [Order_ID], [Worker_ID]) VALUES (88, 40, N'07.05.2022 9:25:10', N'07.05.2022 9:26:38', 76, 5)
INSERT [dbo].[Car_Services_Provided] ([ID_Car_Services_Provided], [List_Services_ID], [Start_Date], [End_Date], [Order_ID], [Worker_ID]) VALUES (89, 33, N'07.05.2022 9:25:12', N'07.05.2022 9:25:13', 76, 5)
INSERT [dbo].[Car_Services_Provided] ([ID_Car_Services_Provided], [List_Services_ID], [Start_Date], [End_Date], [Order_ID], [Worker_ID]) VALUES (90, 4, N'07.05.2022 9:26:47', N'07.05.2022 9:26:47', 76, 5)
INSERT [dbo].[Car_Services_Provided] ([ID_Car_Services_Provided], [List_Services_ID], [Start_Date], [End_Date], [Order_ID], [Worker_ID]) VALUES (91, 1, NULL, NULL, 77, 32)
SET IDENTITY_INSERT [dbo].[Car_Services_Provided] OFF
SET IDENTITY_INSERT [dbo].[Client] ON 

INSERT [dbo].[Client] ([ID_Client], [Surname], [Name], [Middle_Name], [Phone], [Date_Birth]) VALUES (1, N'Карман', N'Дмитрий', N'Александрович', N'+6 (666) 666-6666', CAST(N'2004-03-16' AS Date))
INSERT [dbo].[Client] ([ID_Client], [Surname], [Name], [Middle_Name], [Phone], [Date_Birth]) VALUES (2, N'Романов', N'Иван', N'Дмитреевич', N'+4 (555) 555-5555', CAST(N'2004-04-15' AS Date))
INSERT [dbo].[Client] ([ID_Client], [Surname], [Name], [Middle_Name], [Phone], [Date_Birth]) VALUES (3, N'Булеев', N'Евгений', N'Александрович', N'+8 (489) 483-0290', CAST(N'1978-03-17' AS Date))
INSERT [dbo].[Client] ([ID_Client], [Surname], [Name], [Middle_Name], [Phone], [Date_Birth]) VALUES (4, N'Иванов', N'Иван', N'Иванович', N'+6 (666) 666-6666', CAST(N'1999-05-04' AS Date))
INSERT [dbo].[Client] ([ID_Client], [Surname], [Name], [Middle_Name], [Phone], [Date_Birth]) VALUES (16, N'Булкин', N'Иван', N'Дмитреевич', N'+2 (222) 222-2222', CAST(N'1988-05-10' AS Date))
INSERT [dbo].[Client] ([ID_Client], [Surname], [Name], [Middle_Name], [Phone], [Date_Birth]) VALUES (17, N'Сальник', N'Михаил', N'Анатольевич', N'+5 (555) 555-5555', CAST(N'2004-05-10' AS Date))
INSERT [dbo].[Client] ([ID_Client], [Surname], [Name], [Middle_Name], [Phone], [Date_Birth]) VALUES (18, N'Куркин', N'Александр', N'Михайлович', N'+3 (333) 333-3333', CAST(N'2004-05-10' AS Date))
INSERT [dbo].[Client] ([ID_Client], [Surname], [Name], [Middle_Name], [Phone], [Date_Birth]) VALUES (19, N'Колам', N'Иван', N'Иванович', N'+8 (948) 498-9894', CAST(N'2000-05-10' AS Date))
SET IDENTITY_INSERT [dbo].[Client] OFF
SET IDENTITY_INSERT [dbo].[Component] ON 

INSERT [dbo].[Component] ([ID_Component], [Name_Component], [Minimum_Quantity], [Type_Сonsumable]) VALUES (1, N'Супорта', NULL, 0)
INSERT [dbo].[Component] ([ID_Component], [Name_Component], [Minimum_Quantity], [Type_Сonsumable]) VALUES (2, N'Тормозные колодки', NULL, 0)
INSERT [dbo].[Component] ([ID_Component], [Name_Component], [Minimum_Quantity], [Type_Сonsumable]) VALUES (3, N'Тормозные диски', NULL, 0)
INSERT [dbo].[Component] ([ID_Component], [Name_Component], [Minimum_Quantity], [Type_Сonsumable]) VALUES (4, N'Шины', NULL, 0)
INSERT [dbo].[Component] ([ID_Component], [Name_Component], [Minimum_Quantity], [Type_Сonsumable]) VALUES (5, N'Колпачки для двигателя', 110, 1)
INSERT [dbo].[Component] ([ID_Component], [Name_Component], [Minimum_Quantity], [Type_Сonsumable]) VALUES (6, N'Фара', NULL, 0)
INSERT [dbo].[Component] ([ID_Component], [Name_Component], [Minimum_Quantity], [Type_Сonsumable]) VALUES (7, N'Масло Shell 5W40', 1000, 1)
INSERT [dbo].[Component] ([ID_Component], [Name_Component], [Minimum_Quantity], [Type_Сonsumable]) VALUES (46, N'Свечи', NULL, 0)
INSERT [dbo].[Component] ([ID_Component], [Name_Component], [Minimum_Quantity], [Type_Сonsumable]) VALUES (47, N'Ремень ГРМ', 100, 1)
INSERT [dbo].[Component] ([ID_Component], [Name_Component], [Minimum_Quantity], [Type_Сonsumable]) VALUES (48, N'Привод сцепления', NULL, 0)
INSERT [dbo].[Component] ([ID_Component], [Name_Component], [Minimum_Quantity], [Type_Сonsumable]) VALUES (49, N'Сцепление', 200, 1)
INSERT [dbo].[Component] ([ID_Component], [Name_Component], [Minimum_Quantity], [Type_Сonsumable]) VALUES (50, N'Гур', NULL, 0)
INSERT [dbo].[Component] ([ID_Component], [Name_Component], [Minimum_Quantity], [Type_Сonsumable]) VALUES (51, N'Колпочки для шин 16R', 44, 1)
INSERT [dbo].[Component] ([ID_Component], [Name_Component], [Minimum_Quantity], [Type_Сonsumable]) VALUES (52, N'Моторчик стеклоподемников', 4444, 1)
INSERT [dbo].[Component] ([ID_Component], [Name_Component], [Minimum_Quantity], [Type_Сonsumable]) VALUES (53, N'Кулиса', 0, 1)
INSERT [dbo].[Component] ([ID_Component], [Name_Component], [Minimum_Quantity], [Type_Сonsumable]) VALUES (54, N'Радиатор', NULL, 0)
INSERT [dbo].[Component] ([ID_Component], [Name_Component], [Minimum_Quantity], [Type_Сonsumable]) VALUES (55, N'Масленный фильтр', 218, 1)
INSERT [dbo].[Component] ([ID_Component], [Name_Component], [Minimum_Quantity], [Type_Сonsumable]) VALUES (57, N'Заглушки для пазов', NULL, 0)
INSERT [dbo].[Component] ([ID_Component], [Name_Component], [Minimum_Quantity], [Type_Сonsumable]) VALUES (58, N'Кабель', 120, 1)
INSERT [dbo].[Component] ([ID_Component], [Name_Component], [Minimum_Quantity], [Type_Сonsumable]) VALUES (59, N'Мозги', NULL, 0)
INSERT [dbo].[Component] ([ID_Component], [Name_Component], [Minimum_Quantity], [Type_Сonsumable]) VALUES (60, N'Мозгис', 11, 1)
INSERT [dbo].[Component] ([ID_Component], [Name_Component], [Minimum_Quantity], [Type_Сonsumable]) VALUES (61, N'4', 12, 1)
SET IDENTITY_INSERT [dbo].[Component] OFF
SET IDENTITY_INSERT [dbo].[Component_Order] ON 

INSERT [dbo].[Component_Order] ([ID_Component_Order], [Component_ID], [Quantity_Component], [Order_ID], [Worker_ID], [Date_Enrollment], [Price]) VALUES (2, 2, 1, 2, 7, CAST(N'2022-03-15' AS Date), CAST(516.00 AS Decimal(38, 2)))
INSERT [dbo].[Component_Order] ([ID_Component_Order], [Component_ID], [Quantity_Component], [Order_ID], [Worker_ID], [Date_Enrollment], [Price]) VALUES (3, 5, 3, 1, 5, CAST(N'2022-04-25' AS Date), CAST(100.00 AS Decimal(38, 2)))
INSERT [dbo].[Component_Order] ([ID_Component_Order], [Component_ID], [Quantity_Component], [Order_ID], [Worker_ID], [Date_Enrollment], [Price]) VALUES (4, 5, 2, 3, 6, CAST(N'2022-03-15' AS Date), CAST(100.00 AS Decimal(38, 2)))
INSERT [dbo].[Component_Order] ([ID_Component_Order], [Component_ID], [Quantity_Component], [Order_ID], [Worker_ID], [Date_Enrollment], [Price]) VALUES (5, 4, 2, 9, 5, CAST(N'2022-04-25' AS Date), CAST(100.00 AS Decimal(38, 2)))
INSERT [dbo].[Component_Order] ([ID_Component_Order], [Component_ID], [Quantity_Component], [Order_ID], [Worker_ID], [Date_Enrollment], [Price]) VALUES (6, 3, 1, 9, 6, CAST(N'2022-03-16' AS Date), CAST(100.00 AS Decimal(38, 2)))
INSERT [dbo].[Component_Order] ([ID_Component_Order], [Component_ID], [Quantity_Component], [Order_ID], [Worker_ID], [Date_Enrollment], [Price]) VALUES (7, 4, 1, 8, 6, CAST(N'2022-03-16' AS Date), CAST(100.00 AS Decimal(38, 2)))
INSERT [dbo].[Component_Order] ([ID_Component_Order], [Component_ID], [Quantity_Component], [Order_ID], [Worker_ID], [Date_Enrollment], [Price]) VALUES (10, 3, 2, 11, 5, CAST(N'2022-04-22' AS Date), CAST(100.00 AS Decimal(38, 2)))
INSERT [dbo].[Component_Order] ([ID_Component_Order], [Component_ID], [Quantity_Component], [Order_ID], [Worker_ID], [Date_Enrollment], [Price]) VALUES (11, 2, 1, 11, 7, CAST(N'2022-03-17' AS Date), CAST(100.00 AS Decimal(38, 2)))
INSERT [dbo].[Component_Order] ([ID_Component_Order], [Component_ID], [Quantity_Component], [Order_ID], [Worker_ID], [Date_Enrollment], [Price]) VALUES (12, 5, 15, 12, 7, CAST(N'2022-03-17' AS Date), CAST(500.00 AS Decimal(38, 2)))
INSERT [dbo].[Component_Order] ([ID_Component_Order], [Component_ID], [Quantity_Component], [Order_ID], [Worker_ID], [Date_Enrollment], [Price]) VALUES (13, 2, 15, 12, 7, CAST(N'2022-03-17' AS Date), CAST(100.00 AS Decimal(38, 2)))
INSERT [dbo].[Component_Order] ([ID_Component_Order], [Component_ID], [Quantity_Component], [Order_ID], [Worker_ID], [Date_Enrollment], [Price]) VALUES (15, 6, 2000, 12, 2, CAST(N'2022-04-05' AS Date), CAST(100.00 AS Decimal(38, 2)))
INSERT [dbo].[Component_Order] ([ID_Component_Order], [Component_ID], [Quantity_Component], [Order_ID], [Worker_ID], [Date_Enrollment], [Price]) VALUES (22, 1, 101, 16, 7, CAST(N'2022-03-30' AS Date), CAST(100.00 AS Decimal(38, 2)))
INSERT [dbo].[Component_Order] ([ID_Component_Order], [Component_ID], [Quantity_Component], [Order_ID], [Worker_ID], [Date_Enrollment], [Price]) VALUES (23, 2, 500, 17, 7, CAST(N'2022-03-30' AS Date), CAST(100.00 AS Decimal(38, 2)))
INSERT [dbo].[Component_Order] ([ID_Component_Order], [Component_ID], [Quantity_Component], [Order_ID], [Worker_ID], [Date_Enrollment], [Price]) VALUES (24, 4, 1, 19, 2, CAST(N'2022-03-31' AS Date), CAST(100.00 AS Decimal(38, 2)))
INSERT [dbo].[Component_Order] ([ID_Component_Order], [Component_ID], [Quantity_Component], [Order_ID], [Worker_ID], [Date_Enrollment], [Price]) VALUES (25, 2, 1, 19, 2, CAST(N'2022-03-31' AS Date), CAST(100.00 AS Decimal(38, 2)))
INSERT [dbo].[Component_Order] ([ID_Component_Order], [Component_ID], [Quantity_Component], [Order_ID], [Worker_ID], [Date_Enrollment], [Price]) VALUES (26, 3, 1, 18, 2, CAST(N'2022-03-31' AS Date), CAST(100.00 AS Decimal(38, 2)))
INSERT [dbo].[Component_Order] ([ID_Component_Order], [Component_ID], [Quantity_Component], [Order_ID], [Worker_ID], [Date_Enrollment], [Price]) VALUES (27, 2, 500, 18, 2, CAST(N'2022-03-31' AS Date), CAST(100.00 AS Decimal(38, 2)))
INSERT [dbo].[Component_Order] ([ID_Component_Order], [Component_ID], [Quantity_Component], [Order_ID], [Worker_ID], [Date_Enrollment], [Price]) VALUES (37, 1, 300, 12, 2, CAST(N'2022-04-05' AS Date), CAST(300.00 AS Decimal(38, 2)))
INSERT [dbo].[Component_Order] ([ID_Component_Order], [Component_ID], [Quantity_Component], [Order_ID], [Worker_ID], [Date_Enrollment], [Price]) VALUES (38, 7, 18, 1, 5, CAST(N'2022-04-25' AS Date), CAST(600.00 AS Decimal(38, 2)))
INSERT [dbo].[Component_Order] ([ID_Component_Order], [Component_ID], [Quantity_Component], [Order_ID], [Worker_ID], [Date_Enrollment], [Price]) VALUES (39, 6, 11, 3, 5, CAST(N'2022-04-20' AS Date), CAST(600.00 AS Decimal(38, 2)))
INSERT [dbo].[Component_Order] ([ID_Component_Order], [Component_ID], [Quantity_Component], [Order_ID], [Worker_ID], [Date_Enrollment], [Price]) VALUES (40, 7, 1, 18, 2, CAST(N'2022-04-21' AS Date), CAST(600.00 AS Decimal(38, 2)))
INSERT [dbo].[Component_Order] ([ID_Component_Order], [Component_ID], [Quantity_Component], [Order_ID], [Worker_ID], [Date_Enrollment], [Price]) VALUES (41, 7, 1, 2, 5, CAST(N'2022-04-21' AS Date), CAST(600.00 AS Decimal(38, 2)))
INSERT [dbo].[Component_Order] ([ID_Component_Order], [Component_ID], [Quantity_Component], [Order_ID], [Worker_ID], [Date_Enrollment], [Price]) VALUES (43, 7, 10, 19, 5, CAST(N'2022-04-21' AS Date), CAST(600.00 AS Decimal(38, 2)))
INSERT [dbo].[Component_Order] ([ID_Component_Order], [Component_ID], [Quantity_Component], [Order_ID], [Worker_ID], [Date_Enrollment], [Price]) VALUES (49, 7, 20, 12, 5, CAST(N'2022-04-26' AS Date), CAST(600.00 AS Decimal(38, 2)))
INSERT [dbo].[Component_Order] ([ID_Component_Order], [Component_ID], [Quantity_Component], [Order_ID], [Worker_ID], [Date_Enrollment], [Price]) VALUES (50, 6, 16, 1, 5, CAST(N'2022-04-25' AS Date), CAST(0.00 AS Decimal(38, 2)))
INSERT [dbo].[Component_Order] ([ID_Component_Order], [Component_ID], [Quantity_Component], [Order_ID], [Worker_ID], [Date_Enrollment], [Price]) VALUES (51, 4, 4, 1, 2, CAST(N'2022-04-24' AS Date), CAST(0.00 AS Decimal(38, 2)))
INSERT [dbo].[Component_Order] ([ID_Component_Order], [Component_ID], [Quantity_Component], [Order_ID], [Worker_ID], [Date_Enrollment], [Price]) VALUES (52, 2, 1, 1, 5, CAST(N'2022-04-25' AS Date), CAST(0.00 AS Decimal(38, 2)))
INSERT [dbo].[Component_Order] ([ID_Component_Order], [Component_ID], [Quantity_Component], [Order_ID], [Worker_ID], [Date_Enrollment], [Price]) VALUES (53, 1, 1, 1, 5, CAST(N'2022-04-25' AS Date), CAST(0.00 AS Decimal(38, 2)))
INSERT [dbo].[Component_Order] ([ID_Component_Order], [Component_ID], [Quantity_Component], [Order_ID], [Worker_ID], [Date_Enrollment], [Price]) VALUES (120, 7, 2, 23, 32, CAST(N'2022-04-26' AS Date), CAST(600.00 AS Decimal(38, 2)))
INSERT [dbo].[Component_Order] ([ID_Component_Order], [Component_ID], [Quantity_Component], [Order_ID], [Worker_ID], [Date_Enrollment], [Price]) VALUES (121, 6, 3, 23, 32, CAST(N'2022-04-26' AS Date), CAST(516.00 AS Decimal(38, 2)))
INSERT [dbo].[Component_Order] ([ID_Component_Order], [Component_ID], [Quantity_Component], [Order_ID], [Worker_ID], [Date_Enrollment], [Price]) VALUES (122, 7, 1, 22, 5, CAST(N'2022-04-26' AS Date), CAST(600.00 AS Decimal(38, 2)))
INSERT [dbo].[Component_Order] ([ID_Component_Order], [Component_ID], [Quantity_Component], [Order_ID], [Worker_ID], [Date_Enrollment], [Price]) VALUES (123, 3, 1, 22, 5, CAST(N'2022-04-26' AS Date), CAST(120.00 AS Decimal(38, 2)))
INSERT [dbo].[Component_Order] ([ID_Component_Order], [Component_ID], [Quantity_Component], [Order_ID], [Worker_ID], [Date_Enrollment], [Price]) VALUES (124, 7, 3, 25, 32, CAST(N'2022-04-27' AS Date), CAST(600.00 AS Decimal(38, 2)))
INSERT [dbo].[Component_Order] ([ID_Component_Order], [Component_ID], [Quantity_Component], [Order_ID], [Worker_ID], [Date_Enrollment], [Price]) VALUES (125, 5, 3, 25, 32, CAST(N'2022-04-27' AS Date), CAST(700.00 AS Decimal(38, 2)))
INSERT [dbo].[Component_Order] ([ID_Component_Order], [Component_ID], [Quantity_Component], [Order_ID], [Worker_ID], [Date_Enrollment], [Price]) VALUES (126, 7, 1, 26, 5, CAST(N'2022-04-27' AS Date), CAST(252.24 AS Decimal(38, 2)))
INSERT [dbo].[Component_Order] ([ID_Component_Order], [Component_ID], [Quantity_Component], [Order_ID], [Worker_ID], [Date_Enrollment], [Price]) VALUES (131, 7, 1, 28, 32, CAST(N'2022-04-27' AS Date), CAST(252.24 AS Decimal(38, 2)))
INSERT [dbo].[Component_Order] ([ID_Component_Order], [Component_ID], [Quantity_Component], [Order_ID], [Worker_ID], [Date_Enrollment], [Price]) VALUES (132, 5, 1, 28, 32, CAST(N'2022-04-27' AS Date), CAST(700.00 AS Decimal(38, 2)))
INSERT [dbo].[Component_Order] ([ID_Component_Order], [Component_ID], [Quantity_Component], [Order_ID], [Worker_ID], [Date_Enrollment], [Price]) VALUES (135, 7, 1, 29, 32, CAST(N'2022-04-27' AS Date), CAST(252.24 AS Decimal(38, 2)))
INSERT [dbo].[Component_Order] ([ID_Component_Order], [Component_ID], [Quantity_Component], [Order_ID], [Worker_ID], [Date_Enrollment], [Price]) VALUES (136, 5, 1, 29, 32, CAST(N'2022-04-27' AS Date), CAST(700.00 AS Decimal(38, 2)))
INSERT [dbo].[Component_Order] ([ID_Component_Order], [Component_ID], [Quantity_Component], [Order_ID], [Worker_ID], [Date_Enrollment], [Price]) VALUES (137, 7, 1, 30, 32, CAST(N'2022-04-27' AS Date), CAST(252.24 AS Decimal(38, 2)))
INSERT [dbo].[Component_Order] ([ID_Component_Order], [Component_ID], [Quantity_Component], [Order_ID], [Worker_ID], [Date_Enrollment], [Price]) VALUES (140, 7, 1, 32, 32, CAST(N'2022-04-27' AS Date), CAST(252.24 AS Decimal(38, 2)))
INSERT [dbo].[Component_Order] ([ID_Component_Order], [Component_ID], [Quantity_Component], [Order_ID], [Worker_ID], [Date_Enrollment], [Price]) VALUES (141, 5, 1, 32, 32, CAST(N'2022-04-27' AS Date), CAST(700.00 AS Decimal(38, 2)))
INSERT [dbo].[Component_Order] ([ID_Component_Order], [Component_ID], [Quantity_Component], [Order_ID], [Worker_ID], [Date_Enrollment], [Price]) VALUES (142, 7, 2, 33, 32, CAST(N'2022-04-27' AS Date), CAST(252.24 AS Decimal(38, 2)))
INSERT [dbo].[Component_Order] ([ID_Component_Order], [Component_ID], [Quantity_Component], [Order_ID], [Worker_ID], [Date_Enrollment], [Price]) VALUES (143, 5, 2, 33, 32, CAST(N'2022-04-27' AS Date), CAST(700.00 AS Decimal(38, 2)))
INSERT [dbo].[Component_Order] ([ID_Component_Order], [Component_ID], [Quantity_Component], [Order_ID], [Worker_ID], [Date_Enrollment], [Price]) VALUES (144, 3, 4, 33, 32, CAST(N'2022-04-27' AS Date), CAST(1800.00 AS Decimal(38, 2)))
INSERT [dbo].[Component_Order] ([ID_Component_Order], [Component_ID], [Quantity_Component], [Order_ID], [Worker_ID], [Date_Enrollment], [Price]) VALUES (145, 4, 1, 33, 5, CAST(N'2022-04-27' AS Date), CAST(0.00 AS Decimal(38, 2)))
INSERT [dbo].[Component_Order] ([ID_Component_Order], [Component_ID], [Quantity_Component], [Order_ID], [Worker_ID], [Date_Enrollment], [Price]) VALUES (146, 7, 7, 31, 5, CAST(N'2022-04-27' AS Date), CAST(252.24 AS Decimal(38, 2)))
INSERT [dbo].[Component_Order] ([ID_Component_Order], [Component_ID], [Quantity_Component], [Order_ID], [Worker_ID], [Date_Enrollment], [Price]) VALUES (158, 7, 5, 39, 32, CAST(N'2022-04-28' AS Date), CAST(133.20 AS Decimal(38, 2)))
INSERT [dbo].[Component_Order] ([ID_Component_Order], [Component_ID], [Quantity_Component], [Order_ID], [Worker_ID], [Date_Enrollment], [Price]) VALUES (159, 5, 5, 39, 32, CAST(N'2022-04-28' AS Date), CAST(133.20 AS Decimal(38, 2)))
INSERT [dbo].[Component_Order] ([ID_Component_Order], [Component_ID], [Quantity_Component], [Order_ID], [Worker_ID], [Date_Enrollment], [Price]) VALUES (160, 5, 1, 40, 32, CAST(N'2022-04-29' AS Date), CAST(267.60 AS Decimal(38, 2)))
INSERT [dbo].[Component_Order] ([ID_Component_Order], [Component_ID], [Quantity_Component], [Order_ID], [Worker_ID], [Date_Enrollment], [Price]) VALUES (161, 7, 1, 40, 32, CAST(N'2022-04-29' AS Date), CAST(600.25 AS Decimal(38, 2)))
INSERT [dbo].[Component_Order] ([ID_Component_Order], [Component_ID], [Quantity_Component], [Order_ID], [Worker_ID], [Date_Enrollment], [Price]) VALUES (165, 7, 1, 41, 5, CAST(N'2022-05-01' AS Date), CAST(600.25 AS Decimal(38, 2)))
INSERT [dbo].[Component_Order] ([ID_Component_Order], [Component_ID], [Quantity_Component], [Order_ID], [Worker_ID], [Date_Enrollment], [Price]) VALUES (166, 5, 1, 41, 5, CAST(N'2022-05-01' AS Date), CAST(267.60 AS Decimal(38, 2)))
INSERT [dbo].[Component_Order] ([ID_Component_Order], [Component_ID], [Quantity_Component], [Order_ID], [Worker_ID], [Date_Enrollment], [Price]) VALUES (167, 4, 1, 40, 32, CAST(N'2022-05-01' AS Date), CAST(0.00 AS Decimal(38, 2)))
INSERT [dbo].[Component_Order] ([ID_Component_Order], [Component_ID], [Quantity_Component], [Order_ID], [Worker_ID], [Date_Enrollment], [Price]) VALUES (168, 6, 1, 40, 32, CAST(N'2022-05-01' AS Date), CAST(0.00 AS Decimal(38, 2)))
INSERT [dbo].[Component_Order] ([ID_Component_Order], [Component_ID], [Quantity_Component], [Order_ID], [Worker_ID], [Date_Enrollment], [Price]) VALUES (169, 5, 1, 42, 5, CAST(N'2022-05-01' AS Date), CAST(267.60 AS Decimal(38, 2)))
INSERT [dbo].[Component_Order] ([ID_Component_Order], [Component_ID], [Quantity_Component], [Order_ID], [Worker_ID], [Date_Enrollment], [Price]) VALUES (170, 5, 1, 43, 32, CAST(N'2022-05-01' AS Date), CAST(267.60 AS Decimal(38, 2)))
INSERT [dbo].[Component_Order] ([ID_Component_Order], [Component_ID], [Quantity_Component], [Order_ID], [Worker_ID], [Date_Enrollment], [Price]) VALUES (171, 5, 1, 46, 32, CAST(N'2022-05-03' AS Date), CAST(267.60 AS Decimal(38, 2)))
INSERT [dbo].[Component_Order] ([ID_Component_Order], [Component_ID], [Quantity_Component], [Order_ID], [Worker_ID], [Date_Enrollment], [Price]) VALUES (172, 1, 1, 46, 32, CAST(N'2022-05-03' AS Date), CAST(1200.00 AS Decimal(38, 2)))
INSERT [dbo].[Component_Order] ([ID_Component_Order], [Component_ID], [Quantity_Component], [Order_ID], [Worker_ID], [Date_Enrollment], [Price]) VALUES (173, 7, 1, 44, 5, CAST(N'2022-05-03' AS Date), CAST(600.25 AS Decimal(38, 2)))
INSERT [dbo].[Component_Order] ([ID_Component_Order], [Component_ID], [Quantity_Component], [Order_ID], [Worker_ID], [Date_Enrollment], [Price]) VALUES (174, 5, 1, 44, 5, CAST(N'2022-05-03' AS Date), CAST(267.60 AS Decimal(38, 2)))
INSERT [dbo].[Component_Order] ([ID_Component_Order], [Component_ID], [Quantity_Component], [Order_ID], [Worker_ID], [Date_Enrollment], [Price]) VALUES (175, 6, 1, 44, 5, CAST(N'2022-05-03' AS Date), CAST(1200.00 AS Decimal(38, 2)))
INSERT [dbo].[Component_Order] ([ID_Component_Order], [Component_ID], [Quantity_Component], [Order_ID], [Worker_ID], [Date_Enrollment], [Price]) VALUES (176, 4, 1, 48, 32, CAST(N'2022-05-04' AS Date), CAST(0.00 AS Decimal(38, 2)))
INSERT [dbo].[Component_Order] ([ID_Component_Order], [Component_ID], [Quantity_Component], [Order_ID], [Worker_ID], [Date_Enrollment], [Price]) VALUES (177, 6, 1, 48, 32, CAST(N'2022-05-04' AS Date), CAST(0.00 AS Decimal(38, 2)))
INSERT [dbo].[Component_Order] ([ID_Component_Order], [Component_ID], [Quantity_Component], [Order_ID], [Worker_ID], [Date_Enrollment], [Price]) VALUES (178, 7, 1, 50, 32, CAST(N'2022-05-04' AS Date), CAST(600.25 AS Decimal(38, 2)))
INSERT [dbo].[Component_Order] ([ID_Component_Order], [Component_ID], [Quantity_Component], [Order_ID], [Worker_ID], [Date_Enrollment], [Price]) VALUES (179, 1, 1, 50, 32, CAST(N'2022-05-04' AS Date), CAST(240.00 AS Decimal(38, 2)))
INSERT [dbo].[Component_Order] ([ID_Component_Order], [Component_ID], [Quantity_Component], [Order_ID], [Worker_ID], [Date_Enrollment], [Price]) VALUES (180, 3, 1, 50, 32, CAST(N'2022-05-04' AS Date), CAST(600.00 AS Decimal(38, 2)))
INSERT [dbo].[Component_Order] ([ID_Component_Order], [Component_ID], [Quantity_Component], [Order_ID], [Worker_ID], [Date_Enrollment], [Price]) VALUES (181, 7, 1, 51, 32, CAST(N'2022-05-04' AS Date), CAST(600.25 AS Decimal(38, 2)))
INSERT [dbo].[Component_Order] ([ID_Component_Order], [Component_ID], [Quantity_Component], [Order_ID], [Worker_ID], [Date_Enrollment], [Price]) VALUES (182, 1, 2, 51, 32, CAST(N'2022-05-04' AS Date), CAST(1440.00 AS Decimal(38, 2)))
INSERT [dbo].[Component_Order] ([ID_Component_Order], [Component_ID], [Quantity_Component], [Order_ID], [Worker_ID], [Date_Enrollment], [Price]) VALUES (183, 3, 2, 51, 32, CAST(N'2022-05-04' AS Date), CAST(1200.00 AS Decimal(38, 2)))
INSERT [dbo].[Component_Order] ([ID_Component_Order], [Component_ID], [Quantity_Component], [Order_ID], [Worker_ID], [Date_Enrollment], [Price]) VALUES (184, 7, 1, 52, 32, CAST(N'2022-05-04' AS Date), CAST(600.25 AS Decimal(38, 2)))
INSERT [dbo].[Component_Order] ([ID_Component_Order], [Component_ID], [Quantity_Component], [Order_ID], [Worker_ID], [Date_Enrollment], [Price]) VALUES (188, 7, 1, 57, 32, CAST(N'2022-05-04' AS Date), CAST(600.25 AS Decimal(38, 2)))
INSERT [dbo].[Component_Order] ([ID_Component_Order], [Component_ID], [Quantity_Component], [Order_ID], [Worker_ID], [Date_Enrollment], [Price]) VALUES (189, 7, 1, 58, 32, CAST(N'2022-05-04' AS Date), CAST(600.25 AS Decimal(38, 2)))
INSERT [dbo].[Component_Order] ([ID_Component_Order], [Component_ID], [Quantity_Component], [Order_ID], [Worker_ID], [Date_Enrollment], [Price]) VALUES (190, 7, 1, 59, 32, CAST(N'2022-05-04' AS Date), CAST(600.25 AS Decimal(38, 2)))
INSERT [dbo].[Component_Order] ([ID_Component_Order], [Component_ID], [Quantity_Component], [Order_ID], [Worker_ID], [Date_Enrollment], [Price]) VALUES (191, 4, 1, 59, 5, CAST(N'2022-05-04' AS Date), CAST(120.00 AS Decimal(38, 2)))
INSERT [dbo].[Component_Order] ([ID_Component_Order], [Component_ID], [Quantity_Component], [Order_ID], [Worker_ID], [Date_Enrollment], [Price]) VALUES (192, 6, 1, 59, 5, CAST(N'2022-05-04' AS Date), CAST(240.00 AS Decimal(38, 2)))
INSERT [dbo].[Component_Order] ([ID_Component_Order], [Component_ID], [Quantity_Component], [Order_ID], [Worker_ID], [Date_Enrollment], [Price]) VALUES (193, 3, 1, 60, 32, CAST(N'2022-05-04' AS Date), CAST(360.00 AS Decimal(38, 2)))
INSERT [dbo].[Component_Order] ([ID_Component_Order], [Component_ID], [Quantity_Component], [Order_ID], [Worker_ID], [Date_Enrollment], [Price]) VALUES (194, 6, 1, 60, 5, CAST(N'2022-05-04' AS Date), CAST(0.00 AS Decimal(38, 2)))
INSERT [dbo].[Component_Order] ([ID_Component_Order], [Component_ID], [Quantity_Component], [Order_ID], [Worker_ID], [Date_Enrollment], [Price]) VALUES (195, 7, 1, 61, 32, CAST(N'2022-05-04' AS Date), CAST(600.25 AS Decimal(38, 2)))
INSERT [dbo].[Component_Order] ([ID_Component_Order], [Component_ID], [Quantity_Component], [Order_ID], [Worker_ID], [Date_Enrollment], [Price]) VALUES (196, 4, 1, 61, 32, CAST(N'2022-05-04' AS Date), CAST(2400.00 AS Decimal(38, 2)))
INSERT [dbo].[Component_Order] ([ID_Component_Order], [Component_ID], [Quantity_Component], [Order_ID], [Worker_ID], [Date_Enrollment], [Price]) VALUES (197, 6, 6, 61, 5, CAST(N'2022-05-04' AS Date), CAST(1440.00 AS Decimal(38, 2)))
INSERT [dbo].[Component_Order] ([ID_Component_Order], [Component_ID], [Quantity_Component], [Order_ID], [Worker_ID], [Date_Enrollment], [Price]) VALUES (198, 2, 4, 61, 5, CAST(N'2022-05-04' AS Date), CAST(1200.00 AS Decimal(38, 2)))
INSERT [dbo].[Component_Order] ([ID_Component_Order], [Component_ID], [Quantity_Component], [Order_ID], [Worker_ID], [Date_Enrollment], [Price]) VALUES (199, 3, 5, 61, 5, CAST(N'2022-05-04' AS Date), CAST(1560.00 AS Decimal(38, 2)))
INSERT [dbo].[Component_Order] ([ID_Component_Order], [Component_ID], [Quantity_Component], [Order_ID], [Worker_ID], [Date_Enrollment], [Price]) VALUES (203, 55, 30, 63, 32, CAST(N'2022-05-04' AS Date), CAST(300.00 AS Decimal(38, 2)))
INSERT [dbo].[Component_Order] ([ID_Component_Order], [Component_ID], [Quantity_Component], [Order_ID], [Worker_ID], [Date_Enrollment], [Price]) VALUES (204, 5, 30, 64, 32, CAST(N'2022-05-04' AS Date), CAST(267.60 AS Decimal(38, 2)))
INSERT [dbo].[Component_Order] ([ID_Component_Order], [Component_ID], [Quantity_Component], [Order_ID], [Worker_ID], [Date_Enrollment], [Price]) VALUES (205, 7, 1, 66, 32, CAST(N'2022-05-04' AS Date), CAST(1200.00 AS Decimal(38, 2)))
INSERT [dbo].[Component_Order] ([ID_Component_Order], [Component_ID], [Quantity_Component], [Order_ID], [Worker_ID], [Date_Enrollment], [Price]) VALUES (206, 5, 10, 66, 5, CAST(N'2022-05-04' AS Date), CAST(0.00 AS Decimal(38, 2)))
INSERT [dbo].[Component_Order] ([ID_Component_Order], [Component_ID], [Quantity_Component], [Order_ID], [Worker_ID], [Date_Enrollment], [Price]) VALUES (207, 55, 10, 66, 5, CAST(N'2022-05-04' AS Date), CAST(300.00 AS Decimal(38, 2)))
INSERT [dbo].[Component_Order] ([ID_Component_Order], [Component_ID], [Quantity_Component], [Order_ID], [Worker_ID], [Date_Enrollment], [Price]) VALUES (208, 6, 1, 66, 32, CAST(N'2022-05-04' AS Date), CAST(1200.00 AS Decimal(38, 2)))
INSERT [dbo].[Component_Order] ([ID_Component_Order], [Component_ID], [Quantity_Component], [Order_ID], [Worker_ID], [Date_Enrollment], [Price]) VALUES (209, 7, 10, 67, 32, CAST(N'2022-05-04' AS Date), CAST(1200.00 AS Decimal(38, 2)))
INSERT [dbo].[Component_Order] ([ID_Component_Order], [Component_ID], [Quantity_Component], [Order_ID], [Worker_ID], [Date_Enrollment], [Price]) VALUES (210, 55, 300, 67, 32, CAST(N'2022-05-04' AS Date), CAST(1200.00 AS Decimal(38, 2)))
INSERT [dbo].[Component_Order] ([ID_Component_Order], [Component_ID], [Quantity_Component], [Order_ID], [Worker_ID], [Date_Enrollment], [Price]) VALUES (211, 55, 2, 68, 32, CAST(N'2022-05-05' AS Date), CAST(276.00 AS Decimal(38, 2)))
INSERT [dbo].[Component_Order] ([ID_Component_Order], [Component_ID], [Quantity_Component], [Order_ID], [Worker_ID], [Date_Enrollment], [Price]) VALUES (212, 7, 5, 68, 32, CAST(N'2022-05-05' AS Date), CAST(1200.00 AS Decimal(38, 2)))
INSERT [dbo].[Component_Order] ([ID_Component_Order], [Component_ID], [Quantity_Component], [Order_ID], [Worker_ID], [Date_Enrollment], [Price]) VALUES (213, 1, 1, 68, 32, CAST(N'2022-05-05' AS Date), CAST(1320.00 AS Decimal(38, 2)))
INSERT [dbo].[Component_Order] ([ID_Component_Order], [Component_ID], [Quantity_Component], [Order_ID], [Worker_ID], [Date_Enrollment], [Price]) VALUES (214, 55, 1, 69, 32, CAST(N'2022-05-06' AS Date), CAST(1200.00 AS Decimal(38, 2)))
INSERT [dbo].[Component_Order] ([ID_Component_Order], [Component_ID], [Quantity_Component], [Order_ID], [Worker_ID], [Date_Enrollment], [Price]) VALUES (215, 5, 1, 69, 32, CAST(N'2022-05-06' AS Date), CAST(2400.00 AS Decimal(38, 2)))
INSERT [dbo].[Component_Order] ([ID_Component_Order], [Component_ID], [Quantity_Component], [Order_ID], [Worker_ID], [Date_Enrollment], [Price]) VALUES (216, 7, 1, 69, 32, CAST(N'2022-05-06' AS Date), CAST(2400.00 AS Decimal(38, 2)))
INSERT [dbo].[Component_Order] ([ID_Component_Order], [Component_ID], [Quantity_Component], [Order_ID], [Worker_ID], [Date_Enrollment], [Price]) VALUES (217, 7, 1, 70, 32, CAST(N'2022-05-06' AS Date), CAST(2400.00 AS Decimal(38, 2)))
INSERT [dbo].[Component_Order] ([ID_Component_Order], [Component_ID], [Quantity_Component], [Order_ID], [Worker_ID], [Date_Enrollment], [Price]) VALUES (218, 5, 1, 70, 32, CAST(N'2022-05-06' AS Date), CAST(2400.00 AS Decimal(38, 2)))
GO
INSERT [dbo].[Component_Order] ([ID_Component_Order], [Component_ID], [Quantity_Component], [Order_ID], [Worker_ID], [Date_Enrollment], [Price]) VALUES (219, 55, 1, 70, 32, CAST(N'2022-05-06' AS Date), CAST(1200.00 AS Decimal(38, 2)))
INSERT [dbo].[Component_Order] ([ID_Component_Order], [Component_ID], [Quantity_Component], [Order_ID], [Worker_ID], [Date_Enrollment], [Price]) VALUES (220, 55, 1, 71, 32, CAST(N'2022-05-06' AS Date), CAST(1200.00 AS Decimal(38, 2)))
INSERT [dbo].[Component_Order] ([ID_Component_Order], [Component_ID], [Quantity_Component], [Order_ID], [Worker_ID], [Date_Enrollment], [Price]) VALUES (221, 5, 1, 71, 32, CAST(N'2022-05-06' AS Date), CAST(2400.00 AS Decimal(38, 2)))
INSERT [dbo].[Component_Order] ([ID_Component_Order], [Component_ID], [Quantity_Component], [Order_ID], [Worker_ID], [Date_Enrollment], [Price]) VALUES (222, 7, 1, 71, 32, CAST(N'2022-05-06' AS Date), CAST(2400.00 AS Decimal(38, 2)))
INSERT [dbo].[Component_Order] ([ID_Component_Order], [Component_ID], [Quantity_Component], [Order_ID], [Worker_ID], [Date_Enrollment], [Price]) VALUES (225, 7, 1, 72, 32, CAST(N'2022-05-06' AS Date), CAST(288.00 AS Decimal(38, 2)))
INSERT [dbo].[Component_Order] ([ID_Component_Order], [Component_ID], [Quantity_Component], [Order_ID], [Worker_ID], [Date_Enrollment], [Price]) VALUES (230, 52, 1, 72, 32, CAST(N'2022-05-06' AS Date), CAST(360.00 AS Decimal(38, 2)))
INSERT [dbo].[Component_Order] ([ID_Component_Order], [Component_ID], [Quantity_Component], [Order_ID], [Worker_ID], [Date_Enrollment], [Price]) VALUES (231, 55, 1, 72, 32, CAST(N'2022-05-06' AS Date), CAST(1200.00 AS Decimal(38, 2)))
INSERT [dbo].[Component_Order] ([ID_Component_Order], [Component_ID], [Quantity_Component], [Order_ID], [Worker_ID], [Date_Enrollment], [Price]) VALUES (239, 6, 1, 72, 5, CAST(N'2022-05-06' AS Date), CAST(120.00 AS Decimal(38, 2)))
INSERT [dbo].[Component_Order] ([ID_Component_Order], [Component_ID], [Quantity_Component], [Order_ID], [Worker_ID], [Date_Enrollment], [Price]) VALUES (240, 5, 1, 73, 5, CAST(N'2022-05-06' AS Date), CAST(228.00 AS Decimal(38, 2)))
INSERT [dbo].[Component_Order] ([ID_Component_Order], [Component_ID], [Quantity_Component], [Order_ID], [Worker_ID], [Date_Enrollment], [Price]) VALUES (241, 52, 1, 12, 32, CAST(N'2022-05-06' AS Date), CAST(360.00 AS Decimal(38, 2)))
INSERT [dbo].[Component_Order] ([ID_Component_Order], [Component_ID], [Quantity_Component], [Order_ID], [Worker_ID], [Date_Enrollment], [Price]) VALUES (242, 5, 1, 74, 32, CAST(N'2022-05-07' AS Date), CAST(228.00 AS Decimal(38, 2)))
INSERT [dbo].[Component_Order] ([ID_Component_Order], [Component_ID], [Quantity_Component], [Order_ID], [Worker_ID], [Date_Enrollment], [Price]) VALUES (243, 51, 1, 74, 32, CAST(N'2022-05-07' AS Date), CAST(240.00 AS Decimal(38, 2)))
INSERT [dbo].[Component_Order] ([ID_Component_Order], [Component_ID], [Quantity_Component], [Order_ID], [Worker_ID], [Date_Enrollment], [Price]) VALUES (244, 50, 1, 74, 32, CAST(N'2022-05-07' AS Date), CAST(120.00 AS Decimal(38, 2)))
INSERT [dbo].[Component_Order] ([ID_Component_Order], [Component_ID], [Quantity_Component], [Order_ID], [Worker_ID], [Date_Enrollment], [Price]) VALUES (245, 54, 1, 74, 32, CAST(N'2022-05-07' AS Date), CAST(240.00 AS Decimal(38, 2)))
INSERT [dbo].[Component_Order] ([ID_Component_Order], [Component_ID], [Quantity_Component], [Order_ID], [Worker_ID], [Date_Enrollment], [Price]) VALUES (246, 52, 1, 75, 32, CAST(N'2022-05-07' AS Date), CAST(360.00 AS Decimal(38, 2)))
INSERT [dbo].[Component_Order] ([ID_Component_Order], [Component_ID], [Quantity_Component], [Order_ID], [Worker_ID], [Date_Enrollment], [Price]) VALUES (247, 7, 1, 75, 32, CAST(N'2022-05-07' AS Date), CAST(288.00 AS Decimal(38, 2)))
INSERT [dbo].[Component_Order] ([ID_Component_Order], [Component_ID], [Quantity_Component], [Order_ID], [Worker_ID], [Date_Enrollment], [Price]) VALUES (250, 55, 1, 75, 5, CAST(N'2022-05-07' AS Date), CAST(1200.00 AS Decimal(38, 2)))
INSERT [dbo].[Component_Order] ([ID_Component_Order], [Component_ID], [Quantity_Component], [Order_ID], [Worker_ID], [Date_Enrollment], [Price]) VALUES (252, 7, 1, 76, 32, CAST(N'2022-05-07' AS Date), CAST(288.00 AS Decimal(38, 2)))
INSERT [dbo].[Component_Order] ([ID_Component_Order], [Component_ID], [Quantity_Component], [Order_ID], [Worker_ID], [Date_Enrollment], [Price]) VALUES (253, 51, 1, 76, 32, CAST(N'2022-05-07' AS Date), CAST(240.00 AS Decimal(38, 2)))
INSERT [dbo].[Component_Order] ([ID_Component_Order], [Component_ID], [Quantity_Component], [Order_ID], [Worker_ID], [Date_Enrollment], [Price]) VALUES (254, 50, 1, 76, 32, CAST(N'2022-05-07' AS Date), CAST(360.00 AS Decimal(38, 2)))
INSERT [dbo].[Component_Order] ([ID_Component_Order], [Component_ID], [Quantity_Component], [Order_ID], [Worker_ID], [Date_Enrollment], [Price]) VALUES (255, 54, 1, 76, 32, CAST(N'2022-05-07' AS Date), CAST(3600.00 AS Decimal(38, 2)))
INSERT [dbo].[Component_Order] ([ID_Component_Order], [Component_ID], [Quantity_Component], [Order_ID], [Worker_ID], [Date_Enrollment], [Price]) VALUES (256, 46, 1, 76, 5, CAST(N'2022-05-07' AS Date), CAST(120.00 AS Decimal(38, 2)))
INSERT [dbo].[Component_Order] ([ID_Component_Order], [Component_ID], [Quantity_Component], [Order_ID], [Worker_ID], [Date_Enrollment], [Price]) VALUES (257, 2, 1, 77, 32, CAST(N'2022-05-07' AS Date), CAST(144.00 AS Decimal(38, 2)))
INSERT [dbo].[Component_Order] ([ID_Component_Order], [Component_ID], [Quantity_Component], [Order_ID], [Worker_ID], [Date_Enrollment], [Price]) VALUES (258, 54, 1, 77, 5, CAST(N'2022-05-07' AS Date), CAST(276.00 AS Decimal(38, 2)))
INSERT [dbo].[Component_Order] ([ID_Component_Order], [Component_ID], [Quantity_Component], [Order_ID], [Worker_ID], [Date_Enrollment], [Price]) VALUES (259, 50, 1, 78, 32, CAST(N'2022-05-07' AS Date), CAST(1200.00 AS Decimal(38, 2)))
INSERT [dbo].[Component_Order] ([ID_Component_Order], [Component_ID], [Quantity_Component], [Order_ID], [Worker_ID], [Date_Enrollment], [Price]) VALUES (260, 54, 1, 78, 32, CAST(N'2022-05-07' AS Date), CAST(240.00 AS Decimal(38, 2)))
INSERT [dbo].[Component_Order] ([ID_Component_Order], [Component_ID], [Quantity_Component], [Order_ID], [Worker_ID], [Date_Enrollment], [Price]) VALUES (261, 52, 1, 79, 32, CAST(N'2022-05-10' AS Date), CAST(120.00 AS Decimal(38, 2)))
INSERT [dbo].[Component_Order] ([ID_Component_Order], [Component_ID], [Quantity_Component], [Order_ID], [Worker_ID], [Date_Enrollment], [Price]) VALUES (262, 7, 2, 79, 5, CAST(N'2022-05-10' AS Date), CAST(288.00 AS Decimal(38, 2)))
INSERT [dbo].[Component_Order] ([ID_Component_Order], [Component_ID], [Quantity_Component], [Order_ID], [Worker_ID], [Date_Enrollment], [Price]) VALUES (266, 55, 3, 79, 32, CAST(N'2022-05-10' AS Date), CAST(1200.00 AS Decimal(38, 2)))
INSERT [dbo].[Component_Order] ([ID_Component_Order], [Component_ID], [Quantity_Component], [Order_ID], [Worker_ID], [Date_Enrollment], [Price]) VALUES (267, 7, 1, 78, 5, CAST(N'2022-05-10' AS Date), CAST(288.00 AS Decimal(38, 2)))
SET IDENTITY_INSERT [dbo].[Component_Order] OFF
INSERT [dbo].[Customers_Machines] ([VIN], [Registration_Mark], [Year_Release], [Mileage], [Brand_Model_Compliance_ID], [Client_ID]) VALUES (N'2D2E2D2DDD2D2D226', N'G774GG474', N'2022', 444, 1, NULL)
INSERT [dbo].[Customers_Machines] ([VIN], [Registration_Mark], [Year_Release], [Mileage], [Brand_Model_Compliance_ID], [Client_ID]) VALUES (N'33333333333333338', N'G333RR333', N'2022', 333, 1, NULL)
INSERT [dbo].[Customers_Machines] ([VIN], [Registration_Mark], [Year_Release], [Mileage], [Brand_Model_Compliance_ID], [Client_ID]) VALUES (N'BJ4JBJ3JOJOJ9J99J', N'J858IR197', N'2022', 12000, 649, NULL)
INSERT [dbo].[Customers_Machines] ([VIN], [Registration_Mark], [Year_Release], [Mileage], [Brand_Model_Compliance_ID], [Client_ID]) VALUES (N'DNNU27E1Y27B72B7D', N'D282DD222', N'2022', 322, 420, NULL)
INSERT [dbo].[Customers_Machines] ([VIN], [Registration_Mark], [Year_Release], [Mileage], [Brand_Model_Compliance_ID], [Client_ID]) VALUES (N'EO2KI3RUYGTJ3KRYG', N'Y777YF838', N'2020', 20000, 128, 3)
INSERT [dbo].[Customers_Machines] ([VIN], [Registration_Mark], [Year_Release], [Mileage], [Brand_Model_Compliance_ID], [Client_ID]) VALUES (N'FFFFFFFFFFFFFFFFF', N'F444RR555', N'2022', 33333, 1, 2)
INSERT [dbo].[Customers_Machines] ([VIN], [Registration_Mark], [Year_Release], [Mileage], [Brand_Model_Compliance_ID], [Client_ID]) VALUES (N'FUHFH3UFUH3UHF3HU', N'F333IJ333', N'2022', 333, 1, 3)
INSERT [dbo].[Customers_Machines] ([VIN], [Registration_Mark], [Year_Release], [Mileage], [Brand_Model_Compliance_ID], [Client_ID]) VALUES (N'GGEG4G4GG3G2G4GG4', N'G444GG444', N'2022', 222, 304, NULL)
INSERT [dbo].[Customers_Machines] ([VIN], [Registration_Mark], [Year_Release], [Mileage], [Brand_Model_Compliance_ID], [Client_ID]) VALUES (N'HDULGGFFGGFYH 227', N'F122JH197', N'2019', 20000, 1, 1)
INSERT [dbo].[Customers_Machines] ([VIN], [Registration_Mark], [Year_Release], [Mileage], [Brand_Model_Compliance_ID], [Client_ID]) VALUES (N'HDULGGFFGGFYH 252', N'F122JH197', N'2019', 20000, 1, 1)
INSERT [dbo].[Customers_Machines] ([VIN], [Registration_Mark], [Year_Release], [Mileage], [Brand_Model_Compliance_ID], [Client_ID]) VALUES (N'HDULGGFFGGFYH 283', N'F122JH197', N'2019', 20000, 1, 1)
INSERT [dbo].[Customers_Machines] ([VIN], [Registration_Mark], [Year_Release], [Mileage], [Brand_Model_Compliance_ID], [Client_ID]) VALUES (N'JI3HDUYFKW3IJUK3I', N'R398RU383', N'2022', 1, 1, 3)
INSERT [dbo].[Customers_Machines] ([VIN], [Registration_Mark], [Year_Release], [Mileage], [Brand_Model_Compliance_ID], [Client_ID]) VALUES (N'KJDHJEEJEEIJIEJ45', N'R548JJ555', N'1999', 12000, 601, 2)
INSERT [dbo].[Customers_Machines] ([VIN], [Registration_Mark], [Year_Release], [Mileage], [Brand_Model_Compliance_ID], [Client_ID]) VALUES (N'QQQQQQQQQQQQQQQQQ', N'J589NJ489', N'2022', 40000, 1, 3)
INSERT [dbo].[Customers_Machines] ([VIN], [Registration_Mark], [Year_Release], [Mileage], [Brand_Model_Compliance_ID], [Client_ID]) VALUES (N'QQWDWDDW33RFFWFWW', N'R764GY333', N'2022', 222, 1, 1)
INSERT [dbo].[Customers_Machines] ([VIN], [Registration_Mark], [Year_Release], [Mileage], [Brand_Model_Compliance_ID], [Client_ID]) VALUES (N'R333333333333333R', N'R333RR333', N'2008', 200000, 426, 2)
INSERT [dbo].[Customers_Machines] ([VIN], [Registration_Mark], [Year_Release], [Mileage], [Brand_Model_Compliance_ID], [Client_ID]) VALUES (N'RRRRRRR4444444444', N'R444RR444', N'2022', 222, 1, 19)
INSERT [dbo].[Customers_Machines] ([VIN], [Registration_Mark], [Year_Release], [Mileage], [Brand_Model_Compliance_ID], [Client_ID]) VALUES (N'WCCWCWCWCWCWCWWCC', N'W333FF333', N'2022', 33333, 9, 3)
INSERT [dbo].[Customers_Machines] ([VIN], [Registration_Mark], [Year_Release], [Mileage], [Brand_Model_Compliance_ID], [Client_ID]) VALUES (N'WDDDDDDDDDDDDDWDW', N'D939JJ399', N'2022', 22222, 334, 3)
INSERT [dbo].[Customers_Machines] ([VIN], [Registration_Mark], [Year_Release], [Mileage], [Brand_Model_Compliance_ID], [Client_ID]) VALUES (N'WUHI1IK0I19EJ22EJ', N'E222EE222', N'2022', 222, 1, NULL)
INSERT [dbo].[Customers_Machines] ([VIN], [Registration_Mark], [Year_Release], [Mileage], [Brand_Model_Compliance_ID], [Client_ID]) VALUES (N'МУУУМУМУМУМУМУМУМ', N'М456РР622', N'2022', 20000, 1, 4)
INSERT [dbo].[Customers_Machines] ([VIN], [Registration_Mark], [Year_Release], [Mileage], [Brand_Model_Compliance_ID], [Client_ID]) VALUES (N'П4Р5ШП47ВМ4П5П7П5', N'И001РР197', N'2016', 20000, 1195, NULL)
INSERT [dbo].[Customers_Machines] ([VIN], [Registration_Mark], [Year_Release], [Mileage], [Brand_Model_Compliance_ID], [Client_ID]) VALUES (N'Р11ГР2РГРГГРРГР3Г', N'Ш888ГЕ899', N'2008', 150000, 416, NULL)
INSERT [dbo].[Customers_Machines] ([VIN], [Registration_Mark], [Year_Release], [Mileage], [Brand_Model_Compliance_ID], [Client_ID]) VALUES (N'РК8484П47Н47Н7Н47', N'Г444РР441', N'2005', 1200, 1010, NULL)
SET IDENTITY_INSERT [dbo].[Employee] ON 

INSERT [dbo].[Employee] ([ID_Employee], [Surname], [Name_Employee], [Patronymic]) VALUES (1, N'Иванов', N'Иван', N'Иванович')
INSERT [dbo].[Employee] ([ID_Employee], [Surname], [Name_Employee], [Patronymic]) VALUES (2, N'Иванов', N'Дмитрий', N'Константинович')
INSERT [dbo].[Employee] ([ID_Employee], [Surname], [Name_Employee], [Patronymic]) VALUES (4, N'Косам', N'Егор', N'Максимович')
INSERT [dbo].[Employee] ([ID_Employee], [Surname], [Name_Employee], [Patronymic]) VALUES (5, N'Шамаров', N'Антон', N'Артемовий')
INSERT [dbo].[Employee] ([ID_Employee], [Surname], [Name_Employee], [Patronymic]) VALUES (6, N'Кутяпова', N'Антон', N'Дмитреевич')
INSERT [dbo].[Employee] ([ID_Employee], [Surname], [Name_Employee], [Patronymic]) VALUES (29, N'Булкин', N'Иван', N'Дмитреевич')
INSERT [dbo].[Employee] ([ID_Employee], [Surname], [Name_Employee], [Patronymic]) VALUES (30, N'Иванов', N'Иван', N'Ианович')
INSERT [dbo].[Employee] ([ID_Employee], [Surname], [Name_Employee], [Patronymic]) VALUES (31, N'Балаев', N'Денис', N'Максимович')
INSERT [dbo].[Employee] ([ID_Employee], [Surname], [Name_Employee], [Patronymic]) VALUES (32, N'Маргонин', N'Иван', N'Дмитреевич')
INSERT [dbo].[Employee] ([ID_Employee], [Surname], [Name_Employee], [Patronymic]) VALUES (33, N'Геворг', N'Дмитрий', N'Иванович')
SET IDENTITY_INSERT [dbo].[Employee] OFF
SET IDENTITY_INSERT [dbo].[List_Services] ON 

INSERT [dbo].[List_Services] ([ID_List_Services], [Name_Services], [Norm_Hour], [Price], [Service_Group_ID]) VALUES (1, N'Ремонт клапонной крышки', 1, CAST(2000.00 AS Decimal(38, 2)), 1)
INSERT [dbo].[List_Services] ([ID_List_Services], [Name_Services], [Norm_Hour], [Price], [Service_Group_ID]) VALUES (2, N'Замена подушек', 1, CAST(1200.00 AS Decimal(38, 2)), 1)
INSERT [dbo].[List_Services] ([ID_List_Services], [Name_Services], [Norm_Hour], [Price], [Service_Group_ID]) VALUES (3, N'Замена свечей', 1, CAST(500.00 AS Decimal(38, 2)), 1)
INSERT [dbo].[List_Services] ([ID_List_Services], [Name_Services], [Norm_Hour], [Price], [Service_Group_ID]) VALUES (4, N'Замена суппортов', 2, CAST(1700.00 AS Decimal(38, 2)), 2)
INSERT [dbo].[List_Services] ([ID_List_Services], [Name_Services], [Norm_Hour], [Price], [Service_Group_ID]) VALUES (5, N'Переборка подвески', 2, CAST(7000.00 AS Decimal(38, 2)), 2)
INSERT [dbo].[List_Services] ([ID_List_Services], [Name_Services], [Norm_Hour], [Price], [Service_Group_ID]) VALUES (6, N'Замена тормозных дисков', 1, CAST(2000.00 AS Decimal(38, 2)), 2)
INSERT [dbo].[List_Services] ([ID_List_Services], [Name_Services], [Norm_Hour], [Price], [Service_Group_ID]) VALUES (7, N'Замена колодок', 1, CAST(1800.00 AS Decimal(38, 2)), 2)
INSERT [dbo].[List_Services] ([ID_List_Services], [Name_Services], [Norm_Hour], [Price], [Service_Group_ID]) VALUES (8, N'Сход развал', 1, CAST(1100.00 AS Decimal(38, 2)), 3)
INSERT [dbo].[List_Services] ([ID_List_Services], [Name_Services], [Norm_Hour], [Price], [Service_Group_ID]) VALUES (9, N'Регулировка высоты фар', 1, CAST(2000.00 AS Decimal(38, 2)), 3)
INSERT [dbo].[List_Services] ([ID_List_Services], [Name_Services], [Norm_Hour], [Price], [Service_Group_ID]) VALUES (10, N'Замер мощьности', 1, CAST(1800.00 AS Decimal(38, 2)), 3)
INSERT [dbo].[List_Services] ([ID_List_Services], [Name_Services], [Norm_Hour], [Price], [Service_Group_ID]) VALUES (13, N'Настройка вылета пререднего бампера', 1, CAST(100.00 AS Decimal(38, 2)), 3)
INSERT [dbo].[List_Services] ([ID_List_Services], [Name_Services], [Norm_Hour], [Price], [Service_Group_ID]) VALUES (14, N'Настройка автозвука', 1, CAST(1200.00 AS Decimal(38, 2)), 3)
INSERT [dbo].[List_Services] ([ID_List_Services], [Name_Services], [Norm_Hour], [Price], [Service_Group_ID]) VALUES (15, N'Востоновление падушки безопастности', 1, CAST(1333.00 AS Decimal(38, 2)), 4)
INSERT [dbo].[List_Services] ([ID_List_Services], [Name_Services], [Norm_Hour], [Price], [Service_Group_ID]) VALUES (32, N'Ремонт тормазной системы', 1, CAST(1333.00 AS Decimal(38, 2)), 15)
INSERT [dbo].[List_Services] ([ID_List_Services], [Name_Services], [Norm_Hour], [Price], [Service_Group_ID]) VALUES (33, N'Ремонт топлевной системы', 1, CAST(1333.00 AS Decimal(38, 2)), 1)
INSERT [dbo].[List_Services] ([ID_List_Services], [Name_Services], [Norm_Hour], [Price], [Service_Group_ID]) VALUES (34, N'Замена свечей зажигания', 1, CAST(11111.00 AS Decimal(38, 2)), 15)
INSERT [dbo].[List_Services] ([ID_List_Services], [Name_Services], [Norm_Hour], [Price], [Service_Group_ID]) VALUES (35, N'Чистка инжектора', 2, CAST(2222.00 AS Decimal(38, 2)), 4)
INSERT [dbo].[List_Services] ([ID_List_Services], [Name_Services], [Norm_Hour], [Price], [Service_Group_ID]) VALUES (36, N'Замена сальников', 3, CAST(2222.00 AS Decimal(38, 2)), 3)
INSERT [dbo].[List_Services] ([ID_List_Services], [Name_Services], [Norm_Hour], [Price], [Service_Group_ID]) VALUES (37, N'Чистка дросельной заслонки', 5, CAST(100.00 AS Decimal(38, 2)), 5)
INSERT [dbo].[List_Services] ([ID_List_Services], [Name_Services], [Norm_Hour], [Price], [Service_Group_ID]) VALUES (38, N'Замена масленного насоса', 0.3, CAST(100.00 AS Decimal(38, 2)), 3)
INSERT [dbo].[List_Services] ([ID_List_Services], [Name_Services], [Norm_Hour], [Price], [Service_Group_ID]) VALUES (39, N'Ремонт выхлопной системы', 1, CAST(1000.00 AS Decimal(38, 2)), 42)
INSERT [dbo].[List_Services] ([ID_List_Services], [Name_Services], [Norm_Hour], [Price], [Service_Group_ID]) VALUES (40, N'Регулирование впрыска двигателя', 1, CAST(2000.00 AS Decimal(38, 2)), 1)
INSERT [dbo].[List_Services] ([ID_List_Services], [Name_Services], [Norm_Hour], [Price], [Service_Group_ID]) VALUES (44, N'Замена масла в радиаторе', 1, CAST(1100.00 AS Decimal(38, 2)), 1)
INSERT [dbo].[List_Services] ([ID_List_Services], [Name_Services], [Norm_Hour], [Price], [Service_Group_ID]) VALUES (45, N'Замена колпачка', 1, CAST(1111.00 AS Decimal(38, 2)), 4)
SET IDENTITY_INSERT [dbo].[List_Services] OFF
SET IDENTITY_INSERT [dbo].[List_Status] ON 

INSERT [dbo].[List_Status] ([ID_List_Status], [Name_Status]) VALUES (2, N'Выполняеться')
INSERT [dbo].[List_Status] ([ID_List_Status], [Name_Status]) VALUES (3, N'Закрыт')
INSERT [dbo].[List_Status] ([ID_List_Status], [Name_Status]) VALUES (4, N'Не доступен')
INSERT [dbo].[List_Status] ([ID_List_Status], [Name_Status]) VALUES (1, N'Открыт')
INSERT [dbo].[List_Status] ([ID_List_Status], [Name_Status]) VALUES (6, N'Согласован с заказчиком')
SET IDENTITY_INSERT [dbo].[List_Status] OFF
SET IDENTITY_INSERT [dbo].[Order] ON 

INSERT [dbo].[Order] ([ID_Order], [VIN], [Date_Receipt], [List_Status_ID], [Branch_ID], [Worker_ID]) VALUES (1, NULL, N'15.03.2022', 2, 1, 5)
INSERT [dbo].[Order] ([ID_Order], [VIN], [Date_Receipt], [List_Status_ID], [Branch_ID], [Worker_ID]) VALUES (2, NULL, N'15.03.2022', 2, 1, 1)
INSERT [dbo].[Order] ([ID_Order], [VIN], [Date_Receipt], [List_Status_ID], [Branch_ID], [Worker_ID]) VALUES (3, N'QQWDWDDW33RFFWFWW', N'15.03.2022', 2, 1, 5)
INSERT [dbo].[Order] ([ID_Order], [VIN], [Date_Receipt], [List_Status_ID], [Branch_ID], [Worker_ID]) VALUES (4, N'QQWDWDDW33RFFWFWW', N'15.03.2022', 1, 1, 5)
INSERT [dbo].[Order] ([ID_Order], [VIN], [Date_Receipt], [List_Status_ID], [Branch_ID], [Worker_ID]) VALUES (6, NULL, N'15.03.2022', 3, 1, 1)
INSERT [dbo].[Order] ([ID_Order], [VIN], [Date_Receipt], [List_Status_ID], [Branch_ID], [Worker_ID]) VALUES (7, NULL, N'16.03.2022', 1, 1, 1)
INSERT [dbo].[Order] ([ID_Order], [VIN], [Date_Receipt], [List_Status_ID], [Branch_ID], [Worker_ID]) VALUES (8, N'FFFFFFFFFFFFFFFFF', N'16.03.2022', 1, 1, 1)
INSERT [dbo].[Order] ([ID_Order], [VIN], [Date_Receipt], [List_Status_ID], [Branch_ID], [Worker_ID]) VALUES (9, NULL, N'16.03.2022', 1, 1, 1)
INSERT [dbo].[Order] ([ID_Order], [VIN], [Date_Receipt], [List_Status_ID], [Branch_ID], [Worker_ID]) VALUES (10, N'KJDHJEEJEEIJIEJ45', N'17.03.2022', 2, 1, 1)
INSERT [dbo].[Order] ([ID_Order], [VIN], [Date_Receipt], [List_Status_ID], [Branch_ID], [Worker_ID]) VALUES (11, N'KJDHJEEJEEIJIEJ45', N'17.03.2022', 1, 1, 1)
INSERT [dbo].[Order] ([ID_Order], [VIN], [Date_Receipt], [List_Status_ID], [Branch_ID], [Worker_ID]) VALUES (12, N'EO2KI3RUYGTJ3KRYG', N'17.03.2022', 2, 1, 1)
INSERT [dbo].[Order] ([ID_Order], [VIN], [Date_Receipt], [List_Status_ID], [Branch_ID], [Worker_ID]) VALUES (13, N'R333333333333333R', N'28.03.2022', 1, 1, 2)
INSERT [dbo].[Order] ([ID_Order], [VIN], [Date_Receipt], [List_Status_ID], [Branch_ID], [Worker_ID]) VALUES (14, N'R333333333333333R', N'28.03.2022', 1, 1, 2)
INSERT [dbo].[Order] ([ID_Order], [VIN], [Date_Receipt], [List_Status_ID], [Branch_ID], [Worker_ID]) VALUES (15, N'QQWDWDDW33RFFWFWW', N'28.03.2022', 1, 1, 2)
INSERT [dbo].[Order] ([ID_Order], [VIN], [Date_Receipt], [List_Status_ID], [Branch_ID], [Worker_ID]) VALUES (16, NULL, N'30.03.2022', 1, 1, 2)
INSERT [dbo].[Order] ([ID_Order], [VIN], [Date_Receipt], [List_Status_ID], [Branch_ID], [Worker_ID]) VALUES (17, NULL, N'30.03.2022', 1, 1, 2)
INSERT [dbo].[Order] ([ID_Order], [VIN], [Date_Receipt], [List_Status_ID], [Branch_ID], [Worker_ID]) VALUES (18, NULL, N'31.03.2022', 1, 1, 2)
INSERT [dbo].[Order] ([ID_Order], [VIN], [Date_Receipt], [List_Status_ID], [Branch_ID], [Worker_ID]) VALUES (19, NULL, N'31.03.2022', 1, 1, 2)
INSERT [dbo].[Order] ([ID_Order], [VIN], [Date_Receipt], [List_Status_ID], [Branch_ID], [Worker_ID]) VALUES (20, N'JI3HDUYFKW3IJUK3I', N'26.04.2022', 1, 1, 5)
INSERT [dbo].[Order] ([ID_Order], [VIN], [Date_Receipt], [List_Status_ID], [Branch_ID], [Worker_ID]) VALUES (21, NULL, N'26.04.2022', 1, 1, 5)
INSERT [dbo].[Order] ([ID_Order], [VIN], [Date_Receipt], [List_Status_ID], [Branch_ID], [Worker_ID]) VALUES (22, NULL, N'26.04.2022', 2, 1, 5)
INSERT [dbo].[Order] ([ID_Order], [VIN], [Date_Receipt], [List_Status_ID], [Branch_ID], [Worker_ID]) VALUES (23, N'QQWDWDDW33RFFWFWW', N'26.04.2022', 1, 1, 32)
INSERT [dbo].[Order] ([ID_Order], [VIN], [Date_Receipt], [List_Status_ID], [Branch_ID], [Worker_ID]) VALUES (24, N'HDULGGFFGGFYH 252', N'26.04.2022', 1, 1, 5)
INSERT [dbo].[Order] ([ID_Order], [VIN], [Date_Receipt], [List_Status_ID], [Branch_ID], [Worker_ID]) VALUES (25, N'HDULGGFFGGFYH 227', N'27.04.2022', 2, 1, 5)
INSERT [dbo].[Order] ([ID_Order], [VIN], [Date_Receipt], [List_Status_ID], [Branch_ID], [Worker_ID]) VALUES (26, NULL, N'27.04.2022', 2, 1, 32)
INSERT [dbo].[Order] ([ID_Order], [VIN], [Date_Receipt], [List_Status_ID], [Branch_ID], [Worker_ID]) VALUES (27, N'HDULGGFFGGFYH 227', N'27.04.2022', 1, 1, 32)
INSERT [dbo].[Order] ([ID_Order], [VIN], [Date_Receipt], [List_Status_ID], [Branch_ID], [Worker_ID]) VALUES (28, N'HDULGGFFGGFYH 227', N'27.04.2022', 1, 1, 32)
INSERT [dbo].[Order] ([ID_Order], [VIN], [Date_Receipt], [List_Status_ID], [Branch_ID], [Worker_ID]) VALUES (29, N'HDULGGFFGGFYH 227', N'27.04.2022', 1, 1, 32)
INSERT [dbo].[Order] ([ID_Order], [VIN], [Date_Receipt], [List_Status_ID], [Branch_ID], [Worker_ID]) VALUES (30, N'HDULGGFFGGFYH 252', N'27.04.2022', 1, 1, 32)
INSERT [dbo].[Order] ([ID_Order], [VIN], [Date_Receipt], [List_Status_ID], [Branch_ID], [Worker_ID]) VALUES (31, N'HDULGGFFGGFYH 252', N'27.04.2022', 1, 1, 5)
INSERT [dbo].[Order] ([ID_Order], [VIN], [Date_Receipt], [List_Status_ID], [Branch_ID], [Worker_ID]) VALUES (32, N'HDULGGFFGGFYH 283', N'27.04.2022', 1, 1, 32)
INSERT [dbo].[Order] ([ID_Order], [VIN], [Date_Receipt], [List_Status_ID], [Branch_ID], [Worker_ID]) VALUES (33, N'HDULGGFFGGFYH 283', N'27.04.2022', 1, 1, 5)
INSERT [dbo].[Order] ([ID_Order], [VIN], [Date_Receipt], [List_Status_ID], [Branch_ID], [Worker_ID]) VALUES (34, N'HDULGGFFGGFYH 283', N'27.04.2022', 1, 1, 32)
INSERT [dbo].[Order] ([ID_Order], [VIN], [Date_Receipt], [List_Status_ID], [Branch_ID], [Worker_ID]) VALUES (39, N'JI3HDUYFKW3IJUK3I', N'28.04.2022', 1, 1, 32)
INSERT [dbo].[Order] ([ID_Order], [VIN], [Date_Receipt], [List_Status_ID], [Branch_ID], [Worker_ID]) VALUES (40, NULL, N'29.04.2022', 2, 1, 32)
INSERT [dbo].[Order] ([ID_Order], [VIN], [Date_Receipt], [List_Status_ID], [Branch_ID], [Worker_ID]) VALUES (41, N'WDDDDDDDDDDDDDWDW', N'29.04.2022', 1, 1, 5)
INSERT [dbo].[Order] ([ID_Order], [VIN], [Date_Receipt], [List_Status_ID], [Branch_ID], [Worker_ID]) VALUES (42, N'QQWDWDDW33RFFWFWW', N'01.05.2022', 2, 1, 5)
INSERT [dbo].[Order] ([ID_Order], [VIN], [Date_Receipt], [List_Status_ID], [Branch_ID], [Worker_ID]) VALUES (43, N'HDULGGFFGGFYH 227', N'01.05.2022', 1, 1, 32)
INSERT [dbo].[Order] ([ID_Order], [VIN], [Date_Receipt], [List_Status_ID], [Branch_ID], [Worker_ID]) VALUES (44, N'QQQQQQQQQQQQQQQQQ', N'01.05.2022', 2, 1, 5)
INSERT [dbo].[Order] ([ID_Order], [VIN], [Date_Receipt], [List_Status_ID], [Branch_ID], [Worker_ID]) VALUES (45, NULL, N'01.05.2022', 1, 1, 32)
INSERT [dbo].[Order] ([ID_Order], [VIN], [Date_Receipt], [List_Status_ID], [Branch_ID], [Worker_ID]) VALUES (46, N'QQQQQQQQQQQQQQQQQ', N'03.05.2022', 1, 1, 32)
INSERT [dbo].[Order] ([ID_Order], [VIN], [Date_Receipt], [List_Status_ID], [Branch_ID], [Worker_ID]) VALUES (47, N'QQQQQQQQQQQQQQQQQ', N'03.05.2022', 2, 1, 5)
INSERT [dbo].[Order] ([ID_Order], [VIN], [Date_Receipt], [List_Status_ID], [Branch_ID], [Worker_ID]) VALUES (48, N'QQQQQQQQQQQQQQQQQ', N'04.05.2022', 2, 1, 32)
INSERT [dbo].[Order] ([ID_Order], [VIN], [Date_Receipt], [List_Status_ID], [Branch_ID], [Worker_ID]) VALUES (49, N'QQQQQQQQQQQQQQQQQ', N'04.05.2022', 1, 1, 32)
INSERT [dbo].[Order] ([ID_Order], [VIN], [Date_Receipt], [List_Status_ID], [Branch_ID], [Worker_ID]) VALUES (50, N'МУУУМУМУМУМУМУМУМ', N'04.05.2022', 3, 1, 5)
INSERT [dbo].[Order] ([ID_Order], [VIN], [Date_Receipt], [List_Status_ID], [Branch_ID], [Worker_ID]) VALUES (51, N'BJ4JBJ3JOJOJ9J99J', N'04.05.2022', 2, 1, 5)
INSERT [dbo].[Order] ([ID_Order], [VIN], [Date_Receipt], [List_Status_ID], [Branch_ID], [Worker_ID]) VALUES (52, N'GGEG4G4GG3G2G4GG4', N'04.05.2022', 3, 1, 5)
INSERT [dbo].[Order] ([ID_Order], [VIN], [Date_Receipt], [List_Status_ID], [Branch_ID], [Worker_ID]) VALUES (53, N'GGEG4G4GG3G2G4GG4', N'04.05.2022', 1, 1, 32)
INSERT [dbo].[Order] ([ID_Order], [VIN], [Date_Receipt], [List_Status_ID], [Branch_ID], [Worker_ID]) VALUES (54, N'МУУУМУМУМУМУМУМУМ', N'04.05.2022', 1, 1, 32)
INSERT [dbo].[Order] ([ID_Order], [VIN], [Date_Receipt], [List_Status_ID], [Branch_ID], [Worker_ID]) VALUES (55, N'МУУУМУМУМУМУМУМУМ', N'04.05.2022', 1, 1, 32)
INSERT [dbo].[Order] ([ID_Order], [VIN], [Date_Receipt], [List_Status_ID], [Branch_ID], [Worker_ID]) VALUES (56, N'МУУУМУМУМУМУМУМУМ', N'04.05.2022', 2, 1, 32)
INSERT [dbo].[Order] ([ID_Order], [VIN], [Date_Receipt], [List_Status_ID], [Branch_ID], [Worker_ID]) VALUES (57, N'BJ4JBJ3JOJOJ9J99J', N'04.05.2022', 1, 1, 32)
INSERT [dbo].[Order] ([ID_Order], [VIN], [Date_Receipt], [List_Status_ID], [Branch_ID], [Worker_ID]) VALUES (58, N'GGEG4G4GG3G2G4GG4', N'04.05.2022', 1, 1, 32)
INSERT [dbo].[Order] ([ID_Order], [VIN], [Date_Receipt], [List_Status_ID], [Branch_ID], [Worker_ID]) VALUES (59, NULL, N'04.05.2022', 2, 1, 5)
INSERT [dbo].[Order] ([ID_Order], [VIN], [Date_Receipt], [List_Status_ID], [Branch_ID], [Worker_ID]) VALUES (60, NULL, N'04.05.2022', 2, 1, 5)
INSERT [dbo].[Order] ([ID_Order], [VIN], [Date_Receipt], [List_Status_ID], [Branch_ID], [Worker_ID]) VALUES (61, N'Р11ГР2РГРГГРРГР3Г', N'04.05.2022', 3, 1, 5)
INSERT [dbo].[Order] ([ID_Order], [VIN], [Date_Receipt], [List_Status_ID], [Branch_ID], [Worker_ID]) VALUES (62, N'Р11ГР2РГРГГРРГР3Г', N'04.05.2022', 2, 1, 32)
INSERT [dbo].[Order] ([ID_Order], [VIN], [Date_Receipt], [List_Status_ID], [Branch_ID], [Worker_ID]) VALUES (63, N'Р11ГР2РГРГГРРГР3Г', N'04.05.2022', 2, 1, 32)
INSERT [dbo].[Order] ([ID_Order], [VIN], [Date_Receipt], [List_Status_ID], [Branch_ID], [Worker_ID]) VALUES (64, N'Р11ГР2РГРГГРРГР3Г', N'04.05.2022', 2, 1, 32)
INSERT [dbo].[Order] ([ID_Order], [VIN], [Date_Receipt], [List_Status_ID], [Branch_ID], [Worker_ID]) VALUES (65, N'Р11ГР2РГРГГРРГР3Г', N'04.05.2022', 1, 1, 32)
INSERT [dbo].[Order] ([ID_Order], [VIN], [Date_Receipt], [List_Status_ID], [Branch_ID], [Worker_ID]) VALUES (66, N'Р11ГР2РГРГГРРГР3Г', N'04.05.2022', 1, 1, 5)
INSERT [dbo].[Order] ([ID_Order], [VIN], [Date_Receipt], [List_Status_ID], [Branch_ID], [Worker_ID]) VALUES (67, NULL, N'04.05.2022', 3, 1, 5)
INSERT [dbo].[Order] ([ID_Order], [VIN], [Date_Receipt], [List_Status_ID], [Branch_ID], [Worker_ID]) VALUES (68, N'П4Р5ШП47ВМ4П5П7П5', N'05.05.2022', 2, 1, 5)
INSERT [dbo].[Order] ([ID_Order], [VIN], [Date_Receipt], [List_Status_ID], [Branch_ID], [Worker_ID]) VALUES (69, N'DNNU27E1Y27B72B7D', N'06.05.2022', 1, 1, 32)
INSERT [dbo].[Order] ([ID_Order], [VIN], [Date_Receipt], [List_Status_ID], [Branch_ID], [Worker_ID]) VALUES (70, N'DNNU27E1Y27B72B7D', N'06.05.2022', 1, 1, 32)
INSERT [dbo].[Order] ([ID_Order], [VIN], [Date_Receipt], [List_Status_ID], [Branch_ID], [Worker_ID]) VALUES (71, N'2D2E2D2DDD2D2D226', N'06.05.2022', 2, 1, 5)
INSERT [dbo].[Order] ([ID_Order], [VIN], [Date_Receipt], [List_Status_ID], [Branch_ID], [Worker_ID]) VALUES (72, N'РК8484П47Н47Н7Н47', N'06.05.2022', 2, 1, 5)
INSERT [dbo].[Order] ([ID_Order], [VIN], [Date_Receipt], [List_Status_ID], [Branch_ID], [Worker_ID]) VALUES (73, N'РК8484П47Н47Н7Н47', N'06.05.2022', 2, 1, 5)
INSERT [dbo].[Order] ([ID_Order], [VIN], [Date_Receipt], [List_Status_ID], [Branch_ID], [Worker_ID]) VALUES (74, N'РК8484П47Н47Н7Н47', N'07.05.2022', 2, 1, 32)
INSERT [dbo].[Order] ([ID_Order], [VIN], [Date_Receipt], [List_Status_ID], [Branch_ID], [Worker_ID]) VALUES (75, N'РК8484П47Н47Н7Н47', N'07.05.2022', 3, 1, 5)
INSERT [dbo].[Order] ([ID_Order], [VIN], [Date_Receipt], [List_Status_ID], [Branch_ID], [Worker_ID]) VALUES (76, N'РК8484П47Н47Н7Н47', N'07.05.2022', 3, 1, 5)
INSERT [dbo].[Order] ([ID_Order], [VIN], [Date_Receipt], [List_Status_ID], [Branch_ID], [Worker_ID]) VALUES (77, N'РК8484П47Н47Н7Н47', N'07.05.2022', 2, 1, 5)
INSERT [dbo].[Order] ([ID_Order], [VIN], [Date_Receipt], [List_Status_ID], [Branch_ID], [Worker_ID]) VALUES (78, N'РК8484П47Н47Н7Н47', N'07.05.2022', 2, 1, 5)
INSERT [dbo].[Order] ([ID_Order], [VIN], [Date_Receipt], [List_Status_ID], [Branch_ID], [Worker_ID]) VALUES (79, N'RRRRRRR4444444444', N'10.05.2022', 2, 1, 5)
SET IDENTITY_INSERT [dbo].[Order] OFF
SET IDENTITY_INSERT [dbo].[Order_Log] ON 

INSERT [dbo].[Order_Log] ([ID_Order_Log], [Quantity_Component], [Component_Order_ID], [Application_ID], [Price], [List_Status_ID]) VALUES (66, 138, 206, NULL, CAST(200.00 AS Decimal(38, 2)), 1)
SET IDENTITY_INSERT [dbo].[Order_Log] OFF

INSERT [dbo].[Order_Log] ([ID_Order_Log], [Quantity_Component], [Component_Order_ID], [Application_ID], [Price], [List_Status_ID]) VALUES (67, 272, 207, NULL, CAST(1000.00 AS Decimal(38, 2)), 3)
INSERT [dbo].[Order_Log] ([ID_Order_Log], [Quantity_Component], [Component_Order_ID], [Application_ID], [Price], [List_Status_ID]) VALUES (492, 10, NULL, 29, CAST(300.00 AS Decimal(38, 2)), 3)
INSERT [dbo].[Order_Log] ([ID_Order_Log], [Quantity_Component], [Component_Order_ID], [Application_ID], [Price], [List_Status_ID]) VALUES (496, 1, NULL, 31, CAST(200.00 AS Decimal(38, 2)), 3)
INSERT [dbo].[Order_Log] ([ID_Order_Log], [Quantity_Component], [Component_Order_ID], [Application_ID], [Price], [List_Status_ID]) VALUES (497, 1, NULL, 32, CAST(300.00 AS Decimal(38, 2)), 3)
INSERT [dbo].[Order_Log] ([ID_Order_Log], [Quantity_Component], [Component_Order_ID], [Application_ID], [Price], [List_Status_ID]) VALUES (499, 5555, 230, NULL, CAST(100.00 AS Decimal(38, 2)), 3)
INSERT [dbo].[Order_Log] ([ID_Order_Log], [Quantity_Component], [Component_Order_ID], [Application_ID], [Price], [List_Status_ID]) VALUES (507, NULL, 239, NULL, CAST(100.00 AS Decimal(38, 2)), 3)
INSERT [dbo].[Order_Log] ([ID_Order_Log], [Quantity_Component], [Component_Order_ID], [Application_ID], [Price], [List_Status_ID]) VALUES (508, NULL, 244, NULL, CAST(100.00 AS Decimal(38, 2)), 3)
INSERT [dbo].[Order_Log] ([ID_Order_Log], [Quantity_Component], [Component_Order_ID], [Application_ID], [Price], [List_Status_ID]) VALUES (509, NULL, 245, NULL, CAST(200.00 AS Decimal(38, 2)), 3)
INSERT [dbo].[Order_Log] ([ID_Order_Log], [Quantity_Component], [Component_Order_ID], [Application_ID], [Price], [List_Status_ID]) VALUES (513, NULL, 254, NULL, CAST(300.00 AS Decimal(38, 2)), 3)
INSERT [dbo].[Order_Log] ([ID_Order_Log], [Quantity_Component], [Component_Order_ID], [Application_ID], [Price], [List_Status_ID]) VALUES (514, NULL, 255, NULL, CAST(3000.00 AS Decimal(38, 2)), 3)
INSERT [dbo].[Order_Log] ([ID_Order_Log], [Quantity_Component], [Component_Order_ID], [Application_ID], [Price], [List_Status_ID]) VALUES (515, NULL, 256, NULL, CAST(100.00 AS Decimal(38, 2)), 3)
INSERT [dbo].[Order_Log] ([ID_Order_Log], [Quantity_Component], [Component_Order_ID], [Application_ID], [Price], [List_Status_ID]) VALUES (520, 272, 207, NULL, CAST(1000.00 AS Decimal(38, 2)), 1)
INSERT [dbo].[Order_Log] ([ID_Order_Log], [Quantity_Component], [Component_Order_ID], [Application_ID], [Price], [List_Status_ID]) VALUES (521, 272, 207, NULL, CAST(1000.00 AS Decimal(38, 2)), 1)
INSERT [dbo].[Order_Log] ([ID_Order_Log], [Quantity_Component], [Component_Order_ID], [Application_ID], [Price], [List_Status_ID]) VALUES (522, 272, 207, NULL, CAST(1000.00 AS Decimal(38, 2)), 1)
INSERT [dbo].[Order_Log] ([ID_Order_Log], [Quantity_Component], [Component_Order_ID], [Application_ID], [Price], [List_Status_ID]) VALUES (523, 55, NULL, 33, CAST(0.00 AS Decimal(38, 2)), 1)
SET IDENTITY_INSERT [dbo].[Order_Log] OFF
SET IDENTITY_INSERT [dbo].[Post] ON 

INSERT [dbo].[Post] ([ID_Post], [Name_Post]) VALUES (2, N'Админестратор точки')
INSERT [dbo].[Post] ([ID_Post], [Name_Post]) VALUES (1, N'Кладовщик')
INSERT [dbo].[Post] ([ID_Post], [Name_Post]) VALUES (3, N'Механик')
SET IDENTITY_INSERT [dbo].[Post] OFF
SET IDENTITY_INSERT [dbo].[Service_Group] ON 

INSERT [dbo].[Service_Group] ([ID_Service_Group], [Name_Group_Service]) VALUES (1, N'Двигатели')
INSERT [dbo].[Service_Group] ([ID_Service_Group], [Name_Group_Service]) VALUES (2, N'Диагностика')
INSERT [dbo].[Service_Group] ([ID_Service_Group], [Name_Group_Service]) VALUES (5, N'Замена частей')
INSERT [dbo].[Service_Group] ([ID_Service_Group], [Name_Group_Service]) VALUES (43, N'Колесная база')
INSERT [dbo].[Service_Group] ([ID_Service_Group], [Name_Group_Service]) VALUES (44, N'Косметический ремонт')
INSERT [dbo].[Service_Group] ([ID_Service_Group], [Name_Group_Service]) VALUES (45, N'оо')
INSERT [dbo].[Service_Group] ([ID_Service_Group], [Name_Group_Service]) VALUES (15, N'Подвеска')
INSERT [dbo].[Service_Group] ([ID_Service_Group], [Name_Group_Service]) VALUES (28, N'Подготовительные')
INSERT [dbo].[Service_Group] ([ID_Service_Group], [Name_Group_Service]) VALUES (42, N'Рулевое управление')
INSERT [dbo].[Service_Group] ([ID_Service_Group], [Name_Group_Service]) VALUES (3, N'Тех осмотр')
INSERT [dbo].[Service_Group] ([ID_Service_Group], [Name_Group_Service]) VALUES (4, N'Тормозная система')
INSERT [dbo].[Service_Group] ([ID_Service_Group], [Name_Group_Service]) VALUES (34, N'Трансмисия')
INSERT [dbo].[Service_Group] ([ID_Service_Group], [Name_Group_Service]) VALUES (31, N'Ходовая')
INSERT [dbo].[Service_Group] ([ID_Service_Group], [Name_Group_Service]) VALUES (33, N'Шино монтаж р')
SET IDENTITY_INSERT [dbo].[Service_Group] OFF
SET IDENTITY_INSERT [dbo].[Warehouse] ON 

INSERT [dbo].[Warehouse] ([ID_Warehouse], [Component_ID], [Quantity_Warehouse], [Price], [Branch_ID]) VALUES (18, 7, 2697, CAST(288.00 AS Decimal(38, 2)), 1)
INSERT [dbo].[Warehouse] ([ID_Warehouse], [Component_ID], [Quantity_Warehouse], [Price], [Branch_ID]) VALUES (21, 5, 225, CAST(228.00 AS Decimal(38, 2)), 1)
INSERT [dbo].[Warehouse] ([ID_Warehouse], [Component_ID], [Quantity_Warehouse], [Price], [Branch_ID]) VALUES (23, 55, 285, CAST(1200.00 AS Decimal(38, 2)), 1)
INSERT [dbo].[Warehouse] ([ID_Warehouse], [Component_ID], [Quantity_Warehouse], [Price], [Branch_ID]) VALUES (25, 52, 5754, CAST(120.00 AS Decimal(38, 2)), 1)
INSERT [dbo].[Warehouse] ([ID_Warehouse], [Component_ID], [Quantity_Warehouse], [Price], [Branch_ID]) VALUES (26, 51, 400, CAST(240.00 AS Decimal(38, 2)), 1)
SET IDENTITY_INSERT [dbo].[Warehouse] OFF
SET IDENTITY_INSERT [dbo].[Worker] ON 

INSERT [dbo].[Worker] ([ID_Worker], [Employee_ID], [Post_ID], [Login], [Password], [Date_Employment], [Branch_ID]) VALUES (1, 2, 2, N'bugalter1', N'2b7d11433cf9b308c55aa6d80f573daa', N'19.03.2022', 1)
INSERT [dbo].[Worker] ([ID_Worker], [Employee_ID], [Post_ID], [Login], [Password], [Date_Employment], [Branch_ID]) VALUES (2, 2, 2, N'kadrov1', N'ee6d75e18d5212d7c28ba8532242c025', N'19.03.2022', 2)
INSERT [dbo].[Worker] ([ID_Worker], [Employee_ID], [Post_ID], [Login], [Password], [Date_Employment], [Branch_ID]) VALUES (3, NULL, 2, N'menadger1', N'88c9fb2f9eb2b4c770d3ef53479c9092', N'19.03.2022', 1)
INSERT [dbo].[Worker] ([ID_Worker], [Employee_ID], [Post_ID], [Login], [Password], [Date_Employment], [Branch_ID]) VALUES (4, NULL, 3, N'menadger2', N'88c9fb2f9eb2b4c770d3ef53479c90924', N'19.03.2022', 1)
INSERT [dbo].[Worker] ([ID_Worker], [Employee_ID], [Post_ID], [Login], [Password], [Date_Employment], [Branch_ID]) VALUES (5, 4, 3, N'kladovchic1', N'a887ecc31204f2d3ec6454a47cb960da', N'19.03.2022', 1)
INSERT [dbo].[Worker] ([ID_Worker], [Employee_ID], [Post_ID], [Login], [Password], [Date_Employment], [Branch_ID]) VALUES (6, 5, 3, N'hefpovar', N'8783d03af819ce9befc1959f0bdde1c7', N'19.03.2022', 1)
INSERT [dbo].[Worker] ([ID_Worker], [Employee_ID], [Post_ID], [Login], [Password], [Date_Employment], [Branch_ID]) VALUES (7, 6, 3, N'ofiziant1', N'aa75fb6f797211ace425c08abd1ded7581DCFD81', N'19.03.2022', 1)
INSERT [dbo].[Worker] ([ID_Worker], [Employee_ID], [Post_ID], [Login], [Password], [Date_Employment], [Branch_ID]) VALUES (32, 29, 2, N'admin2', N'c84258e9c39059a89ab77d846ddab909', N'26.04.2022', 1)
INSERT [dbo].[Worker] ([ID_Worker], [Employee_ID], [Post_ID], [Login], [Password], [Date_Employment], [Branch_ID]) VALUES (36, 32, 2, N'qwerty1234', N'58b4e38f66bcdb546380845d6af27187', N'06.05.2022', 2)
INSERT [dbo].[Worker] ([ID_Worker], [Employee_ID], [Post_ID], [Login], [Password], [Date_Employment], [Branch_ID]) VALUES (37, 33, 2, N'qwertyuu', N'a947c1d31e9e9626b2a88d8b21618850', N'06.05.2022', 2)
INSERT [dbo].[Worker] ([ID_Worker], [Employee_ID], [Post_ID], [Login], [Password], [Date_Employment], [Branch_ID]) VALUES (38, NULL, 3, N'mexanicAttem', N'f5fe3f7d032824d7ac6dc16bbe6dd6f1', N'10.05.2022', 1)
SET IDENTITY_INSERT [dbo].[Worker] OFF
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__Componen__C037E41F01F9DF7B]    Script Date: 11.05.2022 9:03:35 ******/
ALTER TABLE [dbo].[Component] ADD UNIQUE NONCLUSTERED 
(
	[Name_Component] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__List_Ser__A1E9313B08C92B6F]    Script Date: 11.05.2022 9:03:35 ******/
ALTER TABLE [dbo].[List_Services] ADD UNIQUE NONCLUSTERED 
(
	[Name_Services] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__List_Sta__884170A7C679B785]    Script Date: 11.05.2022 9:03:35 ******/
ALTER TABLE [dbo].[List_Status] ADD  CONSTRAINT [UQ__List_Sta__884170A7C679B785] UNIQUE NONCLUSTERED 
(
	[Name_Status] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__Post__CE85D8F67DD58492]    Script Date: 11.05.2022 9:03:35 ******/
ALTER TABLE [dbo].[Post] ADD UNIQUE NONCLUSTERED 
(
	[Name_Post] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__Service___CEAAA1CAFCE89491]    Script Date: 11.05.2022 9:03:35 ******/
ALTER TABLE [dbo].[Service_Group] ADD UNIQUE NONCLUSTERED 
(
	[Name_Group_Service] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__Worker__5E55825B053841CC]    Script Date: 11.05.2022 9:03:35 ******/
ALTER TABLE [dbo].[Worker] ADD UNIQUE NONCLUSTERED 
(
	[Login] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Order] ADD  CONSTRAINT [DF__Order__Date_Rece__36470DEF]  DEFAULT (CONVERT([nvarchar](max),format(dateadd(hour,(3),getdate()),'dd.MM.yyyy'))) FOR [Date_Receipt]
GO
ALTER TABLE [dbo].[Worker] ADD  DEFAULT (CONVERT([nvarchar](max),format(getdate(),'dd.MM.yyyy'))) FOR [Date_Employment]
GO
ALTER TABLE [dbo].[Application]  WITH CHECK ADD  CONSTRAINT [FK_BrahchID_Application] FOREIGN KEY([Branch_ID])
REFERENCES [dbo].[Branch] ([ID_Branch])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Application] CHECK CONSTRAINT [FK_BrahchID_Application]
GO
ALTER TABLE [dbo].[Application]  WITH CHECK ADD  CONSTRAINT [FK_ComponentID_Application] FOREIGN KEY([Component_ID])
REFERENCES [dbo].[Component] ([ID_Component])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Application] CHECK CONSTRAINT [FK_ComponentID_Application]
GO
ALTER TABLE [dbo].[Application]  WITH CHECK ADD  CONSTRAINT [FK_Worker_Application] FOREIGN KEY([Worker_ID])
REFERENCES [dbo].[Worker] ([ID_Worker])
ON DELETE SET NULL
GO
ALTER TABLE [dbo].[Application] CHECK CONSTRAINT [FK_Worker_Application]
GO
ALTER TABLE [dbo].[Brand_Model_Compliance]  WITH CHECK ADD  CONSTRAINT [FK_CarBrand_BrandModelCompliance] FOREIGN KEY([Car_Brand_ID])
REFERENCES [dbo].[Car_Brand] ([ID_Car_Brand])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Brand_Model_Compliance] CHECK CONSTRAINT [FK_CarBrand_BrandModelCompliance]
GO
ALTER TABLE [dbo].[Brand_Model_Compliance]  WITH CHECK ADD  CONSTRAINT [FK_CarModel_BrandModelCompliance] FOREIGN KEY([Car_Model_ID])
REFERENCES [dbo].[Car_Model] ([ID_Car_Model])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Brand_Model_Compliance] CHECK CONSTRAINT [FK_CarModel_BrandModelCompliance]
GO
ALTER TABLE [dbo].[Car_Services_Provided]  WITH CHECK ADD  CONSTRAINT [FK_ListServices_CarServicesProvided] FOREIGN KEY([List_Services_ID])
REFERENCES [dbo].[List_Services] ([ID_List_Services])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Car_Services_Provided] CHECK CONSTRAINT [FK_ListServices_CarServicesProvided]
GO
ALTER TABLE [dbo].[Car_Services_Provided]  WITH CHECK ADD  CONSTRAINT [FK_Order_CarServicesProvided] FOREIGN KEY([Order_ID])
REFERENCES [dbo].[Order] ([ID_Order])
ON DELETE SET NULL
GO
ALTER TABLE [dbo].[Car_Services_Provided] CHECK CONSTRAINT [FK_Order_CarServicesProvided]
GO
ALTER TABLE [dbo].[Car_Services_Provided]  WITH CHECK ADD  CONSTRAINT [FK_Worker_CarServicesProvided] FOREIGN KEY([Worker_ID])
REFERENCES [dbo].[Worker] ([ID_Worker])
ON DELETE SET NULL
GO
ALTER TABLE [dbo].[Car_Services_Provided] CHECK CONSTRAINT [FK_Worker_CarServicesProvided]
GO
ALTER TABLE [dbo].[Component_Order]  WITH CHECK ADD  CONSTRAINT [FK_Component_ComponentOrder] FOREIGN KEY([Component_ID])
REFERENCES [dbo].[Component] ([ID_Component])
GO
ALTER TABLE [dbo].[Component_Order] CHECK CONSTRAINT [FK_Component_ComponentOrder]
GO
ALTER TABLE [dbo].[Component_Order]  WITH CHECK ADD  CONSTRAINT [FK_Order_ComponentOrder] FOREIGN KEY([Order_ID])
REFERENCES [dbo].[Order] ([ID_Order])
ON DELETE SET NULL
GO
ALTER TABLE [dbo].[Component_Order] CHECK CONSTRAINT [FK_Order_ComponentOrder]
GO
ALTER TABLE [dbo].[Component_Order]  WITH CHECK ADD  CONSTRAINT [FK_Worker_ComponentOrder] FOREIGN KEY([Worker_ID])
REFERENCES [dbo].[Worker] ([ID_Worker])
ON DELETE SET NULL
GO
ALTER TABLE [dbo].[Component_Order] CHECK CONSTRAINT [FK_Worker_ComponentOrder]
GO
ALTER TABLE [dbo].[Customers_Machines]  WITH CHECK ADD  CONSTRAINT [FK_BrandModelCompliance_CustomersMachines] FOREIGN KEY([Brand_Model_Compliance_ID])
REFERENCES [dbo].[Brand_Model_Compliance] ([ID_Brand_Model_Compliance])
ON DELETE SET NULL
GO
ALTER TABLE [dbo].[Customers_Machines] CHECK CONSTRAINT [FK_BrandModelCompliance_CustomersMachines]
GO
ALTER TABLE [dbo].[Customers_Machines]  WITH CHECK ADD  CONSTRAINT [FK_Client_CustomersMachines] FOREIGN KEY([Client_ID])
REFERENCES [dbo].[Client] ([ID_Client])
ON DELETE SET NULL
GO
ALTER TABLE [dbo].[Customers_Machines] CHECK CONSTRAINT [FK_Client_CustomersMachines]
GO
ALTER TABLE [dbo].[List_Services]  WITH CHECK ADD  CONSTRAINT [FK_ServiceGroup_ListServices] FOREIGN KEY([Service_Group_ID])
REFERENCES [dbo].[Service_Group] ([ID_Service_Group])
GO
ALTER TABLE [dbo].[List_Services] CHECK CONSTRAINT [FK_ServiceGroup_ListServices]
GO
ALTER TABLE [dbo].[Order]  WITH CHECK ADD  CONSTRAINT [FK_Branch_Order] FOREIGN KEY([Branch_ID])
REFERENCES [dbo].[Branch] ([ID_Branch])
GO
ALTER TABLE [dbo].[Order] CHECK CONSTRAINT [FK_Branch_Order]
GO
ALTER TABLE [dbo].[Order]  WITH CHECK ADD  CONSTRAINT [FK_CustomersMachines_Order] FOREIGN KEY([VIN])
REFERENCES [dbo].[Customers_Machines] ([VIN])
ON UPDATE CASCADE
ON DELETE SET NULL
GO
ALTER TABLE [dbo].[Order] CHECK CONSTRAINT [FK_CustomersMachines_Order]
GO
ALTER TABLE [dbo].[Order]  WITH CHECK ADD  CONSTRAINT [FK_ListStatus_Order] FOREIGN KEY([List_Status_ID])
REFERENCES [dbo].[List_Status] ([ID_List_Status])
GO
ALTER TABLE [dbo].[Order] CHECK CONSTRAINT [FK_ListStatus_Order]
GO
ALTER TABLE [dbo].[Order]  WITH CHECK ADD  CONSTRAINT [FK_Worker_Order] FOREIGN KEY([Worker_ID])
REFERENCES [dbo].[Worker] ([ID_Worker])
ON DELETE SET NULL
GO
ALTER TABLE [dbo].[Order] CHECK CONSTRAINT [FK_Worker_Order]
GO
ALTER TABLE [dbo].[Order_Log]  WITH CHECK ADD  CONSTRAINT [FK_ApplicationID_OrderLog] FOREIGN KEY([Application_ID])
REFERENCES [dbo].[Application] ([ID_Application])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Order_Log] CHECK CONSTRAINT [FK_ApplicationID_OrderLog]
GO
ALTER TABLE [dbo].[Order_Log]  WITH CHECK ADD  CONSTRAINT [FK_ComponentOrderID_OrderLog] FOREIGN KEY([Component_Order_ID])
REFERENCES [dbo].[Component_Order] ([ID_Component_Order])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Order_Log] CHECK CONSTRAINT [FK_ComponentOrderID_OrderLog]
GO
ALTER TABLE [dbo].[Order_Log]  WITH CHECK ADD  CONSTRAINT [FK_ListStatus_OrderLog] FOREIGN KEY([List_Status_ID])
REFERENCES [dbo].[List_Status] ([ID_List_Status])
GO
ALTER TABLE [dbo].[Order_Log] CHECK CONSTRAINT [FK_ListStatus_OrderLog]
GO
ALTER TABLE [dbo].[Warehouse]  WITH CHECK ADD  CONSTRAINT [FK_Branch_Warehouse] FOREIGN KEY([Branch_ID])
REFERENCES [dbo].[Branch] ([ID_Branch])
GO
ALTER TABLE [dbo].[Warehouse] CHECK CONSTRAINT [FK_Branch_Warehouse]
GO
ALTER TABLE [dbo].[Warehouse]  WITH CHECK ADD  CONSTRAINT [FK_Component_Warehouse] FOREIGN KEY([Component_ID])
REFERENCES [dbo].[Component] ([ID_Component])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Warehouse] CHECK CONSTRAINT [FK_Component_Warehouse]
GO
ALTER TABLE [dbo].[Worker]  WITH CHECK ADD  CONSTRAINT [FK_Branch_Worker] FOREIGN KEY([Branch_ID])
REFERENCES [dbo].[Branch] ([ID_Branch])
GO
ALTER TABLE [dbo].[Worker] CHECK CONSTRAINT [FK_Branch_Worker]
GO
ALTER TABLE [dbo].[Worker]  WITH CHECK ADD  CONSTRAINT [FK_Employee_Worker] FOREIGN KEY([Employee_ID])
REFERENCES [dbo].[Employee] ([ID_Employee])
ON DELETE SET NULL
GO
ALTER TABLE [dbo].[Worker] CHECK CONSTRAINT [FK_Employee_Worker]
GO
ALTER TABLE [dbo].[Worker]  WITH CHECK ADD  CONSTRAINT [FK_Post_Worker] FOREIGN KEY([Post_ID])
REFERENCES [dbo].[Post] ([ID_Post])
GO
ALTER TABLE [dbo].[Worker] CHECK CONSTRAINT [FK_Post_Worker]
GO
ALTER TABLE [dbo].[Worker]  WITH CHECK ADD CHECK  ((len([Login])>=(6)))
GO
ALTER TABLE [dbo].[Worker]  WITH CHECK ADD CHECK  ((len([Password])>=(6)))
GO
/****** Object:  StoredProcedure [dbo].[Analiz_RosterWorkService]    Script Date: 11.05.2022 9:03:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create   procedure [dbo].[Analiz_RosterWorkService] --Все сервисы котрые исполнил сотрудник
@startDate [nvarchar] (20),
@endDate [nvarchar] (20),
@idWorker [nvarchar] (max)
as
	select top(100)
		listServ.[Name_Services] as 'Наименование услуг',
		count(listServ.[Name_Services]) as 'Количество выполненных услуг',
		carServOrd.[Worker_ID] as 'Номер работника'
		from [dbo].[Car_Services_Provided] carServOrd
		inner join [dbo].[List_Services] listServ on [List_Services_ID]=[ID_List_Services]
		where carServOrd.[Worker_ID] 
		IN (
			select value from STRING_SPLIT(@idWorker, ';')
		)  
		and carServOrd.[End_Date] != ''
		and (cast(carServOrd.[Start_Date] as datetime) BETWEEN @startDate and @endDate) 
		and (cast(carServOrd.[End_Date] as datetime) BETWEEN @startDate and @endDate)
		GROUP BY listServ.[Name_Services],carServOrd.[Worker_ID]
GO
/****** Object:  StoredProcedure [dbo].[Analiz_Worker]    Script Date: 11.05.2022 9:03:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create   procedure [dbo].[Analiz_Worker] -- Анализ по работнику
@startDate [nvarchar] (20),
@endDate [nvarchar] (20),
@idWorker [nvarchar] (max)
as
	DECLARE @TableWorker TABLE (idWorker int)
	DECLARE @TableTime TABLE (idWorker int,Time_Worker int)
	DECLARE @TableCompletedOrder TABLE (idWorker int,Count_Completed_Order int)
	DECLARE @TableCountComponent TABLE (idWorker int,Sum_Count_Component int)
	DECLARE @TableCountService TABLE (idWorker int,Sum_Count_Service int)

	INSERT INTO @TableWorker
	select 
		worker.[ID_Worker] as 'Номер работника'
		from [dbo].[Worker] worker
		where worker.[ID_Worker] IN (select value from STRING_SPLIT(@idWorker, ';'))
		GROUP BY  worker.[ID_Worker]

	INSERT INTO @TableTime
	select 
		worker.[ID_Worker] as 'Номер работника',
	    SUM(ls.[Norm_Hour]) as 'Отработанное время в часах'
		from [dbo].[Worker] worker
		inner join [dbo].[Car_Services_Provided] carServOrd on [Worker_ID]=[ID_Worker]
		inner join [dbo].[List_Services] ls on carServOrd.[List_Services_ID] = ls.[ID_List_Services]
		where carServOrd.[Worker_ID] IN (select value from STRING_SPLIT(@idWorker, ';'))
		and carServOrd.[End_Date] != ''
		and (cast(carServOrd.[Start_Date] as datetime) BETWEEN @startDate and @endDate) 
		and (cast(carServOrd.[End_Date] as datetime) BETWEEN @startDate and @endDate)
		GROUP BY  worker.[ID_Worker],carServOrd.[Worker_ID]

	INSERT INTO @TableCompletedOrder
	select 
		worker.[ID_Worker] as 'Номер работника',
		COUNT(DISTINCT carServOrd.[Order_ID]) as 'Количество выполненых заказ нарядов'
		from [dbo].[Worker] worker
		inner join [dbo].[Car_Services_Provided] carServOrd on carServOrd.[Worker_ID]=[ID_Worker]
		where carServOrd.[Worker_ID] IN (select value from STRING_SPLIT(@idWorker, ';'))  
		and (cast(carServOrd.[Start_Date] as datetime) BETWEEN @startDate and @endDate) 
		and (cast(carServOrd.[End_Date] as datetime) BETWEEN @startDate and @endDate)
		GROUP BY worker.[ID_Worker]

	INSERT INTO @TableCountComponent
	select 
		worker.[ID_Worker] as 'Номер работника',
		SUM(compOrder.Quantity_Component) as 'Количество назначенных компонентов'
		from [Worker] worker
		inner join [dbo].[Component_Order] compOrder on compOrder.[Worker_ID] = worker.[ID_Worker]
		where compOrder.[Worker_ID] IN (select value from STRING_SPLIT(@idWorker, ';')) 
		and (cast(compOrder.[Date_Enrollment] as datetime) BETWEEN @startDate and @endDate)
		GROUP BY compOrder.[Worker_ID],worker.[ID_Worker]

	INSERT INTO @TableCountService
	select 
		 worker.[ID_Worker] as 'Номер работника',
		 COUNT(carServOrd.Worker_ID) as 'Количество выполненных услуг'
		 from [dbo].[Worker] worker
		 inner join [dbo].[Car_Services_Provided] carServOrd on carServOrd.[Worker_ID]=[ID_Worker]
		 where carServOrd.[Worker_ID] IN (select value from STRING_SPLIT(@idWorker, ';'))  
		 and (cast(carServOrd.[Start_Date] as datetime) BETWEEN @startDate and @endDate) 
		 and (cast(carServOrd.[End_Date] as datetime) BETWEEN @startDate and @endDate)
		 GROUP BY carServOrd.[Worker_ID],worker.[ID_Worker]

	select
	 tw.[idWorker] as 'Номер работника',
	 ISNULL(tco.Count_Completed_Order,0) as 'Количество отработанных заказ нарядов',
	 ISNULL(tt.Time_Worker,0) as 'Отработанное время в часах',
	 ISNULL(tcc.Sum_Count_Component,0) as 'Количество использованных компонентов',
	 ISNULL(tcs.Sum_Count_Service,0) as 'Количество исполненых услуг'
	 from @TableWorker tw
	 full join @TableCompletedOrder tco on tw.idWorker = tco.idWorker
	 full join @TableCountComponent tcc on tw.idWorker=tcc.idWorker 
	 full join @TableCountService tcs on tw.idWorker=tcs.idWorker 
	 full join @TableTime tt on tw.idWorker=tt.idWorker 
GO
/****** Object:  StoredProcedure [dbo].[Application_delete]    Script Date: 11.05.2022 9:03:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   procedure [dbo].[Application_delete] -- Добавление в список заказов
@ID_Application [int]
as
	delete from [Application]
	where ID_Application = @ID_Application
GO
/****** Object:  StoredProcedure [dbo].[Application_insert]    Script Date: 11.05.2022 9:03:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   procedure [dbo].[Application_insert] -- Добавление в список заказов
@Component_ID [int],
@Branch_ID [int],
@Worker_ID [int],
@Date_Creation [nvarchar] (20),
@Quantity_Component [float]
as
	declare @idApplication [int]
	
	insert into [dbo].[Application] ([Component_ID],[Branch_ID],[Worker_ID],[Date_Creation])
	values (@Component_ID,@Branch_ID,@Worker_ID,@Date_Creation)

	SET @idApplication = (select SCOPE_IDENTITY())

	insert into [dbo].[Order_Log] ([Quantity_Component],[Application_ID],[Price],[List_Status_ID])
	values (@Quantity_Component,@idApplication,0,1)
GO
/****** Object:  StoredProcedure [dbo].[Branch_insert]    Script Date: 11.05.2022 9:03:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[Branch_insert] -- Добавление Адресса
@Address [nvarchar](150)
as
	insert into [dbo].[Branch] ([Address])
	values (@Address)

GO
/****** Object:  StoredProcedure [dbo].[BrandModelCompliance_insert]    Script Date: 11.05.2022 9:03:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--Хранимые процедуры
create procedure [dbo].[BrandModelCompliance_insert] -- Добавление новой машины
@Car_Brand_ID [int],
@Car_Model_ID [int]
as
	insert into [dbo].[Brand_Model_Compliance] ([Car_Brand_ID],[Car_Model_ID])
	values (@Car_Brand_ID,@Car_Model_ID)

	select
	[ID_Brand_Model_Compliance] as 'ID_Brand_Model_Compliance'
	from [dbo].[Brand_Model_Compliance]
	where [Car_Brand_ID] = @Car_Brand_ID and [Car_Model_ID] = @Car_Model_ID

GO
/****** Object:  StoredProcedure [dbo].[BrandModelCompliance_update]    Script Date: 11.05.2022 9:03:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[BrandModelCompliance_update] -- Обновление машины
@ID_Brand_Model_Compliance [int],
@Car_Brand_ID [int],
@Car_Model_ID [int]
as
	update [dbo].[Brand_Model_Compliance] set
	Car_Brand_ID = @Car_Brand_ID,
	Car_Model_ID = @Car_Model_ID
	where ID_Brand_Model_Compliance = @ID_Brand_Model_Compliance

GO
/****** Object:  StoredProcedure [dbo].[Car_Brand_insert]    Script Date: 11.05.2022 9:03:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[Car_Brand_insert] -- Добавление новой марки машины
@Name_Car_Brand [nvarchar] (30)
as
	insert into [dbo].[Car_Brand] ([Name_Car_Brand])
	values (@Name_Car_Brand)

	select
	[ID_Car_Brand] as 'ID_Car_Brand'
	from [dbo].[Car_Brand]
	where [Name_Car_Brand] = @Name_Car_Brand

GO
/****** Object:  StoredProcedure [dbo].[Car_Brand_update]    Script Date: 11.05.2022 9:03:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[Car_Brand_update] -- Обновление марки машины
@ID_Car_Brand [int],
@Name_Car_Brand [nvarchar] (30)
as
	update [dbo].[Car_Brand] set
	Name_Car_Brand = @Name_Car_Brand
	where ID_Car_Brand = @ID_Car_Brand

GO
/****** Object:  StoredProcedure [dbo].[Car_Model_insert]    Script Date: 11.05.2022 9:03:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[Car_Model_insert] -- Добавление новой модели машины
@Name_Car_Model [nvarchar] (30)
as
	insert into [dbo].[Car_Model] ([Name_Car_Model])
	values (@Name_Car_Model)

	select
	[ID_Car_Model] as 'ID_Car_Model'
	from [dbo].[Car_Model]
	where [Name_Car_Model] = @Name_Car_Model

GO
/****** Object:  StoredProcedure [dbo].[Car_Model_update]    Script Date: 11.05.2022 9:03:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[Car_Model_update] -- Обновление модели машины
@ID_Car_Model [int],
@Name_Car_Model [nvarchar] (30)
as
	update [dbo].[Car_Model] set
	Name_Car_Model = @Name_Car_Model
	where ID_Car_Model = @ID_Car_Model

GO
/****** Object:  StoredProcedure [dbo].[Car_Services_Provided_delete]    Script Date: 11.05.2022 9:03:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[Car_Services_Provided_delete] -- Удаление элемента из заказ наряда
@ID_Car_Services_Provided [int]
as
	delete from [dbo].[Car_Services_Provided]
	where ID_Car_Services_Provided=@ID_Car_Services_Provided

GO
/****** Object:  StoredProcedure [dbo].[Car_Services_Provided_End_Time_update]    Script Date: 11.05.2022 9:03:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[Car_Services_Provided_End_Time_update] -- Изменение заказ наряда
@ID_Car_Services_Provided [int],
@End_Date [nvarchar] (20),
@Worker_ID [int],
@Order_ID [int]
as
	update [dbo].[Car_Services_Provided] set
	End_Date = @End_Date,
	Worker_ID = @Worker_ID
	where ID_Car_Services_Provided = @ID_Car_Services_Provided

	select * from [dbo].[Car_Services_Provided]
	where [Order_ID] = @Order_ID and [ID_Car_Services_Provided] = @ID_Car_Services_Provided

GO
/****** Object:  StoredProcedure [dbo].[Car_Services_Provided_insert]    Script Date: 11.05.2022 9:03:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   procedure [dbo].[Car_Services_Provided_insert]--Добавление услуги в заказ наряд
@List_Services_ID [int],
@Order_ID [int],
@Worker_ID [int]
as
	insert into [dbo].[Car_Services_Provided] ([List_Services_ID],[Order_ID],[Worker_ID])
	values (@List_Services_ID,@Order_ID,@Worker_ID)

	select SCOPE_IDENTITY() as 'ID_Car_Services_Provided' from [dbo].[Car_Services_Provided]
	where Order_ID = @Order_ID
GO
/****** Object:  StoredProcedure [dbo].[Car_Services_Provided_Start_Time_update]    Script Date: 11.05.2022 9:03:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[Car_Services_Provided_Start_Time_update] -- Изменение заказ наряда времени начала
@ID_Car_Services_Provided [int],
@Start_Date [nvarchar] (20) ,
@Order_ID [int],
@Worker_ID [int]
as
	update [dbo].[Car_Services_Provided] set
	Start_Date = @Start_Date,
	Worker_ID = @Worker_ID
	where ID_Car_Services_Provided = @ID_Car_Services_Provided

	select * from [dbo].[Car_Services_Provided]
	where [Order_ID] = @Order_ID and [ID_Car_Services_Provided] = @ID_Car_Services_Provided

GO
/****** Object:  StoredProcedure [dbo].[Client_insert]    Script Date: 11.05.2022 9:03:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[Client_insert] -- Добавление клиента
@Surname [nvarchar] (50),
@Name [nvarchar] (50),
@Middle_Name [nvarchar] (50),
@Phone [nvarchar] (20),
@Date_Birth [date]
as
	insert into [dbo].[Client] ([Surname],[Name],[Middle_Name],[Phone],[Date_Birth])
	values (@Surname,@Name,@Middle_Name,@Phone,@Date_Birth)

GO
/****** Object:  StoredProcedure [dbo].[Client_update]    Script Date: 11.05.2022 9:03:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[Client_update]--Обновление клиента
@ID_Client [int],
@Surname [nvarchar] (50),
@Name [nvarchar] (50),
@Middle_Name [nvarchar] (50),
@Phone [nvarchar] (20),
@Date_Birth [date]
as
	update [dbo].[Client] set
	Surname = @Surname,
	Name = @Name,
	Middle_Name = @Middle_Name,
	Phone = @Phone,
	Date_Birth = @Date_Birth
	where ID_Client = @ID_Client

GO
/****** Object:  StoredProcedure [dbo].[Component_insert]    Script Date: 11.05.2022 9:03:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--Хранимые процедуры
create   procedure [dbo].[Component_insert] -- Добавление компонента
@Name_Component [nvarchar] (50),
@Minimum_Quantity [float],
@Type_Сonsumable [bit]
as
	insert into [dbo].[Component] ([Name_Component],[Minimum_Quantity],[Type_Сonsumable])
	values (@Name_Component, @Minimum_Quantity, @Type_Сonsumable)

	select
	[ID_Component] as 'ID_Component'
	from [dbo].[Component]
	where [Name_Component] = @Name_Component
GO
/****** Object:  StoredProcedure [dbo].[Component_Order_delete]    Script Date: 11.05.2022 9:03:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   procedure [dbo].[Component_Order_delete] -- Удаление компонента из скиска с компонентами за заказ
@ID_Component_Order [int]
as
	delete from [dbo].[Component_Order]
	where ID_Component_Order=@ID_Component_Order
GO
/****** Object:  StoredProcedure [dbo].[Component_Order_delete_OrdreLog]    Script Date: 11.05.2022 9:03:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   procedure [dbo].[Component_Order_delete_OrdreLog] -- Удаление компонента из спика с заказаныыми компонентами
@ID_Component_Order [int],
@List_Status_ID_OrderLog [int],
@List_Status_ID_Order [int]
as
	DECLARE @idOrder [int], @countWin [int]
	SET @idOrder = (select [Order_ID] from [Component_Order] co where co.[ID_Component_Order] = @ID_Component_Order)

	delete from [dbo].[Component_Order]
	where ID_Component_Order=@ID_Component_Order

	SET @countWin = (
		select count(ol.[ID_Order_Log]) from [dbo].[Order_Log] ol
		inner join [dbo].[Component_Order] co on ol.[Component_Order_ID] = co.[ID_Component_Order]
		inner join [dbo].[Component] component on co.[Component_ID] = component.[ID_Component]
		where co.[Order_ID] = @idOrder and ol.[List_Status_ID] != @List_Status_ID_OrderLog and component.[Type_Сonsumable] = 0
	)

	IF @countWin = 0
	begin
		update [dbo].[Order] set
		List_Status_ID = @List_Status_ID_Order
		where ID_Order = @idOrder
	end;
GO
/****** Object:  StoredProcedure [dbo].[Component_Order_insert]    Script Date: 11.05.2022 9:03:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   procedure [dbo].[Component_Order_insert]--Добавление компонентов за заказ
@Component_ID [int],
@Quantity_Component [float],
@Order_ID [int],
@Worker_ID [int],
@Date_Enrollment [date],
@Price [decimal] (38,2)
as
	insert into [dbo].[Component_Order] ([Component_ID],[Quantity_Component],[Order_ID],[Worker_ID],[Date_Enrollment],[Price])
	values (@Component_ID,@Quantity_Component,@Order_ID,@Worker_ID,@Date_Enrollment,@Price)

	select SCOPE_IDENTITY() as 'ID_Component_Order' from [dbo].[Component_Order]
	where Order_ID = @Order_ID
GO
/****** Object:  StoredProcedure [dbo].[Component_Order_update]    Script Date: 11.05.2022 9:03:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[Component_Order_update] -- Изменение заказ наряда времени начала
@ID_Component_Order [int],
@Quantity_Component [float],
@Worker_ID [int],
@Date_Enrollment [date]
as
	update [dbo].[Component_Order] set
	Quantity_Component = @Quantity_Component,
	Worker_ID=@Worker_ID,
	Date_Enrollment=@Date_Enrollment
	where ID_Component_Order = @ID_Component_Order

GO
/****** Object:  StoredProcedure [dbo].[Component_Order_update_Price]    Script Date: 11.05.2022 9:03:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   procedure [dbo].[Component_Order_update_Price] -- Изменение цену за компонент в списке уомпонентов по заказ наряду
@ID_Component_Order [int],
@Price [decimal] (38,2)
as
	update [dbo].[Component_Order] set
	Price=@Price
	where ID_Component_Order = @ID_Component_Order
GO
/****** Object:  StoredProcedure [dbo].[Component_update]    Script Date: 11.05.2022 9:03:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create   procedure [dbo].[Component_update] -- Обновление компонента
@ID_Component [int],
@Name_Component [nvarchar] (50),
@Minimum_Quantity [float],
@Type_Сonsumable [bit]
as
	update [dbo].[Component] set
	Name_Component = @Name_Component,
    Minimum_Quantity = @Minimum_Quantity,
	Type_Сonsumable = @Type_Сonsumable
	where ID_Component = @ID_Component
GO
/****** Object:  StoredProcedure [dbo].[ComponentNoTypeConsumabl_insert]    Script Date: 11.05.2022 9:03:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create   procedure [dbo].[ComponentNoTypeConsumabl_insert] -- Добавление компонента
@Name_Component [nvarchar] (50),
@Type_Сonsumable [bit]
as
	insert into [dbo].[Component] ([Name_Component],[Type_Сonsumable])
	values (@Name_Component, @Type_Сonsumable)

	select
	[ID_Component] as 'ID_Component'
	from [dbo].[Component]
	where [Name_Component] = @Name_Component
GO
/****** Object:  StoredProcedure [dbo].[ComponentNoTypeConsumable_update]    Script Date: 11.05.2022 9:03:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create   procedure [dbo].[ComponentNoTypeConsumable_update] -- Обновление компонента
@ID_Component [int],
@Name_Component [nvarchar] (50),
@Type_Сonsumable [bit]
as
	update [dbo].[Component] set
	Name_Component = @Name_Component,
	Minimum_Quantity = NULL,
	Type_Сonsumable = @Type_Сonsumable
	where ID_Component = @ID_Component
GO
/****** Object:  StoredProcedure [dbo].[ComponentOrder_update_Price]    Script Date: 11.05.2022 9:03:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[ComponentOrder_update_Price] -- Изменение цену за компонент в списке уомпонентов по заказ наряду
@ID_Component_Order [int],
@Price [decimal] (38,2)
as
	update [dbo].[Component_Order] set
	Price=@Price
	where ID_Component_Order = @ID_Component_Order
GO
/****** Object:  StoredProcedure [dbo].[Customers_Machines_insert]    Script Date: 11.05.2022 9:03:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[Customers_Machines_insert]--Добавление машины
@VIN [nvarchar] (17),
@Registration_Mark [nvarchar] (9),
@Year_Release [nvarchar] (4),
@Mileage [int],
@Brand_Model_Compliance_ID [int],
@Client_ID [int]
as
	insert into [dbo].[Customers_Machines] ([VIN],[Registration_Mark], [Year_Release], [Mileage],[Brand_Model_Compliance_ID],[Client_ID])
	values (@VIN,@Registration_Mark,@Year_Release,@Mileage,@Brand_Model_Compliance_ID,@Client_ID)

GO
/****** Object:  StoredProcedure [dbo].[Customers_Machines_update]    Script Date: 11.05.2022 9:03:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[Customers_Machines_update]--Обновление машины
@VIN [nvarchar] (17),
@Registration_Mark [nvarchar] (9),
@Year_Release [nvarchar] (4),
@Mileage [int],
@Brand_Model_Compliance_ID [int],
@Client_ID [int]
as
	update [dbo].[Customers_Machines] set
	Registration_Mark = @Registration_Mark,
	Year_Release = @Year_Release,
	Mileage = @Mileage,
	Brand_Model_Compliance_ID = @Brand_Model_Compliance_ID,
	Client_ID = @Client_ID
	where VIN = @VIN

GO
/****** Object:  StoredProcedure [dbo].[Customers_Machines_update_VIN]    Script Date: 11.05.2022 9:03:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[Customers_Machines_update_VIN]--Обновление машины
@VIN [nvarchar] (17),
@VIN_New [nvarchar] (17),
@Registration_Mark [nvarchar] (9),
@Year_Release [nvarchar] (4),
@Mileage [int],
@Brand_Model_Compliance_ID [int],
@Client_ID [int]
as
	update [dbo].[Customers_Machines] set
	VIN = @VIN_New,
	Registration_Mark = @Registration_Mark,
	Year_Release = @Year_Release,
	Mileage = @Mileage,
	Brand_Model_Compliance_ID = @Brand_Model_Compliance_ID,
	Client_ID = @Client_ID
	where VIN = @VIN
GO
/****** Object:  StoredProcedure [dbo].[Employee_delete]    Script Date: 11.05.2022 9:03:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[Employee_delete]--Удаление сотрудника
@ID_Employee [int]
as
	delete from [dbo].[Employee]
	where ID_Employee=@ID_Employee

GO
/****** Object:  StoredProcedure [dbo].[Employee_insert]    Script Date: 11.05.2022 9:03:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create   procedure [dbo].[Employee_insert]-- Добавление сотрудника
@Surname [nvarchar] (50),
@Name_Employee [nvarchar] (50),
@Patronymic [nvarchar] (50)
as
	insert into [dbo].[Employee] ([Surname],[Name_Employee],[Patronymic])
	values (@Surname,@Name_Employee,@Patronymic)
GO
/****** Object:  StoredProcedure [dbo].[Employee_update]    Script Date: 11.05.2022 9:03:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create   procedure [dbo].[Employee_update]-- Обновление сотрудника
@ID_Employee [int],
@Surname [nvarchar] (50),
@Name_Employee [nvarchar] (50),
@Patronymic [nvarchar] (50)
as
	update [dbo].[Employee] set
	Surname= @Surname,
	Name_Employee = @Name_Employee,
	Patronymic=@Patronymic
	where ID_Employee=@ID_Employee
GO
/****** Object:  StoredProcedure [dbo].[List_Service_insert]    Script Date: 11.05.2022 9:03:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[List_Service_insert] -- Добавление новой услуги
@Name_Services [nvarchar] (50),
@Norm_Hour [float],
@Price [decimal] (38,2),
@Service_Group_ID [int]
as
	insert into [dbo].[List_Services] ([Name_Services],[Norm_Hour],[Price],[Service_Group_ID])
	values (@Name_Services,@Norm_Hour,@Price,@Service_Group_ID)

	select
	[ID_List_Services] as 'ID_List_Services'
	from [dbo].[List_Services]
	where [Name_Services] = @Name_Services

GO
/****** Object:  StoredProcedure [dbo].[List_Service_update]    Script Date: 11.05.2022 9:03:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[List_Service_update] -- Обновление услуги
@ID_List_Services [int],
@Name_Services [nvarchar] (50),
@Norm_Hour [float],
@Price [decimal] (38,2),
@Service_Group_ID [int]
as
	update [dbo].[List_Services] set
	Name_Services = @Name_Services,
    Norm_Hour = @Norm_Hour,
	Price = @Price,
	Service_Group_ID = @Service_Group_ID
	where ID_List_Services = @ID_List_Services

GO
/****** Object:  StoredProcedure [dbo].[Order_insert]    Script Date: 11.05.2022 9:03:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[Order_insert]--Добавление заказа
@VIN [nvarchar] (17),
@Date_Receipt [nvarchar] (20),
@Branch_ID [int],
@Worker_ID [int]
as
	insert into [dbo].[Order] ([VIN],[Date_Receipt],[List_Status_ID],[Branch_ID],[Worker_ID])
	values (@VIN, @Date_Receipt,1,@Branch_ID,@Worker_ID)

GO
/****** Object:  StoredProcedure [dbo].[Order_StatusList_update]    Script Date: 11.05.2022 9:03:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create   procedure [dbo].[Order_StatusList_update] -- Изменение статуса заказа
@ID_Order [int],
@List_Status_ID [int]
as
	update [dbo].[Order] set
	List_Status_ID = @List_Status_ID
	where ID_Order = @ID_Order
GO
/****** Object:  StoredProcedure [dbo].[Order_update_Worker]    Script Date: 11.05.2022 9:03:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[Order_update_Worker]--Изменение сотрудника последнего работующего по заказу
@ID_Order [int],
@Worker_ID [int]
as
	update [dbo].[Order] set
	Worker_ID = @Worker_ID
	where ID_Order = @ID_Order
GO
/****** Object:  StoredProcedure [dbo].[OrderLog_insert_Consumables]    Script Date: 11.05.2022 9:03:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create   procedure [dbo].[OrderLog_insert_Consumables] -- Добавление компонентов в журнал заказов(расходники)
@Component_Order_ID [int],
@Quantity_Component [float]
as
	insert into [dbo].[Order_Log] ([Component_Order_ID],[Quantity_Component],[List_Status_ID],[Price])
	values (@Component_Order_ID,@Quantity_Component,1,0)
GO
/****** Object:  StoredProcedure [dbo].[OrderLog_insert_Individual]    Script Date: 11.05.2022 9:03:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create   procedure [dbo].[OrderLog_insert_Individual] -- Добавление компонентов в журнал заказов(индивидуальные)
@Component_Order_ID [int]
as
	insert into [dbo].[Order_Log] ([Component_Order_ID],[List_Status_ID],[Price])
	values (@Component_Order_ID,1,0)
GO
/****** Object:  StoredProcedure [dbo].[OrderLog_update_Consumables]    Script Date: 11.05.2022 9:03:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create   procedure [dbo].[OrderLog_update_Consumables] -- Изменение журнала заказа
@ID_Order_Log [int],
@Quantity_Warehouse [float],
@Price [decimal] (38,2),
@List_Status_ID [int]
as
	update [dbo].[Order_Log] set
	Quantity_Component = @Quantity_Warehouse,
	Price = @Price,
	List_Status_ID = @List_Status_ID
	where ID_Order_Log = @ID_Order_Log
GO
/****** Object:  StoredProcedure [dbo].[OrderLog_update_Individual]    Script Date: 11.05.2022 9:03:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create   procedure [dbo].[OrderLog_update_Individual] -- Изменение журнала заказа
@ID_Order_Log [int],
@Price [decimal] (38,2),
@List_Status_ID [int]
as
	update [dbo].[Order_Log] set
	Price = @Price,
	List_Status_ID = @List_Status_ID
	where ID_Order_Log = @ID_Order_Log
GO
/****** Object:  StoredProcedure [dbo].[Service_Group_insert]    Script Date: 11.05.2022 9:03:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[Service_Group_insert] -- Добавление новой группы услуг
@Name_Group_Service [nvarchar] (30)
as
	insert into [dbo].[Service_Group] ([Name_Group_Service])
	values (@Name_Group_Service)

	select
	[ID_Service_Group] as 'ID_Service_Group'
	from [dbo].[Service_Group]
	where [Name_Group_Service] = @Name_Group_Service

GO
/****** Object:  StoredProcedure [dbo].[Service_Group_update]    Script Date: 11.05.2022 9:03:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[Service_Group_update] -- Обновление группы услуг
@ID_Service_Group [int],
@Name_Group_Service [nvarchar] (30)
as
	update [dbo].[Service_Group] set
	Name_Group_Service = @Name_Group_Service
	where ID_Service_Group = @ID_Service_Group

GO
/****** Object:  StoredProcedure [dbo].[sp_InstallListenerNotification_1]    Script Date: 11.05.2022 9:03:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

                        CREATE PROCEDURE [dbo].[sp_InstallListenerNotification_1]
                        AS
                        BEGIN
                            -- Service Broker configuration statement.
                            
                -- Setup Service Broker
                IF EXISTS (SELECT * FROM sys.databases 
                                    WHERE name = 'CarService' AND (is_broker_enabled = 0 OR is_trustworthy_on = 0)) 
                BEGIN

                    ALTER DATABASE [CarService2] SET SINGLE_USER WITH ROLLBACK IMMEDIATE
                    ALTER DATABASE [CarService2] SET ENABLE_BROKER; 
                    ALTER DATABASE [CarService2] SET MULTI_USER WITH ROLLBACK IMMEDIATE

                    -- FOR SQL Express
                    ALTER AUTHORIZATION ON DATABASE::[CarService2] TO [sa]
                    ALTER DATABASE [CarService2] SET TRUSTWORTHY ON;

                END

                -- Create a queue which will hold the tracked information 
                IF NOT EXISTS (SELECT * FROM sys.service_queues WHERE name = 'ListenerQueue_1')
	                CREATE QUEUE dbo.[ListenerQueue_1]
                -- Create a service on which tracked information will be sent 
                IF NOT EXISTS(SELECT * FROM sys.services WHERE name = 'ListenerService_1')
	                CREATE SERVICE [ListenerService_1] ON QUEUE dbo.[ListenerQueue_1] ([DEFAULT]) 
            

                            -- Notification Trigger check statement.
                            
                IF OBJECT_ID ('dbo.tr_Listener_1', 'TR') IS NOT NULL
                    RETURN;
            

                            -- Notification Trigger configuration statement.
                            DECLARE @triggerStatement NVARCHAR(MAX)
                            DECLARE @select NVARCHAR(MAX)
                            DECLARE @sqlInserted NVARCHAR(MAX)
                            DECLARE @sqlDeleted NVARCHAR(MAX)
                            
                            SET @triggerStatement = N'
                CREATE TRIGGER [tr_Listener_1]
                ON dbo.[Order_Log]
                AFTER INSERT, UPDATE, DELETE 
                AS

                SET NOCOUNT ON;

                --Trigger Order_Log is rising...
                IF EXISTS (SELECT * FROM sys.services WHERE name = ''ListenerService_1'')
                BEGIN
                    DECLARE @message NVARCHAR(MAX)
                    SET @message = N''<root/>''

                    IF ( EXISTS(SELECT 1))
                    BEGIN
                        DECLARE @retvalOUT NVARCHAR(MAX)

                        %inserted_select_statement%

                        IF (@retvalOUT IS NOT NULL)
                        BEGIN SET @message = N''<root>'' + @retvalOUT END                        

                        %deleted_select_statement%

                        IF (@retvalOUT IS NOT NULL)
                        BEGIN
                            IF (@message = N''<root/>'') BEGIN SET @message = N''<root>'' + @retvalOUT END
                            ELSE BEGIN SET @message = @message + @retvalOUT END
                        END 

                        IF (@message != N''<root/>'') BEGIN SET @message = @message + N''</root>'' END
                    END

                	--Beginning of dialog...
                	DECLARE @ConvHandle UNIQUEIDENTIFIER
                	--Determine the Initiator Service, Target Service and the Contract 
                	BEGIN DIALOG @ConvHandle 
                        FROM SERVICE [ListenerService_1] TO SERVICE ''ListenerService_1'' ON CONTRACT [DEFAULT] WITH ENCRYPTION=OFF, LIFETIME = 60; 
	                --Send the Message
	                SEND ON CONVERSATION @ConvHandle MESSAGE TYPE [DEFAULT] (@message);
	                --End conversation
	                END CONVERSATION @ConvHandle;
                END
            '
                            
                            SET @select = STUFF((SELECT ',' + '[' + COLUMN_NAME + ']'
						                         FROM INFORMATION_SCHEMA.COLUMNS
						                         WHERE DATA_TYPE NOT IN  ('text','ntext','image','geometry','geography') AND TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'Order_Log' AND TABLE_CATALOG = 'CarService'
						                         FOR XML PATH ('')
						                         ), 1, 1, '')
                            SET @sqlInserted = 
                                N'SET @retvalOUT = (SELECT ' + @select + N' 
                                                     FROM INSERTED 
                                                     FOR XML PATH(''row''), ROOT (''inserted''))'
                            SET @sqlDeleted = 
                                N'SET @retvalOUT = (SELECT ' + @select + N' 
                                                     FROM DELETED 
                                                     FOR XML PATH(''row''), ROOT (''deleted''))'                            
                            SET @triggerStatement = REPLACE(@triggerStatement
                                                     , '%inserted_select_statement%', @sqlInserted)
                            SET @triggerStatement = REPLACE(@triggerStatement
                                                     , '%deleted_select_statement%', @sqlDeleted)

                            EXEC sp_executesql @triggerStatement
                        END
                        
GO
/****** Object:  StoredProcedure [dbo].[sp_UninstallListenerNotification_1]    Script Date: 11.05.2022 9:03:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

                        CREATE PROCEDURE [dbo].[sp_UninstallListenerNotification_1]
                        AS
                        BEGIN
                            -- Notification Trigger drop statement.
                            
                IF OBJECT_ID ('dbo.tr_Listener_1', 'TR') IS NOT NULL
                    DROP TRIGGER dbo.[tr_Listener_1];
            

                            -- Service Broker uninstall statement.
                            
                DECLARE @serviceId INT
                SELECT @serviceId = service_id FROM sys.services 
                WHERE sys.services.name = 'ListenerService_1'

                DECLARE @ConvHandle uniqueidentifier
                DECLARE Conv CURSOR FOR
                SELECT CEP.conversation_handle FROM sys.conversation_endpoints CEP
                WHERE CEP.service_id = @serviceId AND ([state] != 'CD' OR [lifetime] > GETDATE() + 1)

                OPEN Conv;
                FETCH NEXT FROM Conv INTO @ConvHandle;
                WHILE (@@FETCH_STATUS = 0) BEGIN
    	            END CONVERSATION @ConvHandle WITH CLEANUP;
                    FETCH NEXT FROM Conv INTO @ConvHandle;
                END
                CLOSE Conv;
                DEALLOCATE Conv;

                -- Droping service and queue.
                IF (@serviceId IS NOT NULL)
                    DROP SERVICE [ListenerService_1];
                IF OBJECT_ID ('dbo.ListenerQueue_1', 'SQ') IS NOT NULL
	                DROP QUEUE dbo.[ListenerQueue_1];
            

                            IF OBJECT_ID ('dbo.sp_InstallListenerNotification_1', 'P') IS NOT NULL
                                DROP PROCEDURE dbo.sp_InstallListenerNotification_1
                            
                            DROP PROCEDURE dbo.sp_UninstallListenerNotification_1
                        END
                        
GO
/****** Object:  StoredProcedure [dbo].[Warehouse_delete]    Script Date: 11.05.2022 9:03:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create   procedure [dbo].[Warehouse_delete]--Удаление компонента со склада
@ID_Warehouse [int]
as
	delete from [dbo].[Warehouse]
	where ID_Warehouse=@ID_Warehouse
GO
/****** Object:  StoredProcedure [dbo].[Warehouse_insert]    Script Date: 11.05.2022 9:03:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   procedure [dbo].[Warehouse_insert] -- Добавление расходника на склад
@Component_ID [int],
@Quantity_Warehouse [float],
@Price [decimal] (38,2),
@Branch_ID [int]
as

	insert into [dbo].[Warehouse] ([Component_ID],[Quantity_Warehouse],[Price],[Branch_ID])
	values (@Component_ID,@Quantity_Warehouse,@Price,@Branch_ID)
GO
/****** Object:  StoredProcedure [dbo].[Warehouse_update_Price]    Script Date: 11.05.2022 9:03:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[Warehouse_update_Price] -- Обновление Цены определенного компонента на складе
@ID_Warehouse [int],
@Quantity_Warehouse [float],
@Price [decimal] (38,2)
as
	update [dbo].[Warehouse] set
	Price = @Price,
	Quantity_Warehouse = @Quantity_Warehouse
	where ID_Warehouse = @ID_Warehouse
GO
/****** Object:  StoredProcedure [dbo].[Warehouse_update_Price_Quantity]    Script Date: 11.05.2022 9:03:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[Warehouse_update_Price_Quantity] -- Обновление Цены определенного компонента на складе
@ID_Warehouse [int],
@Quantity_Warehouse [float],
@Price [decimal] (38,2)
as
	update [dbo].[Warehouse] set
	Price = @Price,
	Quantity_Warehouse = @Quantity_Warehouse
	where ID_Warehouse = @ID_Warehouse
GO
/****** Object:  StoredProcedure [dbo].[Warehouse_update_Quantity]    Script Date: 11.05.2022 9:03:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[Warehouse_update_Quantity] -- Обновление колличества определенного компонента на складе
@ID_Warehouse [int],
@Quantity_Warehouse [float]
as
	update [dbo].[Warehouse] set
	Quantity_Warehouse = @Quantity_Warehouse
	where ID_Warehouse = @ID_Warehouse
GO
/****** Object:  StoredProcedure [dbo].[Worker_delete]    Script Date: 11.05.2022 9:03:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[Worker_delete] -- Увольнение работника
@ID_Worker [int]
as
	delete from [dbo].[Worker]
	where ID_Worker=@ID_Worker

GO
/****** Object:  StoredProcedure [dbo].[Worker_insert]    Script Date: 11.05.2022 9:03:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[Worker_insert] -- Добавление работника
@Employee_ID [int],
@Post_ID [int],
@Login [nvarchar] (50),
@Password [nvarchar] (50),
@Branch_ID [int]
as
	insert into [dbo].[Worker] ([Employee_ID],[Post_ID],[Login],[Password],[Branch_ID])
	values (@Employee_ID,@Post_ID,@Login,@Password,@Branch_ID)

GO
/****** Object:  StoredProcedure [dbo].[Worker_update]    Script Date: 11.05.2022 9:03:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[Worker_update] --Обновление работника
@ID_Worker [int],
@Employee_ID [int],
@Post_ID [int],
@Login [nvarchar] (50),
@Password [nvarchar] (50),
@Branch_ID [int]
as
	update [dbo].[Worker] set
	Employee_ID=@Employee_ID,
	Post_ID=@Post_ID,
	Login=@Login,
	Password=@Password,
	Branch_ID = @Branch_ID
	where ID_Worker=@ID_Worker

GO
USE [master]
GO
ALTER DATABASE [CarService] SET  READ_WRITE 
GO
