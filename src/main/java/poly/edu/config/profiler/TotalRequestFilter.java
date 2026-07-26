package poly.edu.config.profiler;

import jakarta.servlet.*;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;

import java.io.IOException;

import org.springframework.core.Ordered;

@Component
@Order(Ordered.HIGHEST_PRECEDENCE)
public class TotalRequestFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        String uri = httpRequest.getRequestURI();

        if (uri.startsWith("/css/") || uri.startsWith("/js/") || uri.startsWith("/images/") 
            || uri.startsWith("/fonts/") || uri.endsWith(".png") || uri.endsWith(".jpg") 
            || uri.endsWith(".svg") || uri.endsWith(".ico") || uri.endsWith(".woff2")
            || uri.startsWith("/uploads/")) {
            chain.doFilter(request, response);
            return;
        }

        SimpleProfiler.startRequest();
        long start = System.currentTimeMillis();
        try {
            chain.doFilter(request, response);
        } finally {
            long totalTime = System.currentTimeMillis() - start;
            if (totalTime > 10) {
                SimpleProfiler.printReport(totalTime, uri);
            }
        }
    }
}
