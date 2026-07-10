package poly.edu.config.profiler;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

@Component
public class ProfilerInterceptor implements HandlerInterceptor {

    private static final ThreadLocal<Long> VIEW_START = new ThreadLocal<>();

    @Override
    public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception {
        if (modelAndView != null && modelAndView.getViewName() != null) {
            VIEW_START.set(System.currentTimeMillis());
        }
    }

    @Override
    public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) throws Exception {
        Long start = VIEW_START.get();
        if (start != null) {
            long time = System.currentTimeMillis() - start;
            SimpleProfiler.logView("Thymeleaf", time);
            VIEW_START.remove();
        }
    }
}
