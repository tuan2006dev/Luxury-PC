package poly.edu.config.profiler;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import java.util.ArrayList;
import java.util.List;

public class SimpleProfiler {
    public static boolean ENABLED = true;

    private static final Logger log = LoggerFactory.getLogger(SimpleProfiler.class);

    private static final ThreadLocal<List<String>> REPOSITORIES = ThreadLocal.withInitial(ArrayList::new);
    private static final ThreadLocal<List<String>> SERVICES = ThreadLocal.withInitial(ArrayList::new);
    private static final ThreadLocal<List<String>> CONTROLLERS = ThreadLocal.withInitial(ArrayList::new);
    private static final ThreadLocal<List<String>> VIEWS = ThreadLocal.withInitial(ArrayList::new);
    
    public static void startRequest() {
        if (!ENABLED) return;
        REPOSITORIES.get().clear();
        SERVICES.get().clear();
        CONTROLLERS.get().clear();
        VIEWS.get().clear();
    }
    
    public static void logRepository(String name, long time) {
        if (ENABLED) REPOSITORIES.get().add(String.format("%-30s .......... %d ms", name, time));
    }
    
    public static void logService(String name, long time) {
        if (ENABLED) SERVICES.get().add(String.format("%-30s .......... %d ms", name, time));
    }
    
    public static void logController(String name, long time) {
        if (ENABLED) CONTROLLERS.get().add(String.format("%-30s .......... %d ms", name, time));
    }

    public static void logView(String name, long time) {
        if (ENABLED) VIEWS.get().add(String.format("%-30s .......... %d ms", name, time));
    }
    
    public static void printReport(long totalMs, String uri) {
        if (!ENABLED) return;
        StringBuilder sb = new StringBuilder();
        sb.append("\n=================================================");
        sb.append("\nREQUEST: ").append(uri);
        sb.append("\n=================================================");
        sb.append("\nRepository:");
        for (String s : REPOSITORIES.get()) sb.append("\n  ").append(s);
        sb.append("\nService:");
        for (String s : SERVICES.get()) sb.append("\n  ").append(s);
        sb.append("\nController:");
        for (String s : CONTROLLERS.get()) sb.append("\n  ").append(s);
        sb.append("\nView Rendering:");
        for (String s : VIEWS.get()) sb.append("\n  ").append(s);
        sb.append("\nTOTAL REQUEST .............. ").append(totalMs).append(" ms");
        sb.append("\n=================================================");
        log.debug("{}", sb);

        REPOSITORIES.remove();
        SERVICES.remove();
        CONTROLLERS.remove();
        VIEWS.remove();
    }
}
