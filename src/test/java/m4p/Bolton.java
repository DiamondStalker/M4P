package m4p;

import com.intuit.karate.junit5.Karate;

public class Bolton {

    @Karate.Test
    public Karate CompraPaquete() {
        return Karate.run("classpath:m4p/bolton/apply_bonus.feature")
                .tags("@enviarinfo")
                .reportDir("target/Bolton/apply_bonus")
                .relativeTo(getClass());
    }
}
