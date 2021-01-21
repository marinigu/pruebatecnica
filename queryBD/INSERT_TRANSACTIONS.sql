SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Marisol Nieto
-- Create date: 20-ene-2021
-- Description:	Procedimiento que se encarga de realizar la inserción de la transacción
-- =============================================
ALTER PROCEDURE INSERT_TRANSACTIONS
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
