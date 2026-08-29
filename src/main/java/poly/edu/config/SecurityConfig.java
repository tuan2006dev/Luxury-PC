package poly.edu.config;

import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.core.session.SessionRegistry;
import org.springframework.security.core.session.SessionRegistryImpl;
import org.springframework.security.web.session.HttpSessionEventPublisher;
import org.springframework.security.web.context.SecurityContextRepository;
import org.springframework.security.web.context.HttpSessionSecurityContextRepository;

@Configuration
@EnableWebSecurity
@RequiredArgsConstructor
public class SecurityConfig {

        private final poly.edu.security.CustomOAuth2UserService oauth2UserService;

        private final poly.edu.security.CustomAuthenticationSuccessHandler successHandler;

        private final poly.edu.service.AuthService authService;

        private final poly.edu.repository.AdminLogRepository adminLogRepository;

        private final poly.edu.security.UserStatusCheckFilter userStatusCheckFilter;

        private final poly.edu.dao.UserSessionDAO userSessionDAO;

        @Bean
        public SecurityContextRepository securityContextRepository() {
                return new HttpSessionSecurityContextRepository();
        }

        @Bean
        public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
                http
                                .userDetailsService(authService)
                                .addFilterAfter(userStatusCheckFilter, org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter.class)
                                .headers(headers -> headers
                                                .crossOriginEmbedderPolicy(coep -> coep.policy(org.springframework.security.web.header.writers.CrossOriginEmbedderPolicyHeaderWriter.CrossOriginEmbedderPolicy.UNSAFE_NONE))
                                                .crossOriginResourcePolicy(corp -> corp.policy(org.springframework.security.web.header.writers.CrossOriginResourcePolicyHeaderWriter.CrossOriginResourcePolicy.CROSS_ORIGIN))
                                                .crossOriginOpenerPolicy(coop -> coop.policy(org.springframework.security.web.header.writers.CrossOriginOpenerPolicyHeaderWriter.CrossOriginOpenerPolicy.SAME_ORIGIN_ALLOW_POPUPS))
                                                .frameOptions(frame -> frame.disable()))
                                .securityContext(context -> context
                                                .securityContextRepository(securityContextRepository()))
                                .authorizeHttpRequests(auth -> auth
                                                .requestMatchers(
                                                                "/admin/users/**", "/admin/roles/**",
                                                                "/admin/account/**", "/admin/account",
                                                                "/admin/employees/**", "/admin/employees",
                                                                "/admin/vouchers/**", "/admin/vouchers",
                                                                "/admin/flash-sales/**", "/admin/flash-sales",
                                                                "/admin/*/delete/**", "/admin/*/*/delete/**",
                                                                "/admin/orders/approve-refund",
                                                                "/admin/orders/confirm-refund",
                                                                "/admin/orders/recall")
                                                .hasRole("ADMIN")
                                                .requestMatchers("/admin/**").hasAnyRole("ADMIN", "STAFF")
                                                .requestMatchers("/checkout", "/checkout/**", "/cart/checkout",
                                                                "/cart/checkout/**")
                                                .authenticated()
                                                .requestMatchers("/", "/auth/**", "/api/register", "/api/send-otp",
                                                                "/api/auth/check-status",
                                                                "/api/forgot-password/**", "/api/newsletter/**",
                                                                "/api/voucher/**", "/api/user-voucher/**", "/api/cart",
                                                                "/api/cart/add",
                                                                "/api/products", "/api/products/**", "/api/build/**",
                                                                "/build-pc/**", "/api/tickets/**",
                                                                "/api/reviews/**", "/api/wishlist/**",
                                                                "/api/address/**",
                                                                "/api/shipping/**", "/api/test-login-debug",
                                                                "/api/sepay/webhook", "/api/webhook/**",
                                                                "/css/**", "/js/**", "/images/**", "/*.png", "/*.jpg",
                                                                "/*.jpeg", "/*.svg", "/error", "/testdb", "/favicon.ico",
                                                                "/.well-known/**",
                                                                "/cart", "/cart/**",
                                                                "/products", "/products/**", "/product/**",
                                                                "/promotions", "/news", "/news/**",
                                                                "/support", "/support/**", "/chat-socket",
                                                                "/chat-socket/**")
                                                .permitAll()
                                                .anyRequest().authenticated())

                                .formLogin(form -> form
                                                .loginPage("/auth/login")
                                                .loginProcessingUrl("/login")
                                                .usernameParameter("username")
                                                .passwordParameter("password")
                                                .successHandler(successHandler)
                                                .failureHandler(authenticationFailureHandler())
                                                .permitAll())

                                .oauth2Login(oauth2 -> oauth2
                                                .loginPage("/auth/login")
                                                .userInfoEndpoint(userInfo -> userInfo
                                                                .userService(oauth2UserService))
                                                .successHandler(successHandler)
                                                .failureHandler(authenticationFailureHandler()))

                                .logout(logout -> logout
                                                .logoutUrl("/logout")
                                                .addLogoutHandler((request, response, authentication) -> {
                                                        jakarta.servlet.http.HttpSession session = request.getSession(false);
                                                        if (session != null) {
                                                                try {
                                                                        userSessionDAO.findBySessionId(session.getId()).ifPresent(us -> {
                                                                                us.setIsExpired(true);
                                                                                userSessionDAO.save(us);
                                                                        });
                                                                } catch (Exception ignored) {}
                                                        }
                                                        if (authentication != null && authentication.getName() != null) {
                                                                String username = authentication.getName();
                                                                String clientIp = request.getHeader("X-Forwarded-For");
                                                                if (clientIp == null || clientIp.isBlank() || "unknown".equalsIgnoreCase(clientIp)) {
                                                                        clientIp = request.getRemoteAddr();
                                                                }
                                                                try {
                                                                        adminLogRepository.save(new poly.edu.entity.AdminLog(
                                                                                        username,
                                                                                        "Đăng xuất khỏi hệ thống",
                                                                                        clientIp,
                                                                                        username
                                                                        ));
                                                                } catch (Exception ignored) {}
                                                        }
                                                })
                                                .logoutSuccessUrl("/auth/login"))

                                .csrf(csrf -> csrf.disable())
                                .sessionManagement(session -> session
                                                .maximumSessions(-1)
                                                .sessionRegistry(sessionRegistry()));

                return http.build();
        }

        @Bean
        public org.springframework.security.web.authentication.AuthenticationFailureHandler authenticationFailureHandler() {
                return (request, response, exception) -> {
                        String username = request.getParameter("username");
                        String errorParam = "bad_credentials";
                        Throwable cause = exception.getCause() != null ? exception.getCause() : exception;
                        String msg = cause != null && cause.getMessage() != null ? cause.getMessage().toLowerCase()
                                        : "";

                        if (exception instanceof org.springframework.security.authentication.DisabledException ||
                                        exception instanceof org.springframework.security.authentication.LockedException
                                        ||
                                        msg.contains("khóa") || msg.contains("vô hiệu hóa") || msg.contains("locked")
                                        || msg.contains("disabled")) {
                                errorParam = "disabled";
                        }

                        if (username != null && !username.isBlank()) {
                                String clientIp = request.getHeader("X-Forwarded-For");
                                if (clientIp == null || clientIp.isBlank() || "unknown".equalsIgnoreCase(clientIp)) {
                                        clientIp = request.getRemoteAddr();
                                }
                                try {
                                        adminLogRepository.save(new poly.edu.entity.AdminLog(
                                                        username,
                                                        "Đăng nhập thất bại (" + ("disabled".equals(errorParam) ? "Tài khoản bị khóa" : "Sai mật khẩu") + ")",
                                                        clientIp,
                                                        username
                                        ));
                                } catch (Exception ignored) {}
                        }

                        response.sendRedirect("/auth/login?error=" + errorParam);
                };
        }

        @Bean
        public SessionRegistry sessionRegistry() {
                return new SessionRegistryImpl();
        }

        @Bean
        public HttpSessionEventPublisher httpSessionEventPublisher() {
                return new HttpSessionEventPublisher();
        }
}
