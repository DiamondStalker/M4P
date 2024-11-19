Feature: Validar acumulador con raise.level y validar DB

  Background:

    * def natsAdmin =  baseUrls.natsAdmin
    * def userNameDB = database.username
    * def passDB = database.passDB
    * def urlDb = database.url


  @EnviarRaseLevel
  Scenario Outline: RaiseLevel numero <SUBSCRIBER_NUMBER> con valor de  <Acumulado> para el UUID <UUID>

    Given url natsAdmin
    And header accept = '*/*'
    And header Content-Type = 'application/json'
    And request
    """
    {
      "subject": "nebula.raiseLevel",
      "message": {
        "date": ,
        "serviceNumber": <SUBSCRIBER_NUMBER>,
        "totalAmount": <Acumulado>,
        "transactionId": <UUID>
      }
    }
    """

    When method POST
    Then status 200


    # Query the PostgreSQL database
    * def dbConfig = {username: '#(userNameDB)',password: '#(passDB)',url: '#(urlDb)'}
    * def dbQuery = `   SELECT * FROM logger.tbl_multi_subject where transaction_id = '${UUID}' and subject = 'nebula.supplyBonus'`
    * def response = karate.call('../../utils/postgresql.feature', { dbConfig: dbConfig, dbQuery: dbQuery })

    # * print result
    * print " ======== Result DB <SUBSCRIBER_NUMBER> ======== "
    * print dbQuery
    * print response.result.length

    # Validar que el campose response.result tenga un array de 3 o mas campos
    * assert response.result.length == <Bono>




    Examples:
      | read('classpath:m4p/raiselevel.json') |