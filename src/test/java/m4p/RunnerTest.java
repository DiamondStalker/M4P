package m4p;

import com.intuit.karate.junit5.Karate;


public class RunnerTest {
    @Karate.Test
    public Karate CompraPaquete() {
        return Karate.run("classpath:m4p/Acumulador/Acumulador.feature")
                .tags("@CompraPaquete")
                .reportDir("target/karate-reports-compra-paquete")
                .relativeTo(getClass());
    }

    @Karate.Test
    public Karate CantidadRegistros() {
        return Karate.run("classpath:m4p/Acumulador/Acumulador.feature")
                .tags("@validaCantidadRegistros")
                .reportDir("target/karate-reports-valida-registros")
                .relativeTo(getClass());
    }

    @Karate.Test
    public Karate Limpieza() {
        return Karate.run("classpath:m4p/Acumulador/Acumulador.feature")
                .tags("@LimpiezaDB")
                .reportDir("target/karate-reports-valida-registros")
                .relativeTo(getClass());
    }

    @Karate.Test
    public Karate Acumulador() {
        return Karate.run("classpath:m4p/Acumulador/Acumulador.feature")
                .tags("@validaMontoAcumulado")
                .reportDir("target/Acumulaodor")
                .relativeTo(getClass());
    }

    @Karate.Test
    public Karate FechasCorte() {
        return Karate.run("classpath:m4p/Acumulador/Acumulador.feature")
                .tags("@ValidarDiferentesFechasSeguidas")
                .reportDir("target/FechaCorte")
                .relativeTo(getClass());
    }

}
