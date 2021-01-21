USE [TransactionsDB]
GO
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
ALTER PROCEDURE GET_ISVALID_TRANSACTIONS
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
