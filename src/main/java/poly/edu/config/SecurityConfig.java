package poly.edu.config;

import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.beans.factory.annotation.Autowired;
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
                .securityContext(context -> context
                        .securityContextRepository(securityContextRepository()))
                .authorizeHttpRequests(auth -> auth
                        .requestMatchers("/admin/users/**", "/admin/roles/**", "/admin/account/**", "/admin/account", "/admin/news/create", "/admin/news/edit/**", "/admin/news/save", "/admin/news/delete/**").hasRole("ADMIN")
                        .requestMatchers("/admin/**").hasAnyRole("ADMIN", "STAFF")
                        .requestMatchers("/", "/auth/**", "/api/register", "/api/send-otp", "/api/forgot-password/**",
                                "/api/voucher/**", "/api/cart", "/api/products", "/api/products/**", "/api/build/**", "/build-pc/**", "/api/tickets/**",
                                "/api/reviews/**", "/api/wishlist/**", "/api/address/**", "/api/translations/**", "/api/shipping/**",
                                "/css/**", "/js/**", "/images/**", "/*.png", "/*.jpg", "/*.jpeg", "/*.svg", "/error", "/testdb",
                                "/profile", "/checkout", "/checkout/**", "/cart", "/cart/**", "/payment/vietqr",
                                "/products", "/products/**", "/product/**",
                                "/promotions", "/news", "/news/**",
                                "/support", "/support/**", "/chat-socket", "/chat-socket/**")
                                .permitAll()
                        .anyRequest().authenticated())

                .formLogin(form -> form
                        .loginPage("/auth/login") // 👈 trang của mày
                        .loginProcessingUrl("/login")
                        .usernameParameter("username")
                        .passwordParameter("password")
                        .successHandler(successHandler)
                        .failureUrl("/auth/login?error=true")
                        .permitAll())

                .oauth2Login(oauth2 -> oauth2
                        .loginPage("/auth/login")
                        .userInfoEndpoint(userInfo -> userInfo
                                .userService(oauth2UserService))
                        .defaultSuccessUrl("/", true)
                        .failureUrl("/auth/login?error=true"))

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
    public SessionRegistry sessionRegistry() {
        return new SessionRegistryImpl();
    }

    @Bean
    public HttpSessionEventPublisher httpSessionEventPublisher() {
        return new HttpSessionEventPublisher();
    }
}
