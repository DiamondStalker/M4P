package m4p;

import com.intuit.karate.junit5.Karate;

public class RaiseLevel {

    @Karate.Test
    public Karate CompraPaquete() {
        return Karate.run("classpath:m4p/raiseLevel/enviarraiselevel.feature")
                .tags("@EnviarRaseLevel")
                .reportDir("target/EnviarRaseLevel")
                .relativeTo(getClass());
    }

    @Karate.Test
    public Karate CompraPaquetex2() {
        return Karate.run("classpath:m4p/raiseLevel/enviarraiselevel.feature")
                .tags("@EnviarRaseLevel")
                .reportDir("target/EnviarRaseLevelx2")
                .relativeTo(getClass());
    }

}
