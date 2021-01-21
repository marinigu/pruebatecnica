

ALTER TABLE account DROP COLUMN  idOperation 

ALTER TABLE [transaction] ADD  [gmfToAplicate] FLOAT
--para el insert de la transaccion se tiene en cuenta que ingrese
--bancoOrigen, bancoDestino, valorRetiro, idPersona, numeroCuenta, tipoOperacion

--PArametros entrada
  DECLARE @idPerson int
  DECLARE @accountNumber VARCHAR (50)
  DECLARE @operation INT
  DECLARE @value FLOAT
  DECLARE @AccountNumberDestination VARCHAR (50)

  SET @idPerson =123 
  SET @accountNumber ='A'
  SET @value = 9600000--1000000 --9600000
  SET @operation = 1
  SET @AccountNumberDestination = 'B'
  DECLARE @destinationBank VARCHAR(50)
  DECLARE @operationDestination INT
  SET @operationDestination = 4

   --valido si la cuenta del cliente es exenta y obtengo el id de la cuenta
  DECLARE @exento BIT  
  DECLARE @idAccount INT
  DECLARE @sourceBank VARCHAR(50)
   DECLARE @idAccountDestination INT

   /*
  idoperation = 1 retiro
  idoperation = 2 transferencia
  idoperation = 3 retirox4xmil gmf
  idoperation = 4 consignacion
  */

  DECLARE @idOperationRetiro INT
  DECLARE @idOperationTransferencia INT
  DECLARE @idOperationGmf INT
  DECLARE @idOperationConsignacion INT

  SET @idOperationRetiro =1
  SET @idOperationTransferencia =2
  SET @idOperationGmf = 3
  SET @idOperationConsignacion = 4

    --valido si la cuenta del cliente es exenta
  SELECT @exento = [exento], @idAccount = id, @sourceBank = bank FROM [TransactionsDB].[dbo].[account]  WITH(NOLOCK)  WHERE idPerson = @idPerson AND accountNumber =@accountNumber

  IF(@AccountNumberDestination IS NULL)
  BEGIN
	SELECT @destinationBank = @sourceBank
  END
  ELSE
  BEGIN
    SELECT @idAccountDestination=id,@destinationBank = bank FROM [TransactionsDB].[dbo].[account]  WHERE idPerson = @idPerson AND accountNumber =@AccountNumberDestination
  END


  DECLARE @saldoInicial float
  DECLARE @saldoFinal float

  DECLARE @sumConsignacion float
  DECLARE @sumRetiro float
 

   DECLARE @saldoInicialDestination float
  DECLARE @saldoFinalDestination float

  DECLARE @sumConsignacionDestination float
  DECLARE @sumRetiroDestination float

  --busco los valores iniciales antes de la operación
    SELECT @sumConsignacion= ISNULL(SUM(value),0) FROM [TransactionsDB].[dbo].[transaction]  WHERE idOperation = @idOperationConsignacion AND idAccount = @idAccount
	SELECT @sumRetiro= ISNULL(SUM(value),0) FROM [TransactionsDB].[dbo].[transaction]  WHERE idOperation in (@idOperationTransferencia,@idOperationRetiro,@idOperationGmf) AND idAccount = @idAccount

	    SELECT @sumConsignacionDestination= ISNULL(SUM(value),0) FROM [TransactionsDB].[dbo].[transaction]  WHERE idOperation = @idOperationConsignacion AND idAccount = @idAccountDestination
	SELECT @sumRetiroDestination= ISNULL(SUM(value),0) FROM [TransactionsDB].[dbo].[transaction]  WHERE idOperation in (@idOperationTransferencia,@idOperationRetiro,@idOperationGmf) AND idAccount = @idAccountDestination

	SELECT @saldoInicialDestination = @sumConsignacionDestination - @sumRetiroDestination
	IF(@operationDestination = @idOperationConsignacion)
	BEGIN
		SELECT @saldoFinalDestination = @saldoInicialDestination + @value
	END

	SELECT @saldoInicial = @sumConsignacion - @sumRetiro


	IF(@operation = @idOperationConsignacion)
	BEGIN
		SELECT @saldoFinal = @saldoInicial + @value
	END
	ELSE
	BEGIN
		SELECT @saldoFinal = @saldoInicial - @value
	END

	SELECT @saldoInicial saldoInicial, @saldoFinal saldoFinal, @value [value], @operation operation, @sumConsignacion sumConsignacion, @sumRetiro sumRetiro
	SELECT @saldoInicialDestination saldoInicialD, @saldoFinalDestination saldoFinalD, @value [value], @operationDestination operationD, @sumConsignacionDestination sumConsignacionD, @sumRetiroDestination sumRetiroD

  --SET @value  = 9600000

  DECLARE @gmf float
  SET @gmf = 0
  --si operación=1 retiro y valor >= 9.600.000

  IF(@exento = 'False')
  BEGIN
		IF(@operation = @idOperationTransferencia)
		BEGIN
		    SET @gmf = (@value * 4) / 1000
			SELECT 'paga 4xmil operation = 2'
		END
		ELSE
		BEGIN
			IF(@operation = @idOperationRetiro AND @value >= 9600000)
			BEGIN
			  SET @gmf = (@value * 4) / 1000
				SELECT 'paga 4xmil operation= 1'
			END
		END
  END

  DECLARE @Error int
  --necesito hacer un insert a transaction

  
	IF(@saldoInicial > (SELECT @value + @gmf))
	BEGIN
		SELECT 1
	END
	ELSE
	BEGIN
		SELECT 0
	END
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
		   ,[gmfToAplicate]
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

	IF (@gmf > 0)
	BEGIN
	SET @saldoInicial = @saldoFinal
	SET @saldoFinal = @saldoFinal - @gmf

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
		   ,[gmfToAplicate]
		   ,[created]
		   ,[modified])
     VALUES
           (@idPerson
           ,@idOperationGmf
           ,@saldoInicial
           , @saldoFinal
           ,@sourceBank
           ,@destinationBank
           ,@idAccount
           ,@gmf
		   ,0
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

			IF(@operationDestination = @idOperationConsignacion)
	BEGIN
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
				   ,[gmfToAplicate]
				   ,[created]
				   ,[modified])
			 VALUES
				   (@idPerson
				   ,@operationDestination
				   ,@saldoInicialDestination
				   , @saldoFinalDestination
				   ,@sourceBank
				   ,@destinationBank
				   ,@idAccountDestination
				   ,@value
				   ,0
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
	END
