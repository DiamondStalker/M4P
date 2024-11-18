Feature: Validar respuesta correcta del servicio Bolton

  Background:


    * def natsBolton = baseUrls.natsBolton
    * def userNameDB = database.username
    * def passDB = database.passDB
    * def urlDb = database.url

  @Bolton
  Scenario Outline: Realizando una peticion a servicio Bolton <appId> usando <userCode> el numero de usuario <subscriberNumber> y el bolton code <boltonCode>
    Given url natsBolton
    And header accept = '*/*'
    And header Content-Type = 'application/json'
    And request
    """
      {
      "appId": <appId>,
      "appInfoReference": "testing",
      "userCode": <userCode>,
      "opCost": 0,
      "subscriberNumber":<subscriberNumber>,
      "boltonCode": <boltonCode>,
      "amount": 90
      }
    """
    When method POST
    Then status 200
    * print 'Resultado==>',response

    Examples:
      | read('classpath:m4p/bolton/bolton_set_datos.json') |