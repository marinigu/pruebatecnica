USE [master]
GO
/****** Object:  Database [TransactionsDB]    Script Date: 21/01/2021 1:58:14 a. m. ******/
CREATE DATABASE [TransactionsDB]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'TransactionsDB', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.SQLEXPRESS\MSSQL\DATA\TransactionsDB.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'TransactionsDB_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.SQLEXPRESS\MSSQL\DATA\TransactionsDB_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [TransactionsDB] SET COMPATIBILITY_LEVEL = 140
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [TransactionsDB].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [TransactionsDB] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [TransactionsDB] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [TransactionsDB] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [TransactionsDB] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [TransactionsDB] SET ARITHABORT OFF 
GO
ALTER DATABASE [TransactionsDB] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [TransactionsDB] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [TransactionsDB] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [TransactionsDB] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [TransactionsDB] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [TransactionsDB] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [TransactionsDB] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [TransactionsDB] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [TransactionsDB] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [TransactionsDB] SET  DISABLE_BROKER 
GO
ALTER DATABASE [TransactionsDB] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [TransactionsDB] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [TransactionsDB] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [TransactionsDB] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [TransactionsDB] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [TransactionsDB] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [TransactionsDB] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [TransactionsDB] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [TransactionsDB] SET  MULTI_USER 
GO
ALTER DATABASE [TransactionsDB] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [TransactionsDB] SET DB_CHAINING OFF 
GO
ALTER DATABASE [TransactionsDB] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [TransactionsDB] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [TransactionsDB] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [TransactionsDB] SET QUERY_STORE = OFF
GO
USE [TransactionsDB]
GO
/****** Object:  Table [dbo].[account]    Script Date: 21/01/2021 1:58:15 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[account](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[idPerson] [int] NULL,
	[idTypeAccount] [int] NULL,
	[accountNumber] [nchar](10) NULL,
	[exento] [bit] NULL,
	[created] [datetime] NULL,
	[modified] [datetime] NULL,
	[bank] [varchar](50) NULL,
 CONSTRAINT [PK_account] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[accountType]    Script Date: 21/01/2021 1:58:15 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[accountType](
	[id] [int] NULL,
	[Type] [nvarchar](30) NULL,
	[description] [nvarchar](150) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[auditoria]    Script Date: 21/01/2021 1:58:15 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[auditoria](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[fechaHora] [nchar](10) NULL,
	[modulo] [nchar](10) NULL,
	[ipConsulta] [nchar](10) NULL,
	[observaciones] [nchar](10) NULL,
 CONSTRAINT [PK_auditoria] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[operation]    Script Date: 21/01/2021 1:58:15 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[operation](
	[id] [nchar](10) NULL,
	[operation] [nchar](10) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[person]    Script Date: 21/01/2021 1:58:15 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[person](
	[id] [int] NOT NULL,
	[idType] [int] NULL,
	[name] [nvarchar](50) NULL,
	[created] [datetime] NULL,
	[modified] [datetime] NULL,
 CONSTRAINT [PK_person] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[transaction]    Script Date: 21/01/2021 1:58:15 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[transaction](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[idPerson] [int] NOT NULL,
	[idOperation] [int] NOT NULL,
	[initialValue] [float] NULL,
	[finalValue] [float] NULL,
	[modified] [datetime] NULL,
	[sourceBank] [varchar](50) NULL,
	[destinationBank] [varchar](50) NULL,
	[idAccount] [int] NULL,
	[created] [datetime] NULL,
	[value] [float] NULL,
	[gmf] [float] NULL,
 CONSTRAINT [PK_transaction] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[person] ADD  CONSTRAINT [DF_person_created]  DEFAULT (getdate()) FOR [created]
GO
/****** Object:  StoredProcedure [dbo].[GENERATE_TRANSACTIONS]    Script Date: 21/01/2021 1:58:15 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Marisol Nieto
-- Create date: 20-ene-2021
-- Description:	Procedimiento que se encarga de realizar el calculo de la transacción
--  idoperation = 1 retiro
--  idoperation = 2 transferencia
--  idoperation = 3 retirox4xmil gmf
--  idoperation = 4 consignacion
-- =============================================
--EXEC GENERATE_TRANSACTIONS 123,'A',1,9600000,'B'
CREATE PROCEDURE [dbo].[GENERATE_TRANSACTIONS] 
	@idPerson int
  , @accountNumber VARCHAR (50)
  , @operation INT
  , @value FLOAT
  , @AccountNumberDestination VARCHAR (50) NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @operationDestination INT
	SET @operationDestination = 4

	DECLARE @exento BIT  
	DECLARE @idAccount INT
	DECLARE @sourceBank VARCHAR(50)
	DECLARE @idAccountDestination INT

	--Inicializo las variables de los tipos de operaciones a usar
	DECLARE @idOperationRetiro INT
	DECLARE @idOperationTransferencia INT
	DECLARE @idOperationGmf INT
	DECLARE @idOperationConsignacion INT

	SET @idOperationRetiro = 1
	SET @idOperationTransferencia = 2
	SET @idOperationGmf = 3
	SET @idOperationConsignacion = 4

	--valido si la cuenta del cliente es exenta y obtengo el id de la cuenta
	SELECT @exento = [exento], @idAccount = id, @sourceBank = bank FROM [TransactionsDB].[dbo].[account] WITH(NOLOCK) WHERE idPerson = @idPerson AND accountNumber =@accountNumber
    
	DECLARE @saldoInicial float
	DECLARE @saldoFinal float

	DECLARE @sumConsignacion float
	DECLARE @sumRetiro float

	--busco los valores iniciales antes de la operación
	SELECT @sumConsignacion= ISNULL(SUM(value),0) FROM [TransactionsDB].[dbo].[transaction]  WHERE idOperation = @idOperationConsignacion AND idAccount = @idAccount
	SELECT @sumRetiro= ISNULL(SUM(value),0) FROM [TransactionsDB].[dbo].[transaction]  WHERE idOperation in (@idOperationTransferencia,@idOperationRetiro,@idOperationGmf) AND idAccount = @idAccount

	SELECT @saldoInicial = @sumConsignacion - @sumRetiro

	IF(@operation = @idOperationConsignacion)
	BEGIN
		SELECT @saldoFinal = @saldoInicial + @value
	END
	ELSE
	BEGIN
		SELECT @saldoFinal = @saldoInicial - @value
	END

	DECLARE @gmf float
	SET @gmf = 0
	--si operación=1 retiro y valor >= 9.600.000

	IF(@exento = 'False')
	BEGIN
		IF(@operation = @idOperationTransferencia)
		BEGIN
			SET @gmf = (@value * 4) / 1000
			--SELECT 'paga 4xmil operation = 2'
		END
		ELSE
		BEGIN
			IF(@operation = @idOperationRetiro AND @value >= 9600000)
			BEGIN
				SET @gmf = (@value * 4) / 1000
				--SELECT 'paga 4xmil operation= 1'
			END
		END
	END
	DECLARE @destinationBank VARCHAR(50)
	
	IF(@AccountNumberDestination IS NULL)
	BEGIN
		SELECT @destinationBank = @sourceBank
	END
	ELSE
	BEGIN
		SELECT @idAccountDestination=id,@destinationBank = bank FROM [TransactionsDB].[dbo].[account]  WHERE idPerson = @idPerson AND accountNumber =@AccountNumberDestination
	END
	--SET @destinationBank = NULL
	--SELECT @saldoInicial saldoInicial, @saldoFinal saldoFinal, @value [value], @operation operation, @sumConsignacion sumConsignacion, @sumRetiro sumRetiro
	BEGIN TRAN
			EXEC dbo.INSERT_TRANSACTIONS @idPerson,@operation ,@saldoInicial ,@saldoFinal,@sourceBank,@destinationBank,@idAccount,@value,@gmf
	COMMIT TRAN



	DECLARE @saldoInicialDestination float
	DECLARE @saldoFinalDestination float

	DECLARE @sumConsignacionDestination float
	DECLARE @sumRetiroDestination float

	SELECT @sumConsignacionDestination= ISNULL(SUM(value),0) FROM [TransactionsDB].[dbo].[transaction]  WHERE idOperation = @idOperationConsignacion AND idAccount = @idAccountDestination
	SELECT @sumRetiroDestination= ISNULL(SUM(value),0) FROM [TransactionsDB].[dbo].[transaction]  WHERE idOperation in (@idOperationTransferencia,@idOperationRetiro,@idOperationGmf) AND idAccount = @idAccountDestination

	SELECT @saldoInicialDestination = @sumConsignacionDestination - @sumRetiroDestination
	IF(@operationDestination = @idOperationConsignacion)
	BEGIN
		SELECT @saldoFinalDestination = @saldoInicialDestination + @value
	END

	--SELECT @gmf gmf , @operation operation
	IF (@gmf > 0 AND @operation <> @idOperationConsignacion)
	BEGIN
	DECLARE  @saldoInicialgmf FLOAT
	DECLARE  @saldoFinalgmf FLOAT
		SET @saldoInicialgmf = @saldoFinal
		SET @saldoFinalgmf = @saldoFinal - @gmf

		--SELECT @saldoInicialgmf saldoInicial, @saldoFinalgmf saldoFinal, @gmf [value], @operation operation
		BEGIN TRAN
			EXEC dbo.INSERT_TRANSACTIONS @idPerson,@idOperationGmf ,@saldoInicialgmf ,@saldoFinalgmf,@sourceBank,@destinationBank,@idAccount,@gmf,0
		COMMIT TRAN
	END

	IF(@operationDestination = @idOperationConsignacion)
	BEGIN
		/*SET @operation =@operationDestination
				   SET @saldoInicial = @saldoInicialDestination
				   SET @saldoFinal =@saldoFinalDestination
				   SET @idAccount =@idAccountDestination*/
		BEGIN TRAN
			EXEC dbo.INSERT_TRANSACTIONS @idPerson,@operationDestination ,@saldoInicialDestination ,@saldoFinalDestination,@sourceBank,@destinationBank,@idAccountDestination,@value,0
		COMMIT TRAN
	END

	--SELECT @saldoInicialDestination saldoInicialD, @saldoFinalDestination saldoFinalD, @value [value], @operationDestination operationD, @sumConsignacionDestination sumConsignacionD, @sumRetiroDestination sumRetiroD

	BEGIN TRAN
	--	EXEC dbo.INSERT_TRANSACTIONS @idPerson,@operation ,@saldoInicial ,@saldoFinal,@sourceBank,@destinationBank,@idAccount,@value,@gmf
	COMMIT TRAN

END
GO
/****** Object:  StoredProcedure [dbo].[GET_ISVALID_TRANSACTIONS]    Script Date: 21/01/2021 1:58:15 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Marisol Nieto
-- Create date: 20-ene-2021
-- Description:	Procedimiento que permite validar si se tiene saldo para hacer un retiro
-- =============================================
--EXEC GET_ISVALID_TRANSACTIONS  123,'A',1,9600000
CREATE PROCEDURE [dbo].[GET_ISVALID_TRANSACTIONS]
		@idPerson int
  , @accountNumber VARCHAR (50)
  , @operation INT
  , @value FLOAT

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	DECLARE @idAccount INT
	DECLARE @sumConsignacion float
	DECLARE @gmf float
	DECLARE @saldoInicial float
	DECLARE @sumRetiro float
	DECLARE @exento BIT 

	DECLARE @idOperationRetiro INT
	DECLARE @idOperationTransferencia INT
	DECLARE @idOperationGmf INT
	DECLARE @idOperationConsignacion INT

	SET @idOperationRetiro = 1
	SET @idOperationTransferencia = 2
	SET @idOperationGmf = 3
	SET @idOperationConsignacion = 4
	SET NOCOUNT ON;
	SELECT @exento = [exento],  @idAccount = id FROM [TransactionsDB].[dbo].[account] WITH(NOLOCK) WHERE idPerson = @idPerson AND accountNumber =@accountNumber
	SELECT @sumConsignacion= ISNULL(SUM(value),0) FROM [TransactionsDB].[dbo].[transaction]  WHERE idOperation = @idOperationConsignacion AND idAccount = @idAccount
	SELECT @sumRetiro= ISNULL(SUM(value),0) FROM [TransactionsDB].[dbo].[transaction]  WHERE idOperation in (@idOperationTransferencia,@idOperationRetiro,@idOperationGmf) AND idAccount = @idAccount
	SELECT @saldoInicial = @sumConsignacion - @sumRetiro

	SET @gmf = 0
	IF(@exento = 'False')
	BEGIN
		IF(@operation = @idOperationTransferencia)
		BEGIN
			SET @gmf = (@value * 4) / 1000
			--SELECT 'paga 4xmil operation = 2'
		END
		ELSE
		BEGIN
			IF(@operation = @idOperationRetiro AND @value >= 9600000)
			BEGIN
				SET @gmf = (@value * 4) / 1000
				--SELECT 'paga 4xmil operation= 1'
			END
		END
	END

	IF(@saldoInicial > (SELECT @value + @gmf))
	BEGIN
		SELECT '1' valid
	END
	ELSE
	BEGIN
		SELECT '0' valid
	END
END
GO
/****** Object:  StoredProcedure [dbo].[GET_TRANSACTIONS]    Script Date: 21/01/2021 1:58:15 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Marisol Nieto
-- Create date: 20-ene-2021
-- Description:	Permite obtener las transacciones realizada por un cliente
-- =============================================
--EXEC [dbo].[GET_TRANSACTIONS] 123
CREATE PROCEDURE [dbo].[GET_TRANSACTIONS] 

	@idPerson INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	IF(@idPerson <> 0)
	BEGIN
		SELECT CONVERT(VARCHAR(100),[idPerson]) [idPerson]
		  ,CONVERT(VARCHAR(100),[idOperation]) [idOperation]
		  ,[initialValue]
		  ,[value]
		  ,[finalValue]
		  ,[gmf]
		  ,[destinationBank]
		  , [created]
		FROM [TransactionsDB].[dbo].[transaction]
		WHERE [idPerson] = @idPerson
	END
	ELSE
	BEGIN
		SELECT TOP 100 CONVERT(VARCHAR(100),[idPerson]) [idPerson]
		  ,CONVERT(VARCHAR(100),[idOperation]) [idOperation]
		  ,[initialValue]
		  ,[value]
		  ,[finalValue]
		   ,[gmf]
		  ,[destinationBank]
		  , [created]
		FROM [TransactionsDB].[dbo].[transaction]
	END
END
GO
/****** Object:  StoredProcedure [dbo].[INSERT_TRANSACTIONS]    Script Date: 21/01/2021 1:58:15 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Marisol Nieto
-- Create date: 20-ene-2021
-- Description:	Procedimiento que se encarga de realizar la inserción de la transacción
-- =============================================
CREATE PROCEDURE [dbo].[INSERT_TRANSACTIONS]
	@idPerson INT
    ,@operation INT
    ,@saldoInicial FLOAT
    ,@saldoFinal FLOAT
    ,@sourceBank VARCHAR(50)
    ,@destinationBank  VARCHAR(50)
    ,@idAccount INT
    ,@value FLOAT
	,@gmf FLOAT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @Error int
	BEGIN TRAN  
		INSERT INTO [TransactionsDB].[dbo].[transaction]
				([idPerson]
				,[idOperation]
				,[initialValue]
				,[finalValue]
				,[sourceBank]
				,[destinationBank]
				,[idAccount]
				,[value]
				,[gmf]
				,[created]
				,[modified])
			VALUES
				(@idPerson
				,@operation
				,@saldoInicial
				, @saldoFinal
				,@sourceBank
				,@destinationBank
				,@idAccount
				,@value
				,@gmf
				,GETDATE()
				,GETDATE())

		SET @Error=@@ERROR

		IF (@Error<>0) 
		BEGIN
			PRINT 'Ha ecorrido un error. Abortamos la transacción'
			--Se lo comunicamos al usuario y deshacemos la transacción
			--todo volverá a estar como si nada hubiera ocurrido
			ROLLBACK TRAN
		END
	COMMIT TRAN
END
GO
USE [master]
GO
ALTER DATABASE [TransactionsDB] SET  READ_WRITE 
GO
