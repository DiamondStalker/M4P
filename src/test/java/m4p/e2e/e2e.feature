Feature: Validar acumulador con raise.level y validar DB


  Background:

    * def sleep = function(pause){ java.lang.Thread.sleep(pause*1000) }


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
      | read('classpath:m4p/SetDatosCompletos.json') |

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


    #validaMontoAcumulado
  @validaMontoAcumulado
  Scenario Outline: Validacion cumplimiento de bobo para el id <UUID>

      # Query the PostgreSQL database
    * def dbQuery = `SELECT * FROM logger.tbl_multi_subject where transaction_id = '${UUID}' and subject = 'nebula.supplyBonus'`
    * def response = karate.call('../../utils/postgresql.feature', { dbConfig: dbConfig, dbQuery: dbQuery })

        # * print result
    * print " ======== Result DB ======== "
    * print response.result

    * assert response.result.length == '<Bono>'


    Examples:
      | read('classpath:m4p/UUIDRiseLevel.json') |

  Scenario Outline: Validacion de bono <UUID>
     #* sleep(2)
    * def validacion =
      """
        function(Bono,Validacion,response) {
            if (Bono != 0) {
                return response.result[0].response.search(Validacion) != -1
            } else {
                return true
            }
        }
      """

    * def dbQuery = `select * from logger.tbl_logger_subject where transaction_id = '${UUID}'`
    * def response = karate.call('../../utils/postgresql.feature', { dbConfig: dbConfig, dbQuery: dbQuery })


    # Llama a la función de validación
    * def resultadoValidacion = validacion('<Bono>','<Validacion>',response)

    * print "Resultado ===> ",resultadoValidacion

   # Asegúrate de que el resultado es válido
    * assert resultadoValidacion




    # * print "=== response ===",response.result
    # * match  response.result[0].response contains '<Validacion>' : true

    # Validación condicional basada en Bono


    Examples:
      | read('classpath:m4p/UUIDRiseLevel.json') |