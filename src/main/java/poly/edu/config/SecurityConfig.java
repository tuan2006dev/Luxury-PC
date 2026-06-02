package poly.edu.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.beans.factory.annotation.Autowired;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Autowired
    private poly.edu.security.CustomOAuth2UserService oauth2UserService;

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
                .authorizeHttpRequests(auth -> auth
                        .requestMatchers("/admin/**").hasRole("ADMIN")
                        .requestMatchers("/", "/auth/**", "/api/register", "/api/send-otp", "/api/forgot-password/**",
                                "/api/voucher/**", "/api/cart", "/api/products",
                                "/css/**", "/js/**", "/images/**", "/*.png", "/*.jpg", "/*.jpeg", "/*.svg", "/error",
                                "/profile", "/checkout", "/cart", "/cart/**", "/products", "/products/**", "/product/**")
                        .permitAll()
                        .anyRequest().authenticated())

                .formLogin(form -> form
                        .loginPage("/auth/login") // 👈 trang của mày
                        .loginProcessingUrl("/login")
                        .usernameParameter("username")
                        .passwordParameter("password")
                        .defaultSuccessUrl("/", true)
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

                .csrf(csrf -> csrf.disable());

        return http.build();
    }
}