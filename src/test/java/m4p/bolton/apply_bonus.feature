Feature: Aplicación de bonos

  Background:

    * def sleep = function(pause){ java.lang.Thread.sleep(pause*1000) }

    * def natsAdmin =  baseUrls.natsAdmin
    * def userNameDB = database.username
    * def passDB = database.passDB
    * def urlDb = database.url

  @enviarinfo
  Scenario Outline: Validar aplicación de bono valido

    Given url natsAdmin
    And header accept = '*/*'
    And header Content-Type = 'application/json'
    And request
     """
    {
      "subject": "nebula.supplyBonus",
      "message": {
        "transactionId": <transactionId>,
        "serviceNumber": <subscriberNumber>,
        "date": 1732037402.309032972,
        "boltonCode": <boltonCode>
      }
    }
    """
    When method POST
    Then status 200

    * sleep(2)

    * def dbConfig = {username: '#(userNameDB)',password: '#(passDB)',url: '#(urlDb)'}
    * def dbQuery = `select * from logger.tbl_logger_subject where transaction_id = '${transactionId}'`
    * def response = karate.call('../../utils/postgresql.feature', { dbConfig: dbConfig, dbQuery: dbQuery })



    * print "=== response ===",response.result
    * match response.result[0].response contains '<Validacion>'

    Examples:
      | read('classpath:m4p/bolton/bolton_set_datos.json') |
