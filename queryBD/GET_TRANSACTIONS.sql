USE [TransactionsDB]
GO
/****** Object:  StoredProcedure [dbo].[GET_TRANSACTIONS]    Script Date: 20/01/2021 7:56:39 p. m. ******/
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
ALTER PROCEDURE [dbo].[GET_TRANSACTIONS] 

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
