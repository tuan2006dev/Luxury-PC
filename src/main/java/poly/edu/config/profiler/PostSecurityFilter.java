package poly.edu.config.profiler;

import jakarta.servlet.*;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.core.Ordered;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;

import java.io.IOException;

@Component
@Order(-99) // Usually Spring Security is at -100
public class PostSecurityFilter implements Filter {
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        long start = System.currentTimeMillis();
        try {
            chain.doFilter(request, response);
        } finally {
            long time = System.currentTimeMillis() - start;
            if (request instanceof HttpServletRequest req) {
                SimpleProfiler.logController("DispatcherServlet_And_View", time);
            }
        }
    }
}
