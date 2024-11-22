package m4p.Acumulador;

import com.intuit.karate.Results;
import com.intuit.karate.Runner;
import com.intuit.karate.junit5.Karate;

public class AcumuladorRunner {
    @Karate.Test
    Karate Acumulador(){
        return Karate.run().relativeTo(getClass());
    }
}
