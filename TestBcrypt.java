import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
public class TestBcrypt {
    public static void main(String[] args) {
        BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
        System.out.println("Matches: " + encoder.matches("123456", "$2a$10$wOaA32oQOf10iU3r.jGgL.0wZqE64U1rW0h.V46u0g/zZ.q72b9tK"));
    }
}
