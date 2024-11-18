Feature: Connect and Query PostgreSQL Database

  Scenario: Execute query on PostgreSQL
    * def dbConfig = karate.get('dbConfig')
    * def dbQuery = karate.get('dbQuery')


    # Imprime la ruta actual en Karate
    * print "Ruta actual:", java.lang.System.getProperty('user.dir')

    # Llama a la clase Java que ejecuta la consulta
    * def result = Java.type('m4p.utils.DbUtils').executeQuery(dbConfig.url, dbConfig.username, dbConfig.password, dbQuery)

    # Verifica que el resultado no sea nulo y retorna
    * match result != null
    * karate.signal(result)
