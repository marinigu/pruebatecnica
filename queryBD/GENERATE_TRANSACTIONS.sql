USE [TransactionsDB]
GO

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
ALTER PROCEDURE GENERATE_TRANSACTIONS 
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
