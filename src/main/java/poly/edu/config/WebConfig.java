package poly.edu.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.http.CacheControl;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.concurrent.TimeUnit;

@Configuration
public class WebConfig implements WebMvcConfigurer {

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        exposeDirectory("src/main/resources/static/uploads", "/uploads/**", registry);
        exposeDirectory("src/main/resources/static/images", "/images/**", registry);

        // Cache static resources (CSS, JS, fonts) for 7 days
        registry.addResourceHandler("/css/**")
                .addResourceLocations("classpath:/static/css/")
                .setCacheControl(CacheControl.maxAge(7, TimeUnit.DAYS).cachePublic());
        registry.addResourceHandler("/js/**")
                .addResourceLocations("classpath:/static/js/")
                .setCacheControl(CacheControl.maxAge(7, TimeUnit.DAYS).cachePublic());
    }

    private void exposeDirectory(String dirName, String pathPattern, ResourceHandlerRegistry registry) {
        Path uploadDir = Paths.get(dirName);
        String uploadPath = uploadDir.toFile().getAbsolutePath();
        if (!uploadPath.endsWith("/")) {
            uploadPath += "/";
        }
        
        String classpathLocation = "classpath:/" + dirName.replace("src/main/resources/", "") + "/";
        
        registry.addResourceHandler(pathPattern)
                .addResourceLocations("file:" + uploadPath, classpathLocation)
                .setCacheControl(CacheControl.maxAge(1, TimeUnit.DAYS).cachePublic());
    }
    @Override
    public void addInterceptors(org.springframework.web.servlet.config.annotation.InterceptorRegistry registry) {
        registry.addInterceptor(new poly.edu.config.profiler.ProfilerInterceptor());
    }
}
