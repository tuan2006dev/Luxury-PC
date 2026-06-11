import java.io.File;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.stream.Stream;

public class ReplaceFonts {
    public static void main(String[] args) throws Exception {
        String dir = "src/main/resources";
        try (Stream<Path> paths = Files.walk(Paths.get(dir))) {
            paths.filter(Files::isRegularFile)
                 .filter(p -> p.toString().endsWith(".html") || p.toString().endsWith(".css"))
                 .forEach(p -> {
                     try {
                         String content = new String(Files.readAllBytes(p), "UTF-8");
                         String newContent = content.replaceAll("family=Cormorant\\+Garamond[^&]*&family=Montserrat[^&]*&", "family=Outfit:wght@300;400;500;600;700&family=Inter:wght@300;400;500;600&");
                         newContent = newContent.replaceAll("--serif:\\s*['\"]Cormorant Garamond['\"][^;]*;", "--serif: 'Outfit', sans-serif;");
                         newContent = newContent.replaceAll("--serif:\\s*['\"]Cormorant Garamond['\"],Georgia,serif;", "--serif: 'Outfit', sans-serif;");
                         newContent = newContent.replaceAll("--sans:\\s*['\"]Montserrat['\"][^;]*;", "--sans: 'Inter', sans-serif;");
                         newContent = newContent.replaceAll("--sans:\\s*['\"]Montserrat['\"],sans-serif;", "--sans: 'Inter', sans-serif;");
                         newContent = newContent.replaceAll("--font-serif:\\s*['\"]Inter['\"][^;]*;", "--font-serif: 'Outfit', sans-serif;");
                         if (!content.equals(newContent)) {
                             Files.write(p, newContent.getBytes("UTF-8"));
                             System.out.println("Updated " + p);
                         }
                     } catch (Exception e) {
                         e.printStackTrace();
                     }
                 });
        }
    }
}
