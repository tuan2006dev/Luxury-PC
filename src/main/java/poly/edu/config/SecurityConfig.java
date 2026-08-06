package poly.edu.config;

import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
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

        @Bean
        public PasswordEncoder passwordEncoder() {
                return new BCryptPasswordEncoder();
        }

        @Bean
        public SecurityContextRepository securityContextRepository() {
                return new HttpSessionSecurityContextRepository();
        }

        @Bean
        public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
                http
                                .userDetailsService(authService)
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
                                                                "/admin/orders/approve-refund", "/admin/orders/confirm-refund",
                                                                "/admin/orders/recall"
                                                )
                                                .hasRole("ADMIN")
                                                .requestMatchers("/admin/**").hasAnyRole("ADMIN", "STAFF")
                                                 .requestMatchers("/checkout", "/checkout/**", "/cart/checkout", "/cart/checkout/**").authenticated()
                                                .requestMatchers("/", "/auth/**", "/api/register", "/api/send-otp",
                                                                "/api/forgot-password/**", "/api/newsletter/**",
                                                                "/api/voucher/**", "/api/user-voucher/**", "/api/cart", "/api/cart/add",
                                                                "/api/products", "/api/products/**", "/api/build/**",
                                                                "/build-pc/**", "/api/tickets/**",
                                                                "/api/reviews/**", "/api/wishlist/**",
                                                                "/api/address/**",
                                                                "/api/shipping/**", "/api/test-login-debug",
                                                                "/api/sepay/webhook",
                                                                "/css/**", "/js/**", "/images/**", "/*.png", "/*.jpg",
                                                                "/*.jpeg", "/*.svg", "/error", "/testdb",
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
                        String errorParam = "bad_credentials";
                        Throwable cause = exception.getCause() != null ? exception.getCause() : exception;
                        String msg = cause != null && cause.getMessage() != null ? cause.getMessage().toLowerCase() : "";

                        if (exception instanceof org.springframework.security.authentication.DisabledException ||
                            exception instanceof org.springframework.security.authentication.LockedException ||
                            msg.contains("khóa") || msg.contains("vô hiệu hóa") || msg.contains("locked") || msg.contains("disabled")) {
                                errorParam = "disabled";
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
