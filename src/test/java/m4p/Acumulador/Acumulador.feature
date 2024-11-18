Feature: Validar acumulador con raise.level y validar DB

  Background:

    * def dbConfig = {username: '#(database.username)',password: '#(database.passDB)',url: '#(database.url)'}
    * def natsAdmin =  baseUrls.natsAdmin

    # def dbConfigs = karate.get('database')

    * def date =
    """
    (()=>{
      const iso = Math.floor(Date.now() / 1000)
      const isoString = new Date().toISOString();
      const timestampSeconds = Math.floor(new Date(isoString).getTime() / 1000);
      return timestampSeconds
    })()
    """

 #CompraPquete
  @CompraPaquete
  Scenario Outline: Realizando compra paquete de <Recarga> para el numero <SUBSCRIBER_NUMBER>

    Given url natsAdmin
    And header accept = '*/*'
    And header Content-Type = 'application/json'
    And request
    """
    {
      "subject": "nebula.purchasePackage",
      "message": {
        "amount": <Recarga>,
        "date": #(date),
        "referenceId": <ID>,
        "requestId": 0,
        "serviceNumber": <SUBSCRIBER_NUMBER>,
        "transactionId": <UUID>
      }
    }
    """
    When method POST
    Then status 200

    Examples:
      | read('classpath:m4p/SetDatos.json') |

    #ValidarCantidadRegistros
  @validaCantidadRegistros
  Scenario Outline: Validacion  DB para el numero <SUBSCRIBER_NUMBER> para el transaction_id <UUID>

    # Query the PostgreSQL database
    * def dbQuery = `select * from acumulated_purcahses.monthly where service_number = '${SUBSCRIBER_NUMBER}'`
    * def response = karate.call('../../utils/postgresql.feature', { dbConfig: dbConfig, dbQuery: dbQuery })

    # * print result
    * print " ======== Result DB <SUBSCRIBER_NUMBER> ======== "
    * print dbQuery
    * print response.result.length

    # Validar que el campose response.result tenga un array de 3 o mas campos
    * assert response.result.length == <Registros>


    Examples:
      | read('classpath:m4p/UUIDRiseLevel.json') |

  #validaMontoAcumulado
  @validaMontoAcumulado
  Scenario Outline: Validacion DB MUltiSubject para el numero <SUBSCRIBER_NUMBER> para el transaction_id <UUID>

      # Query the PostgreSQL database
    * def dbQuery = `SELECT * FROM logger.tbl_multi_subject where transaction_id = '${UUID}' and subject = 'nebula.raiseLevel'`
    * def response = karate.call('../../utils/postgresql.feature', { dbConfig: dbConfig, dbQuery: dbQuery })

        # * print result
    * print " ======== Result DB ======== "
    * print JSON.parse(response.result[0].content).totalAmount

    * match JSON.parse(response.result[0].content).totalAmount.toString() contains '<Acumulado>'


    Examples:
      | read('classpath:m4p/UUIDRiseLevel.json') |


  # LimpiezaDB
  @LimpiezaDB
  Scenario: Limpieza de resgistros en la DB
    * def executeQuery =
    """
      function(query) {
      return karate.call('../../utils/postgresql.feature', { dbConfig: dbConfig, dbQuery: query });
      }
    """

    * def dbQueryAcumulate = `DELETE FROM acumulated_purcahses.monthly WHERE service_number like '%315861794%'`
    * def responseAcumulate = executeQuery(dbQueryAcumulate)

    * def dbQueryNotifications = `DELETE FROM logger.tbl_multi_subject WHERE transaction_id IN ('6d33610d-7b7a-47ce-88f5-0aec7102a64b','6d33610d-7b7a-47ce-88f5-0aec7102a64a','c1e06300-5791-40ca-af86-288c57eb19bc','c1e06300-5791-40ca-af86-188c57eb19bc','de1b7cf5-0efe-4840-8409-23ad614fc0ea','360c05d3-f009-4f01-b4c1-9ea2f58e2976','260c05d3-f009-4f01-b4c1-9ea2f58e2976','160c05d3-f009-4f01-b4c1-9ea2f58e2976')`
    * def responseNotifications = executeQuery(dbQueryNotifications)

    * def dbQueryBono = `DELETE FROM raise_level.offer_registration WHERE service_number like '%315861794%'`
    * def responseBono = executeQuery(dbQueryBono)

    # Nuevas validaciones

  @ValidarDiferentesFechas
  Scenario Outline: Compra paquete de <Recarga> para el numero <SUBSCRIBER_NUMBER> con diferente fecha para validar que no se acumula por ser diferentes meses

    Given url natsAdmin
    And header accept = '*/*'
    And header Content-Type = 'application/json'
    And request
    """
    {
      "subject": "nebula.purchasePackage",
      "message": {
        "amount": <Recarga>,
        "date": <DATE>,
        "referenceId": <ID>,
        "requestId": 0,
        "serviceNumber": <SUBSCRIBER_NUMBER>,
        "transactionId": <UUID>
      }
    }
    """
    When method POST
    Then status 200

    # Query the PostgreSQL database
    * def dbQuery = `SELECT * FROM logger.tbl_multi_subject where transaction_id = '${UUID}' and subject = 'nebula.raiseLevel'`
    * def response = karate.call('../../utils/postgresql.feature', { dbConfig: dbConfig, dbQuery: dbQuery })

        # * print result
    * print " ======== Result DB ======== "
    * print JSON.parse(response.result[0].content).totalAmount

      # Validar que el campose response.result tenga un array de 3 o mas campos
    * match JSON.parse(response.result[0].content).totalAmount.toString() contains '<Recarga>'

    Examples:
      | read('classpath:m4p/utils/Acumulador/comprasDiferentesFechas.json') |


  @ValidarDiferentesFechasSeguidas
  Scenario Outline: Fecha de corte

    Given url natsAdmin
    And header accept = '*/*'
    And header Content-Type = 'application/json'
    And request
    """
    {
      "subject": "nebula.purchasePackage",
      "message": {
        "amount": <Recarga>,
        "date": <DATE>,
        "referenceId": <ID>,
        "requestId": 0,
        "serviceNumber": <SUBSCRIBER_NUMBER>,
        "transactionId": <UUID>
      }
    }
    """
    When method POST
    Then status 200

    # Query the PostgreSQL database
    * def dbQuery = `SELECT * FROM logger.tbl_multi_subject where transaction_id = '${UUID}' and subject = 'nebula.raiseLevel'`
    * def response = karate.call('../../utils/postgresql.feature', { dbConfig: dbConfig, dbQuery: dbQuery })

        # * print result
    * print " ======== Result DB ======== "
    * print JSON.parse(response.result[0].content).totalAmount

      # Validar que el campose response.result tenga un array de 3 o mas campos
    * match JSON.parse(response.result[0].content).totalAmount.toString() contains '<Recarga>'

    Examples:
      | read('classpath:m4p/utils/Acumulador/comprasDiferentesFechasSeguidas.json') |