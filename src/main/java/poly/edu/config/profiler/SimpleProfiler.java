package poly.edu.config.profiler;

import java.util.ArrayList;
import java.util.List;

public class SimpleProfiler {
    public static boolean ENABLED = true;

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
        System.out.println("\n\n");
        System.out.println("=================================================");
        System.out.println("REQUEST: " + uri);
        System.out.println("=================================================");
        
        System.out.println("\nRepository:");
        for (String s : REPOSITORIES.get()) System.out.println(s);
        
        System.out.println("\nService:");
        for (String s : SERVICES.get()) System.out.println(s);
        
        System.out.println("\nController:");
        for (String s : CONTROLLERS.get()) System.out.println(s);
        
        System.out.println("\nView Rendering:");
        for (String s : VIEWS.get()) System.out.println(s);
        
        System.out.println("\nTOTAL REQUEST .............. " + totalMs + " ms");
        System.out.println("=================================================\n\n");
        
        REPOSITORIES.remove();
        SERVICES.remove();
        CONTROLLERS.remove();
        VIEWS.remove();
    }
}
